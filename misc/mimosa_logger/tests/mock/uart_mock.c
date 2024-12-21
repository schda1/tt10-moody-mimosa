#include <stdint.h>
#include <string.h>
#include <uart_mock.h>

static struct mock_buffer uart;

uint8_t uart_available(uint8_t* huart)
{
    (void)huart;
    return uart.head != uart.tail;
}

void uart_receive(uint8_t* huart, uint8_t* c)
{
    *c = uart.buf[uart.tail];

    if (uart_available(huart)) {
        uart.tail = (uart.tail + 1) % MOCK_BUFFER_LEN;
    }
}

void uart_mock_init(void)
{
    uart_mock_clear();
}
 
void uart_mock_add_message(const char* msg, uint16_t len)
{   
    uint16_t pos = uart.head;

    for (uint16_t i = 0; i < len; i++) {
        uart.buf[pos] = msg[i];
        pos = (pos + 1) % MOCK_BUFFER_LEN;
    }

    uart.head = pos;
}

void uart_mock_clear(void)
{
    memset(&uart, 0, sizeof(struct mock_buffer));
}

const struct mock_buffer* uart_mock_get_buf(void)
{
    return (const struct mock_buffer*) uart.buf;
}