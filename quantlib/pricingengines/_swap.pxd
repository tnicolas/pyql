cdef extern from 'ql/pricingengines/swap/discountingswapengine.hpp' namespace 'QuantLib':

    cdef cppclass DiscountingSwapEngine(PricingEngine):
        DiscountingSwapEngine(Handle[YieldTermStructure]& discount_curve,
                              bool includeSettlementDateFlows,
                              Date& settlementDate,
                              Date& npvDate)

