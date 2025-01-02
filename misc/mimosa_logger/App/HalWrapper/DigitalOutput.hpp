#include <HalWrapper/IDigitalOutput.hpp>

#include "stm32g4xx_hal.h"

class DigitalOutput : public IDigitalOutput
{
public:
    DigitalOutput(GPIO_TypeDef* port, uint8_t pin);
    virtual ~DigitalOutput() {}

    void init() override;

    void set(uint8_t state) override;
    uint8_t get() const override;
    void toggle() override;
    void invert(bool invert) override;

protected:
    GPIO_TypeDef* port;
    uint8_t pin;
    bool inverted;
};