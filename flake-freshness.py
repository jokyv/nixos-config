#!/usr/bin/env python3
"""
flake-freshness.py: Monitor package versions across nixpkgs inputs

A Python script for tracking package versions in your flake's main nixpkgs
input. Compares installed versions against latest available versions.
"""

import json
import subprocess
import sys
from pathlib import Path
from dataclasses import dataclass
from typing import List, Dict, Optional, Tuple
import tomllib
import polars as pl
from datetime import datetime, timedelta
import os


# ============================================================================
# Configuration & Constants
# ============================================================================
@dataclass
class Config:
    """Configuration for flake-freshness script.

    Attributes
    ----------
    colors : Dict[str, str]
        ANSI color codes for terminal output
    cache : Dict[str, int]
        Cache configuration including TTL
    defaults : Dict[str, str]
        Default values for script parameters
    """

    colors: Dict[str, str] = None
    cache: Dict[str, int] = None
    defaults: Dict[str, str] = None

    def __post_init__(self):
        if self.colors is None:
            self.colors = {
                "outdated_bg": "\033[1;31m",
                "latest_bg": "\033[1;32m",
                "equal": "\033[32m",
                "warning": "\033[33m",
                "error": "\033[31m",
                "info": "\033[34m",
                "accent": "\033[36m",
                "reset": "\033[0m",
            }
        if self.cache is None:
            self.cache = {"ttl": 3600}  # 1 hour in seconds
        if self.defaults is None:
            self.defaults = {"flake": "flake.nix"}


CONFIG = Config()


# Runtime paths that depend on environment
def get_cache_dir() -> Path:
    """Get cache directory path.

    Returns
    -------
    Path
        Path to cache directory in user's home
    """
    return Path.home() / ".cache" / "flake-freshness"


def get_default_package_paths() -> List[Path]:
    """Get default package config file paths.

    Returns
    -------
    List[Path]
        List of potential config file locations
    """
    return [
        Path("freshness.toml"),
        Path.home() / ".config" / "flake-freshness" / "freshness.toml",
        Path("scripts") / "flake-freshness" / "freshness.toml",
    ]


# ============================================================================
# Helper Functions
# ============================================================================


def run_command(cmd: List[str], capture_output: bool = True) -> Tuple[int, str, str]:
    """Run a command and return exit code, stdout, stderr.

    Parameters
    ----------
    cmd : List[str]
        Command and arguments to execute
    capture_output : bool, optional
        Whether to capture command output, by default True

    Returns
    -------
    Tuple[int, str, str]
        Exit code, stdout, and stderr from command execution
    """
    try:
        result = subprocess.run(cmd, capture_output=capture_output, text=True)
        return result.returncode, result.stdout, result.stderr
    except Exception as e:
        return 1, "", str(e)


def get_current_system() -> str:
    """Detect current system architecture.

    Returns
    -------
    str
        System architecture string (e.g., 'x86_64-linux')
    """
    exit_code, stdout, stderr = run_command(
        ["nix", "eval", "--impure", "--expr", "builtins.currentSystem", "--raw"]
    )
    if exit_code == 0:
        return stdout.strip()
    else:
        print(
            f"{CONFIG.colors['error']}Error getting current system: {stderr}{CONFIG.colors['reset']}"
        )
        return "x86_64-linux"  # fallback


def find_packages_config(override: Optional[str] = None) -> Path:
    """Find packages config file.

    Parameters
    ----------
    override : Optional[str], optional
        Override path to config file, by default None

    Returns
    -------
    Path
        Path to found config file

    Raises
    ------
    FileNotFoundError
        If no config file is found
    """
    if override and override != "":
        config_path = Path(override)
        if config_path.exists():
            return config_path
        else:
            raise FileNotFoundError(f"Packages config not found: {override}")

    for path in get_default_package_paths():
        if path.exists():
            return path

    raise FileNotFoundError(
        "No config found. Create freshness.toml in your project root or ~/.config/flake-freshness/freshness.toml"
    )


def extract_branch_from_url(url: str) -> str:
    """Extract branch name from flake URL.
    
    Parameters
    ----------
    url : str
        Flake URL string
        
    Returns
    -------
    str
        Branch name or 'unknown'
    """
    if not url:
        return "unknown"
    
    # Handle GitHub URLs with branches
    if "github:" in url and "/" in url:
        parts = url.split("/")
        if len(parts) > 1:
            # Extract branch from last part (e.g., nixos-unstable)
            branch_part = parts[-1]
            # Remove any query parameters or fragments
            return branch_part.split("?")[0].split("#")[0]
    
    return "unknown"


