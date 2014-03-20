
from setuptools import setup, find_packages
# Warning : do not import the distutils extension before setuptools
# It does break the cythonize function calls
from distutils.extension import Extension

import glob
import os
import sys

from Cython.Distutils import build_ext
from Cython.Build import cythonize

import numpy

# Symbols added in quantlib.ql from the support code are not exposed to 
# the rest of the library. We need to expose them by hand ... 
# Gorry but works ... Need to find a real solution asap
#SYMBOLS = [
#    "?simulateMP@QuantLib@@YAXABV?$shared_ptr@VStochasticProcess@QuantLib@@@boost@@HHNK_NPAN@Z",
#    "?set_evaluation_date@QL@@YAXAAVDate@QuantLib@@@Z",
#    "?get_evaluation_date@QL@@YA?AVDate@QuantLib@@XZ",
#    "?term_structure_factory@QuantLib@@YA?AV?$shared_ptr@VYieldTermStructure@QuantLib@@@boost@@AAV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@0ABVDate@1@ABV?$vector@V?$shared_ptr@V?$BootstrapHelper@VYieldTermStructure@QuantLib@@@QuantLib@@@boost@@V?$allocator@V?$shared_ptr@V?$BootstrapHelper@VYieldTermStructure@QuantLib@@@QuantLib@@@boost@@@std@@@5@AAVDayCounter@1@N@Z",
#    "?credit_term_structure_factory@QuantLib@@YA?AV?$shared_ptr@VDefaultProbabilityTermStructure@QuantLib@@@boost@@AAV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@0ABVDate@1@ABV?$vector@V?$shared_ptr@V?$BootstrapHelper@VDefaultProbabilityTermStructure@QuantLib@@@QuantLib@@@boost@@V?$allocator@V?$shared_ptr@V?$BootstrapHelper@VDefaultProbabilityTermStructure@QuantLib@@@QuantLib@@@boost@@@std@@@5@AAVDayCounter@1@N@Z",
#    "?mc_vanilla_engine_factory@QuantLib@@YA?AV?$shared_ptr@VPricingEngine@QuantLib@@@boost@@AAV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@0ABV?$shared_ptr@VHestonProcess@QuantLib@@@3@_NIIK@Z",
#    # Start of QL symbols
#    # FIXME: this should be generated ... Can be found using `nm -ug target.obj`
#    "??0Period@QuantLib@@QAE@W4Frequency@1@@Z",
#    "?todaysDate@Date@QuantLib@@SA?AV12@XZ",
#    "??0TARGET@QuantLib@@QAE@XZ",
#    "?advance@Calendar@QuantLib@@QBE?AVDate@2@ABV32@HW4TimeUnit@2@W4BusinessDayConvention@2@_N@Z",
#    "??0Schedule@QuantLib@@QAE@VDate@1@ABV21@ABVPeriod@1@ABVCalendar@1@W4BusinessDayConvention@1@4W4Rule@DateGeneration@1@_N11@Z",
#    "??0FixedRateBond@QuantLib@@QAE@INABVSchedule@1@ABV?$vector@NV?$allocator@N@std@@@std@@ABVDayCounter@1@W4BusinessDayConvention@1@NABVDate@1@ABVCalendar@1@@Z",
#    "??0Date@QuantLib@@QAE@XZ",
#    "?implementation@ActualActual@QuantLib@@CA?AV?$shared_ptr@VImpl@DayCounter@QuantLib@@@boost@@W4Convention@12@@Z",
#    "?month@Date@QuantLib@@QBE?AW4Month@2@XZ",
#    "?year@Date@QuantLib@@QBEHXZ",
#    "?endOfMonth@Date@QuantLib@@SA?AV12@ABV12@@Z",
#    "?isLeap@Date@QuantLib@@SA_NH@Z",
#    "?monthLength@Date@QuantLib@@CAHW4Month@2@_N@Z",
#    "??0Date@QuantLib@@QAE@HW4Month@1@H@Z",
#    "?settlementDate@Bond@QuantLib@@QBE?AVDate@2@V32@@Z",
#    "??0ZeroCouponBond@QuantLib@@QAE@IABVCalendar@1@NABVDate@1@W4BusinessDayConvention@1@N1@Z",
#    "?what@Error@QuantLib@@UBEPBDXZ",
#    "?dirtyPrice@Bond@QuantLib@@QBENXZ",
#    "?maturityDate@Bond@QuantLib@@QBE?AVDate@2@XZ",
#    "?cleanPrice@Bond@QuantLib@@QBENXZ",
#    "??0Error@QuantLib@@QAE@ABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@J00@Z",
#    "?holidayList@Calendar@QuantLib@@SA?AV?$vector@VDate@QuantLib@@V?$allocator@VDate@QuantLib@@@std@@@std@@ABV12@ABVDate@2@1_N@Z",
#    "?advance@Calendar@QuantLib@@QBE?AVDate@2@ABV32@ABVPeriod@2@W4BusinessDayConvention@2@_N@Z",
#    "?removeHoliday@Calendar@QuantLib@@QAEXABVDate@2@@Z",
#    "?addHoliday@Calendar@QuantLib@@QAEXABVDate@2@@Z",
#    "?businessDaysBetween@Calendar@QuantLib@@QBEJABVDate@2@0_N1@Z",
#    "?assertion_failed@boost@@YAXPBD00J@Z",
#    "?adjust@Calendar@QuantLib@@QBE?AVDate@2@ABV32@W4BusinessDayConvention@2@@Z",
#    "??_0Period@QuantLib@@QAEAAV01@H@Z",
#    "?minDate@Date@QuantLib@@SA?AV12@XZ",
#    "?maxDate@Date@QuantLib@@SA?AV12@XZ",
#    "?nthWeekday@Date@QuantLib@@SA?AV12@IW4Weekday@2@W4Month@2@H@Z",
#    "?nextWeekday@Date@QuantLib@@SA?AV12@ABV12@W4Weekday@2@@Z",
#    "??ZDate@QuantLib@@QAEAAV01@ABVPeriod@1@@Z",
#    "??ZDate@QuantLib@@QAEAAV01@J@Z",
#    "??YDate@QuantLib@@QAEAAV01@ABVPeriod@1@@Z",  
#    "??YDate@QuantLib@@QAEAAV01@J@Z",
#    "??ZPeriod@QuantLib@@QAEAAV01@ABV01@@Z",
#    "??YPeriod@QuantLib@@QAEAAV01@ABV01@@Z",
#    "??GQuantLib@@YA?AVPeriod@0@ABV10@0@Z",
#    "?normalize@Period@QuantLib@@QAEXXZ",
#    "?frequency@Period@QuantLib@@QBE?AW4Frequency@2@XZ",
#    "?monthOffset@Date@QuantLib@@CAHW4Month@2@_N@Z",
#    "?advance@Date@QuantLib@@CA?AV12@ABV12@HW4TimeUnit@2@@Z",
#    "??0Date@QuantLib@@QAE@J@Z",
#    "?yearOffset@Date@QuantLib@@CAJH@Z",
#    "??MQuantLib@@YA_NABVPeriod@0@0@Z", 
#    "?yearFraction@Impl@Business252@QuantLib@@UBENABVDate@3@000@Z", 
#    "?dayCount@Impl@Business252@QuantLib@@UBEJABVDate@3@0@Z",
#    "?yearFraction@Impl@SimpleDayCounter@QuantLib@@UBENABVDate@3@000@Z",  
#    "?name@Impl@Business252@QuantLib@@UBE?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@XZ",
#    "?dayCount@Impl@SimpleDayCounter@QuantLib@@UBEJABVDate@3@0@Z",
#    "?previousDate@Schedule@QuantLib@@QBE?AVDate@2@ABV32@@Z",
#    "?nextDate@Schedule@QuantLib@@QBE?AVDate@2@ABV32@@Z",
#    "??0SimpleCashFlow@QuantLib@@QAE@NABVDate@1@@Z",
#    "??0JointCalendar@QuantLib@@QAE@ABVCalendar@1@0W4JointCalendarRule@1@@Z",
#    "??0UnitedKingdom@QuantLib@@QAE@W4Market@01@@Z",
#    "??0UnitedStates@QuantLib@@QAE@W4Market@01@@Z",
#    "??0Germany@QuantLib@@QAE@W4Market@01@@Z",
#    "?implementation@Thirty360@QuantLib@@CA?AV?$shared_ptr@VImpl@DayCounter@QuantLib@@@boost@@W4Convention@12@@Z",
#    "??0DiscountingBondEngine@QuantLib@@QAE@ABV?$Handle@VYieldTermStructure@QuantLib@@@1@V?$optional@_N@boost@@@Z",
#    "??0InterestRate@QuantLib@@QAE@XZ",
#    "?zeroRate@YieldTermStructure@QuantLib@@QBE?AVInterestRate@2@ABVDate@2@ABVDayCounter@2@W4Compounding@2@W4Frequency@2@_N@Z",
#    "??0InterestRate@QuantLib@@QAE@NABVDayCounter@1@W4Compounding@1@W4Frequency@1@@Z",
#    "?discount@YieldTermStructure@QuantLib@@QBENN_N@Z",
#    "??0FlatForward@QuantLib@@QAE@ABVDate@1@ABV?$Handle@VQuote@QuantLib@@@1@ABVDayCounter@1@W4Compounding@1@W4Frequency@1@@Z",
#    "??0FlatForward@QuantLib@@QAE@ABVDate@1@NABVDayCounter@1@W4Compounding@1@W4Frequency@1@@Z",
#    "??0FlatForward@QuantLib@@QAE@IABVCalendar@1@ABV?$Handle@VQuote@QuantLib@@@1@ABVDayCounter@1@W4Compounding@1@W4Frequency@1@@Z",
#    "??0FlatForward@QuantLib@@QAE@IABVCalendar@1@NABVDayCounter@1@W4Compounding@1@W4Frequency@1@@Z",
#    "??0FuturesRateHelper@QuantLib@@QAE@ABV?$Handle@VQuote@QuantLib@@@1@ABVDate@1@IABVCalendar@1@W4BusinessDayConvention@1@_NABVDayCounter@1@0@Z",
#    "??0FraRateHelper@QuantLib@@QAE@ABV?$Handle@VQuote@QuantLib@@@1@IIIABVCalendar@1@W4BusinessDayConvention@1@_NABVDayCounter@1@@Z",
#    "??0SwapRateHelper@QuantLib@@QAE@NABV?$shared_ptr@VSwapIndex@QuantLib@@@boost@@ABV?$Handle@VQuote@QuantLib@@@1@ABVPeriod@1@ABV?$Handle@VYieldTermStructure@QuantLib@@@1@@Z",
#    "??0SwapRateHelper@QuantLib@@QAE@NABVPeriod@1@ABVCalendar@1@W4Frequency@1@W4BusinessDayConvention@1@ABVDayCounter@1@ABV?$shared_ptr@VIborIndex@QuantLib@@@boost@@ABV?$Handle@VQuote@QuantLib@@@1@0ABV?$Handle@VYieldTermStructure@QuantLib@@@1@@Z",
#    "??0DepositRateHelper@QuantLib@@QAE@NABV?$shared_ptr@VIborIndex@QuantLib@@@boost@@@Z",
#    "??0DepositRateHelper@QuantLib@@QAE@NABVPeriod@1@IABVCalendar@1@W4BusinessDayConvention@1@_NABVDayCounter@1@@Z",
#    "??0SwapIndex@QuantLib@@QAE@ABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@ABVPeriod@1@IVCurrency@1@ABVCalendar@1@1W4BusinessDayConvention@1@ABVDayCounter@1@ABV?$shared_ptr@VIborIndex@QuantLib@@@boost@@@Z",
#    "??0Libor@QuantLib@@QAE@ABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@ABVPeriod@1@IABVCurrency@1@ABVCalendar@1@ABVDayCounter@1@ABV?$Handle@VYieldTermStructure@QuantLib@@@1@@Z",
#    "??0ZeroYieldStructure@QuantLib@@QAE@ABVDate@1@ABVCalendar@1@ABVDayCounter@1@ABV?$vector@V?$Handle@VQuote@QuantLib@@@QuantLib@@V?$allocator@V?$Handle@VQuote@QuantLib@@@QuantLib@@@std@@@std@@ABV?$vector@VDate@QuantLib@@V?$allocator@VDate@QuantLib@@@std@@@6@@Z",
#    "??6QuantLib@@YAAAV?$basic_ostream@DU?$char_traits@D@std@@@std@@AAV12@ABVDate@0@@Z",
#    "?setJumps@YieldTermStructure@QuantLib@@AAEXXZ",
#    "?update@TermStructure@QuantLib@@UAEXXZ",
#    "?referenceDate@TermStructure@QuantLib@@UBEABVDate@2@XZ",
#    "??0DividendVanillaOption@QuantLib@@QAE@ABV?$shared_ptr@VStrikedTypePayoff@QuantLib@@@boost@@ABV?$shared_ptr@VExercise@QuantLib@@@3@ABV?$vector@VDate@QuantLib@@V?$allocator@VDate@QuantLib@@@std@@@std@@ABV?$vector@NV?$allocator@N@std@@@6@@Z",
#    "??0EuropeanOption@QuantLib@@QAE@ABV?$shared_ptr@VStrikedTypePayoff@QuantLib@@@boost@@ABV?$shared_ptr@VExercise@QuantLib@@@3@@Z",
#    "??0VanillaOption@QuantLib@@QAE@ABV?$shared_ptr@VStrikedTypePayoff@QuantLib@@@boost@@ABV?$shared_ptr@VExercise@QuantLib@@@3@@Z",
#    "??0AmericanExercise@QuantLib@@QAE@ABVDate@1@0_N@Z",
#    "??0AmericanExercise@QuantLib@@QAE@ABVDate@1@_N@Z",
#    "??0EuropeanExercise@QuantLib@@QAE@ABVDate@1@@Z",
#    "?impliedVolatility@DividendVanillaOption@QuantLib@@QBENNABV?$shared_ptr@VGeneralizedBlackScholesProcess@QuantLib@@@boost@@NINN@Z",
#    "?impliedVolatility@VanillaOption@QuantLib@@QBENNABV?$shared_ptr@VGeneralizedBlackScholesProcess@QuantLib@@@boost@@NINN@Z",
#    "?itmCashProbability@OneAssetOption@QuantLib@@QBENXZ",
#    "?strikeSensitivity@OneAssetOption@QuantLib@@QBENXZ",
#    "?dividendRho@OneAssetOption@QuantLib@@QBENXZ",
#    "?rho@OneAssetOption@QuantLib@@QBENXZ",
#    "?vega@OneAssetOption@QuantLib@@QBENXZ",
#    "?thetaPerDay@OneAssetOption@QuantLib@@QBENXZ",
#    "?theta@OneAssetOption@QuantLib@@QBENXZ",
#    "?gamma@OneAssetOption@QuantLib@@QBENXZ",
#    "?elasticity@OneAssetOption@QuantLib@@QBENXZ",
#    "?deltaForward@OneAssetOption@QuantLib@@QBENXZ",
#    "?delta@OneAssetOption@QuantLib@@QBENXZ",
#    "?accept@PlainVanillaPayoff@QuantLib@@UAEXAAVAcyclicVisitor@2@@Z",
#    "?description@StrikedTypePayoff@QuantLib@@UBE?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@XZ",
#    "?description@TypePayoff@QuantLib@@UBE?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@XZ",
#    "??RPlainVanillaPayoff@QuantLib@@UBENN@Z",
#     "??0BlackScholesMertonProcess@QuantLib@@QAE@ABV?$Handle@VQuote@QuantLib@@@1@ABV?$Handle@VYieldTermStructure@QuantLib@@@1@1ABV?$Handle@VBlackVolTermStructure@QuantLib@@@1@ABV?$shared_ptr@Vdiscretization@StochasticProcess1D@QuantLib@@@boost@@@Z",
#     "??0BlackScholesProcess@QuantLib@@QAE@ABV?$Handle@VQuote@QuantLib@@@1@ABV?$Handle@VYieldTermStructure@QuantLib@@@1@ABV?$Handle@VBlackVolTermStructure@QuantLib@@@1@ABV?$shared_ptr@Vdiscretization@StochasticProcess1D@QuantLib@@@boost@@@Z",
#     "?covariance@EulerDiscretization@QuantLib@@UBE?AV?$Disposable@VMatrix@QuantLib@@@2@ABVStochasticProcess@2@NABVArray@2@N@Z",
#     "?diffusion@EulerDiscretization@QuantLib@@UBE?AV?$Disposable@VMatrix@QuantLib@@@2@ABVStochasticProcess@2@NABVArray@2@N@Z",
#     "?diffusion@EulerDiscretization@QuantLib@@UBENABVStochasticProcess1D@2@NNN@Z",
#     "?drift@EulerDiscretization@QuantLib@@UBE?AV?$Disposable@VArray@QuantLib@@@2@ABVStochasticProcess@2@NABVArray@2@N@Z",
#     "?drift@EulerDiscretization@QuantLib@@UBENABVStochasticProcess1D@2@NNN@Z",
#     "?variance@EulerDiscretization@QuantLib@@UBENABVStochasticProcess1D@2@NNN@Z",
#]

