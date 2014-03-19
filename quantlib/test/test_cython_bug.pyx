include '../types.pxi'

from cython.operator cimport dereference as deref
from libcpp.vector cimport vector

from quantlib.ql cimport (
    get_evaluation_date, set_evaluation_date,
    ActualActual, TARGET, Years, Unadjusted, Schedule, Period,
    ModifiedFollowing, Backward, FixedRateBond, ISMA, Days, Calendar,
    Date_endOfMonth, Date_todaysDate, Following, Annual, Jul, August
)
from quantlib cimport ql #need to avoid clashing with the PyQL Date

from quantlib.time.date cimport date_from_qldate, Date

cdef FixedRateBond* get_bond_for_evaluation_date(ql.Date& in_date):

    set_evaluation_date(in_date)
    
    # debugged evaluation date
    cdef ql.Date evaluation_date = get_evaluation_date()
    #cdef Date cython_evaluation_date = date_from_qldate(evaluation_date)
    print 'Current evaluation date', evaluation_date.serialNumber()

    cdef Calendar calendar = TARGET()
    cdef ql.Date effective_date = ql.Date(10, Jul, 2006)

    cdef ql.Date termination_date = calendar.advance(
        effective_date, <Integer>10, Years, Unadjusted, False
    )

    cdef Natural settlement_days = 3
    cdef Real face_amount = 100.0
    cdef Real coupon_rate = 0.05
    cdef Real redemption = 100.0

    cdef Schedule fixed_bond_schedule = Schedule(
            effective_date,
            termination_date,
            Period(Annual),
            calendar,
            ModifiedFollowing,
            ModifiedFollowing,
            Backward,
            False
    )

    cdef ql.Date issue_date = ql.Date(10, Jul, 2006)

    cdef vector[Rate]* coupons = new vector[Rate]()
    coupons.push_back(coupon_rate)

    cdef FixedRateBond* bond = new FixedRateBond(
            settlement_days,
            face_amount,
            fixed_bond_schedule,
            deref(coupons),
            ActualActual(ISMA),
            Following,
            redemption,
            issue_date
    )

    return bond

def test_bond_schedule_today_cython():
    cdef ql.Date today = Date_todaysDate()
    cdef Calendar calendar = TARGET()

    cdef FixedRateBond* bond = get_bond_for_evaluation_date(today)

    cdef ql.Date s_date = calendar.advance(
        today, <Integer>3, Days, Following, False)
    cdef ql.Date b_date = bond.settlementDate()

    print s_date.serialNumber()
    print b_date.serialNumber()
    cdef Date s1 = date_from_qldate(s_date)
    cdef Date s2 = date_from_qldate(b_date)

    return s1, s2

def test_bond_schedule_anotherday_cython():

    cdef ql.Date last_month = ql.Date(30, August, 2011)
    cdef ql.Date eval_date = Date_endOfMonth(last_month)
    cdef Calendar calendar = TARGET()

    cdef FixedRateBond* bond = get_bond_for_evaluation_date(eval_date)

    cdef ql.Date s_date = calendar.advance(
        eval_date, <Integer>3, Days, Following, False
    )
    cdef ql.Date b_date = bond.settlementDate()
    cdef ql.Date e_date = get_evaluation_date()

    cdef Date s1 = date_from_qldate(s_date)
    cdef Date s2 = date_from_qldate(b_date)
    
    cdef Date s3 = date_from_qldate(e_date)
    print 'Evaluation date ', s_date.serialNumber()
    print b_date.serialNumber()
    
    return s1, s2
