from quantlib.ql cimport shared_ptr, Handle, _credit_helpers as _ci

cdef class CdsHelper:
    cdef shared_ptr[_ci.CdsHelper]* _thisptr

cdef class SpreadCdsHelper(CdsHelper):
    pass
