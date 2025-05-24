# Shido Node Upgrade Script

Automated script for upgrading Shido nodes to the Enso upgrade.

## Usage

```bash
chmod +x enso.sh
./enso.sh
```

Select your Ubuntu version (20.04 or 22.04) when prompted.

Stops node → updates WASM → removes old binary → installs new binary → starts node.
