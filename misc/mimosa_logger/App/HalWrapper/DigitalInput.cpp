#include <HalWrapper/DigitalInput.hpp>

#include "stm32g4xx_hal.h"

#include <cstdio>

DigitalInput::DigitalInput(GPIO_TypeDef* port, uint8_t pin) : port(port), pin(pin), inverted(false) {}

void DigitalInput::init(DigitalInputMode mode)
{
    if (port == GPIOA) {
        __HAL_RCC_GPIOA_CLK_ENABLE();
    } else if (port == GPIOB) {
        __HAL_RCC_GPIOB_CLK_ENABLE();
    } else if (port == GPIOC) {
        __HAL_RCC_GPIOC_CLK_ENABLE();
    }

    GPIO_InitTypeDef GPIO_InitStruct = {0};

    GPIO_InitStruct.Pin = (1L << pin);
    GPIO_InitStruct.Mode = GPIO_MODE_INPUT;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_LOW;

    if (mode == DigitalInputMode::INPUT_PULL_UP) {
        GPIO_InitStruct.Pull = GPIO_PULLUP;
    } else if (mode == DigitalInputMode::INPUT_PULL_DOWN) {
        GPIO_InitStruct.Pull = GPIO_PULLDOWN;
    }

    HAL_GPIO_Init(port, &GPIO_InitStruct);
}

uint8_t DigitalInput::get() const
{
    uint8_t state = HAL_GPIO_ReadPin(port, 1 << pin);

    if (inverted) {
        state = !state;
    }

    return state;
}

void DigitalInput::invert(bool invert)
{
    inverted = invert;
}
