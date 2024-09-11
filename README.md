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
You can configure the following content:

#### [`config.mk`](https://github.com/nodedev74/Devel-Linux/blob/master/config.example.mk)
General build configurations.

#### [`.env`](https://github.com/nodedev74/Devel-Linux/blob/master/.env.exampe)
Project secrets like *passwords* and *passphrases* for the resulting users and disk encryption. 

### Build
Whenever the project is configured correctly you can build the ISO file for the distribution.
```shell
$ make build
```

### Install
The built distribution can be installed on a USB-Device. As the system requires a persistent partition it will create one as well.

```shell
# make install USB_DEVICE=/dev/sdX
```

### Test


