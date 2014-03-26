#include<ql/quantlib.hpp>

namespace QL {

  /*
   * Multipath simulator
   */

    void simulateMP(const boost::shared_ptr<QuantLib::StochasticProcess>& process,
                    int nbPaths, int nbSteps, QuantLib::Time horizon, QuantLib::BigNatural seed,
                    bool antithetic_variates, double *res);


}
