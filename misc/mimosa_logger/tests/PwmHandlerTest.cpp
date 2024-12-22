#include <CppUTest/TestHarness.h>

#include <pwm_handler.h>
#include <gpio_mock.h>
#include <timer_mock.h>
#include <stdio.h>

static struct pwm_handler pwm;
static GPIO_TypeDef port;
static uint8_t pin_nr = 2;
static TIM_HandleTypeDef htim;

TEST_GROUP(PwmHandler)
{
    void setup() {
        memset(&pwm, 0, sizeof(struct pwm_handler));
    }

    void teardown() {
        /* Nothing to be done */
    }
};

TEST(PwmHandler, test_gpio_mock)
{
    for (uint8_t i = 0; i < 16; i++) {
        gpio_write_pin(&port, i, 1);
        LONGS_EQUAL(1<<i, port);
        gpio_write_pin(&port, i, 0);
        LONGS_EQUAL(0, port);
    }
}

TEST(PwmHandler, test_timer_mock)
{
    TIM_HandleTypeDef htim;
    CHECK_EQUAL(false, timer_is_running(&htim));
    timer_start(&htim);
    CHECK_EQUAL(true, timer_is_running(&htim));
    timer_stop(&htim);
    CHECK_EQUAL(false, timer_is_running(&htim));
}

TEST(PwmHandler, test_init) 
{
    pwm_handler_init(&pwm, &htim);
    CHECK_EQUAL(&htim, pwm.htim);
    CHECK_EQUAL(0, pwm.n_channels);
    CHECK_EQUAL(false, pwm.enabled);
}

TEST(PwmHandler, test_attach)
{
    pwm_handler_init(&pwm, &htim);
    pwm_handler_attach(&pwm, &port, pin_nr, 50);
    CHECK_EQUAL(1, pwm.n_channels);
    CHECK_EQUAL(&port, pwm.channels[0].port);
    CHECK_EQUAL(pin_nr, pwm.channels[0].pin_nr);
    CHECK_EQUAL(50, pwm.channels[0].duty_cycle);
}

TEST(PwmHandler, test_set_duty_cycle)
{
    pwm_handler_init(&pwm, &htim);
    pwm_handler_attach(&pwm, &port, pin_nr, 50);
    pwm_handler_set_duty_cycle(&pwm, 0, 75);
    CHECK_EQUAL(75, pwm.channels[0].duty_cycle);
}

TEST(PwmHandler, test_enable)
{
    pwm_handler_init(&pwm, &htim);
    pwm_handler_attach(&pwm, &port, pin_nr, 50);
    pwm_handler_enable(&pwm, true);
    CHECK_EQUAL(true, pwm.enabled);
    CHECK_EQUAL(true, timer_is_running(&htim));
    pwm_handler_enable(&pwm, false);
    CHECK_EQUAL(false, pwm.enabled);
    CHECK_EQUAL(false, timer_is_running(&htim));
}

TEST(PwmHandler, test_configure_too_many_channels)
{
    pwm_handler_init(&pwm, &htim);

    for (uint8_t i = 0; i < N_PWM_CHANNELS; i++) {
        pwm_handler_attach(&pwm, &port, i, 50);
    }
    pwm_handler_attach(&pwm, &port, N_PWM_CHANNELS, 50);
    CHECK_EQUAL(N_PWM_CHANNELS, pwm.n_channels);
}

TEST(PwmHandler, test_pwm_functionality)
{
    pwm_handler_init(&pwm, &htim);
    pwm_handler_attach(&pwm, &port, pin_nr, 50);
    pwm_handler_enable(&pwm, true);

    for (uint8_t i = 0; i < 100; i++) {
        pwm_handler_callback(&pwm);
        CHECK_EQUAL(i < 50, gpio_read_pin(&port, pin_nr));
    }
}

TEST(PwmHandler, test_output_if_not_enabled)
{
    pwm_handler_init(&pwm, &htim);
    pwm_handler_attach(&pwm, &port, pin_nr, 50);
    pwm_handler_enable(&pwm, false);

    for (uint8_t i = 0; i < 100; i++) {
        pwm_handler_callback(&pwm);
        CHECK_EQUAL(0, gpio_read_pin(&port, pin_nr));
    }
}