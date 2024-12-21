
#include "pin_observer.h"
#include <stdio.h>

#include "stm32g4xx_hal.h"

/* Defining port and pins mapped to tt ui_in pins */
#define UI_IN_PORT   (GPIOB->IDR)
#define UI_IN_SHIFT  (0)
#define UI_IN_MASK   (0x00FF)

/* Defining port and pins mapped to tt uo_out pins */
#define UO_OUT_PORT  (GPIOC->IDR)
#define UO_OUT_SHIFT (0)
#define UO_OUT_MASK  (0x00FF)

/* Defining port and pins mapped to tt uio pins */
#define UIO_PORT     (GPIOC->IDR)
#define UIO_SHIFT    (8)
#define UIO_MASK     (0x00FF)

/* Defining port and pins mapped to tt rst_n and clk pins */
#define CTRL_PORT    (GPIOB->IDR)
#define CTRL_SHIFT   (10)
#define CTRL_MASK    (0x0003)

static uint8_t calc_check_sum(struct pin_observer* pin_observer);

void pin_observer_init(struct pin_observer* pin_observer)
{
    pin_observer->cycle = 0;
}

void pin_observer_update(struct pin_observer* pin_observer)
{
    pin_observer->cycle++;
    pin_observer->ui_in  = ((UI_IN_PORT >> UI_IN_SHIFT) & UI_IN_MASK);          
    pin_observer->uo_out = ((UO_OUT_PORT >> UO_OUT_SHIFT) & UO_OUT_MASK);          
    pin_observer->uoi    = ((UIO_PORT >> UIO_SHIFT) & UIO_MASK);          
    pin_observer->ctrl   = ((CTRL_PORT >> CTRL_SHIFT) & CTRL_MASK);           
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
                                   pin_observer->ctrl, 
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