GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

GW1NS & GW1NSR & GW1NSE & GW1NSER
  Series of FPGA Products Schematic Manual

Introduction
                      You should follow some rules for circuit board design when using
                 GW1NS & GW1NSR & GW1NSE & GW1NSER series of FPGA products.
                 This manual describes the characteristics of GW1NS & GW1NSR &
                 GW1NSE & GW1NSER series of FPGA products. The main contents of
                 this manual are as follows:
                      Power Supply
                      JTAG
                      MSPI
                      Clock Pin
                      Difference Pin
                      READY, RECONFIG_N, DONE
                      MODE
                      JTAGSEL_N
                      FASTRD_N
                      Configure Dual-purpose Pin
                      External Crystal Oscillator Circuit Reference
                      Bank Voltage
                      Configuration Modes Supported by Each Device
                      MIPI
                      ADC
                      USB
                      Pinout
Power Supply
                 Overview
                      GW1NS & GW1NSR & GW1NSE & GW1NSER series of FPGA
                 products support LX, UX and LV versions. The voltage includes core
                 voltage (VCC), auxiliary voltage (VCCX) and bank voltage (VCCO).
GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                      There is no linear voltage regulator in devices of LX version, and VCCX
                 needs to be set to 1.8V. The I/O Bank voltage VCCO can be set to 1.2 V, 1.5
                 V, or 1.8 V as required.
                      There is linear voltage regulator in devices of UX, and VCCX can be set
                 to 2.5 V or 3.3V. The I/O Bank voltage VCCO can be set to 1.2 V, 1.5 V, 1.8 V,
                 2.5 V, or 3.3 V as required. It should be noted that VCCX needs to be greater
                 than or equal to VCCO.
                      There is no linear voltage regulator in devices of LV version, and VCCX
                 can be set to 1.8V, 2.5V or 3.3V. The I/O Bank voltage VCCO can be set to
                 1.2 V, 1.5 V, 1.8 V, 2.5 V, or 3.3 V as required.
                 Note!
                 LX and LX versions have the same functions, and the pins are compatible.
                      Vcc of these three versions is 1.2V. VCCX is the auxiliary power, which
                 is used to supply some circuits in the chip, supporting 1.8V, 2.5V and 3.3V.
                 After the chip powers on, VCCX can be turned off. VCCO Bank can be set to
                 1.2V, 1.5V, 1.8V, 2.5V, or 3.3V as required.
                 Power Index
                     The device can only operate when the power voltage is in the
                 recommended range. Table 1 lists the recommended range.
                 Table 1 Recommended Range
                 Name        Description                                       Min.         Max.
                 VCC         Core voltage                                      1.14V        1.26V
                             I/O Bank voltage for LX version                   1.14V        1.89V
                             I/O Bank voltage for UX version
                 VCCOx       VCCX needs to be greater than or equal to VCCOx   1.14V        3.465V
                             for UX version.
                             I/O Bank voltage for LV version                   1.14V        3.465V
                             Auxiliary voltage for LX version                  1.71V        1.89V
                             Auxiliary voltage for UX version
                 VCCX        VCCX needs to be greater than or equal to VCCOx   2.375V       3.465V
                             for UX version.
                             Auxiliary voltage for LV version                  1.71V        3.465V

                 Power Consumption
                    For specific density, packages, and resource utilization, you can use
                 GPA tool to evaluate and analyze the power consumption.
                 Power Rising Slope
                        The reference for power-on time: 0.01mV/μs ~ 10mV/μs.
                 Power Filter
                     Each FPGA power input pin is connected to the ground with a 0.1uF
                 ceramic capacitor.
                     Noise processing should be noted at the input end of the V CC, and the
GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                 specific is as follows:
                 Figure 1 Noise Processing
                     V1P2
                                  FB                  Vcc
                                              C

                                              4.7uF

                     FB is a magnetic bead, and the reference model is MH2029-221Y. The
                 ceramic capacitance is 4.7uF, and It offers an accuracy of more than ±20%.
