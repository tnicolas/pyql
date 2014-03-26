include '../types.pxi'

from libcpp cimport bool

from quantlib cimport ql

ctypedef ql.shared_ptr[ql.StochasticProcess] process_type

cdef simulate_process(process_type* process,
        int nb_paths, int nb_steps, Time horizon, BigNatural seed,
        bool antithetic=?)
