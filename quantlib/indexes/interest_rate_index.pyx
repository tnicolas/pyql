"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from quantlib.index cimport Index

cdef class InterestRateIndex(Index):
    def __cinit__(self):
        pass
        
    def __str__(self):
        return 'Interest rate index %s' % self.name
    
#    property tenor:
#        def __get__(self):
#            return self._thisptr.get().tenor()
            
#    property fixingDays:
#        def __get__(self):
#            return self._thisptr.fixingDays()
            
