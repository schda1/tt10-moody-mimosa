#include "app.h"
#include "pin_observer.h"
#include "msg_parser.h"
#include "pwm_handler.h"
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

#define PWM_CH_COLD      (0)
#define PWM_CH_HOT       (1)
#define PWM_CH_DARK      (2)
#define PWM_CH_BRIGHT    (3)
#define PWM_CH_QUIET     (4)
#define PWM_CH_LOUD      (5)

struct app_data {
    uint32_t cnt_ms;
    uint32_t period_ms;
    uint8_t status;
};

static struct pin_observer pin_observer;
static struct app_data app_data;
static struct msg_parser msg_parser;
static struct pwm_handler pwm_handler;
static struct msg msg;

static void app_process_cmd(struct msg* msg);
static void app_init_pwm_handler();
static void set_clock(uint8_t value);
static void set_rst_n(uint8_t value);
static void start(void);
static void stop(void);
static void pause(void);
static void set_period_ms(uint32_t period_ms);

extern TIM_HandleTypeDef htim3;
extern UART_HandleTypeDef hlpuart1;

static volatile uint8_t flag = 0;
static volatile uint8_t rxByte;


void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
    if (huart->Instance == LPUART1) {
        msg_parser_add(&msg_parser, &rxByte);
        HAL_UART_Receive_IT(huart, &rxByte, 1);
    }
}

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef* htim)
{
    if (htim->Instance == TIM3) {
        pwm_handler_callback(&pwm_handler);
        return;
    }

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
    msg_parser_init(&msg_parser, &hlpuart1);
    app_init_pwm_handler();
    pin_observer_init(&pin_observer);

    set_clock(0);
    set_rst_n(1);

    HAL_UART_Receive_IT(&hlpuart1, &rxByte, 1);
}

void app_run(void)
{
    while (1) {

        /* Process incoming commands */
        msg_parser_update(&msg_parser, &msg);
        if (msg.type != MSG_NONE) {
            app_process_cmd(&msg);
        }

        if (app_data.status & MASK_NOT_RUNNING) {
            continue;
        }

        /* Update pin observer */
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

static void app_process_cmd(struct msg* msg)
{
    switch (msg->type) {
        case MSG_START:
            start();
            break;
        case MSG_STOP:
            stop();
            break;
        case MSG_PAUSE:
            pause();
            break;
        case MSG_SET_PERIOD:
            set_period_ms(msg->value);
            break;
        case MSG_SET_COLD:
            pwm_handler_set_duty_cycle(&pwm_handler, PWM_CH_COLD, msg->value);
            break;
        case MSG_SET_HOT:
            pwm_handler_set_duty_cycle(&pwm_handler, PWM_CH_HOT, msg->value);
            break;
        case MSG_SET_DARK:
            pwm_handler_set_duty_cycle(&pwm_handler, PWM_CH_DARK, msg->value);
            break;
        case MSG_SET_BRIGHT:
            pwm_handler_set_duty_cycle(&pwm_handler, PWM_CH_BRIGHT, msg->value);
            break;
        case MSG_SET_QUIET:
            pwm_handler_set_duty_cycle(&pwm_handler, PWM_CH_QUIET, msg->value);
            break;
        case MSG_SET_LOUD:
            pwm_handler_set_duty_cycle(&pwm_handler, PWM_CH_LOUD, msg->value);
            break;
        default:
            break;
    }
}

static void app_init_pwm_handler()
{
    pwm_handler_init(&pwm_handler, &htim3);
    pwm_handler_attach(&pwm_handler, GPIOA, 7, 0);    /* PWM_CH_COLD   */
    pwm_handler_attach(&pwm_handler, GPIOA, 8, 0);    /* PWM_CH_HOT    */
    pwm_handler_attach(&pwm_handler, GPIOA, 9, 0);    /* PWM_CH_DARK   */
    pwm_handler_attach(&pwm_handler, GPIOA, 10, 0);   /* PWM_CH_BRIGHT */
    pwm_handler_attach(&pwm_handler, GPIOA, 11, 0);   /* PWM_CH_QUIET  */
    pwm_handler_attach(&pwm_handler, GPIOA, 12, 0);   /* PWM_CH_LOUD   */
    pwm_handler_enable(&pwm_handler, 1);
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