from quantlib.indexes.interest_rate_index cimport InterestRateIndex


cdef class IborIndex(InterestRateIndex):
    def __cinit__(self):
        pass

cdef class OvernightIndex(IborIndex):
    def __cinit__(self):
        pass

