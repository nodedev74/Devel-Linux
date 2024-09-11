# Devel Linux
> [!WARNING]
> In development

is a customized portable Linux distribution based on Debian, specifically configured to meet the needs of developers.

## Usage
> [!IMPORTANT]  
> This project can only be used on Debian-based systems (e.g., Debian & Ubuntu)


To use the toolset, you must first run the bootstrap process. This step installs all necessary dependencies and prepares the system for use.
```bash
make bootstrap
```
### Configure

### Build
Whenever the project is configured correctly you can build the ISO file for the distribution.
```bash
make build
```

### Install
The built distribution can be installed on a USB-Device. As the system requires a persistent partition it will install one as well.

```bash
make install USB_DEVICE=/dev/sdX
```

### Test


