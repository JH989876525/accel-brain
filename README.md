- [Overview](#overview)
- [Build ipk](#build-ipk)
- [Install ipk](#install-ipk)
- [Uninstall ipk](#uninstall-ipk)
- [Run](#run)

# Overview
- This repository provide accel brain ipk package build flow.

# Build ipk
```bash
make all
```

# Install ipk
```bash
opkg install accelbrain*.ipk
```

# Uninstall ipk
```bash
opkg list-installed
opkg remove AccelBrain --force-remove
```

# Run
```bash
http://localhost:8080/
```