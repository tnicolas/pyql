from quantlib.ql cimport Handle, shared_ptr, _heston_process as _hp

cdef class HestonProcess:

    cdef shared_ptr[_hp.HestonProcess]* _thisptr
