#ifndef UART_MOCK_H
#define UART_MOCK_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#define MOCK_BUFFER_LEN (256)

typedef void (*uart_rx_callback_t)(char c);

/**
 * @brief Initialize the mock uart
 */
void uart_mock_init(uart_rx_callback_t rx_callback);

/**
 * @brief Emulate sending a message 
 *
 * @param msg Buffer containing the message to be sent
 * @param len Length of the message
 */
void uart_mock_add_message(const char* msg, uint16_t len);


#ifdef __cplusplus
}
#endif

#endif