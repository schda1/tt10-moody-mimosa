#include <CppUTest/TestHarness.h>

#include <msg_parser.h>
#include <uart_mock.h>
#include <stdio.h>

static struct msg_parser parser;
static struct msg msg;

UART_HandleTypeDef huart;

TEST_GROUP(MessageParser)
{
    void setup() {
        memset(&parser, 0, sizeof(struct msg_parser));
    }

    void teardown() {
        /* Nothing to be done */
    }
};

TEST(MessageParser, test_init)
{
    msg_parser_init(&parser, &huart);

    LONGS_EQUAL(parser.head, 0);
    LONGS_EQUAL(parser.tail, 0);
    LONGS_EQUAL(parser.count, 0);
    CHECK_FALSE(parser.huart == NULL);
}

TEST(MessageParser, test_in_two_steps)
{
    msg_parser_init(&parser, &huart);
    uart_mock_init();
    uart_mock_add_message(":STA", 4);
    msg_parser_update(&parser, &msg);

    LONGS_EQUAL(msg.type, MSG_NONE);
    LONGS_EQUAL(msg.value, 0);

    uart_mock_add_message("RT\n", 3);
    msg_parser_update(&parser, &msg);

    LONGS_EQUAL(msg.type, MSG_START);
    LONGS_EQUAL(msg.value, 0);
}

TEST(MessageParser, test_start_several_commands)
{
    msg_parser_init(&parser, &huart);
    uart_mock_init();
    uart_mock_add_message(":START\n", 7);

    msg_parser_update(&parser, &msg);
    LONGS_EQUAL(msg.type, MSG_START);
    LONGS_EQUAL(msg.value, 0);

    msg_parser_update(&parser, &msg);
    LONGS_EQUAL(msg.type, MSG_NONE);
    LONGS_EQUAL(msg.value, 0);

    uart_mock_add_message(":STOP\n", 6);

    msg_parser_update(&parser, &msg);
    LONGS_EQUAL(msg.type, MSG_STOP);
    LONGS_EQUAL(msg.value, 0);
}

TEST(MessageParser, test_broken_cmd)
{
    msg_parser_init(&parser, &huart);
    uart_mock_init();
    uart_mock_add_message("TART\n", 5);

    msg_parser_update(&parser, &msg);
    LONGS_EQUAL(msg.type, MSG_NONE);
    LONGS_EQUAL(msg.value, 0);

    /* Skipped it */
    LONGS_EQUAL(parser.head, 5);
    LONGS_EQUAL(parser.tail, 5);

    uart_mock_add_message(":START\n", 7);

    msg_parser_update(&parser, &msg);
    LONGS_EQUAL(msg.type, MSG_START);
    LONGS_EQUAL(msg.value, 0);
}

TEST(MessageParser, test_start_cmd)
{
    msg_parser_init(&parser, &huart);
    uart_mock_init();
    uart_mock_add_message(":START\n", 7);
    msg_parser_update(&parser, &msg);

    LONGS_EQUAL(msg.type, MSG_START);
    LONGS_EQUAL(msg.value, 0);
}

TEST(MessageParser, test_stop_cmd)
{
    msg_parser_init(&parser, &huart);
    uart_mock_init();
    uart_mock_add_message(":STOP\n", 6);
    msg_parser_update(&parser, &msg);

    LONGS_EQUAL(msg.type, MSG_STOP);
    LONGS_EQUAL(msg.value, 0);
}

TEST(MessageParser, test_pause_cmd)
{
    msg_parser_init(&parser, &huart);
    uart_mock_init();
    uart_mock_add_message(":PAUSE\n", 7);
    msg_parser_update(&parser, &msg);

    LONGS_EQUAL(msg.type, MSG_PAUSE);
    LONGS_EQUAL(msg.value, 0);
}

TEST(MessageParser, test_set_period)
{
    msg_parser_init(&parser, &huart);
    uart_mock_init();
    uart_mock_add_message(":SET_PERIOD,1000\n", 17);
    msg_parser_update(&parser, &msg);

    LONGS_EQUAL(msg.type, MSG_SET_PERIOD);
    LONGS_EQUAL(msg.value, 1000);
}

TEST(MessageParser, test_invalid_command)
{
    msg_parser_init(&parser, &huart);
    uart_mock_init();

    /* Invalid command */
    uart_mock_add_message(":REWIND\n", 8);
    msg_parser_update(&parser, &msg);

    LONGS_EQUAL(msg.type, MSG_INVALID);
    LONGS_EQUAL(msg.value, 0);

    /* Valid command */
    uart_mock_add_message(":PAUSE\n", 7);
    msg_parser_update(&parser, &msg);

    LONGS_EQUAL(msg.type, MSG_PAUSE);
    LONGS_EQUAL(msg.value, 0);
}