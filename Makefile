.PHONY: install backup install-extensions dconf packages flatpak uninstall

install:
	./scripts/install.sh

backup:
	./scripts/backup.sh

install-extensions:
	./scripts/install-extensions.sh

dconf:
	./scripts/dconf.sh extensions

packages:
	./scripts/packages.sh

flatpak:
	./scripts/flatpak.sh

uninstall:
	./scripts/uninstall.sh