def extract_all_inputs(flake_path: Path) -> Dict[str, Dict[str, str]]:
    """Extract all flake inputs with their branches and locked revisions.

    Parameters
    ----------
    flake_path : Path
        Path to flake.nix file

    Returns
    -------
    Dict[str, Dict[str, str]]
        Dictionary mapping input names to their branch and locked revision
    """
    # Get flake metadata
    exit_code, stdout, stderr = run_command(
        ["nix", "flake", "metadata", "--json"], capture_output=True
    )

    if exit_code != 0:
        print(
            f"{CONFIG.colors['error']}Error getting flake metadata: {stderr}{CONFIG.colors['reset']}"
        )
        return {}

    try:
        metadata = json.loads(stdout)
        locks = metadata.get("locks", {}).get("nodes", {})
        
        inputs_info = {}
        for input_name, lock_info in locks.items():
            locked = lock_info.get("locked", {})
            inputs_info[input_name] = {
                "locked_rev": locked.get("rev"),
                "url": locked.get("url", ""),
                "branch": extract_branch_from_url(locked.get("url", "")),
            }
        
        return inputs_info
        
    except (json.JSONDecodeError, KeyError) as e:
        print(f"{CONFIG.colors['error']}Error parsing flake metadata: {e}{CONFIG.colors['reset']}")
        return {}


def load_packages(config_path: Path) -> Dict[str, List[str]]:
    """Load packages organized by input from TOML.

    Parameters
    ----------
    config_path : Path
        Path to freshness.toml config file

    Returns
    -------
    Dict[str, List[str]]
        Dictionary mapping input names to package lists

    Raises
    ------
    ValueError
        If config file doesn't contain valid package sections
    """
    with open(config_path, "rb") as f:
        config = tomllib.load(f)

    packages_by_input = {}
    
    # Support both formats: simple list and input-specific
    if "packages" in config and "packages" in config["packages"]:
        # Simple format - assign all packages to nixpkgs
        packages_by_input["nixpkgs"] = config["packages"].get("packages", [])
    else:
        # Input-specific format
        for input_name, packages in config.items():
            if isinstance(packages, dict) and "packages" in packages:
                packages_by_input[input_name] = packages.get("packages", [])

    if not packages_by_input:
        raise ValueError("freshness.toml must contain package definitions")

    return packages_by_input


def get_cache_path(key: str) -> Path:
    """Get cache file path for a specific key.

    Parameters
    ----------
    key : str
        Cache key to generate path for

    Returns
    -------
    Path
        Path to cache file
    """
    safe_key = key.replace("/", "_").replace(":", "_")
    return get_cache_dir() / f"{safe_key}.json"


def is_cache_valid(cache_path: Path) -> bool:
    """Check if cache is valid.

    Parameters
    ----------
    cache_path : Path
        Path to cache file

    Returns
    -------
    bool
        True if cache exists and is not expired
    """
    if not cache_path.exists():
        return False

    cache_time = datetime.fromtimestamp(cache_path.stat().st_mtime)
    now = datetime.now()
    age = (now - cache_time).total_seconds()

    return age < CONFIG.cache["ttl"]


def read_cache(key: str) -> Optional[str]:
    """Read from cache.

    Parameters
    ----------
    key : str
        Cache key to read

    Returns
    -------
    Optional[str]
        Cached value or None if not found or expired
    """
    cache_path = get_cache_path(key)

    if is_cache_valid(cache_path):
        try:
            with open(cache_path, "r") as f:
                return json.load(f)
        except (json.JSONDecodeError, FileNotFoundError):
            return None
    return None


def write_cache(key: str, value: str) -> None:
    """Write to cache.

    Parameters
    ----------
    key : str
        Cache key to write
    value : str
        Value to cache
    """
    cache_dir = get_cache_dir()
    cache_dir.mkdir(parents=True, exist_ok=True)

    cache_path = get_cache_path(key)
    with open(cache_path, "w") as f:
        json.dump(value, f)


