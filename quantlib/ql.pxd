from libcpp cimport bool
from libcpp.vector cimport vector
from libcpp.string cimport string

include 'types.pxi'

cdef extern from 'ql/version.hpp':

    char* QL_VERSION
    int QL_HEX_VERSION
    char* QL_LIB_VERSION

from quantlib.handle cimport shared_ptr, Handle, RelinkableHandle
from quantlib cimport _cashflow
from quantlib cimport _currency
from quantlib cimport _index 
from quantlib cimport _interest_rate
from quantlib cimport _quote
from quantlib.indexes cimport _euribor
from quantlib.indexes cimport _ibor_index
from quantlib.indexes cimport _libor
from quantlib.indexes cimport _swap_index
from quantlib.indexes cimport _interest_rate_index
from quantlib.instruments cimport _bonds
from quantlib.instruments cimport _credit_default_swap
from quantlib.instruments cimport _exercise
from quantlib.instruments cimport _instrument
from quantlib.instruments cimport _option
from quantlib.instruments cimport _payoffs
from quantlib.math cimport _interpolations
from quantlib.math cimport _optimization
from quantlib.models.equity cimport _bates_model
from quantlib.models.equity cimport _heston_model
from quantlib.processes cimport _black_scholes_process
from quantlib.processes cimport _heston_process
from quantlib.processes cimport _stochastic_process
from quantlib.pricingengines cimport _blackformula
from quantlib.pricingengines cimport _bond as _bond_pricing_engine
from quantlib.pricingengines cimport _pricing_engine
from quantlib.pricingengines cimport _swap
from quantlib.pricingengines cimport _credit
from quantlib.pricingengines.vanilla cimport _vanilla
from quantlib.termstructures cimport _default_term_structure 
from quantlib.termstructures cimport _yield_term_structure
from quantlib.termstructures.credit cimport _credit_helpers
from quantlib.termstructures.credit cimport _piecewise_default_curve
from quantlib.termstructures.volatility.equityfx cimport _black_vol_term_structure
from quantlib.termstructures.yields cimport _flat_forward
from quantlib.termstructures.yields cimport _rate_helpers
from quantlib.termstructures.yields cimport _zero_curve
from quantlib.termstructures.yields cimport _piecewise_yield_curve
from quantlib.time cimport _calendar
from quantlib.time.calendars cimport (
    _united_states, _united_kingdom, _null_calendar, _germany, _jointcalendar
)
from quantlib.time cimport _date
from quantlib.time cimport _daycounter
from quantlib.time.daycounters cimport _actual_actual, _thirty360
from quantlib.time cimport _period
from quantlib.time cimport _schedule


# Local imports from the C++ support code

cdef extern from "ql_settings.hpp" namespace "QL":
    _date.Date get_evaluation_date()
    void set_evaluation_date(_date.Date& date)

cdef extern from "simulate_support_code.hpp":

    void simulateMP(shared_ptr[_stochastic_process.StochasticProcess]& process,
                    int nbPaths, int nbSteps, Time horizon, BigNatural seed,
                    bool antithetic_variates, double *res) except +

cdef extern from 'mc_vanilla_engine_support_code.hpp' namespace 'QuantLib':

    cdef shared_ptr[_pricing_engine.PricingEngine] mc_vanilla_engine_factory(
      string& trait, 
      string& RNG,
      shared_ptr[_heston_process.HestonProcess]& process,
      bool doAntitheticVariate,
      Size stepsPerYear,
      Size requiredSamples,
      BigNatural seed) except +

## Cython does not seem to handle nested templates
## cdef extern from 'ql/pricingengines/vanilla/mcvanillaengine.hpp' namespace 'QuantLib':

##     cdef cppclass MCVanillaEngine[[MC], RNG, S, Inst]:
##         pass
##         # Not using the constructor because of the missing support for typemaps
##         # in Cython --> use only the vanilla_engine_factory!