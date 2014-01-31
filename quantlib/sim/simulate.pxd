include '../types.pxi'

from libcpp cimport bool

from quantlib.ql cimport _sp
from quantlib.ql cimport shared_ptr

ctypedef shared_ptr[_sp.StochasticProcess] process_type

cdef simulate_process(process_type* process,
        int nb_paths, int nb_steps, Time horizon, BigNatural seed,
        bool antithetic=?)
