from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.string cimport string

include 'types.pxi'

include '_boost.pxd'

cdef extern from 'ql/version.hpp':

    char* QL_VERSION
    int QL_HEX_VERSION
    char* QL_LIB_VERSION

# ! include order is important! 

include "time/_period.pxd"
include "time/_date.pxd"
include "time/_calendar.pxd"
include "time/_daycounter.pxd"
include "time/_schedule.pxd"

include "time/daycounters/_actual_actual.pxd"
include "time/daycounters/_thirty360.pxd"

include "time/calendars/_germany.pxd"
include "time/calendars/_jointcalendar.pxd"
include "time/calendars/_null_calendar.pxd"
include "time/calendars/_united_kingdom.pxd"
include "time/calendars/_united_states.pxd"

include "_cashflow.pxd"
include "_currency.pxd"
include "_index.pxd"
include "_interest_rate.pxd"
include "_quote.pxd"

include "indexes/_interest_rate_index.pxd"
include "indexes/_ibor_index.pxd"
include "indexes/_libor.pxd"
include "indexes/_swap_index.pxd"
include "indexes/_euribor.pxd"

include "pricingengines/_pricing_engine.pxd"

include "instruments/_instrument.pxd"
include "instruments/_bonds.pxd"

include "termstructures/volatility/equityfx/_black_vol_term_structure.pxd"
include "processes/_black_scholes_process.pxd"
include "instruments/_exercise.pxd"
include "instruments/_payoffs.pxd"
include "instruments/_option.pxd"
include "instruments/_credit_default_swap.pxd"

include "termstructures/_helpers.pxd"
include "termstructures/_yield_term_structure.pxd"
include "termstructures/yields/_flat_forward.pxd"
include "termstructures/yields/_rate_helpers.pxd"
include "termstructures/yields/_zero_curve.pxd"
include "termstructures/_default_term_structure.pxd"

include "termstructures/credit/_credit_helpers.pxd"

include "pricingengines/_swap.pxd"
include "pricingengines/_bond.pxd"

include "math/_optimization.pxd"
include "processes/_heston_process.pxd"
include "processes/_stochastic_process.pxd"
include "models/equity/_heston_model.pxd"
include "models/equity/_bates_model.pxd"
include "pricingengines/vanilla/_vanilla.pxd"

##### Local imports from the C++ support code

cdef extern from "ql_settings.hpp" namespace "QuantLib":
    Date get_evaluation_date()
    void set_evaluation_date(Date& date)

cdef extern from "simulate_support_code.hpp" namespace 'QuantLib':
    void simulateMP(shared_ptr[StochasticProcess]& process,
                    int nbPaths, int nbSteps, Time horizon, BigNatural seed,
                    bool antithetic_variates, double *res) except +

cdef extern from 'mc_vanilla_engine_support_code.hpp' namespace 'QuantLib':

    cdef shared_ptr[PricingEngine] mc_vanilla_engine_factory(
      string& trait, 
      string& RNG,
      shared_ptr[HestonProcess]& process,
      bool doAntitheticVariate,
      Size stepsPerYear,
      Size requiredSamples,
      BigNatural seed) except +


include "termstructures/yields/_piecewise_yield_curve.pxd"
include "termstructures/credit/_piecewise_default_curve.pxd"

include "pricingengines/_blackformula.pxd"