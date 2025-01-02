#pragma once

#include <PersistantStorage/PersistantStorage.hpp>
#include <HalWrapper/ISpi.hpp>

class FramStorage_Spi : public PersistantStorage
{

public:
    FramStorage_Spi(ISpi* hspi);
    FramStorage_Spi(ISpi* hspi, uint32_t start_address, uint32_t len);
    virtual ~FramStorage_Spi() {}

    virtual void init() override;
    virtual void erase(uint32_t start_address, uint32_t len) override;

    virtual void write8(uint32_t address, uint8_t value) override;
    virtual void write32(uint32_t address, uint32_t value) override;
    virtual void write(uint32_t address, const uint8_t* data, uint32_t size) override;

    virtual void read8(uint32_t address, uint8_t* value) override;
    virtual void read32(uint32_t address, uint32_t* value) override;
    virtual void read(uint32_t address, uint8_t* data, uint32_t size) override;

private:
    // void set_cs(bool value);
    void read_device_id();
    void write_enable(bool value);
    bool valid_device();
    uint8_t calc_address_bytes();

    ISpi* hspi;

    uint8_t manufacturer_id;
    uint16_t product_id;
    uint32_t capacity;
    uint8_t address_bytes;
};
