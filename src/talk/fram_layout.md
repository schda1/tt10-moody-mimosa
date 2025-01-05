# FRAM Layout

Depending on the emotional state and the development stage, phrases from different memory regions of the FRAM are read and transmitted via UART. 

| Bits  | Name       | Comment                                                                  |
| ----  | ------     | -------                                                                  |
| 0-4   | Phrase     | Each phrase is 32 bytes long, so that it would fit on a 2x16 LCD screen. |
| 5     | Variant    | There are 2 variants                                                     |
| 6-8   | Emotion    | There are 8 emotions                                                     |
| 9-10  | Special     | Special treatment (0: General, 1: Eating, 2: Playing, 3: Crying)         |
| 11-12 | Dev. stage | There are 4 development stages                                           |

In total, there are thus 256 possible phrases. They are stored in a textfile (different 
languages or variants possible) and initially loaded via on-board microcontroller onto the 
FRAM. The relevant UART command is: 

```
WRITE_FRAM;[address];[text]\n
```

Example: You want to set a text for variant-0, emotion-happy (0), while eating (1) and in early development stage (0), i.e. address `13'b0_0010_0000_0000 = 0x200 = 512`: 

```
WRITE_FRAM;512;Mjam mjam banana               \n
```

`Detail`: There is a python script that loads an entire file onto the FRAM.