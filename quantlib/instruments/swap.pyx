"""
 Copyright (C) 2013, Enthought Inc
 Copyright (C) 2013, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

include '../types.pxi'

from cython.operator cimport dereference as deref
from libcpp.vector cimport vector
from libcpp cimport bool

from quantlib cimport ql
from quantlib.ql cimport shared_ptr

from quantlib.instruments.instrument cimport Instrument
from quantlib.time.date cimport Date, date_from_qldate
from quantlib.time.schedule cimport Schedule
from quantlib.time.daycounter cimport DayCounter
from quantlib.indexes.ibor_index cimport IborIndex
from quantlib.cashflow cimport SimpleLeg

import datetime

cdef extern from 'ql/instruments/vanillaswap.hpp' namespace 'QuantLib::VanillaSwap':
    cdef enum Type:
        Payer
        Receiver

PAYER    = Payer
RECEIVER = Receiver


cdef ql.Swap* get_swap(Swap swap):
    """ Utility function to extract a properly casted Swap pointer out of the
    internal _thisptr attribute of the Instrument base class. """

    cdef ql.Swap* ref = <ql.Swap*>swap._thisptr.get()
    return ref


cdef class Swap(Instrument):
    """
    Base swap class
    """

    def __init__(self):
        raise NotImplementedError('Generic swap not yet implemented. \
        Please use child classes.')
            
    property is_expired:
        def __get__(self):
            cdef bool is_expired = get_swap(self).isExpired()
            return is_expired

    property start_date:
        def __get__(self):
            cdef ql.Date dt = get_swap(self).startDate()
            return date_from_qldate(dt)

    property maturity_date:
        def __get__(self):
            cdef ql.Date dt = get_swap(self).maturityDate()
            return date_from_qldate(dt)

    def leg_BPS(self, Size j):
        return get_swap(self).legBPS(j)

    def leg_NPV(self, Size j):
        return get_swap(self).legNPV(j)

    ## def startDiscounts(self, Size j):
    ##     return get_swap(self).startDiscounts(j)

    ## def endDiscounts(self, Size j):
    ##     return get_swap(self).endDiscounts(j)

    ## def npvDateDiscount(self):
    ##     return get_swap(self).npvDateDiscount()

cdef ql.VanillaSwap* get_vanilla_swap(VanillaSwap swap):
    """ Utility function to extract a properly casted Swap pointer out of the
    internal _thisptr attribute of the Instrument base class. """

    cdef ql.VanillaSwap* ref = \
         <ql.VanillaSwap*>swap._thisptr.get()
    return ref

cdef class VanillaSwap(Swap):
    """
    Vanilla swap class
    """

    def __init__(self, Type type_,
                     Real nominal,
                     Schedule fixed_schedule,
                     Rate fixed_rate,
                     DayCounter fixed_daycount,
                     Schedule float_schedule,
                     IborIndex ibor_index,
                     Spread spread,
                     DayCounter floating_daycount,
                     ql.BusinessDayConvention payment_convention):

        cdef ql.Schedule* _fixed_schedule = <ql.Schedule*>fixed_schedule._thisptr
        cdef ql.Schedule* _float_schedule = <ql.Schedule*>float_schedule._thisptr


        self._thisptr = new shared_ptr[ql.Instrument](\
            new ql.VanillaSwap(<ql.VanillaSwapType>type_, nominal,
                     deref(_fixed_schedule), fixed_rate,
                     deref(fixed_daycount._thisptr),
                     deref(_float_schedule),
                     deref(<shared_ptr[ql.IborIndex]*> ibor_index._thisptr),
                     spread,
                     deref(floating_daycount._thisptr),
                     <ql.BusinessDayConvention>payment_convention))

    property fair_rate:
        def __get__(self):
            cdef Rate res = get_vanilla_swap(self).fairRate()
            return res

    property fair_spread:
        def __get__(self):
            cdef Spread res = get_vanilla_swap(self).fairSpread()
            return res

    property fixed_leg_bps:
        def __get__(self):
            cdef Real res = get_vanilla_swap(self).fixedLegBPS()
            return res

    property floating_leg_bps:
        def __get__(self):
            cdef Real res = get_vanilla_swap(self).floatingLegBPS()
            return res

    property fixed_leg_npv:
        def __get__(self):
            cdef Real res = get_vanilla_swap(self).fixedLegNPV()
            return res

    property floating_leg_npv:
        def __get__(self):
            cdef Real res = get_vanilla_swap(self).floatingLegNPV()
            return res

    def leg(self, int i):
        """
        Return a swap leg
        TODO: optimize this - avoid copy
        """

        cdef vector[shared_ptr[ql.CashFlow]] leg = get_vanilla_swap(self).leg(i)

        cdef int k
        cdef shared_ptr[ql.CashFlow] _thiscf

        itemlist = []
        cdef int size = leg.size()

        for k from 0 <= k < size:
            _thiscf = leg.at(k)
            _thisdate = Date(_thiscf.get().date().serialNumber())
            itemlist.append((_thiscf.get().amount(), _thisdate))

        return SimpleLeg(itemlist)
