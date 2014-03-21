include '../types.pxi'

# Cython imports
from cython.operator cimport dereference as deref
from libcpp cimport bool
from libcpp.vector cimport vector

from quantlib cimport ql 
from quantlib.ql cimport shared_ptr

from quantlib.instruments.instrument cimport Instrument
from quantlib.instruments.payoffs cimport Payoff, PlainVanillaPayoff
from quantlib.time.date cimport Date
from quantlib.pricingengines.engine cimport PricingEngine
from quantlib.processes.black_scholes_process cimport GeneralizedBlackScholesProcess

cdef public enum ExerciseType:
    American = ql.American
    Bermudan  = ql.Bermudan
    European = ql.European

EXERCISE_TO_STR = {
    American : 'American',
    Bermudan : 'Bermudan',
    European : 'European'
}

cdef class Exercise:

    def __cinit__(self):
        self._thisptr = NULL

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr
            self._thisptr = NULL

    def __str__(self):
        return 'Exercise type: %s' % EXERCISE_TO_STR[self._thisptr.get().type()]

    cdef set_exercise(self, shared_ptr[ql.Exercise] exc):
        if exc.get() == NULL:
            raise ValueError('Setting the exercise with a null pointer.')
        self._thisptr = new shared_ptr[ql.Exercise](exc)

cdef class EuropeanExercise(Exercise):

    def __init__(self, Date exercise_date):
        self._thisptr = new shared_ptr[ql.Exercise]( \
            new ql.EuropeanExercise(
                deref(exercise_date._thisptr.get())
            )
        )

cdef class AmericanExercise(Exercise):

    def __init__(self, Date latest_exercise_date, Date earliest_exercise_date=None):
        """ Creates an AmericanExercise.

        :param latest_exercise_date: Latest exercise date for the option
        :param earliest_exercise_date: Earliest exercise date for the option (default to None)

        """
        if earliest_exercise_date is not None:
            self._thisptr = new shared_ptr[ql.Exercise]( \
                new ql.AmericanExercise(
                    deref(earliest_exercise_date._thisptr.get()),
                    deref(latest_exercise_date._thisptr.get())
                )
            )
        else:
            self._thisptr = new shared_ptr[ql.Exercise]( \
                new ql.AmericanExercise(
                    deref(latest_exercise_date._thisptr.get())
                )
            )

cdef ql.Option* get_option(OneAssetOption option):
    """ Utility function to extract a properly casted VanillaOption out of the
    internal _thisptr attribute of the Instrument base class. """

    cdef ql.Option* ref = <ql.Option*>option._thisptr.get()
    return ref

cdef class OneAssetOption(Instrument):

    def __init__(self):
        raise NotImplementedError(
            'Cannot implement this abstract class. Use child like the '
            'VanillaOption'
        )

    def __str__(self):
        return '%s %s %s' % (
            type(self).__name__, str(self.exercise), str(self.payoff)
        )

    property exercise:
        def __get__(self):
            exercise = Exercise()
            exercise.set_exercise(get_option(self).exercise())
            return exercise

    property payoff:
        def __get__(self):
            payoff = Payoff(0, 0., from_qlpayoff=True)
            payoff.set_payoff(get_option(self).payoff())
            return payoff

    property is_expired:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).isExpired()

    property delta:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).delta()

    property delta_forward:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).deltaForward()

    property elasticity:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).elasticity()

    property gamma:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).gamma()

    property theta:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).theta()

    property theta_per_day:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).thetaPerDay()

    property vega:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).vega()

    property rho:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).rho()

    property dividend_rho:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).dividendRho()

    property strike_sensitivity:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).strikeSensitivity()

    property itm_cash_probability:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).itmCashProbability()


