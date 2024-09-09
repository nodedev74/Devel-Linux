#

include .env

include config.mk

bootstrap:
	bash scripts/bootstrap.sh

build:
	bash scripts/build.sh $(NAME) $(LABEL) $(PUBLISHER) $(USERNAME) $(LOCALES) $(TIMEZONE) $(KEYBOARD_LAYOUTS)

test:

install:
	@if [ "$(USB_DEVICE)" != "" ]; then \
		bash scripts/install.sh  $(USB_DEVICE) $(USERNAME) $(PARTITION_PASSPHRASE); \
	else \
		echo "test"; \
	fi