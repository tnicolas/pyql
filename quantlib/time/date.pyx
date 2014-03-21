include '../types.pxi'

import datetime

from cython.operator cimport dereference as deref

# cannot use date.pxd because of name clashing
from quantlib cimport ql

cdef public enum Month:
    January   = ql.January
    February  = ql.February
    March     = ql.March
    April     = ql.April
    May       = ql.May
    June      = ql.June
    July      = ql.July
    August    = ql.August
    September = ql.September
    October   = ql.October
    November  = ql.November
    December  = ql.December
    Jan = ql.Jan
    Feb = ql.Feb
    Mar = ql.Mar
    Apr = ql.Apr
    Jun = ql.Jun
    Jul = ql.Jul
    Aug = ql.Aug
    Sep = ql.Sep
    Oct = ql.Oct
    Nov = ql.Nov
    Dec = ql.Dec

cdef public enum Weekday:
    Sunday   = ql.Sunday
    Monday   = ql.Monday
    Tuesday  = ql.Tuesday
    Wednesday = ql.Wednesday
    Thursday = ql.Thursday
    Friday   = ql.Friday
    Saturday = ql.Saturday
    Sun = ql.Sun
    Mon = ql.Mon
    Tue = ql.Tue
    Wed = ql.Wed
    Thu = ql.Thu
    Fri = ql.Fri
    Sat = ql.Sat

cdef public enum Frequency:
    NoFrequency      = ql.NoFrequency # null frequency
    Once             = ql.Once  # only once, e.g., a zero-coupon
    Annual           = ql.Annual  # once a year
    Semiannual       = ql.Semiannual  # twice a year
    EveryFourthMonth = ql.EveryFourthMonth  # every fourth month
    Quarterly        = ql.Quarterly  # every third month
    Bimonthly        = ql.Bimonthly  # every second month
    Monthly          = ql.Monthly # once a month
    EveryFourthWeek  = ql.EveryFourthWeek # every fourth week
    Biweekly         = ql.Biweekly # every second week
    Weekly           = ql.Weekly # once a week
    Daily            = ql.Daily # once a day
    OtherFrequency   = ql.OtherFrequency # some other unknown frequency

FREQUENCIES = ['NoFrequency', 'Once', 'Annual', 'Semiannual', 'EveryFourthMonth',
               'Quarterly', 'Bimonthly', 'Monthly', 'EveryFourthWeek',
               'Biweekly', 'Weekly', 'Daily', 'OtherFrequency']
_FREQ_DICT = {globals()[name]:name for name in FREQUENCIES}
_STR_FREQ_DICT = {name:globals()[name] for name in FREQUENCIES}

def frequency_to_str(Frequency f):
    """ Converts a PyQL Frequency to a human readable string. """
    return _FREQ_DICT[f]

def str_to_frequency(char* name):
    """ Converts a string to a PyQL Frequency. """
    return _STR_FREQ_DICT[name]

cdef public enum TimeUnit:
    Days   = ql.Days
    Weeks  = ql.Weeks
    Months = ql.Months
    Years  = ql.Years

cdef extern from "string" namespace "std":
    cdef cppclass string:
        char* c_str()