JTAG
                 Overview
                     JTAG interface is used for downloading the bitstream to SRAM,
                 on-chip flash or off-chip flash of FPGA.
                 Signal Description
                 Table 2 Signal Description
                 Name                   I/O                       Description
                 TCK                    I                         JTAG serial clock input
                                        I, internal weak
                 TMS                                              JTAG serial mode input
                                        pull-up
                                        I, internal weak
                 TDI                                              JTAG serial data input
                                        pull-up
                 TDO                    O                         JTAG serial data output

                 JTAG Circuit Reference
                 Figure 2 JTAG Circuit Reference

                       R
                                                  J
                  4.7K      TCK   R           1
                                       22                    2
                            TDI   R    22     3              4       VCC3P3
                           TDO    R    22     5              6
                                                      JTAG
                                              7              8
                           TMS    R    22     9              10

                 Note!
                      The resistance accuracy is not less than ±5%;
                      The power of JTAG 6th pin can be set to VCC1P2, VCC1P5, VCC1P8, VCC2P5 as
                       required.

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

MSPI
                 Overview
                      FPGA as a master device, MSPI reads the data automatically from the
                 off-chip flash then transmits it to the FPGA SRAM.
                 Signal Description
                 Table 3 Signal Description
                 Name            I/O                      Description
                 MCLK            O                        Clock output in MSPI mode
                 MCS_N           O                        MCS_N in MSPI mode, low-active
                 MI              I                        Data input in MSPI mode
                 MO              O                        Data output in MSPI mode

                 MSPI Circuit Reference
                 Figure 3 MSPI Circuit Reference

                                                                             VCC3P3

                                                   U                          R       C
                                MCS_N          1                    8                 100nF
                       VCC3P3                    CS          VCC
                                   MI                                        4.7K
                                               2 DO                 7
                                                            HOLD
                                   R    4.7K   3                    6               MCLK
                                                   WP        CLK
                                               4                    5               MO
                                                   GND         DI
                                                                        R

                                                       SPI FLASH
                                                                        1K

                 Note!
                      MCLK signal requires 1K pull-down resistor.
                      The resistance accuracy is not less than ± 5%.

Clock Pins
                 Overview
                        The clock pins include GCLK global clock pins and PLL clock pins.
                      GCLK: GCLK in FPGA products distributes in L and R quadrants. Each
                       quadrant provides eight GCLK nets. The clock source of each GCLK
                       can be dedicated pin or CRU, and the dedicated pin can provide better
                       performance.
                      PLL: Frequency (multiplication and division), phase, and duty cycle can
                       be adjusted by configuring the parameters.

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                 Signal Description
                 Table 4 Signal Description
                 Name                    I/O            Description
                                                        Pins in global clock input, T(True), [x]: global clock
                 GCLKT_[x]               I/O
                                                        No.
                                                        Pins for Global clock input, C(Comp), [x]: global
                 GCLKC_[x]               I/O
                                                        clock No.
                 LPLL_T_fb/RPLL_T_fb     I              Left/Right PLL feedback input pins, T(True)
                 LPLL_C_fb/RPLL_C_fb     I              Left/Right PLL feedback input pins, C(Comp)
                 LPLL_T_in/RPLL_T_in     I              Left/Right PLL clock input pin, T(True)
                 LPLL_C_in/RPLL_C_in     I              Left/Right PLL clock input pin, C(Comp)

                 Clock Input Selection
                     If the external clock as PLL clock, it is recommended to input from
                 PLL_T.
                     GCLK is the global clock and is connected to all resources in the
                 device. It is recommended to input from GCLK_T.
