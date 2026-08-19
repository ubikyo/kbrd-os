KBRD_API_VERSION = 1.0.0
KBRD_API_SITE = $(TOPDIR)/../kbrd-api
KBRD_API_SITE_METHOD = local

KBRD_API_SETUP_TYPE = setuptools

KBRD_API_DEPENDENCIES = \
	python3 \
	python-flask

define KBRD_API_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 \
		$(@D)/init/S60kbrd-api \
		$(TARGET_DIR)/etc/init.d/S60kbrd-api
endef

define KBRD_API_PERMISSIONS
	/usr/lib/python3.14/site-packages/kbrd_api r 0755 kbrd kbrd - - - - -
endef

$(eval $(python-package))