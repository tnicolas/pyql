from quantlib cimport ql

from quantlib.time.calendar cimport Calendar

cdef extern from 'ql/time/calendars/unitedkingdom.hpp' namespace 'QuantLib::UnitedKingdom':

    cdef enum Market:
        Settlement
        Exchange
        Metals

SETTLEMENT = Settlement
EXCHANGE   = Exchange
METALS     = Metals

cdef class UnitedKingdom(Calendar):
    ''' United Kingdom calendars.

    Public holidays (data from http://www.dti.gov.uk/er/bankhol.htm):

        Saturdays
        Sundays
        New Year's Day, January 1st (possibly moved to Monday)
        Good Friday
        Easter Monday
        Early May Bank Holiday, first Monday of May
        Spring Bank Holiday, last Monday of May
        Summer Bank Holiday, last Monday of August
        Christmas Day, December 25th (possibly moved to Monday or Tuesday)
        Boxing Day, December 26th (possibly moved to Monday or Tuesday)

    Holidays for the stock exchange:

        Saturdays
        Sundays
        New Year's Day, January 1st (possibly moved to Monday)
        Good Friday
        Easter Monday
        Early May Bank Holiday, first Monday of May
        Spring Bank Holiday, last Monday of May
        Summer Bank Holiday, last Monday of August
        Christmas Day, December 25th (possibly moved to Monday or Tuesday)
        Boxing Day, December 26th (possibly moved to Monday or Tuesday)

    Holidays for the metals exchange:

        Saturdays
        Sundays
        New Year's Day, January 1st (possibly moved to Monday)
        Good Friday
        Easter Monday
        Early May Bank Holiday, first Monday of May
        Spring Bank Holiday, last Monday of May
        Summer Bank Holiday, last Monday of August
        Christmas Day, December 25th (possibly moved to Monday or Tuesday)
        Boxing Day, December 26th (possibly moved to Monday or Tuesday)
    '''

    def __cinit__(self, market=SETTLEMENT):
        self._thisptr = new ql.UnitedKingdom(market)


