#include <HalWrapper/IDigitalInput.hpp>

#include "stm32g4xx_hal.h"

class DigitalInput : public IDigitalInput
{
public:
    DigitalInput(GPIO_TypeDef* port, uint8_t pin);
    virtual ~DigitalInput() {}

    void init(DigitalInputMode mode) override;
    uint8_t get() const override;
    void invert(bool invert) override;

protected:
    DigitalInputMode mode;
    GPIO_TypeDef* port;
    uint8_t pin;
    bool inverted;
};