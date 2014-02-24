"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from cython.operator cimport dereference as deref

from quantlib.ql cimport (
    shared_ptr, Handle, _yield_term_structure as _yts, _credit_helpers as _ci,
    _period, _schedule, _calendar
)

from quantlib.time.date cimport Period
from quantlib.time.calendar cimport Calendar
from quantlib.time.daycounter cimport DayCounter
from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure

cdef class CdsHelper:
    """Base default-probability bootstrap helper
        @param tenor  CDS tenor.
        @param frequency  Coupon frequency.
        @param settlementDays  The number of days from today's date
                               to the start of the protection period.
        @param paymentConvention The payment convention applied to
                                 coupons schedules, settlement dates
                                 and protection period calculations.
    """



cdef class SpreadCdsHelper(CdsHelper):
    """Spread-quoted CDS hazard rate bootstrap helper. """

    def __init__(self, float running_spread, Period tenor, int settlement_days,
                 Calendar calendar, int frequency,
                 int paymentConvention, int date_generation_rule,
                 DayCounter daycounter, float recovery_rate,
                 YieldTermStructure discount_curve, settles_accrual=True,
                 pays_at_default_time=True):
        """
        """

        cdef Handle[_yts.YieldTermStructure] yts = \
                Handle[_yts.YieldTermStructure](
                    deref(discount_curve._thisptr)
                )


        self._thisptr = new shared_ptr[_ci.CdsHelper](\
            new _ci.SpreadCdsHelper(running_spread, deref(tenor._thisptr.get()),
                settlement_days, deref(calendar._thisptr), <_period.Frequency>frequency,
                <_calendar.BusinessDayConvention>paymentConvention, 
                <_schedule.Rule>date_generation_rule,
                deref(daycounter._thisptr),
                recovery_rate, yts, settles_accrual,
                pays_at_default_time)
        )
