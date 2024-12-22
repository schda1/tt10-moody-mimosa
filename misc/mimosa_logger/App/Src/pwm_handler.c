#include <pwm_handler.h>

/* Actual hardware dependence. Will be mocked for unit tests */
void gpio_write_pin(GPIO_TypeDef* port, uint8_t pin, uint8_t state);
void gpio_set_as_output(GPIO_TypeDef* port, uint8_t pin);
void timer_start(TIM_HandleTypeDef* htim);
void timer_stop(TIM_HandleTypeDef* htim);


void pwm_handler_callback(struct pwm_handler* pwm)
{
    bool pin_on = false;

    if (!pwm->enabled) {
        for (uint8_t i = 0; i < pwm->n_channels; i++) {
            gpio_write_pin(pwm->channels[i].port, pwm->channels[i].pin_nr, 0);
        }
        return;
    }

    for (uint8_t i = 0; i < pwm->n_channels; i++) {
        pin_on = pwm->channels[i].cycle < pwm->channels[i].duty_cycle;
        gpio_write_pin(pwm->channels[i].port, pwm->channels[i].pin_nr, pin_on);
        pwm->channels[i].cycle = (pwm->channels[i].cycle + 1) % 100;
    }
}

void pwm_handler_init(struct pwm_handler* pwm, TIM_HandleTypeDef* htim)
{
    pwm->htim = htim;
    pwm->n_channels = 0;
    pwm->enabled = false;
}

void pwm_handler_attach(struct pwm_handler* pwm, GPIO_TypeDef* port, uint8_t pin_nr, uint16_t duty_cycle)
{
    if (pwm->n_channels < N_PWM_CHANNELS) {
        pwm->channels[pwm->n_channels].port = port;
        pwm->channels[pwm->n_channels].pin_nr = pin_nr;
        pwm->channels[pwm->n_channels].duty_cycle = duty_cycle;
        pwm->channels[pwm->n_channels].cycle = 0;
        gpio_set_as_output(port, pin_nr);
        pwm->n_channels++;
    }
}

void pwm_handler_set_duty_cycle(struct pwm_handler* pwm, uint8_t pwm_channel, uint16_t duty_cycle)
{
    if (pwm_channel < pwm->n_channels){
        pwm->channels[pwm_channel].duty_cycle = duty_cycle;
    }
}

void pwm_handler_enable(struct pwm_handler* pwm, bool enable)
{
    if (enable && !pwm->enabled) {
        timer_start(pwm->htim);
    }
    else if (!enable && pwm->enabled) {
        timer_stop(pwm->htim);
    }

    pwm->enabled = enable;
}

#ifndef UTEST
void gpio_set_as_output(GPIO_TypeDef* port, uint8_t pin_nr)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    GPIO_InitStruct.Pin = (1<<pin_nr);
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(port, &GPIO_InitStruct);
}

void gpio_write_pin(GPIO_TypeDef* port, uint8_t pin_nr, uint8_t state)
{
    HAL_GPIO_WritePin(port, 1<<pin_nr, state);
}

void timer_start(TIM_HandleTypeDef* htim)
{
    HAL_TIM_Base_Start_IT(htim);
}

void timer_stop(TIM_HandleTypeDef* htim)
{
    HAL_TIM_Base_Stop_IT(htim);
}
#endif