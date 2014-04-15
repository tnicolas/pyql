include '../../types.pxi'

from cython.operator cimport dereference as deref
from libcpp.vector cimport vector

from quantlib cimport ql
from quantlib.ql cimport shared_ptr

from quantlib.instruments.bonds cimport Bond
from quantlib.quotes cimport Quote
from quantlib.time.date cimport Date
from quantlib.time.schedule cimport Schedule
from quantlib.time.daycounter cimport DayCounter
from quantlib.termstructures.yields.rate_helpers cimport RateHelper


cdef class BondHelper(RateHelper):

    def __init__(self, Quote clean_price, Bond bond):

        # Create quote handle.
        cdef ql.Handle[ql.Quote] price_handle = ql.Handle[ql.Quote](
            deref(clean_price._thisptr)
        )

        self._thisptr = new shared_ptr[ql.RateHelper](
            new ql.BondHelper(
                price_handle,
                deref(<shared_ptr[ql.Bond]*> bond._thisptr)
            ))


cdef class FixedRateBondHelper(BondHelper):

    def __init__(self, Quote clean_price, Natural settlement_days,
                 Real face_amount, Schedule schedule, coupons,
                 DayCounter day_counter, int payment_conv=ql.Following,
                 Real redemption=100.0, Date issue_date=None):

        # Turn Python coupons list into an STL vector.
        cdef vector[Rate] cpp_coupons = vector[Rate]()
        for rate in coupons:
            cpp_coupons.push_back(rate)

        # Create handles.
        cdef ql.Handle[ql.Quote] price_handle = \
                ql.Handle[ql.Quote](deref(clean_price._thisptr))

        # Deal with issue_date default parameter.
        if issue_date is None:
            issue_date = Date()

        self._thisptr = new shared_ptr[ql.RateHelper](
            new ql.FixedRateBondHelper(
                price_handle,
                settlement_days,
                face_amount,
                deref(schedule._thisptr),
                cpp_coupons,
                deref(day_counter._thisptr),
                <ql.BusinessDayConvention> payment_conv,
                redemption,
                deref(issue_date._thisptr.get())
            ))
