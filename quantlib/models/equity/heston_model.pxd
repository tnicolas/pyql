"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from quantlib cimport ql


cdef class HestonModelHelper:

    cdef ql.shared_ptr[ql.HestonModelHelper]* _thisptr

cdef class HestonModel:

    cdef ql.shared_ptr[ql.HestonModel]* _thisptr

