'''The 30/360 day count can be calculated according to US, European, or
Italian conventions.

US (NASD) convention: if the starting date is the 31st of a
month, it becomes equal to the 30th of the same month.
If the ending date is the 31st of a month and the starting
date is earlier than the 30th of a month, the ending date
becomes equal to the 1st of the next month, otherwise the
ending date becomes equal to the 30th of the same month.
Also known as "30/360", "360/360", or "Bond Basis"

European convention: starting dates or ending dates that
occur on the 31st of a month become equal to the 30th of the
same month.
Also known as "30E/360", or "Eurobond Basis"

Italian convention: starting dates or ending dates that
occur on February and are grater than 27 become equal to 30
for computational sake.

'''
from quantlib cimport ql
from quantlib.time.daycounter cimport DayCounter

cdef extern from 'ql/time/daycounters/thirty360.hpp' namespace 'QuantLib::Thirty360':

    cdef enum Convention:
        USA
        BondBasis
        European
        EurobondBasis
        Italian

USA_          = USA
BONDBASIS     = BondBasis
EUROPEAN      = European
EUROBONDBASIS = EurobondBasis
ITALIAN       = Italian

cdef class Thirty360(DayCounter):

    def __cinit__(self, convention=BONDBASIS):
        self._thisptr = <ql.DayCounter*> new \
            ql.Thirty360(<ql.Thirty360Convention> convention)



