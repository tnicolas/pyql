cdef extern from 'ql/indexes/ibor/euribor.hpp' namespace 'QuantLib':

    cdef cppclass Euribor(IborIndex):
        Euribor()
        Euribor(Period& tenor,
                Handle[YieldTermStructure]& h) except +

    cdef cppclass Euribor6M(Euribor):
        Euribor6M(Handle[YieldTermStructure]& yc)

