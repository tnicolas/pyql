"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from quantlib.ql cimport shared_ptr, _flat_forward as ffwd, shared_ptr
from libcpp cimport bool as cbool

from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure

cdef class FlatForward(YieldTermStructure):
    pass


