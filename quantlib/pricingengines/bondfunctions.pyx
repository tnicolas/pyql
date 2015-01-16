include '../types.pxi'

#QL imports
from quantlib.instruments._bonds cimport Bond as QLBond
from quantlib.time._date cimport Day, Month, Year, Date as QLDate
from quantlib.time._period cimport Frequency as _Frequency
from quantlib.time._daycounter cimport DayCounter as _DayCounter
cimport quantlib.termstructures._yield_term_structure as _yt
cimport quantlib.pricingengines._bondfunctions as _bf

#pyql imports
from quantlib.handle cimport shared_ptr
from cython.operator cimport dereference as deref
from quantlib.instruments.bonds cimport Bond
from quantlib.time.date cimport date_from_qldate, Date
from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure
from quantlib.time.daycounter cimport DayCounter

cimport quantlib.pricingengines.bondfunctions

#cdef _bonds.Bond* get_bond(Bond bond):
#    """ Utility function to extract a properly casted Bond pointer out of the
#    internal _thisptr attribute of the Instrument base class. """
#
#    cdef _bonds.Bond* ref = <_bonds.Bond*>bond._thisptr.get()
cdef extern from 'ql/compounding.hpp' namespace 'QuantLib':
    cdef enum Compounding:
        Simple = 0
        Compounded = 1
        Continuous = 2
        SimpleThenCompounded = 3    


cdef extern from 'ql/compounding.hpp' namespace 'QuantLib':
    cdef class Duration:
        def __cinit__(self):
            pass
        cdef enum Type:
            Simple=0
            Macaulay=1
            Modified=2;
    
cdef class BondFunctions:
    
    def __cinit__(self):
        print "BondFunctions contructor"
        self._thisptr = new _bf.BondFunctions()

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr
            self._thisptr = NULL


    @classmethod
    def display(self):
        print "hello world"
    
    def startDate(self, Bond bond):

        cpdef QLBond* _bp = <QLBond*>bond._thisptr.get()
        d =  self._thisptr.startDate(deref(<QLBond*>_bp))
        return date_from_qldate(d)
      
        static Time duration(const Bond& bond,
                             Rate yield,
                             const DayCounter& dayCounter,
                             Compounding compounding,
                             Frequency frequency,
                             Duration::Type type = Duration::Modified,
                             Date settlementDate = Date() );          
        
    def zSpread(self, Bond bond, Real cleanPrice,
        YieldTermStructure pyts,
        DayCounter dayCounter,
        int compounding,
        int frequency,
        Date settlementDate,
        Real accuracy,
        Size maxIterations,
        Rate guess):
                        
        cpdef QLBond* _bp = <QLBond*>bond._thisptr.get()
        cpdef shared_ptr[_yt.YieldTermStructure] _yts = deref(pyts._thisptr)

        d =  self._thisptr.zSpread(
        deref(<QLBond*>_bp),
        cleanPrice,
        _yts,
        deref(dayCounter._thisptr),
        <Compounding> compounding,
        <_Frequency> frequency,
        deref(settlementDate._thisptr.get()),
        accuracy,
        maxIterations,
        guess)                    
                    
        return d