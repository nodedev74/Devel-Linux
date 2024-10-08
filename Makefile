#

ifneq ($(wildcard .bs),)
    include .env
    include config.mk
endif

bootstrap:
	bash scripts/bootstrap.sh

build:
	bash scripts/build.sh $(NAME) $(LABEL) $(PUBLISHER) $(USERNAME) $(LOCALES) $(TIMEZONE) $(KEYBOARD_LAYOUTS)

test:

install:
	@if [ "$(USB_DEVICE)" != "" ]; then \
		bash scripts/install.sh  $(USB_DEVICE) $(USERNAME) $(PARTITION_PASSPHRASE); \
	else \
		echo "[Error] You have to specify a USB-Device"; \
	fi