#ifndef PIN_OBSERVER_H
#define PIN_OBSERVER_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

struct pin_observer {
    uint32_t cycle;    /**< Cycle number of the current observation     */
    uint8_t ui_in;     /**< Pin states ui_in, according to tt notation  */
    uint8_t uo_out;    /**< Pin states uo_out, according to tt notation */
    uint8_t uoi;       /**< Pin states uoi, according to tt notation    */
    uint8_t ctrl;      /**< Rst_n (bit 0) and clk (bit 1) signal        */
};

/**
 * @brief Initialize the pin observer
 * 
 * @param pin_observer Pin observer data structure
 */
void pin_observer_init(struct pin_observer* pin_observer);

/**
 * @brief Run the pin observer
 * 
 * @param pin_observer Pin observer data structure
 */
void pin_observer_update(struct pin_observer* pin_observer);

/**
 * @brief Reset the pin observer
 * 
 * @param pin_observer Pin observer data structure
 */
void pin_observer_reset(struct pin_observer* pin_observer);

/**
 * @brief Print pin observer information
 * 
 * @param pin_observer Pin observer data structure
 */
void pin_observer_print(struct pin_observer* pin_observer);


#ifdef __cplusplus
}
#endif

#endif /* PIN_OBSERVER_H */
