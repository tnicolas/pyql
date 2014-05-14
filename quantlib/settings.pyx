from cython.operator cimport dereference as deref

cimport quantlib.time.date as date

from quantlib cimport ql 

cdef class Settings:

    def __init__(self):
        pass

    property evaluation_date:
        """Property to set/get the evaluation date. """
        def __get__(self):
            cdef ql.Date evaluation_date = ql.get_evaluation_date()
            return date.date_from_qldate(evaluation_date)

        def __set__(self, date.Date evaluation_date):
            cdef ql.Date* date_ref = <ql.Date*>evaluation_date._thisptr.get()
            ql.set_evaluation_date(deref(date_ref))

    property version:
        """Returns the QuantLib C++ version (QL_VERSION) used by this wrapper."""
        def __get__(self):
            return ql.QL_VERSION

    @classmethod
    def instance(cls):
        """ Returns an instance of the global Settings object.

        Utility method to mimic the behaviour of the C++ singleton.

        """

        return cls()

