#include <ql/time/date.hpp>
#include <ql/settings.hpp>

namespace QuantLib {

    void set_evaluation_date(QuantLib::Date& evaluation_date) {
        QuantLib::Settings::instance().evaluationDate() = evaluation_date;
    }

    QuantLib::Date get_evaluation_date(){
        return QuantLib::Settings::instance().evaluationDate();
    }
}