def load_symbols():
    with open('exported_symbols.txt') as fh:
        content = fh.read()
        for line in content.split('\n'):
            if line.startswith('#'):
                continue
            else:
                yield line.strip()

SYMBOLS = list(load_symbols())


SUPPORT_CODE_INCLUDE = './cpp_layer'
CYTHON_DIRECTIVES = {"embedsignature": True}
BUILDING_ON_WINDOWS = False

#FIXME: would be good to be able to customize the path with envrironment
# variables in place of hardcoded paths ...
if sys.platform == 'darwin':
    INCLUDE_DIRS = ['/usr/local/include',
                    '/Users/dpinte/projects/sources/boost_1_55_0',
                    '.', SUPPORT_CODE_INCLUDE]
    LIBRARY_DIRS = ["/usr/local/lib"]
elif sys.platform == 'win32':
    INCLUDE_DIRS = [
        r'C:\dev\QuantLib-1.3',  # QuantLib headers
        r'C:\dev\boost_1_55_0_lib',  # Boost headers
        '.',
        SUPPORT_CODE_INCLUDE
    ]
    LIBRARY_DIRS = [
        r'C:\dev\boost_1_55_0_lib\lib32-msvc-9.0',
        r'C:\dev\QuantLib-1.3\lib',
        r'.',
        # On Win32, we need to explicitely link with the quantlib.ql.pyd
        # We point to the directory where the generated .lib file is and 
        # allows us to link against the content of ql.pyd/.lib
        r'C:\dev\pyql\build\temp.win32-2.7\Release\quantlib'
    ]
    BUILDING_ON_WINDOWS = True
    