Differential Pins
                 Overview
                      Differential transmission is a kind of signal transmission, which is
                 different from the traditional signal line and ground line. Differential
                 transmission signals are transmitted on these two lines. These two signals
                 are with same amplitudeAmplitude, phase and opposite polarity.
                 Differential Type
                 Figure 5 Differential Type
                 I/O output standard     Single/Differ       Bank VCCO (V)     Output Driver Strength (mA)

                 LVPECL33E               Differential        3.3               16

                 MVLDS25E                Differential        2.5               16

                 BLVDS25E                Differential        2.5               16

                 RSDS25E                 Differential        2.5               8

                 LVDS25E                 Differential        2.5               8

                 LVDS25                  Differential        2.5/3.3           3.5/2.5/2/6

                 RSDS                    Differential        2.5/3.3           2

                 MINILVDS                Differential        2.5/3.3           2

                 PPLVDS                  Differential        2.5/3.3           3.5

                 SSTL15D                 Differential        1.5               8

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                 I/O output standard          Single/Differ     Bank VCCO (V)    Output Driver Strength (mA)

                 SSTL25D_I                    Differential      2.5              8

                 SSTL25D_II                   Differential      2.5              8

                 SSTL33D_I                    Differential      3.3              8

                 SSTL33D_II                   Differential      3.3              8

                 SSTL18D_I                    Differential      1.8              8

                 SSTL18D_II                   Differential      1.8              8

                 HSTL18D_I                    Differential      1.8              8

                 HSTL18D_II                   Differential      1.8              8

                 HSTL15D_I                    Differential      1.5              8

                      Note!
                      See pinout manuals for specific differential pin positions.

READY, RECONFIG_N, DONE
                 Overview
                      RECONFIG_N, equivalent to the reset function of FPGA programming
                 configuration, FPGA cannot perform any configuration operation when
                 RECONFIG_N is pulled down.
                      As a configuration pin, a low level with a pulse width of not less than
                 25ns is required for GowinCONFIG configuration mode to enable the
                 device to reload the bitstream. You can control the pin by writing logic to
                 trigger the device to reconfigure as required.
                      You can configure FPGA only when the READY signal is high. The
                 device should be restored by power on or triggering RECONFIG_N when
                 the READY signal is low.
                      As an output configuration pin, it can indicate whether the FPGA can
                 be configured currently. If the device is ready, READY signal is high. If the
                 device fails to configure, the READY signal changes to low. As an input
                 configuration pin, you can delay the configuration by its own logic or pulling
                 down the READY signal.
                      DONE signal indicates that the FPGA is configured successfully. The
                 signal is high after successful configuration.
                      As an output configuration pin, it can indicate whether FPGA
                 configuration is successful. If configured successfully, DONE is high, and
                 the device enters into an operating state. If the device failed to configure,
                 the DONE signal remains low. As the input, you can delay the entry into
                 user mode by manually pulling down the DONE signal via the logic.
                      When RECONFIG_N or READY signals are low, DONE signal is also
                 low. When configuring SRAM using JTAG circuit, it does not need to take
                 DONE signal into account.

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                 Signal Description
                 Table 6 Signal Description
                Name                I/O                     Description
                                    I, internal      weak   Low level pulse: start new GowinCONFIG
                RECONFIG_N
                                    pull-up                 configuration
                                                            High-level pulse: The device        can     be
                                                            programmed and configured;
                READY               I/O
                                                            Low-level pulse: The device cannot be
                                                            programmed and configured,
                                                            High-level pulse: Successfully programmed
                                                            and configured;
                DONE                I/O
                                                            Low-level     pulse:   Programming         and
                                                            configuration uncompleted or failed.

                 READY, RECONFIG_N, DONE Reference Circuit
                 Figure 4 READY, RECONFIG_N, DONE Reference Circuit
                                     VCC3P3

                                    R     R   R

                         READY      4.7K 4.7K 4.7K
                     RECONFIG_N
                          DONE

                                              D

                 Note!
                      The pull-up power supply is the bank voltage value VCCO0 of the corresponding pin;
                      The resistance accuracy is not less than ± 5%;

