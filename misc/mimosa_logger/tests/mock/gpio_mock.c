#include <gpio_mock.h>



void gpio_write_pin(GPIO_TypeDef* port, uint8_t pin, uint8_t state)
{
    if (state) {
        *port |= (1 << pin);
    } else {
        *port &= ~(1 << pin);
    }
}

uint8_t gpio_read_pin(GPIO_TypeDef* port, uint8_t pin)
{
    return (*port >> pin) & 0x01;
}

void gpio_set_as_output(GPIO_TypeDef* port, uint8_t pin)
{
    /* Nothing to be done */
}