elif sys.platform == 'linux2':
    # good for Debian / ubuntu 10.04 (with QL .99 installed by default)
    INCLUDE_DIRS = ['/usr/local/include', '/usr/include', '.', SUPPORT_CODE_INCLUDE]
    LIBRARY_DIRS = ['/usr/local/lib', '/usr/lib', ]
    # custom install of QuantLib 1.1
    # INCLUDE_DIRS = ['/opt/QuantLib-1.1', '.', SUPPORT_CODE_INCLUDE]
    # LIBRARY_DIRS = ['/opt/QuantLib-1.1/lib',]

def get_define_macros():
    defines = [ ('HAVE_CONFIG_H', None)]
    if sys.platform == 'win32':
        # based on the SWIG wrappers
        defines += [
            (name, None) for name in [
                '__WIN32__', 'WIN32', 'NDEBUG', '_WINDOWS', 'NOMINMAX', 'WINNT',
                '_WINDLL', '_SCL_SECURE_NO_DEPRECATE', '_CRT_SECURE_NO_DEPRECATE',
                '_SCL_SECURE_NO_WARNINGS',
            ]
        ]
    return defines

def get_extra_compile_args():
    if sys.platform == 'win32':
        args = ['/GR', '/FD', '/Zm250', '/EHsc' ]
    else:
        args = []

    return args

