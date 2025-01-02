#pragma once

#include <HalWrapper/ITimer.hpp>

#include "stm32g4xx_hal.h"

class Timer : public ITimer
{
public:
    Timer(TIM_TypeDef* instance);
    virtual ~Timer(){};

    virtual void set_prescaler(uint32_t prescaler);
    virtual void set_period(uint32_t period);

    virtual void init() override;
    virtual void start() override;
    virtual void stop() override;
    virtual void reset() override;

    virtual void callback() override;
};