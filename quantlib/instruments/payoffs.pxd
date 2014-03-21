from quantlib cimport ql

cdef class Payoff:
    cdef ql.shared_ptr[ql.Payoff]* _thisptr
    cdef set_payoff(self, ql.shared_ptr[ql.Payoff] payoff)

cdef class PlainVanillaPayoff(Payoff):
    pass
