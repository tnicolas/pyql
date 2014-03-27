from quantlib cimport ql

cdef class PricingEngine:
    cdef ql.shared_ptr[ql.PricingEngine]* _thisptr


