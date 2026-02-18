# Python Skill

Write modern Python code following these conventions.

## Tooling

- **Dependency management**: Use `uv` (not pip). Check for `uv.lock` first.
- **Data analysis**: Use `polars` (not pandas)
- **Paths**: Use `pathlib.Path` (not os.path)
- **Data classes**: Use `@dataclass` decorator
- **Config files**: Use `tomllib` for .toml

## Code Style

- Type hints on all function signatures (PEP 484)
- `match...case` instead of complex `if...elif...else`
- Comprehensions over raw loops
- NumPy-style docstrings for functions/classes
- Catch specific exceptions, never broad `except Exception:`

## Project Commands

- If `uv.lock` exists: `uv run python script.py`
- Add deps: `uv add package-name`
- Sync: `uv sync`

## Single-file Scripts

Use inline script metadata:
```python
# /// script
# requires-python = ">=3.11"
# dependencies = ["polars", "httpx"]
# ///
```

Then run: `uv run script.py`
