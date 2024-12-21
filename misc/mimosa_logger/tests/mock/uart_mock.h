#ifndef UART_MOCK_H
#define UART_MOCK_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#define MOCK_BUFFER_LEN (256)

struct mock_buffer {
    uint8_t buf[MOCK_BUFFER_LEN];
    uint16_t head;
    uint16_t tail;
};

uint8_t uart_available(uint8_t* huart);
void uart_receive(uint8_t* huart, uint8_t* c);

/**
 * @brief Initialize the mock uart
 */
void uart_mock_init(void);

/**
 * @brief Emulate sending a message 
 *
 * @param msg Buffer containing the message to be sent
 * @param len Length of the message
 */
void uart_mock_add_message(const char* msg, uint16_t len);

/**
 * @brief Clear the internal mock uart buffer
 */
void uart_mock_clear(void);

/**
 * @brief Get read access to the internal buffer
 *
 * @return Access to the internal mock buffer
 */
const struct mock_buffer* uart_mock_get_buf(void);

#ifdef __cplusplus
}
#endif

#endif