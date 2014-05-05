/*
 * Cython does not support the << operator.
 * 
 */

#include <iostream>
#include <sstream>
#include <ql/time/businessdayconvention.hpp>

namespace QL {
    std::string repr(int b) {
      QuantLib::BusinessDayConvention bd = static_cast<QuantLib::BusinessDayConvention>(b);
      std::ostringstream s;
      s << bd;
      return s.str();
    }
}