def get_package_version(
    flake_ref: str, input_name: str, package: str, use_cache: bool
) -> str:
    """Get package version from nix eval.

    Parameters
    ----------
    flake_ref : str
        Flake reference to evaluate
    input_name : str
        Input name within flake
    package : str
        Package name to get version for
    use_cache : bool
        Whether to use cached values

    Returns
    -------
    str
        Package version or 'not found' if unavailable
    """
    cache_key = f"{flake_ref}-{input_name}-{package}"

    if use_cache:
        cached = read_cache(cache_key)
        if cached is not None:
            return cached

    # Try to get version
    cmd = ["nix", "eval", f"{flake_ref}#{input_name}.{package}.version", "--raw"]
    exit_code, stdout, stderr = run_command(cmd)

    version = stdout.strip() if exit_code == 0 else "not found"

    if use_cache and version != "not found":
        write_cache(cache_key, version)

    return version


def compare_versions(current: str, latest: str) -> str:
    """Compare two version strings.

    Parameters
    ----------
    current : str
        Current version string
    latest : str
        Latest version string

    Returns
    -------
    str
        Comparison result: 'equal', 'outdated', or 'unknown'
    """
    if current == "not found" or latest == "not found":
        return "unknown"

    if current == latest:
        return "equal"
    else:
        return "outdated"


def format_version(version: str, status: str) -> str:
    """Format version with color.

    Parameters
    ----------
    version : str
        Version string to format
    status : str
        Status for color selection

    Returns
    -------
    str
        Formatted version string with ANSI color codes
    """
    match status:
        case "outdated":
            return f"{CONFIG.colors['outdated_bg']}{version}{CONFIG.colors['reset']}"
        case "equal":
            return f"{CONFIG.colors['equal']}{version}{CONFIG.colors['reset']}"
        case _:
            return version


def print_table(results: List[Dict]) -> None:
    """Print results as a formatted table showing inputs.

    Parameters
    ----------
    results : List[Dict]
        List of result dictionaries to display
    """
    if not results:
        return

    # Prepare clean data for polars DataFrame
    table_data = []
    for row in results:
        match row["status"]:
            case "equal":
                status_text = "✓ up to date"
            case "outdated":
                status_text = "⚠ update available"
            case _:
                status_text = "?"

        table_data.append(
            {
                "Input": row["input"],
                "Package": row["package"],
                "Current": row["current"],
                "Latest": row["latest"],
                "Status": status_text,
            }
        )

    # Create polars DataFrame
    df = pl.DataFrame(table_data)

    # Configure display for better terminal output
    pl.Config.set_tbl_rows(len(results))
    pl.Config.set_tbl_cols(len(df.columns))
    pl.Config.set_fmt_str_lengths(30)
    pl.Config.set_tbl_width_chars(120)
    pl.Config.set_tbl_hide_column_data_types(True)
    pl.Config.set_tbl_hide_dataframe_shape(True)

    # Print the table
    print("\n")
    print(df)

    # Add color legend below the table
    print(f"\n{CONFIG.colors['info']}Color Legend:{CONFIG.colors['reset']}")
    for row in results:
        if row["status"] == "outdated":
            print(f"  {row['input']}.{row['package']}: {CONFIG.colors['outdated_bg']}{row['current']}{CONFIG.colors['reset']} → {CONFIG.colors['latest_bg']}{row['latest']}{CONFIG.colors['reset']}")
        elif row["status"] == "equal":
            print(f"  {row['input']}.{row['package']}: {CONFIG.colors['equal']}{row['current']}{CONFIG.colors['reset']} (up to date)")


# ============================================================================
# Main Logic
# ============================================================================


