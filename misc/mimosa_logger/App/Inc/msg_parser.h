#ifndef MESSAGE_PARSER_H
#define MESSAGE_PARSER_H

#include <stdint.h>

#ifndef UTEST
#include "main.h"
#else
typedef uint8_t UART_HandleTypeDef;
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define MSG_BUFFER_LEN (256)

struct msg_parser {
    uint8_t buf[MSG_BUFFER_LEN];
    uint8_t head;
    uint8_t tail;
    uint32_t count;

    UART_HandleTypeDef* huart;
};

enum msg_type {
    MSG_NONE = 0, 
    MSG_START, 
    MSG_STOP,
    MSG_PAUSE, 
    MSG_SET_PERIOD, 
    MSG_INVALID
};

struct msg {
    enum msg_type type;
    uint32_t value;
};

/**
 * @brief Initialize the message parser and provide the uart handle
 * 
 * @param msg_parser Message parser data structure
 * @param huart Handle to the uart for incoming data
 */
void msg_parser_init(struct msg_parser* msg_parser, UART_HandleTypeDef* huart);

/**
 * @brief Update the message parser and return information about parsed message, if any
 *
 * @param msg_parser Message parser data structure
 * @param msg Current message. can be none
 */
void msg_parser_update(struct msg_parser* msg_parser, struct msg* msg);


#ifdef __cplusplus
}
#endif

#endif /* MESSAGE_PARSER_H */