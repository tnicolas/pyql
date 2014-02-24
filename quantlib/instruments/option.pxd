from quantlib.ql cimport shared_ptr, _exercise

cdef class Exercise:
    cdef shared_ptr[_exercise.Exercise]* _thisptr
    cdef set_exercise(self, shared_ptr[_exercise.Exercise] exc)


