/*
 * Cython does not support the full CPP syntax preventing to expose the
 * Piecewise constructors (e.g. typemap).
 *
 */

#include <string>
#include <ql/quantlib.hpp>
#include <ql/processes/hestonprocess.hpp>

namespace QuantLib {

    boost::shared_ptr<QuantLib::PricingEngine> mc_vanilla_engine_factory(
      std::string& trait, 
      std::string& rng,
      const boost::shared_ptr<QuantLib::HestonProcess>& process,
      bool doAntitheticVariate,
      QuantLib::Size stepsPerYear,
      QuantLib::Size requiredSamples,
      QuantLib::BigNatural seed);
}
