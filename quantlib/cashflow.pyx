"""
 Copyright (C) 2013, Enthought Inc
 Copyright (C) 2013, Patrick Henaff
 Copyright (c) 2012 BG Research LLC

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""
include 'types.pxi'
import datetime

from libcpp.vector cimport vector
from cython.operator cimport dereference as deref
from quantlib.ql cimport shared_ptr
from quantlib cimport ql

cimport quantlib.time.date as date
from quantlib.time.date import pydate_from_qldate, qldate_from_pydate



cdef class CashFlow:
    """Abstract Base Class.

    Use SimpleCashFlow instead

    """
    def __cinit__(self):
        self._thisptr = NULL

    def __init__(self):
        raise ValueError(
            'This is an abstract class.'
        )

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr

    property date:
        def __get__(self):
            cdef ql.Date cf_date
            if self._thisptr:
                cf_date = self._thisptr.get().date()
                return date.date_from_qldate(cf_date)
            else:
                return None

    property amount:
        def __get__(self):
            if self._thisptr:
                return self._thisptr.get().amount()
            else:
                return None


cdef class SimpleCashFlow(CashFlow):

    def __init__(self, Real amount, date.Date cfdate):
        cdef ql.Date* _cfdate
        _cfdate = <ql.Date*>((<date.Date>cfdate)._thisptr.get())

        self._thisptr = new shared_ptr[ql.CashFlow]( \
                            new ql.SimpleCashFlow(amount,
                                                   deref(_cfdate))
                            )

    def __str__(self):
        return 'Simple Cash Flow: %f, %s' % (self.amount,
                                             self.date)

cdef object leg_items(ql.Leg& leg):
    """
    Returns a list of (amount, pydate)
    """
    cdef int i
    cdef shared_ptr[ql.CashFlow] _thiscf
    cdef date.Date _thisdate

    itemlist = []
    print 'Size ', leg.size()
    for i in range(<int>leg.size()):
        print i
        _thiscf = leg.at(i)
        if _thiscf.get() is NULL:
            raise ValueError()
        else:
            print 'has cashflow'
        print 'Use count ', _thiscf.use_count()
        print 'Amount '
        print _thiscf.get().amount()
        print 'Date '
        print _thiscf.get().date().serialNumber()
        _thisdate = date.Date(_thiscf.get().date().serialNumber())
        

        itemlist.append((_thiscf.get().amount(), pydate_from_qldate(_thisdate)))
        print itemlist
    return itemlist

cdef class SimpleLeg:

    def __cinit__(self):
        self._thisptr = NULL

    def __init__(self, leg=None, noalloc=False):
        '''Takes as input a list of (amount, QL Date) tuples. '''

        #TODO: make so that it handles pydate as well as QL Dates.
        cdef shared_ptr[ql.CashFlow] _thiscf
        cdef ql.Date *_thisdate
        cdef int i

        if noalloc:
            return

        self._thisptr = new ql.Leg()   
        for _amount, _date in leg:
            if isinstance(_date, datetime.date):
                _date  = qldate_from_pydate(_date)
            _thisdate = <ql.Date*>((<date.Date>_date)._thisptr.get())
            _thiscf = shared_ptr[ql.CashFlow](
                new ql.SimpleCashFlow(_amount, deref(_thisdate))
            )
            self._thisptr.push_back(_thiscf)

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr

    property size:
        def __get__(self):
            cdef int size = self._thisptr.size()
            return size

    property items:
        def __get__(self):
            '''Return Leg as (amount, date) list

            '''
            cdef ql.Leg leg = deref(self._thisptr)
            return leg_items(leg)


    def to_str(self):
            """
            pretty print cash flow schedule
            """
            _items = self.items
            text = "Cash Flow Schedule:\n"
            for _it in _items:
                text += ("%s %f\n" % (_it[1], _it[0]))
            return text

