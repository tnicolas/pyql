cdef extern from "string" namespace "std":
    cdef cppclass string:
        char* c_str()

cdef extern from 'ql/payoff.hpp' namespace 'QuantLib':
        
    cdef cppclass Payoff:
        Payoff()
        string name()


cdef extern from 'ql/instruments/payoffs.hpp' namespace 'QuantLib':

    cdef cppclass TypePayoff(Payoff):
        TypePayoff()
        TypePayoff(Type type)
        Type optionType()

    cdef cppclass StrikedTypePayoff(TypePayoff):
        StrikedTypePayoff()
        StrikedTypePayoff(Type type, Real strike)
        Real strike()

    cdef cppclass PlainVanillaPayoff(StrikedTypePayoff):
        PlainVanillaPayoff()
        PlainVanillaPayoff(Type type, Real strike)
