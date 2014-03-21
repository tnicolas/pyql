cdef extern from 'ql/time/calendars/nullcalendar.hpp' namespace 'QuantLib':
    cdef cppclass NullCalendar(Calendar):
        NullCalendar()

