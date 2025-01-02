
#include <MimosaDriver.hpp>
#include <Parameter.hpp>
#include <functional>

#define MASK_IS_PAUSED (1 << 0)
#define MASK_IS_STOPPED (1 << 1)
#define MASK_NOT_RUNNING (MASK_IS_PAUSED | MASK_IS_STOPPED)
#define MASK_HALF_CYCLE (1 << 2)
#define MASK_FULL_CYCLE (1 << 3)

MimosaDriver::MimosaDriver(ITimer* timer, IDigitalOutput* clk, IDigitalOutput* rst_n, PinObserver* observer, ParameterHandler* handler) :
    mimosa_timer(timer),
    clk(clk),
    rst_n(rst_n),
    pin_observer(observer),
    param_handler(handler)
{
    timer->set_callback([this]() { this->callback(); });
}

void MimosaDriver::init()
{
    clk->init();
    rst_n->init();

    period_ms = param_handler->get_or_create<uint32_t>(PARAM_MIMOSA_PERIOD, PARAM_MIMOSA_PERIOD_DEFAULT);
    printf("Mimosa Period: %ld\n", *period_ms);

    // set_period();
}

void MimosaDriver::start()
{
    clk->set(1);
    rst_n->set(1);
    mimosa_timer->start();
    status &= ~MASK_NOT_RUNNING;
}

void MimosaDriver::stop()
{
    clk->set(0);
    rst_n->set(0);
    mimosa_timer->stop();
    counter = 0;
    status |= MASK_IS_STOPPED;
}

void MimosaDriver::pause()
{
    mimosa_timer->stop();
    status |= MASK_IS_PAUSED;
}

void MimosaDriver::update()
{
    if ((status & MASK_NOT_RUNNING) > 0) {
        return;
    }

    if ((status & MASK_HALF_CYCLE) > 0) {
        pin_observer->update();
        pin_observer->print();
        status &= ~MASK_HALF_CYCLE;
    } else if ((status & MASK_FULL_CYCLE) > 0) {
        status &= ~MASK_FULL_CYCLE;
    }
}

void MimosaDriver::set_period_ms(uint32_t period_ms)
{
    *this->period_ms = period_ms;
    set_period();
}

void MimosaDriver::enable_log(bool enable)
{
    pin_observer->enable_log(enable);
}

void MimosaDriver::set_period()
{
    mimosa_timer->set_period(*period_ms);
}

void MimosaDriver::callback()
{
    if ((status & MASK_NOT_RUNNING) == 0) {

        counter++;

        /* Create rising edge */
        if (counter == *period_ms / 2) {
            clk->set(1);
            status |= MASK_HALF_CYCLE;
        }

        /* Create falling edge */
        else if (counter >= *period_ms) {
            counter = 0;
            clk->set(0);
            status |= MASK_FULL_CYCLE;
        }
    }
}