#include "app.h"
#include "pin_observer.h"
#include <stdint.h>
#include <stdio.h>

#include "main.h"

#define CLK_PORT    (GPIOA)
#define CLK_PIN     (GPIO_PIN_4)
#define RST_N_PORT  (GPIOA)
#define RST_N_PIN   (GPIO_PIN_5)

#define MASK_IS_PAUSED   (1<<0)
#define MASK_IS_STOPPED  (1<<1)
#define MASK_NOT_RUNNING (MASK_IS_PAUSED | MASK_IS_STOPPED)
#define MASK_HALF_CYCLE  (1<<2)
#define MASK_FULL_CYCLE  (1<<3)

struct app_data {
    uint32_t cnt_ms;
    uint32_t period_ms;
    uint8_t status;
};

static struct pin_observer pin_observer;
static struct app_data app_data;

static void set_clock(uint8_t value);
static void set_rst_n(uint8_t value);
static void start(void);
static void stop(void);
static void pause(void);
static void set_period_ms(uint32_t period_ms);


static volatile uint8_t flag = 0;

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef* htim)
{
    if ((app_data.status & MASK_NOT_RUNNING) == 0) {
        app_data.cnt_ms++;

        /* Create rising edge */
        if (app_data.cnt_ms == app_data.period_ms / 2) {
            app_data.status |= MASK_HALF_CYCLE;
            set_clock(1);
        } 
        /* Create falling edge */
        else if (app_data.cnt_ms >= app_data.period_ms) {
            app_data.status |= MASK_FULL_CYCLE;
            set_clock(0);
        }
    }
    else
    {
        app_data.cnt_ms = 0;
        app_data.status = 0;
    }
}

void app_init(void)
{
    pin_observer_init(&pin_observer);
    set_clock(0);
    set_rst_n(1);
}

void app_run(void)
{
    while (1) {

        if (app_data.status & MASK_NOT_RUNNING) {
            continue;
        }

        if (app_data.status & MASK_HALF_CYCLE) {
            pin_observer_update(&pin_observer);
            pin_observer_print(&pin_observer);
            app_data.status &= ~MASK_HALF_CYCLE;
        }
        else if (app_data.status & MASK_FULL_CYCLE) {
            app_data.status &= ~MASK_FULL_CYCLE;
        }
    }
}

static void stop(void)
{
    set_clock(0);
    set_rst_n(0);
    pin_observer_reset(&pin_observer);

    app_data.status |= MASK_IS_STOPPED;
    app_data.status &= ~MASK_IS_PAUSED;
}

static void start(void)
{
    set_rst_n(1);

    app_data.status &= ~MASK_IS_STOPPED;
    app_data.status &= ~MASK_IS_PAUSED;
}

static void pause(void)
{
    app_data.status |= ~MASK_IS_PAUSED;
}

static void set_period_ms(uint32_t period_ms)
{
    app_data.period_ms = period_ms;
}

static void set_clock(uint8_t value)
{
    HAL_GPIO_WritePin(CLK_PORT, CLK_PIN, value);
}

static void set_rst_n(uint8_t value)
{
    HAL_GPIO_WritePin(RST_N_PORT, RST_N_PIN, value);
}