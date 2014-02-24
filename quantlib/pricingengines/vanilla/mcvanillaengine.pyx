include '../../types.pxi'

from libcpp cimport bool
from libcpp.string cimport string
from cpython.string cimport PyString_AsString

from cython.operator cimport dereference as deref

from quantlib.ql cimport (
    shared_ptr, _heston_process as _hp, _pricing_engine as _pe,
    mc_vanilla_engine_factory
)

from quantlib.processes.heston_process cimport HestonProcess
from quantlib.pricingengines.engine cimport PricingEngine


VALID_TRAITS = ['MCEuropeanHestonEngine',]
VALID_RNG = ['PseudoRandom',]

cdef class MCVanillaEngine(PricingEngine):

    def __init__(self, str trait, str RNG,
      HestonProcess process,
      doAntitheticVariate,
      Size stepsPerYear,
      Size requiredSamples,
      BigNatural seed):

        # validate inputs
        if trait not in VALID_TRAITS:
            raise ValueError('Traits must be in {}',format(VALID_TRAITS))

        if RNG not in VALID_RNG:
            raise ValueError(
                'RNG must be one of {}'.format(VALID_RNG)
            )

        # convert the Python str to C++ string
        cdef string traits_string = string(PyString_AsString(trait))
        cdef string RNG_string = string(PyString_AsString(RNG))

        # the input may be a Heston process or a Bates process
        # this may not be needed ...
        
        cdef shared_ptr[_hp.HestonProcess]* hp_pt = <shared_ptr[_hp.HestonProcess] *> process._thisptr

        cdef shared_ptr[_pe.PricingEngine] engine = mc_vanilla_engine_factory(
          traits_string, 
          RNG_string,
          deref(<shared_ptr[_hp.HestonProcess]*> hp_pt),
          doAntitheticVariate,
          stepsPerYear,
          requiredSamples,
          seed)

        self._thisptr = new shared_ptr[_pe.PricingEngine](engine)

