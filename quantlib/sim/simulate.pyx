# distutils: language = c++

from cython.operator cimport dereference as deref

from quantlib cimport ql
from quantlib.ql cimport shared_ptr

from quantlib.processes.heston_process cimport HestonProcess
from quantlib.processes.bates_process cimport BatesProcess
from quantlib.models.equity.heston_model cimport HestonModel
from quantlib.models.equity.bates_model cimport BatesModel, BatesDetJumpModel, BatesDoubleExpModel

import numpy as np
cimport numpy as cnp


cdef simulate_sub(void *tmp, int nbPaths, int nbSteps,
	     Time horizon, BigNatural seed, bool antithetic=True):

    cdef cnp.ndarray[cnp.double_t, ndim=2] res = np.zeros((nbPaths+1, nbSteps+1), dtype=np.double)

    cdef shared_ptr[ql.StochasticProcess]* hp_pt = <shared_ptr[ql.StochasticProcess] *> tmp
  
    ql.simulateMP(deref(<shared_ptr[ql.StochasticProcess]*> hp_pt),
               nbPaths, nbSteps, horizon, seed, antithetic, <double*> res.data)

    return res


cdef simulate_process(process_type* process,
        int nb_paths, int nb_steps, Time horizon, BigNatural seed,
        bool antithetic=True):
    """ Runs a multipath simulation on the process and returns a 2d array
    (paths * steps).

    """

    cdef cnp.ndarray[cnp.double_t, ndim=2] result = \
            np.zeros((nb_paths + 1, nb_steps + 1), dtype=np.double)

    ql.simulateMP(deref(process), nb_paths, nb_steps, horizon, seed, antithetic,
            <double*> result.data)

    return result


def simulateHeston(HestonModel model, int nbPaths, int nbSteps,
	     Time horizon, BigNatural seed, bool antithetic=True):

    proc = <HestonProcess> model.process()

    # intermediate cast to void per Cython doc:
    # http://docs.cython.org/src/reference/language_basics.html

    cdef void *tmp
    tmp = <void *> proc._thisptr

    return simulate_sub(tmp, nbPaths, nbSteps,
	     horizon, seed, antithetic)


def simulateBates(BatesModel model, int nbPaths, int nbSteps,
	     Time horizon, BigNatural seed, bool antithetic=True):

    proc = <BatesProcess> model.process()
    
    # intermediate cast to void per Cython doc:
    # http://docs.cython.org/src/reference/language_basics.html

    cdef void *tmp
    tmp = <void *> proc._thisptr

    return simulate_sub(tmp, nbPaths, nbSteps,
	     horizon, seed, antithetic)


def simulateBatesDetJumpModel(BatesDetJumpModel model, int nbPaths, int nbSteps,
	     Time horizon, BigNatural seed, bool antithetic=True):

    proc = <BatesProcess> model.process()
    
    # intermediate cast to void per Cython doc:
    # http://docs.cython.org/src/reference/language_basics.html

    cdef void *tmp
    tmp = <void *> proc._thisptr

    res = simulate_sub(tmp, nbPaths, nbSteps,
	     horizon, seed, antithetic)

    ## TODO
    ## add jump process to simulation
    
    return res


def simulateBatesDoubleExpModel(BatesDoubleExpModel model, int nbPaths,
                                int nbSteps,
	     Time horizon, BigNatural seed, bool antithetic=True):

    cdef cnp.ndarray[cnp.double_t, ndim=2] res = np.zeros((nbPaths+1, nbSteps+1), dtype=np.double)

    proc = <HestonProcess> model.process()
    
    # intermediate cast to void per Cython doc:
    # http://docs.cython.org/src/reference/language_basics.html

    cdef void *tmp
    tmp = <void *> proc._thisptr

    res = simulate_sub(tmp, nbPaths, nbSteps,
	     horizon, seed, antithetic)

     # parameters of double exponential jump model
     # Lambda   jump occurence: rate of Poisson process
     # nuUp     up jump intensity (exp dist)
     # nuDown   down jump intensity
     # p        prob of up jump

## TODO
    ## add double exp jump process to simulation
    
    return res

