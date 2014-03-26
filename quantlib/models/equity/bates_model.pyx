"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

include '../../types.pxi'

from cython.operator cimport dereference as deref

from quantlib cimport ql
from quantlib.ql cimport shared_ptr

from quantlib.processes.heston_process cimport HestonProcess
from quantlib.processes.bates_process cimport BatesProcess
from quantlib.models.equity.heston_model cimport HestonModel
from quantlib.models.equity.bates_model cimport BatesModel

cdef class BatesModel(HestonModel):

    def __cinit__(self):
        self._thisptr = NULL

    def __init__(self, BatesProcess process):
        self._thisptr = new shared_ptr[ql.HestonModel](
            new ql.BatesModel(
            deref(<shared_ptr[ql.BatesProcess]*> process._thisptr)))

    def __str__(self):
        return 'Bates model\nv0: %f kappa: %f theta: %f sigma: %f\nrho: %f lambda: %f nu: %f delta: %f' % \
          (self.v0, self.kappa, self.theta, self.sigma,
           self.rho, self.Lambda, self.nu, self.delta)

    def process(self):
        process = BatesProcess(noalloc=True)
        cdef shared_ptr[ql.HestonProcess] bp_ptr = self._thisptr.get().process()
        cdef shared_ptr[ql.HestonProcess]* bp_pt = new shared_ptr[ql.HestonProcess](bp_ptr)
        process._thisptr = bp_pt
        
        return process

    property Lambda:
        def __get__(self):
            return (<ql.BatesModel*> self._thisptr.get()).Lambda()

    property nu:
        def __get__(self):
            return (<ql.BatesModel *> self._thisptr.get()).nu()

    property delta:
        def __get__(self):
            return (<ql.BatesModel *> self._thisptr.get()).delta()

cdef class BatesDetJumpModel(BatesModel):

    def __cinit__(self):
        self._thisptr = NULL

    def __init__(self, BatesProcess process,
                 kappaLambda=1.0, thetaLambda=0.1):
        self._thisptr = new shared_ptr[ql.HestonModel](
        new ql.BatesDetJumpModel(
        deref(<shared_ptr[ql.BatesProcess]*> process._thisptr),
                                  kappaLambda,
                                  thetaLambda))

    def __str__(self):
        return 'Bates Det Jump model\nv0: %f kappa: %f theta: %f sigma: %f\nrho: %f lambda: %f nu: %f delta: %f\nkappa_lambda: %f theta_lambda: %f' % \
          (self.v0, self.kappa, self.theta, self.sigma,
           self.rho, self.Lambda, self.nu, self.delta,
           self.kappaLambda, self.thetaLambda)

    property kappaLambda:
        def __get__(self):
            return (<ql.BatesDetJumpModel*> self._thisptr.get()).kappaLambda()

    property thetaLambda:
        def __get__(self):
            return (<ql.BatesDetJumpModel*> self._thisptr.get()).thetaLambda()

cdef class BatesDoubleExpModel(HestonModel):

    def __cinit__(self):
        self._thisptr = NULL

    def __init__(self, HestonProcess process,
                 Lambda=0.1,
                 nuUp=0.1, nuDown=0.1,
                 p=0.5):
        self._thisptr = new shared_ptr[ql.HestonModel](
            new ql.BatesDoubleExpModel(deref(process._thisptr),
                                        Lambda, nuUp, nuDown, p))

    def __str__(self):
        return 'Bates Double Exp model\nv0: %f kappa: %f theta: %f sigma: %f\nrho: %f lambda: %f nuUp: %f nuDown: %f p: %f' % \
          (self.v0, self.kappa, self.theta, self.sigma,
           self.rho, self.Lambda, self.nuUp, self.nuDown,
           self.p)
    
    property Lambda:
        def __get__(self):
            return (<ql.BatesDoubleExpModel*> self._thisptr.get()).Lambda()

    property nuUp:
        def __get__(self):
            return (<ql.BatesDoubleExpModel *> self._thisptr.get()).nuUp()

    property nuDown:
        def __get__(self):
            return (<ql.BatesDoubleExpModel *> self._thisptr.get()).nuDown()

    property p:
        def __get__(self):
            return (<ql.BatesDoubleExpModel *> self._thisptr.get()).p()

cdef class BatesDoubleExpDetJumpModel(BatesDoubleExpModel):

    def __cinit__(self):
        self._thisptr = NULL

    def __init__(self, HestonProcess process,
                 Lambda=0.1,
                 nuUp=0.1, nuDown=0.1,
                 p=0.5, kappaLambda=1.0, thetaLambda=.1):
        self._thisptr = new shared_ptr[ql.HestonModel](
            new ql.BatesDoubleExpDetJumpModel(deref(process._thisptr),
                                        Lambda, nuUp, nuDown, p, kappaLambda, thetaLambda))

    def __str__(self):
        return 'Bates Double Exp Det Jump model\nv0: %f kappa: %f theta: %f sigma: %f\nrho: %f lambda: %f nuUp: %f nuDown: %f p: %f' % \
          (self.v0, self.kappa, self.theta, self.sigma,
           self.rho, self.Lambda, self.nuUp, self.nuDown,
           self.p, self.kappaLambda, self.thetaLambda)
    
    property kappaLambda:
        def __get__(self):
            return (<ql.BatesDoubleExpDetJumpModel*> self._thisptr.get()).kappaLambda()

    property thetaLambda:
        def __get__(self):
            return (<ql.BatesDoubleExpDetJumpModel*> self._thisptr.get()).thetaLambda()

