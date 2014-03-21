from quantlib cimport ql

cdef class Exercise:
    cdef ql.shared_ptr[ql.Exercise]* _thisptr
    cdef set_exercise(self, ql.shared_ptr[ql.Exercise] exc)


