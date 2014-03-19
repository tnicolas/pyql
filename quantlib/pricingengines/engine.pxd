# distutils: language = c++

from quantlib.ql cimport shared_ptr
from quantlib cimport ql

cdef class PricingEngine:
    cdef shared_ptr[ql.PricingEngine]* _thisptr


