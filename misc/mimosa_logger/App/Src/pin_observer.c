
#include "pin_observer.h"
#include <stdio.h>

#include "stm32l0xx_hal.h"

static uint8_t calc_check_sum(struct pin_observer* pin_observer);

void pin_observer_init(struct pin_observer* pin_observer)
{
    pin_observer->cycle = 0;
}

void pin_observer_update(struct pin_observer* pin_observer)
{
    uint16_t gpioa_port = GPIOA->IDR;
    uint16_t gpiob_port = GPIOB->IDR;

    pin_observer->cycle++;
    pin_observer->ui_in  = (gpioa_port & 0x00FF);
    pin_observer->uo_out = (gpiob_port & 0x00FF);
    pin_observer->uoi    = ((gpiob_port >> 8) & 0x00FF);
    pin_observer->rst_n  = ((gpioa_port >> 10) & 0x0001);
}

void pin_observer_reset(struct pin_observer* pin_observer)
{
    pin_observer->cycle = 0;
}

void pin_observer_print(struct pin_observer* pin_observer)
{
    uint8_t cs = calc_check_sum(pin_observer);

    printf("%lu,%u,%u,%u,%u,%u\n", pin_observer->cycle, 
                                   pin_observer->ui_in, 
                                   pin_observer->uo_out, 
                                   pin_observer->uoi, 
                                   pin_observer->rst_n, 
                                   cs);
}

static uint8_t calc_check_sum(struct pin_observer* pin_observer)
{
    uint8_t cs = 0;
    uint8_t* p = (uint8_t*)(pin_observer);

    for (uint8_t i = 0; i < sizeof(struct pin_observer); i++) {
        cs ^= p[i];
    }

    return cs;
}