cdef class Period:
    ''' Class providing a Period (length + time unit) class and implements a
    limited algebra.

    '''

    def __cinit__(self, *args):
        if len(args) == 1:
            self._thisptr = new shared_ptr[ql.Period](new ql.Period(<ql.Frequency>args[0]))
        elif len(args) == 2:
            self._thisptr = new shared_ptr[ql.Period](new ql.Period(<Integer> args[0], <ql.TimeUnit> args[1]))
        else:
            raise RuntimeError('Invalid arguments for Period.__cinit__')

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr

    property length:
        def __get__(self):
            return self._thisptr.get().length()

    property units:
        def __get__(self):
            return self._thisptr.get().units()

    property frequency:
        def __get__(self):
            return self._thisptr.get().frequency()

    def normalize(self):
        '''Normalises the units.'''
        self._thisptr.get().normalize()

    def __sub__(self, value):
        cdef ql.Period outp
        if isinstance(self, Period) and isinstance(value, Period):
            outp = ql.sub_op(deref( (<Period>self)._thisptr.get()),
                    deref( (<Period>value)._thisptr.get()))

        # fixme : this is inefficient and ugly ;-)
        return Period(outp.length(), outp.units())

    def __mul__(self, value):
        cdef ql.Period inp
        if isinstance(self, Period):
            inp = deref((<Period>self)._thisptr.get())
            value = <int> value
        elif isinstance(self, int) and isinstance(value, Period):
            inp = deref((<Period>value)._thisptr.get())
            value = self
        else:
            raise NotImplemented()

        cdef ql.Period outp = ql.mult_op(inp, value)

        # fixme : this is inefficient and ugly ;-)
        return Period(outp.length(), outp.units())

    def __iadd__(self, value):
        cdef ql.Period p1
        cdef ql.Period* tmp  = (<Period>value)._thisptr.get()

        if isinstance(self, Period) and isinstance(value, Period):

            if self.units != value.units:
                raise ValueError('Units must be the same')

            p1 = self._thisptr.get().i_add( deref( tmp ))

            return self
        else:
            return NotImplemented

    def __isub__(self, value):
        cdef ql.Period p1
        cdef ql.Period* tmp  = (<Period>value)._thisptr.get()

        if isinstance(self, Period) and isinstance(value, Period):

            if self.units != value.units:
                raise ValueError('Units must be the same')

            p1 = self._thisptr.get().i_sub( deref( tmp ))

            return self
        else:
            return NotImplemented

    def __idiv__(self, value):
        cdef ql.Period p1

        if isinstance(self, Period) and isinstance(value, int):

            p1 = self._thisptr.get().i_div( <int> value)

            return self
        else:
            return NotImplemented


    def __richcmp__(self, value, t):

        cdef ql.Period* p1 = (<Period>self)._thisptr.get()
        if not isinstance(value, Period):
            return False

        cdef ql.Period* p2 = (<Period>value)._thisptr.get()

        if t==0:
            return ql.period_l_op( deref(p1), deref(p2))
        elif t==1:
            return ql.period_leq_op( deref(p1), deref(p2))
        elif t==2:
            return ql.period_eq_op( deref(p1), deref(p2))
        elif t==3:
            return ql.period_neq_op( deref(p1), deref(p2))
        elif t==4:
            return ql.period_g_op( deref(p1), deref(p2))
        elif t==5:
            return ql.period_geq_op( deref(p1), deref(p2))

    def __str__(self):
        return 'Period %d length  %d units' % (self.length, self.units)

cdef class Date:
    """ This class provides methods to inspect dates as well as methods and
    operators which implement a limited date algebra (increasing and decreasing
    dates, and calculating their difference).

    """

    def __cinit__(self, *args):

        if len(args) == 0:
            self._thisptr = new shared_ptr[ql.Date](new ql.Date())
        elif len(args) == 3:
            day, month, year = args
            self._thisptr = new shared_ptr[ql.Date](new ql.Date(<Integer>day, <ql.Month>month, <ql.Year>year))
        elif len(args) == 1:
            serial = args[0]
            self._thisptr = new shared_ptr[ql.Date](new ql.Date(<BigInteger> serial))
        else:
            raise RuntimeError('Invalid constructor')

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr
            self._thisptr = NULL

    property month:
        def __get__(self):
            return self._thisptr.get().month()

    property day:
        def __get__(self):
            return self._thisptr.get().dayOfMonth()

    property year:
        def __get__(self):
            return self._thisptr.get().year()

    property serial:
        def __get__(self):
            return self._thisptr.get().serialNumber()

    property weekday:
        def __get__(self):
            return self._thisptr.get().weekday()

    property day_of_year:
        """ Day of the year (one based - Jan 1st = 1). """
        def __get__(self):
            return self._thisptr.get().dayOfYear()

    def __str__(self):
        # fixme: cannot find an easy way to get the << operator usable here
        return '%2d/%02d/%2d' % (self._thisptr.get().dayOfMonth(),
                self._thisptr.get().month(), self._thisptr.get().year())

    def __repr__(self):
        return self.__str__()

    def __hash__(self):
        # Returns a hash based on the serial
        return self.serial

    def __cmp__(self, date2):
        if isinstance(date2, (datetime.date, datetime.datetime)):
            date2 = Date.from_datetime(date2)
        elif not isinstance(date2, Date):
            return NotImplemented

        if self.serial < date2.serial:
            return -1
        elif self.serial == date2.serial:
            return 0
        else:
            return 1


    def __richcmp__(self, date2, int t):

        if isinstance(date2, (datetime.date, datetime.datetime)):
            date2 = Date.from_datetime(date2)
        elif not isinstance(date2, Date):
            return NotImplemented

        # fixme : operations done on the Python objects, could probably be
        # done faster on the C++ int directly ?
        if t==0:
            return self.serial < date2.serial
        elif t==1:
            return self.serial <= date2.serial
        elif t==2:
            return self.serial == date2.serial
        elif t==3:
            return self.serial != date2.serial
        elif t==4:
            return self.serial > date2.serial
        elif t==5:
            return self.serial >= date2.serial

        return False

    def __int__(self):
        '''Conversion to int returns the serial value
        '''
        return self._thisptr.get().serialNumber()

    def __add__(self, value):
        cdef ql.Date add
        if isinstance(self, Date):
            if isinstance(value, Period):
                add = deref((<Date>self)._thisptr.get()) + deref((<Period>value)._thisptr.get())
            else:
                add = deref((<Date>self)._thisptr.get()) + <BigInteger>value
            return date_from_qldate(add)
        else:
            return NotImplemented

    def __iadd__(self, value):
        cdef ql.Date add
        if isinstance(self, Date):
            if isinstance(value, Period):
                add = self._thisptr.get().i_add(deref((<Period>value)._thisptr.get()))
            else:
                add = self._thisptr.get().i_add(<BigInteger>value)
            return self
        else:
            return NotImplemented

    def __sub__(self, value):
        cdef ql.Date sub
        if isinstance(self, Date):
            if isinstance(value, Period):
                sub = deref((<Date>self)._thisptr.get()) - deref((<Period>value)._thisptr.get())
            elif isinstance(value, int):
                sub = deref((<Date>self)._thisptr.get()) - <BigInteger>value
            else:
                raise ValueError('Unsupported operand')
            return date_from_qldate(sub)
        else:
            return NotImplemented

    def __isub__(self, value):
        cdef ql.Date sub
        if isinstance(self, Date):
            if isinstance(value, Period):
                self._thisptr.get().i_sub( deref((<Period>value)._thisptr.get()) )
            else:
                self._thisptr.get().i_sub( <BigInteger>value)
            return self
        else:
            return NotImplemented

    @classmethod
    def from_datetime(cls, date):
        """Returns the Quantlib Date object from the date/datetime object. """

        return Date(date.day, date.month, date.year)

