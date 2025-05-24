# Shido Node Upgrade Scripts

Automated scripts for upgrading Shido nodes to the Enso upgrade.

## Usage

**Ubuntu 20.04:**
```bash
chmod +x enso_20.04.sh
./enso_20.04.sh
```

**Ubuntu 22.04:**
```bash
chmod +x enso_22.04.sh
./enso_22.04.sh
```

**Dry run:**
```bash
./enso_20.04.sh --dry-run
./enso_22.04.sh --dry-run
```

Stops node → removes old binary → installs new binary → starts node.