MODE
                 Overview
                      MODE includes MODE0, MODE1, MODE2, and GowinCONFIG.
                 When FPGA powers on or a low pulse triggers RECONFIG_N, the device
                 enters the corresponding GowinCONFIG state according to the MODE
                 value. As the number of pins for each package is different, some MODE
                 pins are not all packaged, and the unpacked MODE pins are grounded
                 inside. Please refer to the corresponding pinout manual for further details.

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                 Signal Description
                 Table 7 Signal Description
                 Name         I/O                   Description
                              I, internal weak
                 MODE2                              GowinCONFIG mode selection pin.
                              pull-up
                              I, internal weak
                 MODE1                              GowinCONFIG modes selection pin.
                              pull-up
                              I, internal weak
                 MODE0                              GowinCONFIG mode selection pin.
                              pull-up

                 Mode Selection
                 Table 8 Mode Selection
                 Configuration Mode           MODE[2:0]     Description
                                                            External Host configure FPGA products of
                 JTAG                         XXX
                                                            LittleBee® Family via JTAG interface.
                                    AUTO                    FPGA reads data from embedded Flash
                                              000
                                    BOOT                    for configuration
                                                            External Host configure FPGA products of
                                    SSPI      001
                                                            LittleBee® Family via SPI interface.
                                                            FPGA as Master, FPGA reads data from
                                    MSPI      010           external Flash (or other devices) via the
                                                            SPI interface for configuration..
                 GowinCONFIG
                                                            FPGA reads data from external Flash first
                                    DUAL
                                              110           and if the external Flash fails, it reads from
                                    BOOT
                                                            the internal Flash.
                                                            External Host configure FPGA products of
                                    SERIAL    101
                                                            LittleBee® Family via DIN interface.
                                                            External Host configure FPGA products of
                                    CPU       111
                                                            LittleBee® Family via DBUS interface.

JTAGSEL_N
                 Overview
                      JTAGSEL_N is JTAG mode selection signal. If the JTAG pin is set to
                 GPIO in Gowin software, the JTAG pin changes to GPIO after the device is
                 powered on to configure successfully. If JTAG configuration fails, you can
                 recover by pulling down JTAGSEL_N. If you do not set JTAG multiplexing,
                 the JTAG configuration function is always available.
                 Signal Description
                 Table 9 Signal Description
                 Pin Name             I/O                 Description
                                      I, internal weak    Change JTAG pin from GPIO to
                 JTAGSEL_N
                                      pull-up             configuration pin, active-low
                 Note!

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                 The JTAGSEL_N pin and four JTAG pins (TCK, TMS, TDI, and TDO) configured as GPIO
                 are exclusive. JTAG pins can only be used as configuration pin if JTAGSEL_N is set to
                 GPIO. JTAGSEL_N can only be used as a configuration pin if JTAG pins are set to GPIOs.

FASTRD_N
                 Overview
                       MSPI configuration mode reads the SPI Flash speed selection signal.
                 When FASTRD_N is high, it is normal read mode. When FASTRD_N is low,
                 it is high speed read mode. Different manufacturers have different
                 high-speed read operation instructions, please refer to the corresponding
                 Flash datasheet.
                 Signal Description
                 Table 10 Signal Description
                 Pin Name              I/O          Description
                                                        As a configuration pin, internal weak pull-up,
                                                         READY signal rising edge samples MSPI
                 FASTRD_N              I/O               configuration speed mode;
                                                        As a GPIO, it can be used as input or output.
                 Note!
                      High level: Normal Flash mode, clock frequency should not be higher than 30MHz;
                      Low level: High speed Flash mode, clock frequency should be > 30MHz and <
                       80MHz

Configure Dual-purpose Pin
                 Overview
                     Dual-purpose pin configuration refers to performing configuration
                 function at the moment of power-on. After downloading bitstream files, it is
                 used as general I/O.
                       The steps are as follows:
                 1. Open the project in Gowin software;
                 2. Select "Project > Configuration > Dual Purpose Pin" from the menu, as
                    shown in Figure 5;
                 3. Check the corresponding options.

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                 Figure 5 Configure Dual-purpose Pin

                 Dual- purpose Pin
                      SSPI: As a GPIO, SSPI can be used as input or output;
                      MSPI: As a GPIO, MSPI can be used as input or output;
                      RECONFIG_N GPIO can only be used as an output. Set the initial
                       value of RECONFIG_N as high when multiplexing it.
                      READY: As a GPIO, READY can be used as input or output. As an
                       input GPIO, the initial value of READY should be 1. Otherwise, the
                       FPGA will fail to configure;
                      As a GPIO, DONE can be used as an input or output. If DONE is used
                       as an input GPIO, the initial value of DONE should be 1. Otherwise, the
                       FPGA will fail to enter the user mode after configuring;
                      As a GPIO, JTAG can be used as an input or output;
                      As a GPIO, JTAGSEL_N can be used as an input or output.
                      As a GPIO, JTAG can be used as an input or output. You multiplex
                       MODE pin, the correct value is needed to provided during configuration
                       (power-on or low-level pulse triggers RECONFIG_N). Up to three pins
                       can be multiplexed in MODE. Unpackaged pins are grounded internally.
                       Please refer to pinout manuasl for details. For the MODE value
                       corresponding to different configuration modes, please refer to the
                       corresponding device manual.
                       Note!
                       If the number of I/O ports is sufficient, use non-multiplexed pins first.

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

