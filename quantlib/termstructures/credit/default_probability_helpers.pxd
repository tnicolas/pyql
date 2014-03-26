from quantlib cimport ql

cdef class CdsHelper:
    cdef ql.shared_ptr[ql.CdsHelper]* _thisptr

cdef class SpreadCdsHelper(CdsHelper):
    pass
