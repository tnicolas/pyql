'''Actual/Actual day count

The day count can be calculated according to:

 - the ISDA convention, also known as "Actual/Actual (Historical)",
   "Actual/Actual", "Act/Act", and according to ISDA also "Actual/365",
   "Act/365", and "A/365";
 - the ISMA and US Treasury convention, also known as
   "Actual/Actual (Bond)";
 - the AFB convention, also known as "Actual/Actual (Euro)".

For more details, refer to
http://www.isda.org/publications/pdf/Day-Count-Fracation1999.pdf
'''
from quantlib cimport ql
from quantlib.time.daycounter cimport DayCounter

cdef public enum Convention:
    ISMA       = ql.ISMA
    Bond       = ql.ISMA
    ISDA       = ql.ISDA
    Historical = ql.Historical
    Actual365  = ql.Actual365
    AFB        = ql.AFB
    Euro       = ql.Euro

CONVENTIONS = {
    'ISMA' : ql.ISMA,
    'Bond' : ql.ISMA,
    'ISDA' : ql.ISDA,
    'Historical' : ql.Historical,
    'Actual365' : ql.Actual365,
    'AFB' : ql.AFB,
    'Euro' : ql.Euro
}


cdef class ActualActual(DayCounter):
    """ Actual/Actual day count

    The day count can be calculated according to:

        - the ISDA convention, also known as "Actual/Actual (Historical)",
          "Actual/Actual", "Act/Act", and according to ISDA also "Actual/365",
          "Act/365", and "A/365";
        - the ISMA and US Treasury convention, also known as
          "Actual/Actual (Bond)";
        - the AFB convention, also known as "Actual/Actual (Euro)".

        For more details, refer to
        http://www.isda.org/publications/pdf/Day-Count-Fracation1999.pdf

    """

    def __cinit__(self, convention=ISMA):
        self._thisptr = <ql.DayCounter*> new \
            ql.ActualActual(<ql.Convention>convention)

    @classmethod
    def help(cls):
        res = 'Valid ACT/ACT daycounts are:\n'
        for k in CONVENTIONS:
            res += 'ACT/ACT(' + k + ')\n'
        return res

cdef ql.DayCounter* from_name(str name, str convention):

    cdef ql.Convention ql_convention = <ql.Convention>CONVENTIONS[convention]

    cdef ql.DayCounter* return_val =  new ql.ActualActual(ql_convention)

    return return_val



