"""
 Copyright (C) 2013, Enthought Inc
 Copyright (C) 2013, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""
cdef extern from 'ql/instruments/swap.hpp' namespace 'QuantLib':

    cdef cppclass Swap(Instrument):

        bool isExpired()
        Date startDate()
        Date maturityDate()
        Real legBPS(Size j) except +
        Real legNPV(Size j) except +
        const Leg& leg(Size j) except +

