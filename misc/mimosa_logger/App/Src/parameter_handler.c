#include <parameter_handler.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

static void write_to_flash(uint32_t address, uint32_t value);
static uint32_t read_from_flash(uint32_t address);
static void erase_flash(uint32_t address, uint32_t size);

#define FLASH_PARAM_PAGE      (0x0807F800)
#define FLASH_PARAM_PAGE_SIZE (2048)
#define FLASH_PARAM_BANK      (FLASH_BANK_2)

#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define MAX(a, b) (((a) > (b)) ? (a) : (b))

static struct persistent_storage flash_storage = 
{
    .persistent_storage_start_address = FLASH_PARAM_PAGE,
    .persistent_storage_size_bytes = FLASH_PARAM_PAGE_SIZE,
    .persistent_starge_min_offset = 8,
    .erase_fct = erase_flash,
    .write_fct = write_to_flash,
    .read_fct = read_from_flash,
    .storage_medium_must_be_erased_before_writing = true
};

void parameter_handler_init(struct parameter_handler* param_handler, struct persistent_storage* storage)
{
    memset(param_handler, 0, sizeof(struct parameter_handler));

    /* If no valid storage medium is provided, the last flash page is used by default */
    param_handler->storage = (storage != NULL) ? storage : &flash_storage;
}

void param_handler_attach(struct parameter_handler* param_handler, uint32_t* parameter, uint32_t identifier)
{
    uint32_t address;
    uint32_t offset = MAX(param_handler->storage->persistent_starge_min_offset, sizeof(uint32_t));

    if (param_handler->num_parameters < MAX_PARAMETERS) {
        address = param_handler->storage->persistent_storage_start_address + (param_handler->num_parameters * offset);
        param_handler->parameters[param_handler->num_parameters].parameter = parameter;
        param_handler->parameters[param_handler->num_parameters].identifier = identifier;
        param_handler->parameters[param_handler->num_parameters].address = address;
        param_handler->num_parameters++;
    }
}

void param_handler_download(struct parameter_handler* param_handler)
{
    struct persistent_storage* storage = param_handler->storage;

    for (uint8_t i = 0; i < param_handler->num_parameters; i++) {
        *(param_handler->parameters[i].parameter) = storage->read_fct(param_handler->parameters[i].address);
    }
}

void param_handler_upload(struct parameter_handler* param_handler)
{
    struct persistent_storage* storage = param_handler->storage;

    if (storage->storage_medium_must_be_erased_before_writing) {
        storage->erase_fct(storage->persistent_storage_start_address, storage->persistent_storage_size_bytes);
    }
    
    for (uint8_t i = 0; i < param_handler->num_parameters; i++) {
        storage->write_fct(param_handler->parameters[i].address, *(param_handler->parameters[i].parameter));
    }
}

void param_handler_print(struct parameter_handler* param_handler)
{
    for (uint8_t i = 0; i < param_handler->num_parameters; i++) {
        printf("Parameter %d: %d\n", param_handler->parameters[i].identifier, *(param_handler->parameters[i].parameter));
    }
}

#ifndef UTEST

#include "stm32g4xx_hal.h"

static uint32_t read_from_flash(uint32_t address)
{
    return *((uint32_t*)(address));
}

static void erase_flash(uint32_t address, uint32_t size)
{   
    uint32_t error = 0;

    HAL_FLASH_Unlock();

    FLASH_EraseInitTypeDef erase_init = {0};
    erase_init.TypeErase = FLASH_TYPEERASE_PAGES;
    erase_init.Banks = FLASH_PARAM_BANK;
    erase_init.Page = (address - FLASH_BASE) / FLASH_PAGE_SIZE;
    erase_init.NbPages = size / FLASH_PAGE_SIZE;

    __disable_irq();
    HAL_FLASHEx_Erase(&erase_init, &error);
    __enable_irq();

    HAL_FLASH_Lock();
}

static void write_to_flash(uint32_t address, uint32_t value)
{
    HAL_FLASH_Unlock();

    __disable_irq();
    HAL_FLASH_Program(FLASH_TYPEPROGRAM_DOUBLEWORD, address, (uint64_t)value);
    __enable_irq();

    HAL_FLASH_Lock();
}

#endif