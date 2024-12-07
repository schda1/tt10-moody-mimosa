<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

### Pinout


| Pin      | Name       | Function                          |  
| -------- | -------    | --------------------------------  | 
| clk      | clk        | Base clock                        |
| rst_n    | rst_n      | Reset, active low                 |
| ui_in[0] | clk_model  | Base clock for model update       |
| ui_in[1] | stimulus_1 | -       |
| ui_in[2] | stimulus_2 | -       |
| ui_in[3] | stimulus_3 | -       |
| ui_in[4] | stimulus_4 | -       |
| ui_in[5] | stimulus_5 | -       |
| ui_in[6] | stimulus_6 | -       |
| ui_in[7] | stimulus_7 | -       |

| Pin       | Name       | Function                |  
| --------- | -------    | ----------------------- | 
| uo_out[0] | emotion_0  | Happy indicator         |
| uo_out[1] | emotion_1  | Comfortable indicator   |
| uo_out[2] | emotion_2  | Excited indicator       |
| uo_out[3] | emotion_3  | Bored indicator         |
| uo_out[4] | emotion_4  | Tired indicator         |
| uo_out[5] | emotion_5  | Angry indicator         |
| uo_out[6] | emotion_6  | Nervous indicator       |
| uo_out[6] | emotion_7  | Stressed indicator      |

| Pin        | Dir | Name       | Function          |  
| ---------- | --- | -------    | ----------------- | 
| uio_out[0] | 1   | asleep     | Asleep indicator  |
| uio_out[1] | 1   | dead       | Dead indicator    |
| uio_out[2] | 1   | heartbeat  | hearbeat          |
| uio_out[3] | 1   | uart_tx    | UART TX           |
| uio_out[4] | 1   | spi_sck    | SPI SCK           |
| uio_out[5] | 1   | spi_mosi   | SPI MOSI          |
| uio_in[6]  | 0   | spi_miso   | SPI MISO          |
| uio_out[6] | 1   | spi_cs     | SPI CS            |


### Emotional model

Each resource (energy, stress, pleasure) is represented as an N-bit value. The value range is divided into three categories:

- LOW: Values in the lower quarter of the range.
- OK: Values in the middle two quarters of the range.
- HIGH: Values in the upper quarter of the range.

For example, with a 6-bit value (0 to 63), LOW represents 0<=x<16, OK represents 16<=x<48 and HIGH represents 48<=x<63. Emotions are determined using a truth table based on the current levels of energy, stress, and pleasure. The table specifies how combinations of resource levels map to different emotional states.

| Energy   | Stress  | Pleasure  | Emotion            |
| -------- | ------- | --------- | ------------------ |
| LOW      | LOW     | LOW       | Tired              |
| LOW      | LOW     | OK        | Tired              |
| LOW      | LOW     | HIGH      | Tired              |
| LOW      | OK      | LOW       | Tired              |
| LOW      | OK      | OK        | Tired              |
| LOW      | OK      | HIGH      | Tired              |
| LOW      | HIGH    | LOW       | Angry              |
| LOW      | HIGH    | OK        | Stressed           |
| LOW      | HIGH    | HIGH      | Excited            |
| OK       | LOW     | LOW       | Bored              |
| OK       | LOW     | OK        | Comfortable        |
| OK       | LOW     | HIGH      | Happy              |
| OK       | OK      | LOW       | Bored              |
| OK       | OK      | OK        | Comfortable        |
| OK       | OK      | HIGH      | Happy              |
| OK       | HIGH    | LOW       | Angry              |
| OK       | HIGH    | OK        | Stressed           |
| OK       | HIGH    | HIGH      | Excited            |
| HIGH     | LOW     | LOW       | Bored              |
| HIGH     | LOW     | OK        | Excited            |
| HIGH     | LOW     | HIGH      | Excited            |
| HIGH     | OK      | LOW       | Nervous            |
| HIGH     | OK      | OK        | Nervous            |
| HIGH     | OK      | HIGH      | Excited            |
| HIGH     | HIGH    | LOW       | Angry              |
| HIGH     | HIGH    | OK        | Stressed           |
| HIGH     | HIGH    | HIGH      | Stressed           |

The heartbeat depends on the current emotional state. The heartbeat defines how fast the model is clocked. If the heartbeat is high, the model clock is increased and ressources are affected (reduced) faster. In particular, more energy is consumed and the asic gets tired more quickly. The mapping between emotional state and heartbeat (i.e. clock division) is defined according to the following truth table:

| Emotion     |  Sleep  | HeartbClock divider |
| ----------- | ------- | ------------------- |
| Happy       | 0       | 1                   |
| Comfortable | 0       | 1                   |
| Excited     | 0       | 0                   |
| Bored       | 0       | 2                   |
| Tired       | 0       | 2                   |
| Angry       | 0       | 0                   |
| Nervous     | 0       | 0                   |
| Stressed    | 0       | 0                   |
| X           | 1       | 3                   |


## How to test

There will be some information here. 

## External hardware

There will be some information here. 
