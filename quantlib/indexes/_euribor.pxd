cdef extern from 'ql/indexes/ibor/euribor.hpp' namespace 'QuantLib':

    cdef cppclass Euribor(IborIndex):
        pass
    
    cdef cppclass Euribor6M(Euribor):
        Euribor6M(Handle[YieldTermStructure]& yc)
