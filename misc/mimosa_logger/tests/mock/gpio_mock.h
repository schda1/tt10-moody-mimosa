#ifndef GPIO_MOCK_H
#define GPIO_MOCK_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

typedef uint16_t GPIO_TypeDef;

/**
 * @brief Write a pin 
 * 
 * @param port GPIO port
 * @param pin GPIO pin
 * @param state State of the pin
 */
void gpio_write_pin(GPIO_TypeDef* port, uint8_t pin, uint8_t state);

/**
 * @brief Read a pin
 * 
 * @param port GPIO port
 * @param pin GPIO pin
 * @return uint8_t State of the pin
 */
uint8_t gpio_read_pin(GPIO_TypeDef* port, uint8_t pin);

#ifdef __cplusplus
}
#endif

#endif