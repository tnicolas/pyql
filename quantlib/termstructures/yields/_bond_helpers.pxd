cdef extern from 'ql/termstructures/yield/bondhelpers.hpp' namespace 'QuantLib':

    cdef cppclass BondHelper(RateHelper):
        # this is added because of Cython. This empty constructor does not exist
        # and should never be used
        BondHelper()
        BondHelper(
            Handle[Quote]& cleanPrice,
            shared_ptr[Bond]& bond
            ) except +

    cdef cppclass FixedRateBondHelper(BondHelper):
        FixedRateBondHelper(
            Handle[Quote]& cleanPrice,
            Natural settlementDays,
            Real faceAmount,
            Schedule& schedule,
            vector[Rate]& coupons,
            DayCounter& dayCounter,
            int paymentConv,  # Following
            Real redemption,  # 100.0
            Date& issueDate  # Date()
        ) except +

