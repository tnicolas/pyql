
from cython.operator cimport dereference as deref

from quantlib.ql cimport (
    shared_ptr, _pricing_engine as _pe, _instrument, _date
)

from quantlib.pricingengines.engine cimport PricingEngine
from quantlib.time.date cimport date_from_qldate

cdef class Instrument:

    def __cinit__(self):
        self._thisptr = NULL
        self._has_pricing_engine = False

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr
            self._thisptr = NULL

    def set_pricing_engine(self, PricingEngine engine):
        '''Sets the pricing engine.

        '''
        cdef shared_ptr[_pe.PricingEngine] engine_ptr = \
                shared_ptr[_pe.PricingEngine](deref(engine._thisptr))

        self._thisptr.get().setPricingEngine(engine_ptr)

        self._has_pricing_engine = True

    property net_present_value:
        """ Instrument net present value. """
        def __get__(self):
            if self._has_pricing_engine:
                return self._thisptr.get().NPV()

    property npv:
        """ Shortcut to the net_present_value property. """
        def __get__(self):
            return self.net_present_value


    property valuation_date:
        """ The instrument valuation date. """
        def __get__(self):
            cdef _date.Date valuation_date
            valuation_date = self._thisptr.get().valuationDate()
            return date_from_qldate(valuation_date)
