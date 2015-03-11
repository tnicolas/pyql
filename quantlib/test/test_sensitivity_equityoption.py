from quantlib.experimental.risk.sensitivityanalysis import bucketAnalysis
from quantlib.quotes import SimpleQuote
from quantlib.instruments.option import (
    EuropeanExercise, AmericanExercise, DividendVanillaOption
    )
from quantlib.instruments.payoffs import PlainVanillaPayoff, Put
from quantlib.instruments.option import VanillaOption
from quantlib.pricingengines.vanilla.vanilla import (
    AnalyticEuropeanEngine, BaroneAdesiWhaleyApproximationEngine,
    FDDividendAmericanEngine
    )
from quantlib.processes.black_scholes_process import BlackScholesMertonProcess
from quantlib.settings import Settings
from quantlib.time.api import Date, TARGET, May, Actual365Fixed
from quantlib.termstructures.yields.flat_forward import FlatForward
from quantlib.quotes import SimpleQuote

from quantlib.termstructures.volatility.equityfx.black_vol_term_structure import BlackConstantVol



settings = Settings()

calendar = TARGET()

todays_date = Date(15, May, 1998)
settlement_date = Date(17, May, 1998)

settings.evaluation_date = todays_date

# options parameters
option_type = Put
underlying = 40
strike = 40
dividend_yield = 0.00
risk_free_rate = 0.001
volatility = 0.20
maturity = Date(17, May, 1999)
daycounter = Actual365Fixed()

underlyingH = SimpleQuote(underlying)

payoff = PlainVanillaPayoff(option_type, strike)


# bootstrap the yield/dividend/vol curves
flat_term_structure = FlatForward(
    reference_date = settlement_date,
    forward        = risk_free_rate,
    daycounter     = daycounter
)
flat_dividend_ts = FlatForward(
    reference_date = settlement_date,
    forward        = dividend_yield,
    daycounter     = daycounter
)

flat_vol_ts = BlackConstantVol(
    settlement_date,
    calendar,
    volatility,
    daycounter
)

black_scholes_merton_process = BlackScholesMertonProcess(
    underlyingH,
    flat_dividend_ts,
    flat_term_structure,
    flat_vol_ts
)



european_exercise = EuropeanExercise(maturity)
european_option = VanillaOption(payoff, european_exercise)
analytic_european_engine = AnalyticEuropeanEngine(
            black_scholes_merton_process
        )

european_option.set_pricing_engine(analytic_european_engine)
print str(european_option.delta)
print str(european_option.npv)

print bucketAnalysis(
        [[underlyingH]],[european_option], [1], 0.50, 1)
