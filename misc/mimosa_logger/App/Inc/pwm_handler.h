#ifndef PWM_HANDLER_H
#define PWM_HANDLER_H

#define N_PWM_CHANNELS (6)

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdbool.h>

#ifndef UTEST
#include "main.h"
#else
typedef uint16_t GPIO_TypeDef;
typedef uint16_t TIM_HandleTypeDef;
#endif


struct pwm_channel {
    GPIO_TypeDef* port;     /**< Port of the pwm output */
    uint8_t pin_nr;         /**< Pin of the pwm output  */
    uint8_t duty_cycle;     /**< Duty cycle in %        */
    uint8_t cycle;          /**< Current cycle          */
};

struct pwm_handler {
    struct pwm_channel channels[N_PWM_CHANNELS];   /**< Pwm channels             */
    TIM_HandleTypeDef* htim;                /**< Timer handler            */
    uint8_t n_channels;                     /**< Number of valid channels */
    bool enabled;                           /**< Output signal enables    */                       
};

/**
 * @brief Initialize the pwm handler
 * 
 * @param pwm_handler Pwm handler data structure
 */
void pwm_handler_init(struct pwm_handler* pwm, TIM_HandleTypeDef* htim);

/**
 * @brief Attach a pwm output to the pwm handler
 * 
 * @param pwm Pwm handler data structure
 * @param port GPIO port
 * @param pin GPIO pin
 * @param duty_cycle Duty cycle
 */
void pwm_handler_attach(struct pwm_handler* pwm, GPIO_TypeDef* port, uint8_t pin, uint16_t duty_cycle);

/**
 * @brief Set the duty cycle of a pwm channel
 * 
 * @param pwm Pwm handler data structure
 * @param pwm_channel PWM channel
 * @param duty_cycle Duty cycle
 */
void pwm_handler_set_duty_cycle(struct pwm_handler* pwm, uint8_t pwm_channel, uint16_t duty_cycle);

/**
 * @brief Enable or disable the pwm handler
 * 
 * @param pwm Pwm handler data structure
 * @param enable Enable or disable
 */
void pwm_handler_enable(struct pwm_handler* pwm, bool enable);

/**
 * @brief Callback function for the pwm handler
 * 
 * @param pwm Pwm handler data structure
 */
void pwm_handler_callback(struct pwm_handler* pwm);


#ifdef __cplusplus
}
#endif

#endif /* PIN_OBSERVER_H */
