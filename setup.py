
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
SYMBOLS = [
    "?simulateMP@QuantLib@@YAXABV?$shared_ptr@VStochasticProcess@QuantLib@@@boost@@HHNK_NPAN@Z",
    "?set_evaluation_date@QL@@YAXAAVDate@QuantLib@@@Z",
    "?get_evaluation_date@QL@@YA?AVDate@QuantLib@@XZ",
    "?term_structure_factory@QuantLib@@YA?AV?$shared_ptr@VYieldTermStructure@QuantLib@@@boost@@AAV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@0ABVDate@1@ABV?$vector@V?$shared_ptr@V?$BootstrapHelper@VYieldTermStructure@QuantLib@@@QuantLib@@@boost@@V?$allocator@V?$shared_ptr@V?$BootstrapHelper@VYieldTermStructure@QuantLib@@@QuantLib@@@boost@@@std@@@5@AAVDayCounter@1@N@Z",
    "?credit_term_structure_factory@QuantLib@@YA?AV?$shared_ptr@VDefaultProbabilityTermStructure@QuantLib@@@boost@@AAV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@0ABVDate@1@ABV?$vector@V?$shared_ptr@V?$BootstrapHelper@VDefaultProbabilityTermStructure@QuantLib@@@QuantLib@@@boost@@V?$allocator@V?$shared_ptr@V?$BootstrapHelper@VDefaultProbabilityTermStructure@QuantLib@@@QuantLib@@@boost@@@std@@@5@AAVDayCounter@1@N@Z",
    "?mc_vanilla_engine_factory@QuantLib@@YA?AV?$shared_ptr@VPricingEngine@QuantLib@@@boost@@AAV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@0ABV?$shared_ptr@VHestonProcess@QuantLib@@@3@_NIIK@Z",
]



SUPPORT_CODE_INCLUDE = './cpp_layer'
CYTHON_DIRECTIVES = {"embedsignature": True}

# FIXME: would be good to be able to customize the path with envrironment
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

    manual_extensions = [
        ql_extension,
        multipath_extension,
        mc_vanilla_engine_extension,
        piecewise_yield_curve_extension,
        piecewise_default_curve_extension,
        settings_extension,
        test_extension,
    ]

    cython_extension_directories = []
    for dirpath, directories, files in os.walk('quantlib'):

        # skip the settings package
        if dirpath.find('settings') > -1 or dirpath.find('test') > -1:
            continue

        # if the directory contains pyx files, cythonise it
        if len(glob.glob('{0}/*.pyx'.format(dirpath))) > 0:
            cython_extension_directories.append(dirpath)

    collected_extensions = cythonize(
        [
            Extension('*', ['{0}/*.pyx'.format(dirpath)], **ql_ext_args
            ) for dirpath in cython_extension_directories
        ]
    )

    # remove  all the manual extensions from the collected ones
    names = [extension.name for extension in manual_extensions]
    for ext in collected_extensions:
        if ext.name in names:
            collected_extensions.remove(ext)
            continue

    extensions = manual_extensions + collected_extensions

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
