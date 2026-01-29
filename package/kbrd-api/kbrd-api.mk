KBRD_API_VERSION = 1.0.0
KBRD_API_SITE = $(TOPDIR)/../kbrd-api
KBRD_API_SITE_METHOD = local
KBRD_API_SETUP_TYPE = setuptools

KBRD_API_DEPENDENCIES = python3 python-flask

define KBRD_API_REMOVE_OLD_SCRIPT
	rm -f $(TARGET_DIR)/usr/bin/kbrd-api
endef
KBRD_API_PRE_INSTALL_TARGET_HOOKS += KBRD_API_REMOVE_OLD_SCRIPT

define KBRD_API_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(@D)/resources/S60kbrd-api \
		$(TARGET_DIR)/etc/init.d/S60kbrd-api
endef

$(eval $(python-package))
