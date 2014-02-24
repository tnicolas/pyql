from quantlib.ql cimport shared_ptr, _optimization as _opt

cdef class OptimizationMethod:

    cdef shared_ptr[_opt.OptimizationMethod]* _thisptr

cdef class EndCriteria:

    cdef shared_ptr[_opt.EndCriteria]* _thisptr


