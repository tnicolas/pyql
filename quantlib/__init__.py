# For linking reason, the ql module needs to be loaded before any others.
# Otherwise the QuantLib symbols are not accessible by all the other Cython
# extensions. Dont' remote this import or it will break loading the dependent
# Cython modules.
from .ql import __quantlib_version__
