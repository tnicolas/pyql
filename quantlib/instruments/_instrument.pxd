cdef extern from 'ql/instrument.hpp' namespace 'QuantLib':
    cdef cppclass Instrument:
        Instrument()

        Real NPV()
        const Date& valuationDate() except +
        void setPricingEngine(shared_ptr[PricingEngine]&) except +
        bool isExpired()


