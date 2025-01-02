

#include <stdio.h>
#include <string.h>

#include <App.hpp>
#include <HalWrapper/Spi.hpp>
#include <HalWrapper/Uart.hpp>
#include <HalWrapper/Timer.hpp>
#include <HalWrapper/DigitalOutput.hpp>
#include <HalWrapper/DigitalInput.hpp>
#include <PersistantStorage/FramStorage_Spi.hpp>
#include <PersistantStorage/FlashStorage.hpp>
#include <Parameter/ParameterHandler.hpp>
#include <PwmHandler.hpp>
#include <PinObserver.hpp>
#include <MimosaDriver.hpp>
#include <MessageParser.hpp>
#include <ComparatorDriver.hpp>

#include "stm32g4xx_hal.h"

enum class MsgType : int8_t {NONE = 0, START, STOP, PAUSE, SET_PERIOD, SET_COLD, SET_HOT, 
                             SET_DARK, SET_BRIGHT, SET_QUIET, SET_LOUD, WRITE_FRAM, 
                             READ_FRAM, LOG_ON, LOG_OFF, UPLOAD, PRINT, INVALID};

const Command command_table[] = {
    {"START",      (int8_t)MsgType::START,      MsgData::NONE},
    {"STOP",       (int8_t)MsgType::STOP,       MsgData::NONE},
    {"PAUSE",      (int8_t)MsgType::PAUSE,      MsgData::NONE},
    {"SET_PERIOD", (int8_t)MsgType::SET_PERIOD, MsgData::VALUE},
    {"SET_COLD",   (int8_t)MsgType::SET_COLD,   MsgData::VALUE},
    {"SET_HOT",    (int8_t)MsgType::SET_HOT,    MsgData::VALUE},
    {"SET_DARK",   (int8_t)MsgType::SET_DARK,   MsgData::VALUE},
    {"SET_BRIGHT", (int8_t)MsgType::SET_BRIGHT, MsgData::VALUE},
    {"SET_QUIET",  (int8_t)MsgType::SET_QUIET,  MsgData::VALUE},
    {"SET_LOUD",   (int8_t)MsgType::SET_LOUD,   MsgData::VALUE},
    {"WRITE_FRAM", (int8_t)MsgType::WRITE_FRAM, MsgData::STRING},
    {"READ_FRAM",  (int8_t)MsgType::READ_FRAM,  MsgData::VALUE},
    {"READ_FRAM",  (int8_t)MsgType::READ_FRAM,  MsgData::VALUE},
    {"READ_FRAM",  (int8_t)MsgType::READ_FRAM,  MsgData::VALUE},
    {"LOG_ON",     (int8_t)MsgType::LOG_ON,     MsgData::NONE},
    {"LOG_OFF",    (int8_t)MsgType::LOG_OFF,    MsgData::NONE},
    {"UPLOAD",     (int8_t)MsgType::UPLOAD,     MsgData::NONE},
    {"PRINT",      (int8_t)MsgType::PRINT,      MsgData::NONE},
    {NULL,         (int8_t)MsgType::INVALID,    MsgData::NONE}
};

static void process_message(Msg* msg);
static void input_config_fct(GPIO_TypeDef* port, uint8_t pin);


Spi spi(SPI2);
Uart uart(LPUART1);
Timer pwm_timer(TIM3);
Timer mimosa_timer(TIM2);
DigitalOutput cs(GPIOB, 11);
DigitalOutput led(GPIOA, 5);

FramStorage_Spi fram(&spi);
FlashStorage flash(0x0807F800, 0x800);

MessageParser parser(&uart);
PwmHandler pwm_handler(&pwm_timer);
PinObserver pin_observer(input_config_fct);
ParameterHandler param_handler(&flash);
MimosaDriver mimosa(&mimosa_timer, &led, &led, &pin_observer, &param_handler);
ComparatorDriver cmp_driver(&pwm_handler, &param_handler);

UART_HandleTypeDef* hlpuart1;

