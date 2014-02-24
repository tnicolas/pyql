from quantlib.ql cimport _interest_rate as _ir, shared_ptr

cdef class InterestRate:
    cdef shared_ptr[_ir.InterestRate]* _thisptr

