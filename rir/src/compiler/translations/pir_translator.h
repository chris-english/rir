#ifndef PIR_TRANSLATOR_H
#define PIR_TRANSLATOR_H

#include "../pir/module.h"
#include <string>

namespace rir {
namespace pir {

class RirCompiler;
class PirTranslator {
  public:
    PirTranslator(const std::string& name) : name(name) {}

    virtual void apply(Closure* function) const = 0;
    std::string getName() const { return this->name; }
    virtual ~PirTranslator() {}

  protected:
    std::string name;
};
}
}

#endif