FPGA External Crystal Oscillator Circuit Reference
                 Figure 6 FPGA External Crystal Oscillator Circuit
                                       VCC3P3

                                               FB

                                                C    10nF

                        1              4
                            IN     VCC

                        2                  R        22 CLK_G
                            GND    OUT 3

                                 OSC

                      FB is a magnetic bead, and MH2029-221Y is the reference model. The
                 resistance accuracy is not less than ±5% , and capacitance accuracy is not
                 less than ±20%.
Bank Voltage
                      For the Bank power supply requirements of the devices, please refer
                 to the Power section of the following documents.
                      UG825, GW1NS-2C Pinout
                      UG822, GW1NS-2 Pinout
                      UG824, GW1NS-4 & 4C Pinout
                      UG862, GW1NSR-2 & 2C Pinout
                      UG864, GW1NSR-4 Pinout
                      UG865, GW1NSR-4C Pinout
                      UG872, GW1NSE-2C Pinout
                      UG883, GW1NSER-4C Pinout
Configuration Modes Supported by Each Device
                 GW1NS-2
                 Table 11 GW1NS -2 Configuration Modes
                                               AUTO            DUAL
                 Modes            JTAG                                MSPI   SSPI   SERIAL    CPU
                                               BOOT            BOOT
                 QN32             √            √               -      -      √      -         -
                 QN32U            √            √               -      -      -      -         -
                 CS36             √            √               -      -      -      -         -
                 CS36U            √            √               -      -      -      -         -
                 QN48             √            √               -      -      -      -         -
                 LQ144            √            √               √      -      √      √         √

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                 GW1NS-2C
                 Table 12 GW1NS -2 C Configuration Modes
                                       AUTO       DUAL
                 Modes     JTAG                          MSPI        SSPI   SERIAL     CPU
                                       BOOT       BOOT
                 QN32      √           √          -      -           √      -          -
                 QN32U     √           √          -      -           -      -          -
                 CS36      √           √          -      -           -      -          -
                 QN48      √           √          -      -           -      -          -
                 LQ144     √           √          √      -           √      √          √

                 GW1NS-4/4C
                 Table 13 GW1NS-4 / 4C Configuration Modes
                 Configuration Modes    JTAG             AUTO BOOT              MSPI
                 CS49                   √                √                      -
                 QN48                   √                √                      √
                 MG64                   √                √                      -

                 GW1NSR-2/2C
                 Table 14 GW1NSR-2 / 2 C Configuration Modes
                 Configuration Modes           JTAG              AUTO BOOT
                 QN48                          √                 √

                 GW1NSE-2C
                 Table 15 GW1NSE -2 C Configuration Modes
                 Configuration Modes           JTAG              AUTO BOOT
                 QN48                          √                 √
                 LQ144                         √                 √

                 GW1NSER-4C
                 Table 16 GW1NSER -4 C Configuration Modes
                 Configuration Modes           JTAG              AUTO BOOT
                 QN48G                         √                 √
                 QN48P                         √                 √

                 GW1NSR-4C
                 Table 17 GW1NSR -4 C Configuration Modes
                 Configuration Modes           JTAG              AUTO BOOT
                 MG64P                         √                 √

MIPI
                    GW1NS series of FPGA products support embedded MIPI interface
                 modules. BANK0 of GW1NS-2 is MIPI input port and BANK2 is MIPI output
GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

                 port. BANK0/BANK1 of GW1NS-4 is MIPI input and BANK2 supports MIPI
                 output.
                 Note!
                      For GW1NS-2C/2 devices of LX or UX version, VCCO0 is set to 1.2V when BANK0 is
                       used as MIPI input and VCCO2 is set to 1.2V when BANK2 is used as MIPI output. And
                       the MIPI speed of LX version is only 60% of that of UX version.
                      When BANK0/BANK1 of GW1NS-4C/4 is used as MIPI input, VCCO0/VCCO1 need to be
                       set to 1.2V, and when BANK2 is used as MIPI output, VCCO2 needs to be set to 1.2V;
                       When VCCX is set to 1.8 V, the speed of MIPI can only reach 60% of the speed of MIPI
                       when VCCX is set to 2.5V/3.3V.

ADC
                      GW1NS-2C/2 series of FPGA products integrate an eight-channel
                 single-ended 12 bits SAR ADC. It is a medium-speed ADC with low-power,
                 low-leakage current and high-speed.
                 Dynamic Performance
                      Slew Rate: Max. 1MHz
                      Dynamic range: >81 dB SFDR，>62 db SINAD
                      Linear performance: INL<1 LSB, DNL<0.5 LSB, no missing codes
                 ADC Reference Voltage
                      The reference voltage can be enabled or disabled by configuring
                       parameters.
                       VREF_EN=1, enabled;
                       VREF_EN=0, disabled, and Vref is provided by Vccx.
                      When Vref is enabled, there are two ways to provide Vref: internal and
                       external.
                       The internal is provided by Vccx and supports seven reference
                       voltages by configuring VREF_SEL. The external is provided by VREF.
                 Note!
                      It is recommended to add 10uF capacitance for ADC signal pin.
                      It is recommended to use external reference voltage

USB
                      GW1NS-2C/2 is embedded with USB2.0 PHY with 480Mbps, USB1.1
                 1.5/12Mbps compatible, plug-and-play, hot-plug.
                 Note!
                      The VBUS pin of FPGA chip needs to be connected to the VBUS of USB connector.
                      The ID pin of FPGA chip needs to be connected to the ID of USB connector.
                      The XIN and XOUT pins of FPGA chip need to be connected to the external 12Mhz
                       crystal.
                      The REXT pin of FPGA chip must be connected to the pull-down 12.7K with
                       resistance of 1% accuracy.

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

Pinout
                     Before the design of the circuit, you should take the FPGA pinout into
                 consideration, and a reasonable choice should be made for IO LOGIC,
                 global clock resource, PLL and differential signals, etc.
                 Note!
                 During the configuration, all I/O (except TCK) of the device is weak pull-up, and I/O status
                 after configuration is controlled by user programs and constraints.

GW1NS & GW1NSR & GW1NSE & GW1NSER Series of FPGA
Products Schematic Manual
UG292-1.0E

Support and Feedback
                     Gowin Semiconductor provides customers with comprehensive
                 technical support. If you have any questions, comments, or suggestions,
                 please feel free to contact us directly by the following ways.
                       Website: www.gowinsemi.com
                       E-mail: support@gowinsemi.com
Revision History
Date             Version      Description
07/28/2020       1.0          Initial version published.

Copyright© 2020 Guangdong Gowin Semiconductor Corporation. All Rights Reserved.
No part of this document may be reproduced or transmitted in any form or by any denotes,
electronic, mechanical, photocopying, recording or otherwise, without the prior written
consent of GOWINSEMI.
Disclaimer
GOWINSEMI®, LittleBee®, Arora, and the GOWINSEMI logos are trademarks of
GOWINSEMI and are registered in China, the U.S. Patent and Trademark Office, and other
countries. All other words and logos identified as trademarks or service marks are the
property of their respective holders, as described at www.gowinsemi.com. GOWINSEMI
assumes no liability and provides no warranty (either expressed or implied) and is not
responsible for any damage incurred to your hardware, software, data, or property resulting
from usage of the materials or intellectual property except as outlined in the GOWINSEMI
Terms and Conditions of Sale. All information in this document should be treated as
preliminary. GOWINSEMI may make changes to this document at any time without prior
notice. Anyone relying on this documentation should contact GOWINSEMI for the current
documentation and errata.
