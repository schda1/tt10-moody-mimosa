
#pragma once

#include <HalWrapper/IDigitalOutput.hpp>
#include <HalWrapper/ITimer.hpp>
#include <Parameter/ParameterHandler.hpp>
#include <Parameter.hpp>
#include <PinObserver.hpp>

class MimosaDriver
{

public:
    MimosaDriver(ITimer* timer, IDigitalOutput* clk, IDigitalOutput* rst_n, PinObserver* observer, ParameterHandler* handler);
    virtual ~MimosaDriver() {}

    void init();
    void start();
    void stop();
    void pause();
    void set_period_ms(uint32_t period_ms);

    void enable_log(bool enable);

    void callback(void);

    void update();

protected:
    void set_period();

    ITimer* mimosa_timer;
    IDigitalOutput* clk;
    IDigitalOutput* rst_n;
    PinObserver* pin_observer;
    ParameterHandler* param_handler;

    uint32_t* period_ms;

    uint8_t status;
    uint32_t counter;
};