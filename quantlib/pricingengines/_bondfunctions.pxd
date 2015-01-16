include '../types.pxi'

from quantlib.instruments._bonds cimport Bond as QLBond
from quantlib.handle cimport shared_ptr
from quantlib.time._period cimport Frequency
from quantlib.termstructures._yield_term_structure cimport YieldTermStructure
from quantlib.time._daycounter cimport DayCounter


cimport quantlib.time._date as _dt

cdef extern from 'ql/cashflows/duration.hpp' namespace 'QuantLib':
    
cdef cppclass Duration:
        cdef cppenum Type:
            Simple=0
            Macaulay=1
            Modified=2

cdef extern from 'ql/pricingengines/bond/bondfunctions.hpp' namespace 'QuantLib':

    cdef cppclass BondFunctions:
        _dt.Date startDate(QLBond bond)
        
        Time duration(QLBond bond, 
                        Rate yield,
                        DayCounter dayCounter,
                        int compounding,
                        Frequency frequency,
                        Duration::Type type = Duration::Modified,
                        Date settlementDate )    
                      
        Spread zSpread(QLBond bond,
                    Real cleanPrice,
                    shared_ptr[YieldTermStructure],
                    DayCounter dayCounter,
                    int compounding,
                    Frequency frequency,
                    _dt.Date settlementDate,
                    Real accuracy,
                    Size maxIterations,
                    Rate guess)