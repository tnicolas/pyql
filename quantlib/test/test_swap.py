from .unittest_tools import unittest

from quantlib.currency.api import USDCurrency
from quantlib.instruments.swap import VanillaSwap, Payer
from quantlib.indexes.libor import Libor
from quantlib.market.market import libor_market
from quantlib.pricingengines.swap import DiscountingSwapEngine
from quantlib.settings import Settings
from quantlib.termstructures.yields.api import (
    FlatForward, YieldTermStructure
)
from quantlib.time.api import (
    Unadjusted, ModifiedFollowing, Date, Days, Semiannual, January, Period,
    Annual, Years, Months, Actual365Fixed, Thirty360, TARGET, Actual360,
    Schedule, Forward
)
from quantlib.util.converter import pydate_to_qldate



class TestQuantLibSwap(unittest.TestCase):

    def test_swap_QL(self):
        """
        Test that a swap with fixed coupon = fair rate has an NPV=0
        Create from QL objects
        """

        swap_type = Payer
        nominal = 100.0
        fixedConvention = Unadjusted
        floatingConvention = ModifiedFollowing
        fixedFrequency = Annual
        floatingFrequency = Semiannual
        fixedDayCount = Thirty360()
        floatDayCount = Thirty360()
        calendar = TARGET()
        settlement_days = 2

        eval_date = Date(2, January, 2014)
        settings = Settings()
        settings.evaluation_date = eval_date

        settlement_date = calendar.advance(eval_date, settlement_days, Days)
        # must be a business day
        settlement_date = calendar.adjust(settlement_date)

        termStructure = YieldTermStructure(relinkable=True)
        termStructure.link_to(FlatForward(settlement_date, 0.05,
                                          Actual365Fixed()))

        index = Libor('USD Libor', Period(6, Months), settlement_days,
                      USDCurrency(), calendar, Actual360(),
                      termStructure)

        length = 5
        fixedRate = .05
        floatingSpread = 0.0

        maturity = calendar.advance(settlement_date, length, Years,
                                    convention=floatingConvention)

        fixedSchedule = Schedule(settlement_date, maturity,
                                 Period(fixedFrequency),
                                 calendar, fixedConvention, fixedConvention,
                                 Forward, False)

        floatSchedule = Schedule(settlement_date, maturity,
                                 Period(floatingFrequency),
                                 calendar, floatingConvention,
                                 floatingConvention,
                                 Forward, False)

        swap = VanillaSwap(swap_type, nominal, fixedSchedule, fixedRate,
                           fixedDayCount,
                           floatSchedule, index, floatingSpread,
                           floatDayCount, fixedConvention)

        engine = DiscountingSwapEngine(termStructure,
                                       False,
                                       settlement_date, settlement_date)
        swap.set_pricing_engine(engine)

        l = swap.leg(0)
        l = swap.leg(1)
        
        f = swap.fair_rate
        print('fair rate: %f' % f)
        p = swap.net_present_value
        print('NPV: %f' % p)

        swap = VanillaSwap(swap_type, nominal, fixedSchedule, f,
                           fixedDayCount,
                           floatSchedule, index, floatingSpread,
                           floatDayCount, fixedConvention)
        swap.set_pricing_engine(engine)

        p = swap.net_present_value
        print('NPV: %f' % p)
        self.assertAlmostEquals(p, 0)

    def test_swap_from_market(self):
        """
        Test that a swap with fixed coupon = fair rate has an NPV=0
        Create from market
        """

        eval_date = Date(2, January, 2014)
        settings = Settings()
        settings.evaluation_date = eval_date

        calendar = TARGET()
        settlement_date = calendar.advance(eval_date, 2, Days)
        # must be a business day
        settlement_date = calendar.adjust(settlement_date)

        length = 5
        fixed_rate = .05
        floating_spread = 0.0

        m = libor_market('USD(NY)')

        quotes = [('DEP', '1W', 0.0382),
                  ('DEP', '1M', 0.0372),
                  ('DEP', '3M', 0.0363),
                  ('DEP', '6M', 0.0353),
                  ('DEP', '9M', 0.0348),
                  ('DEP', '1Y', 0.0345),
                  ('SWAP', '2Y', 0.037125),
                  ('SWAP', '3Y', 0.0398),
                  ('SWAP', '5Y', 0.0443),
                  ('SWAP', '10Y', 0.05165),
                  ('SWAP', '15Y', 0.055175)]

        m.set_quotes(eval_date, quotes)

        m.bootstrap_term_structure()

        dt = Date(2, January, 2015)
        df = m.discount(dt)
        print('discount factor for %s (USD Libor): %f' % (dt, df))

        swap = m.create_fixed_float_swap(settlement_date, length, fixed_rate,
                                         floating_spread)

        fixed_l = swap.leg(0)

        float_l = swap.leg(1)

        f = swap.fair_rate
        print('fair rate: %f' % f)
        p = swap.net_present_value
        print('NPV: %f' % p)

        fixed_npv = swap.fixed_leg_npv
        float_npv = swap.floating_leg_npv

        # verify calculation by discounting both legs

        tot = 0.0
        for a, dt in fixed_l.items:
            df = m.discount(pydate_to_qldate(dt))
            tot += a * df
        print('fixed npv: %f discounted cf: %f' % (fixed_npv, tot))
        self.assertAlmostEquals(fixed_npv, -tot)

        tot = 0.0
        for a, dt in float_l.items:
            df = m.discount(pydate_to_qldate(dt))
            tot += a * df
        print('float npv: %f discounted cf: %f' % (float_npv, tot))
        self.assertAlmostEquals(float_npv, tot)


if __name__ == '__main__':
    unittest.main()
