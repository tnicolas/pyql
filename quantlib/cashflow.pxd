from quantlib cimport ql
from quantlib.ql cimport shared_ptr

from libcpp.vector cimport vector

cdef class CashFlow:	
    cdef shared_ptr[ql.CashFlow]* _thisptr

cdef class SimpleCashFlow(CashFlow):
    pass

cdef class SimpleLeg:
    cdef ql.Leg* _thisptr

cdef object leg_items(ql.Leg& leg)
