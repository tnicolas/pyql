/*
 * Cython does not support the full CPP syntax preventing to expose the
 * Piecewise constructors (e.g. typemap).
 *
 */

#include <string>
#include <iostream>
#include <ql/quantlib.hpp>
#include <ql/processes/hestonprocess.hpp>

namespace QuantLib {

    typedef boost::shared_ptr<QuantLib::PricingEngine> PE;

    PE mc_vanilla_engine_factory(
      std::string& trait, 
      std::string& RNG,
      const boost::shared_ptr<HestonProcess>& process,
      bool doAntitheticVariate,
      QuantLib::Size stepsPerYear,
      QuantLib::Size requiredSamples,
      QuantLib::BigNatural seed
    ) {

      PE engine;
    
        if (trait.compare("MCEuropeanHestonEngine") == 0) {
           if (RNG.compare("PseudoRandom") == 0) {
             engine = QuantLib::MakeMCEuropeanHestonEngine<QuantLib::PseudoRandom>(process)
             .withStepsPerYear(stepsPerYear)
             .withAntitheticVariate(doAntitheticVariate)
             .withSamples(requiredSamples)
             .withSeed(seed);
           }
	}
        else {
            std::cout << "traits = " << trait << std::endl;
            std::cout << "RNG  = " << RNG << std::endl;
            throw Exception("Engine factory options not recognized");
        }
        return engine;
    }
}
