#include <stdint.h>
#include <string.h>
#include <uart_mock.h>

static uart_rx_callback_t rx_callback;

void uart_mock_init(uart_rx_callback_t cb)
{
    rx_callback = cb;
}
 
void uart_mock_add_message(const char* msg, uint16_t len)
{   
    for (uint16_t i = 0; i < len; i++) {
        /* Emulate firing interrupt and corresponding ISR */
        rx_callback(msg[i]);
    }
}