def main(
    flake: str = "flake.nix",
    pkgs: Optional[str] = None,
    updates_only: bool = False,
    no_cache: bool = False,
    json_output: bool = False,
) -> None:
    """Monitor package versions across ALL flake inputs.

    Parameters
    ----------
    flake : str, optional
        Path to flake.nix file, by default "flake.nix"
    pkgs : Optional[str], optional
        Path to freshness.toml config, by default None
    updates_only : bool, optional
        Only show packages with updates available, by default False
    no_cache : bool, optional
        Skip cache and force fresh lookups, by default False
    json_output : bool, optional
        Output results as JSON, by default False
    """

    # Validate flake exists
    flake_path = Path(flake)
    if not flake_path.exists():
        print(
            f"{CONFIG.colors['error']}Error: flake.nix not found at {flake}{CONFIG.colors['reset']}"
        )
        return

    # Find and load packages config
    try:
        pkgs_config = find_packages_config(pkgs)
        print(
            f"{CONFIG.colors['info']}Loading packages from: {pkgs_config}{CONFIG.colors['reset']}"
        )
        packages_by_input = load_packages(pkgs_config)
    except (FileNotFoundError, ValueError) as e:
        print(f"{CONFIG.colors['error']}Error: {e}{CONFIG.colors['reset']}")
        return

    if not packages_by_input:
        print(
            f"{CONFIG.colors['warning']}No packages found to check{CONFIG.colors['reset']}"
        )
        return

    # Extract ALL inputs info
    print(
        f"{CONFIG.colors['info']}Extracting all inputs from: {flake}{CONFIG.colors['reset']}"
    )
    inputs_info = extract_all_inputs(flake_path)

    if not inputs_info:
        print(
            f"{CONFIG.colors['error']}Error: Could not extract input information{CONFIG.colors['reset']}"
        )
        return

    # Detect current system architecture
    system = get_current_system()

    # Check each package against its respective input
    use_cache = not no_cache
    results = []
    total_packages = sum(len(pkgs) for pkgs in packages_by_input.values())

    print(
        f"{CONFIG.colors['info']}Checking {total_packages} packages across {len(packages_by_input)} inputs...{CONFIG.colors['reset']}\n"
    )

    for input_name, packages in packages_by_input.items():
        if input_name not in inputs_info:
            print(f"{CONFIG.colors['warning']}Warning: Input '{input_name}' not found in flake{CONFIG.colors['reset']}")
            continue

        input_info = inputs_info[input_name]
        
        for package in packages:
            print(f"  Checking {package} from {input_name}...")

            # Get current version from locked revision
            if input_info.get("locked_rev"):
                current = get_package_version(
                    f"{input_info['url']}/{input_info['locked_rev']}",
                    f"legacyPackages.{system}",
                    package,
                    use_cache,
                )
            else:
                current = "no lock"

            # Get latest version from upstream
            latest = get_package_version(
                input_info['url'],
                f"legacyPackages.{system}",
                package,
                use_cache,
            )

            status = compare_versions(current, latest)

            results.append(
                {
                    "package": package,
                    "input": input_name,
                    "branch": input_info.get("branch", "unknown"),
                    "current": current,
                    "latest": latest,
                    "status": status,
                }
            )

    # Filter results if updates-only
    display_results = (
        [r for r in results if r["status"] == "outdated"] if updates_only else results
    )

    # Output results
    if json_output:
        print(json.dumps(display_results, indent=2))
        return

    # Display table
    print_table(display_results)

    # Summary with input breakdown
    outdated_by_input = {}
    for result in results:
        if result["status"] == "outdated":
            input_name = result["input"]
            outdated_by_input[input_name] = outdated_by_input.get(input_name, 0) + 1

    outdated_count = len([r for r in results if r["status"] == "outdated"])

    if outdated_count > 0:
        print(f"\n{CONFIG.colors['accent']}Summary:{CONFIG.colors['reset']}")
        print(f"  • {outdated_count} packages with updates available")
        
        for input_name, count in outdated_by_input.items():
            print(f"  • {input_name}: {count} packages need updates")

        print(f"\n{CONFIG.colors['info']}Next steps:{CONFIG.colors['reset']}")
        for input_name in outdated_by_input.keys():
            print(f"  nix flake lock --update-input {input_name}")
        print(f"  nix flake update --refresh --commit-lock-file  # Update all inputs")
    else:
        print(
            f"\n{CONFIG.colors['equal']}✓ All packages are up to date!{CONFIG.colors['reset']}"
        )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Monitor package versions across ALL flake inputs"
    )
    parser.add_argument("--flake", default="flake.nix", help="Path to flake.nix")
    parser.add_argument("--pkgs", help="Path to freshness.toml config")
    parser.add_argument(
        "--updates-only",
        action="store_true",
        help="Only show packages with updates available",
    )
    parser.add_argument(
        "--no-cache", action="store_true", help="Skip cache, force fresh lookups"
    )
    parser.add_argument("--json", action="store_true", help="Output as JSON")

    args = parser.parse_args()

    main(
        flake=args.flake,
        pkgs=args.pkgs,
        updates_only=args.updates_only,
        no_cache=args.no_cache,
        json_output=args.json,
    )
