# Shido Node Upgrade Script (UBUNTU22.04)

Automated script for upgrading Shido nodes to the Enso upgrade.

## Usage

```bash
chmod +x enso.sh
./enso.sh
```

**Dry run first (recommended):**
```bash
./enso.sh --dry-run
```

Stops node → removes old binary → installs new binary → starts node.
