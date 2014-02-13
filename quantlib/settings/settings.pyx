# distutils: language = c++
# distutils: libraries = QuantLib
from cython.operator cimport dereference as deref

cimport quantlib.time.date as date

from quantlib.ql cimport (
    QL_VERSION, get_evaluation_date,
    set_evaluation_date
)
from quantlib.ql cimport _date


cdef class Settings:

    def __init__(self):
        pass

    property evaluation_date:
        """Property to set/get the evaluation date. """
        def __get__(self):
            cdef _date.Date evaluation_date = get_evaluation_date()
            return date.date_from_qldate(evaluation_date)

        def __set__(self, date.Date evaluation_date):
            cdef _date.Date* date_ref = <_date.Date*>evaluation_date._thisptr.get()
            set_evaluation_date(deref(date_ref))

    property version:
        """Returns the QuantLib C++ version (QL_VERSION) used by this wrapper."""
        def __get__(self):
            return QL_VERSION

    @classmethod
    def instance(cls):
        """ Returns an instance of the global Settings object.

        Utility method to mimic the behaviour of the C++ singleton.

        """

        return cls()

