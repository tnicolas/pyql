"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from cython.operator cimport dereference as deref

from quantlib cimport ql
from quantlib.ql cimport shared_ptr


from quantlib.termstructures.yields.flat_forward cimport YieldTermStructure


cdef class Euribor(IborIndex):
    def __init__(self):
        pass
        
cdef class Euribor6M(Euribor):
    def __init__(self):
    
        cdef ql.Handle[ql.YieldTermStructure] yc_handle = \
                ql.Handle[ql.YieldTermStructure]()

        self._thisptr = new shared_ptr[ql.Index](
            new ql.Euribor6M(yc_handle))

