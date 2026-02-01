KBRD_DEV_VERSION = 1.0.0
KBRD_DEV_SITE = $(TOPDIR)/../kbrd-dev
KBRD_DEV_SITE_METHOD = local
KBRD_DEV_SETUP_TYPE = setuptools

KBRD_DEV_DEPENDENCIES = python3 python-flask

define KBRD_DEV_REMOVE_OLD_SCRIPT
	rm -f $(TARGET_DIR)/usr/bin/kbrd-dev
endef
KBRD_DEV_PRE_INSTALL_TARGET_HOOKS += KBRD_DEV_REMOVE_OLD_SCRIPT

#define KBRD_DEV_INSTALL_INIT_SYSV
#	$(INSTALL) -D -m 0755 $(@D)/resources/S60kbrd-dev \
#		$(TARGET_DIR)/etc/init.d/S60kbrd-dev
#endef

$(eval $(python-package))
