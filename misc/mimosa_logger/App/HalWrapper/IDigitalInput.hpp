#pragma once

#include <stdint.h>

enum class DigitalInputMode
{
    INPUT,
    INPUT_PULL_UP,
    INPUT_PULL_DOWN
};

class IDigitalInput
{
public:
    IDigitalInput(){};
    virtual ~IDigitalInput() {}

    virtual void init(enum DigitalInputMode mode) = 0;
    virtual uint8_t get() const = 0;
    virtual void invert(bool invert) = 0;
};