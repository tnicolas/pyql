/*
 * Cython does not support the full CPP syntax preventing to expose the
 * Piecewise constructors. 
 *
 * This code is inspired by the RQuantLib code and provides a factory function
 * for PiecewiseYieldCurve.
 *
 */

#include <ql/termstructures/all.hpp>
#include <ql/time/date.hpp>
#include <ql/time/daycounter.hpp>
#include <vector>
#include <string>

namespace QuantLib {

    // Creates a YieldTermStructure based on a PiecewiseYieldCurve
    boost::shared_ptr<QuantLib::YieldTermStructure> term_structure_factory(
        std::string& traits, std::string& interpolator, 
        const QuantLib::Date& settlement_date,
        const std::vector<boost::shared_ptr<QuantLib::RateHelper> >& curve_input,
        QuantLib::DayCounter& 
        day_counter, QuantLib::Real tolerance
    );
}
