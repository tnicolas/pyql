include '../../types.pxi'

from cython.operator cimport dereference as deref

from quantlib cimport ql
from quantlib.ql cimport shared_ptr 

from quantlib.models.equity.heston_model cimport HestonModel
from quantlib.models.equity.bates_model cimport (
    BatesModel, BatesDetJumpModel, BatesDoubleExpModel,
    BatesDoubleExpDetJumpModel
)
from quantlib.processes.black_scholes_process cimport GeneralizedBlackScholesProcess

from quantlib.pricingengines.engine cimport PricingEngine

cdef class VanillaOptionEngine(PricingEngine):

    pass

cdef class AnalyticEuropeanEngine(VanillaOptionEngine):

    def __init__(self, GeneralizedBlackScholesProcess process):

        cdef shared_ptr[ql.GeneralizedBlackScholesProcess] process_ptr = \
            shared_ptr[ql.GeneralizedBlackScholesProcess](
                deref(process._thisptr)
            )

        self._thisptr = new shared_ptr[ql.PricingEngine](\
            new ql.AnalyticEuropeanEngine(process_ptr)
        )

cdef class BaroneAdesiWhaleyApproximationEngine(VanillaOptionEngine):

    def __init__(self, GeneralizedBlackScholesProcess process):

        cdef shared_ptr[ql.GeneralizedBlackScholesProcess] process_ptr = \
            shared_ptr[ql.GeneralizedBlackScholesProcess](
                deref(process._thisptr)
            )

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.BaroneAdesiWhaleyApproximationEngine(process_ptr)
        )

cdef class AnalyticHestonEngine(PricingEngine):

    def __init__(self, HestonModel model, int integration_order=144):

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.AnalyticHestonEngine(
                deref(model._thisptr),
                <Size>integration_order
            )
        )

cdef class BatesEngine(AnalyticHestonEngine):

    def __init__(self, BatesModel model, int integration_order=144):

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.BatesEngine(
                deref(<shared_ptr[ql.BatesModel]*> model._thisptr),
                <Size>integration_order
            )
        )

cdef class BatesDetJumpEngine(BatesEngine):

    def __init__(self, BatesDetJumpModel model, int integration_order=144):

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.BatesDetJumpEngine(
                deref(<shared_ptr[ql.BatesDetJumpModel]*> model._thisptr),
                <Size>integration_order))

cdef class BatesDoubleExpEngine(AnalyticHestonEngine):

    def __init__(self, BatesDoubleExpModel model, int integration_order=144):

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.BatesDoubleExpEngine(
                deref(<shared_ptr[ql.BatesDoubleExpModel]*> model._thisptr),
                <Size>integration_order))

cdef class BatesDoubleExpDetJumpEngine(BatesDoubleExpEngine):

    def __init__(self, BatesDoubleExpDetJumpModel model, int integration_order=144):

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.BatesDoubleExpDetJumpEngine(
                deref(<shared_ptr[ql.BatesDoubleExpDetJumpModel]*> model._thisptr),
                <Size>integration_order))


cdef class AnalyticDividendEuropeanEngine(PricingEngine):

    def __init__(self, GeneralizedBlackScholesProcess process):

        cdef shared_ptr[ql.GeneralizedBlackScholesProcess] process_ptr = \
            shared_ptr[ql.GeneralizedBlackScholesProcess](
                deref(process._thisptr)
            )

        self._thisptr = new shared_ptr[ql.PricingEngine](\
            new ql.AnalyticDividendEuropeanEngine(process_ptr)
        )


cdef class FDDividendAmericanEngine(PricingEngine):

    def __init__(self, scheme, GeneralizedBlackScholesProcess process, timesteps, gridpoints):

        # FIXME: first implementation using a fixed scheme!
        print 'Warning : rough implementation using CrankNicolson schema'
        cdef shared_ptr[ql.GeneralizedBlackScholesProcess] process_ptr = \
            shared_ptr[ql.GeneralizedBlackScholesProcess](
                deref(process._thisptr)
            )

        self._thisptr = new shared_ptr[ql.PricingEngine](\
            new ql.FDDividendAmericanEngine[ql.CrankNicolson](
                process_ptr, timesteps, gridpoints
            )
        )

cdef class FDAmericanEngine(PricingEngine):

    def __init__(self, scheme, GeneralizedBlackScholesProcess process, timesteps, gridpoints):

        # FIXME: first implementation using a fixed scheme!
        cdef shared_ptr[ql.GeneralizedBlackScholesProcess] process_ptr = \
            shared_ptr[ql.GeneralizedBlackScholesProcess](
                deref(process._thisptr)
            )

        self._thisptr = new shared_ptr[ql.PricingEngine](\
            new ql.FDAmericanEngine[ql.CrankNicolson](
                process_ptr, timesteps, gridpoints
            )
        )