cdef class VanillaOption(OneAssetOption):

    def __init__(self, PlainVanillaPayoff payoff, Exercise exercise):

        cdef shared_ptr[ql.StrikedTypePayoff] payoff_ptr = \
            shared_ptr[ql.StrikedTypePayoff](
                deref(<shared_ptr[ql.StrikedTypePayoff]*>payoff._thisptr)
        )

        cdef shared_ptr[ql.Exercise] exercise_ptr = \
            shared_ptr[ql.Exercise](
                deref(exercise._thisptr)
            )

        self._thisptr = new shared_ptr[ql.Instrument]( \
            new ql.VanillaOption(payoff_ptr, exercise_ptr)
        )


    def implied_volatility(self, Real target_value,
        GeneralizedBlackScholesProcess process, Real accuracy, Size max_evaluations,
        Volatility min_vol, Volatility max_vol):

        cdef shared_ptr[ql.GeneralizedBlackScholesProcess] process_ptr = \
            shared_ptr[ql.GeneralizedBlackScholesProcess](
                deref(<shared_ptr[ql.GeneralizedBlackScholesProcess]*>process._thisptr)
        )

        vol = (<ql.VanillaOption *> self._thisptr.get()).impliedVolatility(
            target_value, process_ptr, accuracy, max_evaluations, min_vol, max_vol)

        return vol

    property delta:
        def __get__(self):
            if self._has_pricing_engine:
                return (<ql.OneAssetOption *> self._thisptr.get()).delta()

cdef class EuropeanOption(VanillaOption):

    def __init__(self, PlainVanillaPayoff payoff, Exercise exercise):

        cdef shared_ptr[ql.StrikedTypePayoff] payoff_ptr = \
            shared_ptr[ql.StrikedTypePayoff](
                deref(<shared_ptr[ql.StrikedTypePayoff]*>payoff._thisptr)
        )

        cdef shared_ptr[ql.Exercise] exercise_ptr = \
            shared_ptr[ql.Exercise](
                deref(exercise._thisptr)
            )

        self._thisptr = new shared_ptr[ql.Instrument]( \
            new ql.EuropeanOption(payoff_ptr, exercise_ptr)
        )

cdef class DividendVanillaOption(OneAssetOption):
    """ Single-asset vanilla option (no barriers) with discrete dividends. """

    def __init__(self, PlainVanillaPayoff payoff, Exercise exercise, dividend_dates, dividends):

        cdef shared_ptr[ql.StrikedTypePayoff] payoff_ptr = \
            shared_ptr[ql.StrikedTypePayoff](
                deref(<shared_ptr[ql.StrikedTypePayoff]*>payoff._thisptr)
        )

        cdef shared_ptr[ql.Exercise] exercise_ptr = \
            shared_ptr[ql.Exercise](
                deref(exercise._thisptr)
        )

        # convert the list of PyQL dates into a vector of QL dates
        cdef vector[ql.Date]* _dividend_dates = new vector[ql.Date]()
        for date in dividend_dates:
            _dividend_dates.push_back(deref((<Date>date)._thisptr.get()))

        # convert the list of float to a vector of Real
        cdef vector[Real]* _dividends = new vector[Real]()
        for value in dividends:
            _dividends.push_back(<Real>value)

        self._thisptr = new shared_ptr[ql.Instrument]( \
            new ql.DividendVanillaOption(
                payoff_ptr, exercise_ptr, deref(_dividend_dates),
                deref(_dividends)
            )
        )

        # cleanup temporary allocated pointers
        del _dividend_dates
        del _dividends

    def implied_volatility(self, Real target_value,
        GeneralizedBlackScholesProcess process, Real accuracy, Size max_evaluations,
        Volatility min_vol, Volatility max_vol):

        cdef shared_ptr[ql.GeneralizedBlackScholesProcess] process_ptr = \
            shared_ptr[ql.GeneralizedBlackScholesProcess](
                deref(<shared_ptr[ql.GeneralizedBlackScholesProcess]*>process._thisptr)
        )

        vol = (<ql.DividendVanillaOption *> self._thisptr.get()).impliedVolatility(
            target_value, process_ptr, accuracy, max_evaluations, min_vol, max_vol)

        return vol
