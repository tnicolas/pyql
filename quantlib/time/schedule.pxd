from quantlib cimport ql

cdef class Schedule:
    cdef ql.Schedule* _thisptr

