KBRD_WEB_VERSION = 1.0.0
KBRD_WEB_SITE = $(TOPDIR)/../kbrd-web
KBRD_WEB_SITE_METHOD = local

define KBRD_WEB_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/var/www
	rsync -a --delete \
		$(@D)/dist/ \
		$(TARGET_DIR)/var/www/
endef

define KBRD_WEB_PERMISSIONS
	/var/www r 0755 kbrd kbrd - - - - -
endef

$(eval $(generic-package))
