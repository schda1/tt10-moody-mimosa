#include "main.h"

extern UART_HandleTypeDef hlpuart1;

/*
 * In order to use printf of the newlib library, the _write function 
 * has to be implemented. Implementing the __io_putchar is not enough
 * if the syscalls.c is not added to the project!
 */
int _write(int file, char *data, int len) {
    HAL_UART_Transmit(&hlpuart1, (uint8_t *)data, len, HAL_MAX_DELAY);
    return len;
}