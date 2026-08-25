KBRD_DEV_VERSION = 1.0.0
KBRD_DEV_SITE = $(TOPDIR)/../kbrd-dev
KBRD_DEV_SITE_METHOD = local

KBRD_DEV_SETUP_TYPE = setuptools

KBRD_DEV_DEPENDENCIES = \
	python3 \
	python-kivy

define KBRD_DEV_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 \
		$(@D)/init/S70kbrd-dev \
		$(TARGET_DIR)/etc/init.d/S70kbrd-dev
endef

define KBRD_DEV_INSTALL_RESOURCES
	mkdir -p $(TARGET_DIR)/usr/share/kbrd

	cp -a \
		$(@D)/resources/. \
		$(TARGET_DIR)/usr/share/kbrd/

	mkdir -p $(TARGET_DIR)/usr/share/kbrd/plugins
	cp -a \
		$(BR2_EXTERNAL_KBRD_PATH)/../kbrd-plugins/src/. \
		$(TARGET_DIR)/usr/share/kbrd/plugins/
endef

define KBRD_DEV_PERMISSIONS
	/usr/lib/python3.14/site-packages/kbrd_dev r 0755 kbrd kbrd - - - - -
	/usr/share/kbrd r 0755 kbrd kbrd - - - - -
endef

KBRD_DEV_POST_INSTALL_TARGET_HOOKS += \
	KBRD_DEV_INSTALL_RESOURCES


$(eval $(python-package))
