"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""                                   
cdef extern from 'ql/termstructures/credit/defaultprobabilityhelpers.hpp' namespace 'QuantLib':

    cdef cppclass CdsHelper(RelativeDateDefaultProbabilityHelper):
        CdsHelper() # empty constructor added for Cython
        CdsHelper(Handle[Quote]& quote, Period& tenor,
                  Integer settlementDays,
                  Calendar& calendar,
                  Frequency frequency,
                  BusinessDayConvention paymentConvention,
                  Rule rule,
                  DayCounter& dayCounter,
                  Real recoveryRate,
                  Handle[YieldTermStructure]& discountCurve,
                  bool settlesAccrual, # removed default value (true)
                  bool paysADefaultTime) # removed default value (true)

        void setTermStructure(DefaultProbabilityTermStructure*)

    cdef cppclass SpreadCdsHelper(CdsHelper):
         SpreadCdsHelper(Rate runningSpread,
                        Period& tenor,
                        Integer settlementDays,
                        Calendar& calendar,
                        Frequency frequency,
                        BusinessDayConvention paymentConvention,
                        Rule rule,
                        DayCounter& dayCounter,
                        Real recoveryRate,
                        Handle[YieldTermStructure]& discountCurve,
                        bool settlesAccrual,  # removed default value (true)
                        bool paysAtDefaultTime) # removed default value (true)

