from quantlib.ql cimport shared_ptr, _black_scholes_process as _bsp

cdef class GeneralizedBlackScholesProcess:

    cdef shared_ptr[_bsp.GeneralizedBlackScholesProcess]* _thisptr



