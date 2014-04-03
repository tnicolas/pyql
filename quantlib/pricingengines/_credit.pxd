cdef extern from 'ql/pricingengines/credit/midpointcdsengine.hpp' namespace 'QuantLib':

    cdef cppclass MidPointCdsEngine(PricingEngine):
        MidPointCdsEngine(
              Handle[DefaultProbabilityTermStructure]&,
              Real recoveryRate,
              Handle[YieldTermStructure]& discountCurve,
              #boost::optional<bool> includeSettlementDateFlows = boost::none);
        )

