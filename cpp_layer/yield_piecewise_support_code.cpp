/*
 * Cython does not support the full CPP syntax preventing to expose the
 * Piecewise constructors (e.g. typemap).
 *
 * This code is inspired by the RQuantLib code and provides a factory function
 * for PiecewiseYieldCurve.
 *
 */
#include <vector>
#include <string>
#include <iostream>
#include <ql/termstructures/all.hpp>
#include <ql/time/date.hpp>
#include <ql/time/daycounter.hpp>

namespace QL {

    typedef boost::shared_ptr<QuantLib::YieldTermStructure> TS;

    // Creates a YieldTermStructure based on a PiecewiseYieldCurve
    TS term_structure_factory(
        std::string& traits, std::string& interpolator, 
        const QuantLib::Date& settlement_date,
        const std::vector<boost::shared_ptr<QuantLib::RateHelper> >& curve_input, 
        QuantLib::DayCounter& 
        day_counter, QuantLib::Real tolerance
    ) {
        
        TS ts;

        if (traits.compare("discount") == 0) {
            if (interpolator.compare("linear") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseYieldCurve<QuantLib::Discount, QuantLib::Linear>(
                        settlement_date, curve_input, day_counter, 
                        tolerance
                    )
                );
            } else if (interpolator.compare("loglinear") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseYieldCurve<QuantLib::Discount, QuantLib::LogLinear>(
                        settlement_date, curve_input, day_counter, 
                        tolerance
                    )
                );
            } else if (interpolator.compare("spline") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseYieldCurve<QuantLib::Discount, QuantLib::Cubic>(
                        settlement_date, curve_input, day_counter, 
                        tolerance
                    )
                );
            }
        } else if (traits.compare("forward") == 0) {
            if (interpolator.compare("linear") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseYieldCurve<QuantLib::ForwardRate, QuantLib::Linear>(
                        settlement_date, curve_input, day_counter, 
                        tolerance
                    )
                );
            } else if (interpolator.compare("loglinear") == 0) {
                ts =  TS(
                    new QuantLib::PiecewiseYieldCurve<QuantLib::ForwardRate, QuantLib::LogLinear>(
                        settlement_date, curve_input, day_counter, 
                        tolerance
                    )
                );
            } else if (interpolator.compare("spline") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseYieldCurve<QuantLib::ForwardRate, QuantLib::Cubic>(
                        settlement_date, curve_input, day_counter, 
                        tolerance
                    )
                );

            }
        } else if(traits.compare("zero") == 0) {
            if (interpolator.compare("linear") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseYieldCurve<QuantLib::ZeroYield, QuantLib::Linear>(
                        settlement_date, curve_input, day_counter, 
                        tolerance
                    )
                );
            } else if (interpolator.compare("loglinear") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseYieldCurve<QuantLib::ZeroYield, QuantLib::LogLinear>(
                        settlement_date, 
                        curve_input, day_counter, 
                        tolerance
                    )
                );
            } else if (interpolator.compare("spline") == 0) {
                ts = TS(
                    new QuantLib::PiecewiseYieldCurve<QuantLib::ZeroYield, QuantLib::Cubic>(
                        settlement_date, curve_input, day_counter, 
                        tolerance
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
