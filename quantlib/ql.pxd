from libcpp cimport bool

include 'types.pxi'

cdef extern from 'ql/version.hpp':

    char* QL_VERSION
    int QL_HEX_VERSION
    char* QL_LIB_VERSION

cdef extern from 'boost/shared_ptr.hpp' namespace 'boost':

    cdef cppclass shared_ptr[T]:
        shared_ptr()
        shared_ptr(T*)
        shared_ptr(shared_ptr[T]&)
        T* get()
        long use_count()
        #void reset(shared_ptr[T]&)

cdef extern from 'ql/handle.hpp' namespace 'QuantLib':
    cdef cppclass Handle[T]:
        Handle()
        Handle(T*)
        Handle(shared_ptr[T]&)
        shared_ptr[T]& currentLink()

    cdef cppclass RelinkableHandle[T](Handle):
        RelinkableHandle()
        RelinkableHandle(T*)
        RelinkableHandle(shared_ptr[T]*)
        void linkTo(shared_ptr[T]&)
        void linkTo(shared_ptr[T]&, bool registerAsObserver)


cimport quantlib._cashflow as _cashflow
cimport quantlib.instruments._bonds as _bonds
cimport quantlib.instruments._instrument as _instrument
cimport quantlib.processes._heston_process as _hp
cimport quantlib.processes._stochastic_process as _sp
cimport quantlib.pricingengines._pricing_engine as _pricing_engine
cimport quantlib.time._calendar as _calendar
cimport quantlib.time._date as _date
cimport quantlib.time._daycounter as _daycounter
cimport quantlib.time.daycounters._actual_actual as _actual_actual
cimport quantlib.time._period as _period
cimport quantlib.time._schedule as _schedule


# Local imports
cdef extern from "ql_settings.hpp" namespace "QL":
    _date.Date get_evaluation_date()
    void set_evaluation_date(_date.Date& date)

cdef extern from "simulate_support_code.hpp":

    void simulateMP(shared_ptr[_sp.StochasticProcess]& process,
                    int nbPaths, int nbSteps, Time horizon, BigNatural seed,
                    bool antithetic_variates, double *res) except +
