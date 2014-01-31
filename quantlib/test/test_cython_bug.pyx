include '../types.pxi'

from cython.operator cimport dereference as deref
from libcpp.vector cimport vector

from quantlib.ql cimport (
    _actual_actual, _bonds, _calendar, _date, _period, _schedule
)

from quantlib.time.date cimport date_from_qldate, Date

cdef extern from "ql_settings.hpp" namespace "QL":
    _date.Date get_evaluation_date()
    void set_evaluation_date(_date.Date& date)


def test_bond_schedule_today_cython():
    cdef _date.Date today = _date.Date_todaysDate()
    cdef _calendar.Calendar calendar = _calendar.TARGET()

    cdef _bonds.FixedRateBond* bond = get_bond_for_evaluation_date(today)

    cdef _date.Date s_date = calendar.advance(
        today, <Integer>3, _period.Days, _calendar.Following, False)
    cdef _date.Date b_date = bond.settlementDate()

    cdef Date s1 = date_from_qldate(s_date)
    cdef Date s2 = date_from_qldate(b_date)

    return s1, s2


cdef _bonds.FixedRateBond* get_bond_for_evaluation_date(_date.Date& in_date):

    set_evaluation_date(in_date)

    # debugged evaluation date
    cdef _date.Date evaluation_date = get_evaluation_date()
    cdef Date cython_evaluation_date = date_from_qldate(evaluation_date)
    print 'Current evaluation date', cython_evaluation_date



    cdef _calendar.Calendar calendar = _calendar.TARGET()
    cdef _date.Date effective_date = _date.Date(10, _date.Jul, 2006)

    cdef _date.Date termination_date = calendar.advance(
        effective_date, <Integer>10, _period.Years, _calendar.Unadjusted, False
    )

    cdef Natural settlement_days = 3
    cdef Real face_amount = 100.0
    cdef Real coupon_rate = 0.05
    cdef Real redemption = 100.0

    cdef _schedule.Schedule fixed_bond_schedule = _schedule.Schedule(
            effective_date,
            termination_date,
            _period.Period(_period.Annual),
            calendar,
            _calendar.ModifiedFollowing,
            _calendar.ModifiedFollowing,
            _schedule.Backward,
            False
    )

    cdef _date.Date issue_date = _date.Date(10, _date.Jul, 2006)

    cdef vector[Rate]* coupons = new vector[Rate]()
    coupons.push_back(coupon_rate)

    cdef _bonds.FixedRateBond* bond = new _bonds.FixedRateBond(
            settlement_days,
            face_amount,
            fixed_bond_schedule,
            deref(coupons),
            _actual_actual.ActualActual(_actual_actual.ISMA),
            _calendar.Following,
            redemption,
            issue_date
    )

    return bond

def test_bond_schedule_anotherday_cython():

    cdef _date.Date last_month = _date.Date(30, _date.August, 2011)
    cdef _date.Date today = _date.Date_endOfMonth(last_month)

    cdef _bonds.FixedRateBond* bond = get_bond_for_evaluation_date(today)

    cdef _calendar.Calendar calendar = _calendar.TARGET()
    cdef _date.Date s_date = calendar.advance(
        today, <Integer>3, _period.Days, _calendar.Following, False
    )
    cdef _date.Date b_date = bond.settlementDate()

    cdef _date.Date e_date = get_evaluation_date()

    print s_date.serialNumber()
    print b_date.serialNumber()

    cdef Date s1 = date_from_qldate(s_date)
    cdef Date s2 = date_from_qldate(b_date)
    cdef Date s3 = date_from_qldate(e_date)
    print s3

    return s1, s2
