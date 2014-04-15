"""
 Copyright (C) 2014, Enthought Inc
 Copyright (C) 2014, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from cython.operator cimport dereference as deref
from libcpp cimport bool
from libcpp.string cimport string

from quantlib cimport ql

from quantlib.time.date cimport Date, date_from_qldate


# IMM Months
cdef public enum Month:
     F = ql.F
     G = ql.G
     H = ql.H
     J = ql.J
     K = ql.K
     M = ql.M
     N = ql.N
     Q = ql.Q
     U = ql.U
     V = ql.V
     X = ql.X
     Z = ql.Z

def is_IMM_date(Date dt, bool main_cycle=True):
    # returns whether or not the given date is an IMM date
    return ql.isIMMdate(deref(dt._thisptr.get()), main_cycle)

def is_IMM_code(char* imm_code, bool main_cycle=True):
    # returns whether or not the given string is an IMM code
    cdef object _code = imm_code
    return ql.isIMMcode(<str> _code, main_cycle)

def code(Date imm_date):
    return  ql.code(deref(imm_date._thisptr.get()))

def date(char* imm_code, Date reference_date=Date()):
    cdef object _code = imm_code
    cdef ql.Date tmp = ql.date(<str>_code, deref(reference_date._thisptr.get()))
    return date_from_qldate(tmp)

def next_date(*args):
    """
    next IMM date following the given date
    returns the 1st delivery date for next contract listed in the
    International Money Market section of the Chicago Mercantile
    Exchange.
    """

    cdef ql.Date tmp
    
    cdef Date reference_date    
    cdef Date dt
    cdef object _code

    if len(args) < 2:
        main_cycle = True
    else:
        main_cycle = args[1]

    if(isinstance(args[0], str)):
        _code = args[0]
        if len(args) == 3:
            reference_date = <Date> args[2]
        else:
            reference_date = Date()
        tmp =  ql.nextDate_str(
            <str> _code, <bool>main_cycle, deref(reference_date._thisptr.get())
        )
    else:
        dt = <Date> args[0]
        tmp =  ql.nextDate_dt(deref(dt._thisptr.get()), <bool>main_cycle)

    return date_from_qldate(tmp)
    
def next_code(*args):
    """
    //! next IMM code following the given date
    /*! returns the IMM code for next contract listed in the
        International Money Market section of the Chicago Mercantile
        Exchange.
    """

    cdef Date reference_date    
    cdef Date dt
    cdef object _code

    if len(args) < 2:
        main_cycle = True
    else:
        main_cycle = args[1]

    if(isinstance(args[0], str)):
        _code = args[0]
        if len(args) == 3:
            reference_date = <Date> args[2]
        else:
            reference_date = Date()
        tmp =  ql.nextCode_str(
            <str> _code, <bool>main_cycle, deref(reference_date._thisptr.get())
        )
    else:
        dt = <Date> args[0]
        tmp =  ql.nextCode_dt(deref(dt._thisptr.get()), <bool>main_cycle)

    return tmp
