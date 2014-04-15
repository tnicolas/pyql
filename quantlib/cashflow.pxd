include 'types.pxi'

from quantlib cimport ql
from quantlib.ql cimport shared_ptr

from libcpp.vector cimport vector

cdef class CashFlow:
    cdef shared_ptr[ql.CashFlow]* _thisptr

cdef class SimpleCashFlow(CashFlow):
    pass

cdef class Leg:
    cdef shared_ptr[ql.Leg]* _thisptr

cdef class SimpleLeg:
    cdef shared_ptr[vector[shared_ptr[ql.CashFlow]]] *_thisptr

cdef object leg_items(vector[shared_ptr[ql.CashFlow]] leg)