def get_extra_link_args():
    if sys.platform == 'win32':
        args = ['/subsystem:windows', '/machine:I386',] # '/NODEFAULTLIB:library']
    else:
        args = []

    return args
 
# FIXME: Naive way to select the QL library name ...
QL_LIBRARY = 'QuantLib-vc90-mt' if BUILDING_ON_WINDOWS else 'QuantLib'

def collect_extensions():
    """ Collect all the directories with Cython extensions and return the list
    of Extension.

    Th function combines static Extension declaration and calls to cythonize
    to build the list of extenions.
    """
    
    default_args = dict(
        language='c++',
        include_dirs=INCLUDE_DIRS + [numpy.get_include()],
        library_dirs=LIBRARY_DIRS,
        define_macros = get_define_macros(),
        extra_compile_args = get_extra_compile_args(),
        extra_link_args = get_extra_link_args(),
        cython_directives = CYTHON_DIRECTIVES,
    )
    
    # Dictionnary of arguments used by all the extensions linking
    # against the quantlib.ql extension. On Windows, it requires a
    # specific setup, reason why we can't use default_args.
    ql_ext_args = default_args.copy()
    if BUILDING_ON_WINDOWS:
        ql_ext_args['libraries'] = ['ql']

    ql_extension = Extension('quantlib.ql',
        ['quantlib/ql.pyx',
         'cpp_layer/ql_settings.cpp',
         'cpp_layer/simulate_support_code.cpp',
         'cpp_layer/yield_piecewise_support_code.cpp',
         'cpp_layer/credit_piecewise_support_code.cpp',
         'cpp_layer/mc_vanilla_engine_support_code.cpp'
        ],
        libraries=[QL_LIBRARY],        
        **default_args
    )

    if BUILDING_ON_WINDOWS:
        # We need to export the symbols of the support code for them to be
        # visible by the other Cython extensions linked to quantlib.ql
        ql_extension.export_symbols = SYMBOLS

    settings_extension = Extension('quantlib.settings',
        ['quantlib/settings/settings.pyx'],
        **ql_ext_args
    )

    test_extension = Extension('quantlib.test.test_cython_bug',
        ['quantlib/test/test_cython_bug.pyx'],
        **ql_ext_args
    )

    piecewise_yield_curve_extension = Extension(
        'quantlib.termstructures.yields.piecewise_yield_curve',
        ['quantlib/termstructures/yields/piecewise_yield_curve.pyx',],
        **ql_ext_args
    )

    piecewise_default_curve_extension = Extension(
        'quantlib.termstructures.credit.piecewise_default_curve',
        ['quantlib/termstructures/credit/piecewise_default_curve.pyx',],
        **ql_ext_args

    )

    multipath_extension = Extension('quantlib.sim.simulate',
        ['quantlib/sim/simulate.pyx'], **ql_ext_args
    )

    mc_vanilla_engine_extension = Extension(
        'quantlib.pricingengines.vanilla.mcvanillaengine',
        ['quantlib/pricingengines/vanilla/mcvanillaengine.pyx'],
        **ql_ext_args
    )
    
    bond_extension = Extension(
        'quantlib.instruments.bonds',
        ['quantlib/instruments/bonds.pyx'],
        **ql_ext_args
    )
    
    instrument_extension = Extension(
        'quantlib.instruments.instrument',
        ['quantlib/instruments/instrument.pyx'],
        **ql_ext_args
    )
    
    engine_extension = Extension(
        'quantlib.pricingengines.engine',
        ['quantlib/pricingengines/engine.pyx'],
        **ql_ext_args
    )
    
    bond_engine_extension = Extension(
        'quantlib.pricingengines.bond',
        ['quantlib/pricingengines/bond.pyx'],
        **ql_ext_args
    )
    
    cashflow_extension = Extension(
        'quantlib.cashflow',
        ['quantlib/cashflow.pyx'],
        **ql_ext_args
    )
    
    actual_actual_extension = Extension(
        'quantlib.time.daycounters.actual_actual',
        ['quantlib/time/daycounters/actual_actual.pyx'],
        **ql_ext_args
    )
    
    thirty360_extension = Extension(
        'quantlib.time.daycounters.thirty360',
        ['quantlib/time/daycounters/thirty360.pyx'],
        **ql_ext_args
    )
    
    joint_calendar_extension = Extension(
        'quantlib.time.calendars.jointcalendar',
        ['quantlib/time/calendars/jointcalendar.pyx'],
        **ql_ext_args
    )
    
    uk_extension = Extension(
        'quantlib.time.calendars.united_kingdom',
        ['quantlib/time/calendars/united_kingdom.pyx'],
        **ql_ext_args
    )
    
    us_extension = Extension(
        'quantlib.time.calendars.united_states',
        ['quantlib/time/calendars/united_states.pyx'],
        **ql_ext_args
    )
    
    null_calendar_extension = Extension(
        'quantlib.time.calendars.null_calendar',
        ['quantlib/time/calendars/null_calendar.pyx'],
        **ql_ext_args
    )
    
    germany_calendar_extension = Extension(
        'quantlib.time.calendars.germany',
        ['quantlib/time/calendars/germany.pyx'],
        **ql_ext_args
    )
    
    yield_term_structures_extension = Extension(
        'quantlib.termstructures.yields.yield_term_structure',
        ['quantlib/termstructures/yields/yield_term_structure.pyx'],
        **ql_ext_args
    )
    
    ff_term_structures_extension = Extension(
        'quantlib.termstructures.yields.flat_forward',
        ['quantlib/termstructures/yields/flat_forward.pyx'],
        **ql_ext_args
    )
    
    zero_curve_extension = Extension(
        'quantlib.termstructures.yields.zero_curve',
        ['quantlib/termstructures/yields/zero_curve.pyx'],
        **ql_ext_args
    )
    
    rate_helpers_extension = Extension(
        'quantlib.termstructures.yields.rate_helpers',
        ['quantlib/termstructures/yields/rate_helpers.pyx'],
        **ql_ext_args
    )
    
    quotes_extension = Extension(
        'quantlib.quotes',
        ['quantlib/quotes.pyx'],
        **ql_ext_args
    )
    
    index_extension = Extension(
        'quantlib.index',
        ['quantlib/index.pyx'],
        **ql_ext_args
    )
    
    ir_index_extension = Extension(
        'quantlib.indexes.interest_rate_index',
        ['quantlib/indexes/interest_rate_index.pyx'],
        **ql_ext_args
    )
    
    swap_index_extension = Extension(
        'quantlib.indexes.swap_index',
        ['quantlib/indexes/swap_index.pyx'],
        **ql_ext_args
    )

    ibor_index_extension = Extension(
        'quantlib.indexes.ibor_index',
        ['quantlib/indexes/ibor_index.pyx'],
        **ql_ext_args
    )
    
    
    libor_index_extension = Extension(
        'quantlib.indexes.libor',
        ['quantlib/indexes/libor.pyx'],
        **ql_ext_args
    )
    
    option_extension = Extension(
        'quantlib.instruments.option',
        ['quantlib/instruments/option.pyx'],
        **ql_ext_args
    )
    
    payoffs_extension = Extension(
        'quantlib.instruments.payoffs',
        ['quantlib/instruments/payoffs.pyx'],
        **ql_ext_args
    )
    
    bs_process_extension = Extension(
        'quantlib.processes.black_scholes_process',
        ['quantlib/processes/black_scholes_process.pyx'],
        **ql_ext_args
    )
    
    ir_extension = Extension(
        'quantlib.interest_rate',
        ['quantlib/interest_rate.pyx'],
        **ql_ext_args
    )
      
    black_vol_extension = Extension(
        'quantlib.termstructures.volatility.equityfx.black_vol_term_structure',
        ['quantlib/termstructures/volatility/equityfx/black_vol_term_structure.pyx'],
        **ql_ext_args
    )
    

    manual_extensions = [
        ql_extension,
        #multipath_extension,
        #mc_vanilla_engine_extension,
        #piecewise_yield_curve_extension,
        #piecewise_default_curve_extension,
        settings_extension,
        test_extension,
        instrument_extension,
        bond_extension,
        cashflow_extension,
        engine_extension,
        bond_engine_extension,
        actual_actual_extension,
        joint_calendar_extension,
        uk_extension,
        us_extension,
        null_calendar_extension,
        germany_calendar_extension,
        thirty360_extension,
        yield_term_structures_extension,
        ff_term_structures_extension,
        rate_helpers_extension,
        quotes_extension,
        index_extension,
        ir_index_extension,
        swap_index_extension,
        ibor_index_extension,
        libor_index_extension,
        zero_curve_extension,
        option_extension,
        payoffs_extension,
        bs_process_extension,
        ir_extension,
        black_vol_extension,
    ]
    
    for mod in ['calendar', 'date', 'daycounter', 'schedule']:
         manual_extensions.append(
            Extension(
            'quantlib.time.{}'.format(mod),
            ['quantlib/time/{}.pyx'.format(mod)],
            **ql_ext_args
            )
        )

    cython_extension_directories = []
    for dirpath, directories, files in os.walk('quantlib'):

        # skip the settings package
        if dirpath.find('settings') > -1 or dirpath.find('test') > -1:
            continue

        # if the directory contains pyx files, cythonise it
        if len(glob.glob('{0}/*.pyx'.format(dirpath))) > 0:
            cython_extension_directories.append(dirpath)

#    collected_extensions = cythonize(
#        [
#            Extension('*', ['{0}/*.pyx'.format(dirpath)], **ql_ext_args
#            ) for dirpath in cython_extension_directories
#        ]
#    )
#
#    # remove  all the manual extensions from the collected ones
#    names = [extension.name for extension in manual_extensions]
#    for ext in collected_extensions[:]:
#        if ext.name in names:
#            collected_extensions.remove(ext)
#            continue
#        elif not ext.name.startswith('quantlib.time.date') or not 'bond' in ext.name:
#            print 'Removing ', ext.name
#            collected_extensions.remove(ext)
#        else:
#            print 'Keeping ', ext.name
#
    #print len(collected_extensions)
    extensions = manual_extensions #+ collected_extensions

    return extensions

setup(
    name = 'quantlib',
    version = '0.1',
    author = 'Didrik Pinte, Patrick Henaff',
    license = 'BSD',
    packages = find_packages(),
    ext_modules = collect_extensions(),
    cmdclass = {'build_ext': build_ext},
    install_requires = ['distribute', 'cython'],
    zip_safe = False
)
