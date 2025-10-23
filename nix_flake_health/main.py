#!/usr/bin/env python3

"""
Monitor package versions in main nixpkgs input

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
    return Path.home() / ".cache" / "nix-flake-health"


def get_default_package_paths() -> List[Path]:
    """Get default package config file paths.

    Returns
    -------
    List[Path]
        List of potential config file locations
    """
    script_dir = Path(__file__).parent
    return [
        script_dir / "apps.toml",  # Bundled config
        Path("apps.toml"),  # Override in current directory
        Path.home() / ".config" / "nix-flake-health" / "apps.toml",  # User-level config
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
        "No config found. Create apps.toml in the script directory, your project root, or ~/.config/nix-flake-health/apps.toml"
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


def extract_nixpkgs_info(flake_path: Path) -> Dict:
    """Extract main nixpkgs branch, locked revision, and last modified date.

    Parameters
    ----------
    flake_path : Path
        Path to flake.nix file

    Returns
    -------
    Dict
        Dictionary with 'branch', 'locked_rev', and 'last_modified' keys
    """
    # Get flake metadata
    exit_code, stdout, stderr = run_command(
        ["nix", "flake", "metadata", "--json"], capture_output=True
    )

    if exit_code != 0:
        print(
            f"{CONFIG.colors['error']}Error getting flake metadata: {stderr}{CONFIG.colors['reset']}"
        )
        return {"branch": "nixos-unstable", "locked_rev": None, "last_modified": None}

    try:
        metadata = json.loads(stdout)
        nixpkgs_lock = metadata.get("locks", {}).get("nodes", {}).get("nixpkgs", {})
        locked_rev = nixpkgs_lock.get("locked", {}).get("rev")

        # Extract branch from URL
        url = nixpkgs_lock.get("locked", {}).get("url", "")
        branch = extract_branch_from_url(url) if url else "nixos-unstable"

        # Extract last modified timestamp
        last_modified = nixpkgs_lock.get("locked", {}).get("lastModified")

        return {
            "branch": branch,
            "locked_rev": locked_rev,
            "last_modified": last_modified,
        }

    except (json.JSONDecodeError, KeyError):
        return {"branch": "nixos-unstable", "locked_rev": None, "last_modified": None}


def load_packages(config_path: Path) -> List[str]:
    """Load simple package list from TOML.

    Parameters
    ----------
    config_path : Path
        Path to freshness.toml config file

    Returns
    -------
    List[str]
        List of package names

    Raises
    ------
    ValueError
        If config file doesn't contain [packages] section
    """
    with open(config_path, "rb") as f:
        config = tomllib.load(f)

    if "packages" not in config:
        raise ValueError("apps.toml must contain a [packages] section")

    return config["packages"].get("packages", [])


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


def print_table(results: List[Dict], revision_age: str) -> None:
    """Print results as a simplified formatted table.

    Parameters
    ----------
    results : List[Dict]
        List of result dictionaries to display
    revision_age : str
        The age of the current nixpkgs revision
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
                "Package": row["package"],
                "Current": row["current"],
                "Latest": row["latest"],
                "Status": status_text,
            }
        )

    # Create polars DataFrame
    df = pl.DataFrame(table_data)

    # Add revision age and reorder columns
    df = df.with_columns(pl.lit(revision_age).alias("Revision Age")).select(
        "Package", "Current", "Revision Age", "Latest", "Status"
    )

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
            print(
                f"  {row['package']}: {CONFIG.colors['outdated_bg']}{row['current']}{CONFIG.colors['reset']} → {CONFIG.colors['latest_bg']}{row['latest']}{CONFIG.colors['reset']}"
            )
        elif row["status"] == "equal":
            print(
                f"  {row['package']}: {CONFIG.colors['equal']}{row['current']}{CONFIG.colors['reset']} (up to date)"
            )


# ============================================================================
# Main Logic
# ============================================================================


def main(
    flake: str = "../flake.nix",
    pkgs: Optional[str] = None,
    updates_only: bool = False,
    no_cache: bool = False,
    json_output: bool = False,
) -> None:
    """Monitor package versions in main nixpkgs input.

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
        packages = load_packages(pkgs_config)
    except (FileNotFoundError, ValueError) as e:
        print(f"{CONFIG.colors['error']}Error: {e}{CONFIG.colors['reset']}")
        return

    if not packages:
        print(
            f"{CONFIG.colors['warning']}No packages found to check{CONFIG.colors['reset']}"
        )
        return

    # Detect current system architecture
    system = get_current_system()

    print(
        f"{CONFIG.colors['info']}Checking {len(packages)} packages from nixpkgs...{CONFIG.colors['reset']}\n"
    )

    # Extract nixpkgs info
    print(
        f"{CONFIG.colors['info']}Extracting nixpkgs info from: {flake}{CONFIG.colors['reset']}"
    )
    nixpkgs_info = extract_nixpkgs_info(flake_path)

    # Calculate revision age
    revision_age_str = "N/A"
    last_modified_timestamp = nixpkgs_info.get("last_modified")
    if last_modified_timestamp:
        modified_date = datetime.fromtimestamp(last_modified_timestamp)
        age_delta = datetime.now() - modified_date
        age_days = age_delta.days
        if age_days == 0:
            revision_age_str = "today"
        elif age_days == 1:
            revision_age_str = "1 day ago"
        else:
            revision_age_str = f"{age_days} days ago"

    if not nixpkgs_info.get("locked_rev"):
        print(
            f"{CONFIG.colors['warning']}Warning: Could not determine locked revision{CONFIG.colors['reset']}"
        )

    # Check each package against nixpkgs
    use_cache = not no_cache
    results = []

    for package in packages:
        print(f"  Checking {package}...")

        # Get current version from locked revision
        if nixpkgs_info.get("locked_rev"):
            current = get_package_version(
                f"github:nixos/nixpkgs/{nixpkgs_info['locked_rev']}",
                f"legacyPackages.{system}",
                package,
                use_cache,
            )
        else:
            current = "no lock"

        # Get latest version from upstream branch
        latest = get_package_version(
            f"github:nixos/nixpkgs/{nixpkgs_info['branch']}",
            f"legacyPackages.{system}",
            package,
            use_cache,
        )

        status = compare_versions(current, latest)

        results.append(
            {
                "package": package,
                "branch": nixpkgs_info["branch"],
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
        # Add revision age to JSON output as well
        output_data = {
            "revision_age": revision_age_str,
            "packages": display_results,
        }
        print(json.dumps(output_data, indent=2))
        return

    # Display simplified table
    print_table(display_results, revision_age_str)

    # Summary
    outdated = [r for r in results if r["status"] == "outdated"]
    outdated_count = len(outdated)

    if outdated_count > 0:
        print(f"\n{CONFIG.colors['accent']}Summary:{CONFIG.colors['reset']}")
        print(f"  • {outdated_count} packages with updates available")
        print(f"  • Branch: {nixpkgs_info['branch']}")
        print(f"  • Current Revision Age: {revision_age_str}")

        print(f"\n{CONFIG.colors['info']}Next steps:{CONFIG.colors['reset']}")
        print(f"  nix flake lock --update-input nixpkgs")
    else:
        print(
            f"\n{CONFIG.colors['equal']}✓ All packages are up to date!{CONFIG.colors['reset']}"
        )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Monitor package versions in main nixpkgs input"
    )
    parser.add_argument("--flake", default="../flake.nix", help="Path to flake.nix")
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
