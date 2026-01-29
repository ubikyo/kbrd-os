KBRD_UI_VERSION = c29d3f4d0284
KBRD_UI_SITE = $(TOPDIR)/../kbrd-ui
KBRD_UI_SITE_METHOD = local

define KBRD_UI_INSTALL_TARGET_CMDS
    echo ">>> INSTALL TARGET: copying dist to TARGET_DIR=$(TARGET_DIR)"
    ls -la $(@D)/dist/ || true
    mkdir -p $(TARGET_DIR)/var/www
    rsync -a --delete $(@D)/dist/ $(TARGET_DIR)/var/www/
endef

$(eval $(generic-package))