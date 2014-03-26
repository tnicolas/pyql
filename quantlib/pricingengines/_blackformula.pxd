cdef extern from 'ql/pricingengines/blackformula.hpp' namespace 'QuantLib':

    Real blackFormula(Type optionType,
                      Real strike,
                      Real forward,
                      Real stdDev,
                      Real discount,
                      Real displacement) except +

    Real blackFormulaImpliedStdDev(Type optionType,
                                   Real strike,
                                   Real forward,
                                   Real blackPrice,
                                   Real discount,
                                   Real displacement,
                                   Real guess,
                                   Real accuracy,
                                   Natural maxIterations) except +
