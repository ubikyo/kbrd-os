PYTHON_CYTHON_KIVY_VERSION = 3.0.11
PYTHON_CYTHON_KIVY_SOURCE = cython-$(PYTHON_CYTHON_KIVY_VERSION).tar.gz
PYTHON_CYTHON_KIVY_SITE = https://files.pythonhosted.org/packages/source/C/Cython

PYTHON_CYTHON_KIVY_LICENSE = Apache-2.0
PYTHON_CYTHON_KIVY_LICENSE_FILES = COPYING.txt LICENSE.txt

HOST_PYTHON_CYTHON_KIVY_DEPENDENCIES = host-python3 host-python-setuptools

HOST_PYTHON_CYTHON_KIVY_INSTALL_DIR = $(HOST_DIR)/lib/python-kivy

define HOST_PYTHON_CYTHON_KIVY_BUILD_CMDS
	cd $(@D) && \
		$(HOST_DIR)/bin/python3 setup.py build
endef

define HOST_PYTHON_CYTHON_KIVY_INSTALL_CMDS
	rm -rf $(HOST_PYTHON_CYTHON_KIVY_INSTALL_DIR)
	mkdir -p $(HOST_PYTHON_CYTHON_KIVY_INSTALL_DIR)
	cd $(@D) && \
		$(HOST_DIR)/bin/python3 setup.py install \
			--skip-build \
			--install-lib=$(HOST_PYTHON_CYTHON_KIVY_INSTALL_DIR) \
			--install-scripts=$(HOST_PYTHON_CYTHON_KIVY_INSTALL_DIR)/bin
endef

$(eval $(host-generic-package))