def today():
    '''Today's date. '''
    cdef ql.Date today = ql.Date_todaysDate()
    return date_from_qldate(today)

def next_weekday(Date date, int weekday):
    ''' Returns the next given weekday following or equal to the given date
    '''
    cdef ql.Date nwd = ql.Date_nextWeekday( deref(date._thisptr.get()), <ql.Weekday>weekday)
    return date_from_qldate(nwd)

def nth_weekday(int size, int weekday, int month, int year):
    '''Return the n-th given weekday in the given month and ql.Year

    E.g., the 4th Thursday of March, 1998 was March 26th, 1998.

    see http://www.cpearson.com/excel/DateTimeWS.htm
    '''
    cdef ql.Date nwd = ql.Date_nthWeekday(<ql.Size>size, <ql.Weekday>weekday, <ql.Month>month, <ql.Year>year)
    return date_from_qldate(nwd)

def end_of_month(Date date):
    '''Last day of the month to which the given date belongs.'''
    cdef ql.Date eom = ql.Date_endOfMonth(deref(date._thisptr.get()))
    return date_from_qldate(eom)

def maxdate():
    '''Latest allowed date.'''
    cdef ql.Date mdate = ql.Date_maxDate()
    return date_from_qldate(mdate)

def mindate():
    '''Earliest date allowed.'''
    cdef ql.Date mdate = ql.Date_minDate()
    return date_from_qldate(mdate)

def is_end_of_month(Date date):
    '''Whether a date is the last day of its month.'''
    return ql.Date_isEndOfMonth(deref(date._thisptr.get()))

def is_leap(int year):
    '''Whether the given ql.Year is a leap one.'''
    return ql.Date_isLeap(<ql.Year> year)

cdef Date date_from_qldate(ql.Date& date):
    '''Converts a QuantLib::Date (ql.Date) to a cython Date instance.

    Inefficient because taking a copy of the date ... but safe!
    '''
    return Date(date.serialNumber())


# Date Interfaces

cdef object _pydate_from_qldate(ql.Date qdate):
    """ Converts a QuantLib Date (C++) to a datetime.date object. """

    cdef int m = qdate.month()
    cdef int d = qdate.dayOfMonth()
    cdef int y = qdate.year()

    return datetime.date(y, m, d)

cpdef object pydate_from_qldate(Date qdate):
    """ Converts a PyQL Date to a datetime.date object. """

    cdef int m = qdate.month
    cdef int d = qdate.day
    cdef int y = qdate.year

    return datetime.date(y, m, d)

cdef ql.Date _qldate_from_pydate(object pydate):
    """ Converts a datetime.date to a QuantLib (C++) object. """

    cdef Date qdate_ref = Date.from_datetime(pydate)
    cdef ql.Date* date_ref = <ql.Date*>qdate_ref._thisptr.get()

    return deref(date_ref)


cpdef Date qldate_from_pydate(object pydate):
    """ Converts a datetime.date to a PyQL date. """

    cdef Date qdate_ref = Date.from_datetime(pydate)

    return qdate_ref



