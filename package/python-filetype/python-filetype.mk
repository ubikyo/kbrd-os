################################################################################
#
# python-filetype
#
################################################################################

PYTHON_FILETYPE_VERSION = 1.2.0
PYTHON_FILETYPE_SOURCE = filetype-$(PYTHON_FILETYPE_VERSION).tar.gz
PYTHON_FILETYPE_SITE = https://files.pythonhosted.org/packages/source/f/filetype
PYTHON_FILETYPE_SETUP_TYPE = setuptools

PYTHON_FILETYPE_LICENSE = MIT
PYTHON_FILETYPE_LICENSE_FILES = LICENSE

$(eval $(python-package))