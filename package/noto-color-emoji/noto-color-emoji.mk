################################################################################
#
# noto-color-emoji
#
################################################################################

NOTO_COLOR_EMOJI_VERSION = 2.051
NOTO_COLOR_EMOJI_SOURCE = NotoColorEmoji.ttf
NOTO_COLOR_EMOJI_SITE = https://raw.githubusercontent.com/googlefonts/noto-emoji/v$(NOTO_COLOR_EMOJI_VERSION)/fonts
NOTO_COLOR_EMOJI_LICENSE = OFL-1.1

define NOTO_COLOR_EMOJI_EXTRACT_CMDS
	$(INSTALL) -D -m 0644 \
		$(NOTO_COLOR_EMOJI_DL_DIR)/$(NOTO_COLOR_EMOJI_SOURCE) \
		$(@D)/NotoColorEmoji.ttf
endef

define NOTO_COLOR_EMOJI_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/NotoColorEmoji.ttf \
		$(TARGET_DIR)/usr/share/kbrd/fonts/NotoColorEmoji.ttf
endef

$(eval $(generic-package))
