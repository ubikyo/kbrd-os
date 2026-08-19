################################################################################
#
# python-cython-kivy
#
################################################################################

PYTHON_CYTHON_KIVY_VERSION = 3.0.11
PYTHON_CYTHON_KIVY_SOURCE = cython-$(PYTHON_CYTHON_KIVY_VERSION).tar.gz
PYTHON_CYTHON_KIVY_SITE = https://files.pythonhosted.org/packages/source/C/Cython
PYTHON_CYTHON_KIVY_SETUP_TYPE = setuptools

PYTHON_CYTHON_KIVY_LICENSE = Apache-2.0
PYTHON_CYTHON_KIVY_LICENSE_FILES = COPYING.txt LICENSE.txt

$(eval $(host-python-package))