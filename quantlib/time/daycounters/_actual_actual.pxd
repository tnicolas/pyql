cdef extern from 'ql/time/daycounters/actualactual.hpp' namespace 'QuantLib::ActualActual':
    cdef enum Convention:
        ISMA
        # Bond -- Bond is duplicate of ISMA and conflicts with the Bond instrument
        ISDA
        Historical
        Actual365
        AFB
        Euro

cdef extern from 'ql/time/daycounters/actualactual.hpp' namespace 'QuantLib':

    cdef cppclass ActualActual(DayCounter):
        ActualActual(Convention)
