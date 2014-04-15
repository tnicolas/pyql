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
from quantlib.time.date cimport Period


cdef class Euribor(IborIndex):
    def __init__(self,
        Period tenor,
        YieldTermStructure ts):

        cdef ql.Handle[ql.YieldTermStructure] ts_handle
        if ts.relinkable:
            ts_handle = ql.Handle[ql.YieldTermStructure](
                ts._relinkable_ptr.get().currentLink()
            )
        else:
            ts_handle = ql.Handle[ql.YieldTermStructure](
                ts._thisptr.get()
            )

        self._thisptr = new shared_ptr[ql.Index](
            new ql.Euribor(deref(tenor._thisptr.get()), ts_handle)
        )

cdef class Euribor6M(Euribor):
    def __init__(self, YieldTermStructure ts):

        cdef ql.Handle[ql.YieldTermStructure] ts_handle
        if ts.relinkable:
            ts_handle = ql.Handle[ql.YieldTermStructure](
                ts._relinkable_ptr.get().currentLink()
            )
        else:
            ts_handle = ql.Handle[ql.YieldTermStructure](
                ts._thisptr.get()
            )

        self._thisptr = new shared_ptr[ql.Index](
            new ql.Euribor6M(ts_handle)
        )

