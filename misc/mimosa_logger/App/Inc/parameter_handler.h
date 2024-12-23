#ifndef PARAMETER_HANDLER_H
#define PARAMETER_HANDLER_H

#ifdef __cplusplus
extern "C" {
#endif

#define MAX_PARAMETERS (10)

#include <stdint.h>
#include <stdbool.h>

typedef void (*write_fct_t)(uint32_t address, uint32_t value);
typedef uint32_t (*read_fct_t)(uint32_t address);
typedef void (*erase_fact_t)(uint32_t address, uint32_t size);

struct parameter {
    uint32_t* parameter;    /**< Pointer to parameter to be handled                        */
    uint32_t identifier;    /**< User-defined identifier for parameter                     */
    uint32_t address;       /**< Address for persistent storage (Flash, EEPROM, FRAM, ...) */
};

struct persistent_storage 
{
    uint32_t persistent_storage_start_address;    /**< Start address for persistent storage */
    uint32_t persistent_storage_size_bytes;       /**< Size of persistent storage in bytes  */
    uint32_t persistent_starge_min_offset;        /**< Minimum offset between parameters    */

    erase_fact_t erase_fct;  /**< Function responsible for erasing persistent storage       */
    write_fct_t write_fct;   /**< Function responsible for writing to persistent storage    */    
    read_fct_t read_fct;     /**< Function responsible for reading from persistent storage  */

    bool storage_medium_must_be_erased_before_writing;  /**< Flag indicating that the storage medium must be erased */
};

struct parameter_handler {
    struct parameter parameters[MAX_PARAMETERS];  /**< Handled parameters                   */
    uint8_t num_parameters;                       /**< Number of handled parameters         */

    struct persistent_storage* storage;          /**< Persistent storage data structure     */
};

/**
 * @brief Initialize the parameter handler
 * 
 * @param param_handler Parameter handler data structure
 * @param storage Persistent storage data structure (if NULL, last flash page is used)
 */
void parameter_handler_init(struct parameter_handler* param_handler, struct persistent_storage* storage);

/**
 * @brief Attach a parameter to the parameter handler
 * 
 * @param param_handler Parameter handler data structure
 * @param parameter Pointer to the parameter
 * @param identifier User-defined identifier for the parameter
 */
void param_handler_attach(struct parameter_handler* param_handler, uint32_t* parameter, uint32_t identifier);

/**
 * @brief Download all parameters from the parameter handler
 * 
 * @param param_handler Parameter handler data structure
 */
void param_handler_download(struct parameter_handler* param_handler);

/**
 * @brief Upload all parameters to the parameter handler
 * 
 * @param param_handler Parameter handler data structure
 */
void param_handler_upload(struct parameter_handler* param_handler);

/**
 * @brief Print all parameters in the parameter handler
 * 
 * @param param_handler Parameter handler data structure
 */
void param_handler_print(struct parameter_handler* param_handler);
    	
#ifdef __cplusplus
}
#endif

#endif /* PIN_OBSERVER_H */
