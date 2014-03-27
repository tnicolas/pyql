cdef extern from 'yield_piecewise_support_code.hpp' namespace 'QuantLib':

    cdef shared_ptr[YieldTermStructure] term_structure_factory(
        string& traits,
        string& interpolator,
        Date& settlement_date,
        vector[shared_ptr[RateHelper]]& curve_input,
        DayCounter& day_counter,
        Real tolerance
    ) except +

cdef extern from 'ql/termstructures/yield/piecewiseyieldcurve.hpp' namespace 'QuantLib':

    cdef cppclass PiecewiseYieldcurve[Traits, Interpolator]:
        PiecewiseYieldCurve()
        # Constructurors are not supported through the Cython syntax !
        #PiecewiseYieldCurve(
        #    Date& referenceDate,
        #    #vector[shared_ptr[Traits::helper]]& instruments,
        #    DayCounter& dayCounter,
        #    Real accuracy,
        #    #Interpolator& i,
        #    #Bootstrap<this_curve>& bootstrap
        #)
