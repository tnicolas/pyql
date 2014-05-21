"""
 Copyright (C) 2013, Enthought Inc
 Copyright (C) 2013, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

cdef extern from 'ql/instruments/vanillaswap.hpp' namespace 'QuantLib':
    
    # renamed to avoid conflicts with the Option Type
    cdef enum VanillaSwapType 'QuantLib::VanillaSwap::Type':
        pass

    cdef cppclass VanillaSwap(Swap):

        VanillaSwap(VanillaSwapType type,
                    Real nominal,
                    Schedule& fixedSchedule,
                    Rate fixedRate,
                    DayCounter& fixedDayCount,
                    Schedule& floatSchedule,
                    shared_ptr[IborIndex] iborIndex,
                    Spread spread,
                    DayCounter& floatingDayCount,
                    BusinessDayConvention paymentConvention)

        VanillaSwapType type()
        Real nominal()

        Schedule& fixedSchedule()
        Rate fixedRate()
        DayCounter& fixedDayCount()

        Schedule& floatingSchedule()
        shared_ptr[IborIndex]& iborIndex()
        Spread spread()
        DayCounter& floatingDayCount()

        BusinessDayConvention paymentConvention()

        Leg& fixedLeg()
        Leg& floatingLeg()

        Real fixedLegBPS() except +
        Real fixedLegNPV() except +
        Rate fairRate() except +

        Real floatingLegBPS() except +
        Real floatingLegNPV() except +
        Spread fairSpread() except +
