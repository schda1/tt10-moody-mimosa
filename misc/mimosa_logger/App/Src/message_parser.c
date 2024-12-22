
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <msg_parser.h>

static void find_start(struct msg_parser* parser);
static void check_for_full_message(struct msg_parser* parser, struct msg* msg);
static void extract_message(struct msg_parser* parser, struct msg* msg, uint8_t start, uint8_t end);

void msg_parser_init(struct msg_parser* parser, UART_HandleTypeDef* huart)
{
    parser->head = 0;
    parser->tail = 0;
    parser->count = 0;
    parser->huart = huart;
}

void msg_parser_add(struct msg_parser* parser, uint8_t* c)
{
    parser->buf[parser->head] = *c;
    parser->head = (parser->head + 1) % MSG_BUFFER_LEN;
    parser->count++;
}

void msg_parser_update(struct msg_parser* parser, struct msg* msg)
{
    find_start(parser);

    check_for_full_message(parser, msg);
}

static void find_start(struct msg_parser* parser)
{
    uint16_t pos = parser->tail;

    if (parser->head == parser->tail)  {
        return;
    }

    if (parser->buf[parser->tail] != ':') {

        while (pos != parser->head) {
            pos = (pos + 1) % MSG_BUFFER_LEN;

            if (parser->buf[pos] == ':') {
                break;
            }
        }

        parser->tail = pos;
    }
}

static void check_for_full_message(struct msg_parser* parser, struct msg* msg)
{
    uint16_t pos = parser->tail;
    uint16_t start = parser->tail;
    uint16_t end = UINT16_MAX;

    msg->type = MSG_NONE;
    msg->value = 0;

    if (parser->head == parser->tail || parser->buf[parser->tail] != ':') {
        return;
    }

    /* Check if full message contained */
    while (true) {
        pos = (pos + 1) % MSG_BUFFER_LEN;

        if (parser->buf[pos] == '\n') {
            end = (pos + 1) % MSG_BUFFER_LEN;
            break;
        }

        if (pos == parser->head) {
            break;
        }
    }

    /* No end found */
    if (end == UINT16_MAX) {
        return;
    }
    extract_message(parser, msg, start, end);

    /* Update buffer */
    parser->tail = end;
}

static void extract_message(struct msg_parser* parser, struct msg* msg, uint8_t start, uint8_t end)
{
    char buf[32] = {0};
    char cmd[32];
    uint16_t pos = start;
    uint8_t cmd_pos = 0;

    while (pos != end) {
        buf[cmd_pos++] = parser->buf[pos];
        pos = (pos + 1) % MSG_BUFFER_LEN;
    }

    if (strchr(buf, ',') != NULL) {
        sscanf(buf, ":%49[^,],%ud\n", cmd, &msg->value);
    } else {
        sscanf(buf, ":%s\n", cmd);
    }

    if (strcmp(cmd, "START") == 0) {
        msg->type = MSG_START;
    } else if (strcmp(cmd, "STOP") == 0) {
        msg->type = MSG_STOP;
    } else if (strcmp(cmd, "PAUSE") == 0) {
        msg->type = MSG_PAUSE;
    } else if (strcmp(cmd, "SET_PERIOD") == 0) {
        msg->type = MSG_SET_PERIOD;
    } else if (strcmp(cmd, "SET_COLD") == 0) {
        msg->type = MSG_SET_COLD;
    } else if (strcmp(cmd, "SET_HOT") == 0) {
        msg->type = MSG_SET_HOT;
    } else if (strcmp(cmd, "SET_DARK") == 0) {
        msg->type = MSG_SET_DARK;
    } else if (strcmp(cmd, "SET_BRIGHT") == 0) {
        msg->type = MSG_SET_BRIGHT;
    } else if (strcmp(cmd, "SET_QUIET") == 0) {
        msg->type = MSG_SET_QUIET;
    } else if (strcmp(cmd, "SET_LOUD") == 0) {
        msg->type = MSG_SET_LOUD;
    }else {
        msg->type = MSG_INVALID;
        msg->value = 0;
    }
}