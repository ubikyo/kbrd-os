PYTHON_KIVY_VERSION = 2.3.1
PYTHON_KIVY_SOURCE = Kivy-$(PYTHON_KIVY_VERSION).tar.gz
PYTHON_KIVY_SITE = https://files.pythonhosted.org/packages/source/K/Kivy
PYTHON_KIVY_SETUP_TYPE = setuptools

PYTHON_KIVY_LICENSE = MIT
PYTHON_KIVY_LICENSE_FILES = LICENSE

PYTHON_KIVY_DEPENDENCIES = \
	host-python-cython-kivy \
	host-python-packaging \
	host-python-setuptools \
	host-python-wheel \
	python-filetype \
	sdl2 \
	sdl2_image \
	sdl2_mixer \
	sdl2_ttf \
	gstreamer1 \
	gst1-plugins-base \
	libgles \
	libegl

PYTHON_KIVY_ENV = \
	PYTHONPATH="$(HOST_DIR)/lib/python-kivy:$(HOST_DIR)/lib/python3.14/site-packages" \
	USE_SDL2=1 \
	USE_GSTREAMER=1 \
	USE_X11=0 \
	USE_OPENGL_ES2=1 \
	USE_OPENGL_MOCK=1

define PYTHON_KIVY_NORMALIZE_GSTPLAYER_LINE_ENDINGS
	$(SED) 's/\r$$//' \
		$(@D)/kivy/core/video/video_gstplayer.py \
		$(@D)/kivy/lib/gstplayer/_gstplayer.h \
		$(@D)/kivy/lib/gstplayer/_gstplayer.pyx
endef

PYTHON_KIVY_POST_EXTRACT_HOOKS += \
	PYTHON_KIVY_NORMALIZE_GSTPLAYER_LINE_ENDINGS

define PYTHON_KIVY_RELAX_BUILD_DEPENDENCIES
	$(SED) 's/setuptools~=69\.2\.0/setuptools>=69.2.0/' $(@D)/pyproject.toml
	$(SED) 's/wheel~=0\.44\.0/wheel>=0.44.0/' $(@D)/pyproject.toml
	$(SED) 's/packaging~=24\.0/packaging>=24.0/' $(@D)/pyproject.toml
endef

PYTHON_KIVY_POST_PATCH_HOOKS += PYTHON_KIVY_RELAX_BUILD_DEPENDENCIES

define PYTHON_KIVY_FIX_SDL2_PATHS
	$(SED) "/sdl2_paths.extend(\['\/usr\/local\/include\/SDL2', '\/usr\/include\/SDL2'\])/d" $(@D)/setup.py
	$(SED) "/flags\['library_dirs'\] = (/,+2c\\    flags['library_dirs'] = sdl2_paths" $(@D)/setup.py
endef

PYTHON_KIVY_POST_PATCH_HOOKS += PYTHON_KIVY_FIX_SDL2_PATHS

$(eval $(python-package))
