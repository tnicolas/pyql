/*
 * Cython does not support the full CPP syntax preventing to expose the
 * Piecewise constructors (e.g. typemap).
 *
 */

#include <vector>
#include <string>
#include <iostream>
#include <ql/termstructures/all.hpp>
#include <ql/time/date.hpp>
#include <ql/time/daycounter.hpp>
#include <ql/math/interpolations/all.hpp>

namespace QL {

    typedef boost::shared_ptr<QuantLib::DefaultProbabilityTermStructure> TS;

    // Creates a DefaultProbabilityTermStructure based on a 
    // PiecewiseDefaultCurve
    TS credit_term_structure_factory(
        std::string& traits, std::string& interpolator, 
        const QuantLib::Date& reference_date,
        const std::vector<boost::shared_ptr<QuantLib::DefaultProbabilityHelper> >& instruments, 
        QuantLib::DayCounter& day_counter, QuantLib::Real accuracy
    ) {


        TS ts;
    
        if (traits.compare("HazardRate") == 0) {
           if (interpolator.compare("Linear") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseDefaultCurve<QuantLib::HazardRate, QuantLib::Linear>(
                        reference_date, instruments, day_counter, accuracy
                    )
                );
            } else if (interpolator.compare("LogLinear") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseDefaultCurve<QuantLib::HazardRate, QuantLib::LogLinear>(
                        reference_date, instruments, day_counter, accuracy
                    )
                );
            } else if (interpolator.compare("BackwardFlat") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseDefaultCurve<QuantLib::HazardRate, QuantLib::BackwardFlat>(
                        reference_date, instruments, day_counter, accuracy
                    )
                );
            }
        } else if (traits.compare("DefaultDensity") == 0) {
           if (interpolator.compare("Linear") == 0) {
               ts = TS(
                    new QuantLib::PiecewiseDefaultCurve<QuantLib::DefaultDensity, QuantLib::Linear>(
                        reference_date, instruments, day_counter, accuracy
                    )
                );
            } else if (interpolator.compare("LogLinear") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseDefaultCurve<QuantLib::DefaultDensity, QuantLib::LogLinear>(
                        reference_date, instruments, day_counter, accuracy
                    )
                );
            } else if (interpolator.compare("BackwardFlat") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseDefaultCurve<QuantLib::DefaultDensity, QuantLib::BackwardFlat>(
                        reference_date, instruments, day_counter, accuracy
                    )
                );
            }
        } else if (traits.compare("SurvivalProbability") == 0) {
           if (interpolator.compare("Linear") == 0) {
               ts = TS(
                    new QuantLib::PiecewiseDefaultCurve<QuantLib::SurvivalProbability, QuantLib::Linear>(
                        reference_date, instruments, day_counter, accuracy
                    )
                );
            } else if (interpolator.compare("LogLinear") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseDefaultCurve<QuantLib::SurvivalProbability, QuantLib::LogLinear>(
                        reference_date, instruments, day_counter, accuracy
                    )
                );
            } else if (interpolator.compare("BackwardFlat") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseDefaultCurve<QuantLib::SurvivalProbability, QuantLib::BackwardFlat>(
                        reference_date, instruments, day_counter, accuracy
                    )
                );
            }
       } else {
            std::cout << "traits = " << traits << std::endl;
            std::cout << "interpolator  = " << interpolator << std::endl;
            throw std::invalid_argument("What/How term structure options not recognized");
        }
        return ts;
    }
}
