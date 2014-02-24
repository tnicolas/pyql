from quantlib.ql cimport shared_ptr, _payoffs

cdef class Payoff:
    cdef shared_ptr[_payoffs.Payoff]* _thisptr
    cdef set_payoff(self, shared_ptr[_payoffs.Payoff] payoff)

cdef class PlainVanillaPayoff(Payoff):
    pass