void app_run(void)
{
    Msg msg;

    while(true) {
        
        /* Process incoming messages */
        parser.update(&msg);
        if (msg.id != (int8_t)MsgType::NONE) {
            process_message(&msg);
        }

        /* Process Mimosa Clock and log data */
        mimosa.update();
        
        HAL_Delay(10);
    }
}

static void process_message(Msg* msg)
{
    MsgType type = (MsgType)msg->id;

    switch (type) {
        case MsgType::START:
            mimosa.start();
            break;
        case MsgType::STOP:
            mimosa.stop();
            break;
        case MsgType::PAUSE:
            mimosa.pause();
            break;
        case MsgType::SET_PERIOD:
            mimosa.set_period_ms(msg->value);
            break;
        case MsgType::SET_COLD:
            cmp_driver.set_cold_thresh(msg->value);
            break;
        case MsgType::SET_HOT:
            cmp_driver.set_hot_thresh(msg->value);
            break;
        case MsgType::SET_DARK:
            cmp_driver.set_dark_thresh(msg->value);
            break;
        case MsgType::SET_BRIGHT:
            cmp_driver.set_bright_thresh(msg->value);
            break;
        case MsgType::SET_QUIET:
            cmp_driver.set_quiet_thresh(msg->value);
            break;
        case MsgType::SET_LOUD:
            cmp_driver.set_loud_thresh(msg->value);
            break;
        case MsgType::WRITE_FRAM:
            fram.write(msg->value, (uint8_t*)msg->str, strlen(msg->str)+1);
            break;
        case MsgType::READ_FRAM:
            char buffer[64];
            fram.read(msg->value, (uint8_t*)buffer, 24);
            printf("Read FRAM: %s\n", buffer);
            break;
        case MsgType::LOG_ON:
            mimosa.enable_log(true);
            break;
        case MsgType::LOG_OFF:
            mimosa.enable_log(false);
            break;
        case MsgType::UPLOAD:
            flash.erase();
            param_handler.upload();
            break;
        case MsgType::PRINT:
            /* Various print functions */
            break;
        default:
            printf("Invalid message\n");
            break;
    }
}

void app_init(void)
{
    /* Externally define uart used for printf function */
    hlpuart1 = uart.get_handle();

    /* Initialize UART message parser */
    parser.init();
    parser.set_command_table(command_table, sizeof(command_table) / sizeof(Command));
    
    /* Initialize FRAM */
    spi.add_cs(&cs);
    fram.init();

    /* Initialize PwmHandler */
    pwm_timer.set_prescaler(11);
    pwm_timer.set_period(80);
    pwm_handler.attach(&led, 50);
    pwm_handler.init();
    pwm_handler.enable(true);

    /* Initialize pin observer */
    pin_observer.configure(PortType::UI_IN, GPIOB, 0x00FF);
    pin_observer.configure(PortType::UO_OUT, GPIOC, 0x00FF);
    pin_observer.configure(PortType::UIO, GPIOC, 0xFF00);
    pin_observer.configure(PortType::CTRL, GPIOA, 0x0050);
    pin_observer.reset();

    /* Initialize mimosa timer */
    mimosa_timer.set_prescaler(81);
    mimosa_timer.set_period(1000);
    mimosa_timer.init();

    /* Initialize Parameters */
    flash.init();
    param_handler.download();

    /* Initialize Comparator Driver */
    cmp_driver.init();
    cmp_driver.enable(true);
    cmp_driver.print();

    /* Initialize Mimosa */
    mimosa.init();

    param_handler.print();

    fram.write(0x00, (uint8_t*)"Das ist ein neuer Test -", 24);
    fram.write(0x40, (uint8_t*)"Mir ist so langweilig --", 24);
    fram.write(0x80, (uint8_t*)"Hello again ------------", 24);
}


static void input_config_fct(GPIO_TypeDef* port, uint8_t pin)
{
    DigitalInput input(port, pin);
    input.init(DigitalInputMode::INPUT);
}