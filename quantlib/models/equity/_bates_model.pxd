cdef extern from 'ql/models/equity/batesmodel.hpp' namespace 'QuantLib':

    cdef cppclass BatesModel(HestonModel):

        BatesModel() # fake empty constructor due to Cython issue
        BatesModel(shared_ptr[BatesProcess]& process) except +

        shared_ptr[BatesProcess] process() except +

        Real Lambda 'lambda'() except + # lambda is a python keyword
        Real nu() except +
        Real delta() except +

    cdef cppclass BatesDetJumpModel(BatesModel):
        BatesDetJumpModel()
        BatesDetJumpModel(shared_ptr[BatesProcess]& process,
                   Real kappaLambda,
                   Real thetaLambda,
        ) except +

        shared_ptr[BatesProcess] process() except +

        Real kappaLambda() except +
        Real thetaLambda() except +

    cdef cppclass BatesDoubleExpModel(HestonModel):
        BatesDoubleExpModel()
        BatesDoubleExpModel(shared_ptr[HestonProcess] & process,
                   Real Lambda,
                   Real nuUp,
                   Real nuDown,
                   Real p) except +

        shared_ptr[HestonProcess] process() except +

        Real p() except +
        Real nuDown() except +
        Real nuUp() except +
        Real Lambda 'lambda'() except +

    cdef cppclass BatesDoubleExpDetJumpModel(BatesDoubleExpModel):
        BatesDoubleExpDetJumpModel()
        BatesDoubleExpDetJumpModel(shared_ptr[HestonProcess]& process,
            Real Lambda,
            Real nuUp,
            Real nuDown,
            Real p,
            Real kappaLambda,
            Real thetaLambda) except +

        shared_ptr[HestonProcess] process() except +

        Real kappaLambda() except +
        Real thetaLambda() except +
