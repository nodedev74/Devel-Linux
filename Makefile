#

include config.mk

bootstrap:
	bash scripts/bootstrap.sh

build:
	bash scripts/build.sh $(NAME) $(LABEL) $(PUBLISHER) $(USERNAME) $(LOCALES) $(TIMEZONE) $(KEYBOARD_LAYOUTS)

test:

install: