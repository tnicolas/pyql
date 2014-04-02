"""
 Copyright (C) 2011, Enthought Inc

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

cdef extern from 'ql/pricingengines/bond/discountingbondengine.hpp' namespace \
    'QuantLib':

    cdef cppclass DiscountingBondEngine(PricingEngine):

        DiscountingBondEngine()
        DiscountingBondEngine(Handle[YieldTermStructure]& discountCurve)
        DiscountingBondEngine(Handle[YieldTermStructure]& discountCurve,
                optional[bool] includeSttlementDateFlows)


