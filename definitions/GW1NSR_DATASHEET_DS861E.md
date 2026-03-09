Datasheet

Copyright © 2025 Guangdong Gowin Semiconductor Corporation. All Rights
Reserved.

          , Gowin, LittleBee, and GOWINSEMI are trademarks of Guangdong Gowin
Semiconductor Corporation and are registered in China, the U.S. Patent and Trademark
Office, and other countries. All other words and logos identified as trademarks or service
marks are the property of their respective holders. No part of this document may be
reproduced or transmitted in any form or by any means, electronic, mechanical,
photocopying, recording or otherwise, without the prior written consent of GOWINSEMI.
Disclaimer
GOWINSEMI assumes no liability and provides no warranty (either expressed or implied)
and is not responsible for any damage incurred to your hardware, software, data, or
property resulting from usage of the materials or intellectual property except as outlined in
the GOWINSEMI Terms and Conditions of Sale. GOWINSEMI may make changes to this
document at any time without prior notice. Anyone relying on this documentation should
contact GOWINSEMI for the current documentation and errata.
Revision History
Date               Version   Description
11/15/2018         1.0E      Initial release.
                                  Recommended operating conditions updated.
01/03/2019         1.1E
                                  Description of PSRAM reference manual updated.
03/12/2019         1.2E      Operating temperature changed to Junction temperature.
11/13/2019         1.3E      GW1NSR-4 and GW1NSR-4C added.
                              Ordering information improved.
02/20/2020         1.4E       DC Characteristics updated.
                              Chapter structure of AC/DC Characteristic improved.
                              Package Information updated.
04/16/2020         1.4.1E
                              CFU structure view updated.
                             “QN48” package name of GW1NSR-2C/GW1NSR-2 corrected as
06/28/2020         1.4.2E
                             “QN48P”.
11/27/2020         1.4.3E    Maximum operating frequency of ARM Cortex-M3 updated.
07/12/2021         1.4.4E    Description of Cortex-M3 improved.
11/16/2021         1.4.5E    I/O standards and ordering information updated.
                              Recommended I/O operating conditions updated.
                              The maximum value of the differential input threshold VTHD
07/21/2022         1.4.6E
                                  updated.
                              Note about USB 2.0 PHY added.
                              Note about DC current limit added.
                              Architecture overviews of GW1NSR series of FPGA products
10/20/2022         1.5E
                                  updated.
                              GW1NSR-2 and GW1NSR-2C removed.
                              “Table 2-1 Output I/O Standards and Configuration Options
                              “Table 3-8 DC Electrical Characteristics over Recommended
                                  Operating Conditions” updated.
                              Section 3.7.4 Byte-enable removed.
                              Description of configuration Flash added.
                              “Table 3-1 Absolute Max. Ratings” updated.
                              Information on Slew Rate removed.
03/30/2023         1.6E
                              “Table 3-24 GW1NSR-4 User Flash Parameters” updated.
                              Description added to “2.8User Flash (GW1NSR-4)”.
                              Description of true LVDS design modified.
                              Note about the default state of GPIOs modified.
                              “Table 3-3 Power Supply Ramp Rates” updated.
                              “Table 3-13 CLU Timing Parameters” updated.
                              The I/O logic output diagram and the I/O logic input diagram
                                  combined into “Figure 2-7 I/O Logic Input and Output”.
                              “Table 3-9 Static Current” updated.
05/08/2023         1.6.1E
                              “2.7.2BSRAM Configuration Modes” added.
05/25/2023         1.6.2E    Information on User Flash of GW1NSR-4C removed.
                              Editorial updates.
                              Note on Maximum GPIOs added to “Table 1-1 Product
                                  Resources”.
                              “3.7.6 Power up Conditions” removed.
11/22/2024         1.7E       Note added to “Table 3-2 Recommended Operating
                                  Conditions”.
                              Note for “Table 3-8 DC Electrical Characteristics over
                                  Recommended Operating Conditions” modified.
                              “Table 3-11 Single-ended I/O DC Characteristics” updated,
Date         Version   Description
                          modifying IOL and IOH of LVCMOS12 standard.
                        “Table 3-15 Gearbox Timing Parameters” optimized.
                        “Table 3-24 GW1NSR-4 User Flash Parameters[1], [4], [5]”
                          updated.
                        “Figure 4-5 Package Marking Examples” updated.
                        Note about default state of GPIOs optimized.
                        Description of MIPI input/output updated.
                        Description of IODELAY module updated.
                        Description of background upgrade added.
                        Description of HCLK optimized.
                        Note on functional description of dual port BSRAM and semi-
                          dual port BSRAM modified.
                        Description of PSRAM updated.
                        Description of MIPI IO optimized.
                        Description of NOR Flash updated.
                        Description of Cortex-M3 updated.
                        “Table 2-1 Output I/O Standards and Configuration Options
                          correcting drive strength values for some I/O types.
                        “Table 2-2 Input I/O Standards and Configuration Options
06/12/2025   1.8E
                          modifying VCCIO values for some I/O types.
                        “Table 3-9 Static Current[1]” updated.
                        “Table 3-16 Single-ended IO Fmax” added.
                        Frequency of on-chip oscillator corrected.
                        Note for “Figure 4-5 Package Marking Examples” updated.
                                                                                                                                                    Contents

      Contents

      Contents ............................................................................................................... i
      List of Figures .................................................................................................... iv
      List of Tables ....................................................................................................... v
      1 General Description......................................................................................... 1
             1.1 Features .............................................................................................................................. 1
             1.2 Product Resources ............................................................................................................. 3
             1.3 Package Information ........................................................................................................... 4
      2 Architecture...................................................................................................... 5
             2.1 Architecture Overview ......................................................................................................... 5
             2.2 PSRAM ............................................................................................................................... 7
             2.3 HyperRAM .......................................................................................................................... 7
             2.4 NOR FLASH ....................................................................................................................... 8
             2.5 Configurable Function Units ............................................................................................... 9
             2.6 Input/Output Blocks .......................................................................................................... 10
             2.6.1 I/O Standards..................................................................................................................11
             2.6.2 True LVDS Design ......................................................................................................... 16
             2.6.3 I/O Logic ........................................................................................................................ 16
             2.6.4 I/O Logic Modes............................................................................................................. 19
             2.7 Block SRAM...................................................................................................................... 19
             2.7.1 Introduction .................................................................................................................... 19
             2.7.2 BSRAM Configuration Modes........................................................................................ 20
             2.7.3 Mixed Data Width Configuration .................................................................................... 21
             2.7.4 Parity Bit ........................................................................................................................ 22
             2.7.5 Synchronous Operation ................................................................................................. 22
             2.7.6 BSRAM Operation Modes ............................................................................................. 22
             2.7.7 Clock Mode .................................................................................................................... 24
             2.8 User Flash (GW1NSR-4) .................................................................................................. 26
             2.9 Digital Signal Processing .................................................................................................. 26
             2.9.1 Macro ............................................................................................................................. 27
             2.9.2 DSP Operation Modes ................................................................................................... 27
             2.10 MIPI D-PHY RX/TX Implemented by Using GPIOs ........................................................ 28

                                                                                                                                                   Contents

             2.11 Cortex-M3 ....................................................................................................................... 28
             2.11.1 Introduction .................................................................................................................. 28
             2.11.2 Cortex-M3 .................................................................................................................... 30
             2.11.3 Bus-Matrix .................................................................................................................... 31
             2.11.4 NVIC............................................................................................................................. 31
             2.11.5 Boot Loader ................................................................................................................. 33
             2.11.6 TimeStamp ................................................................................................................... 33
             2.11.7 Timer ............................................................................................................................ 34
             2.11.8 UART ........................................................................................................................... 35
             2.11.9 Watchdog ..................................................................................................................... 37
             2.11.10 GPIO .......................................................................................................................... 39
             2.11.11 Debug Access Port..................................................................................................... 40
             2.11.12 Memory Mapping ....................................................................................................... 41
             2.11.13 Application.................................................................................................................. 41
             2.12 Clocks ............................................................................................................................. 41
             2.12.1 Global Clocks............................................................................................................... 41
             2.12.2 PLLs ............................................................................................................................. 41
             2.12.3 High-speed Clocks....................................................................................................... 42
             2.13 Long Wires...................................................................................................................... 42
             2.14 Global Set/Reset............................................................................................................. 42
             2.15 Programming & Configuration ........................................................................................ 43
             2.15.1 SRAM Configuration .................................................................................................... 43
             2.15.2 Flash Programming ..................................................................................................... 43
             2.16 On-chip Oscillator ........................................................................................................... 43
      3 DC and Switching Characteristics ............................................................... 45
             3.1 Operating Conditions ........................................................................................................ 45
             3.1.1 Absolute Max. Ratings ................................................................................................... 45
             3.1.2 Recommended Operating Conditions ........................................................................... 45
             3.1.3 Power Supply Ramp Rates ........................................................................................... 46
             3.1.4 Hot Socketing Specifications ......................................................................................... 46
             3.1.5 POR Specifications ........................................................................................................ 46
             3.2 ESD performance ............................................................................................................. 47
             3.3 DC Electrical Characteristics ............................................................................................ 47
             3.3.1 DC Electrical Characteristics over Recommended Operating Conditions .................... 47
             3.3.2 Static Current ................................................................................................................. 48
             3.3.3 Recommended I/O Operating Conditions ..................................................................... 49
             3.3.4 Single-ended I/O DC Characteristics............................................................................. 50
             3.3.5 Differential I/O DC Characteristics ................................................................................. 51
             3.4 Switching Characteristics ................................................................................................. 51

                                                                                                                                                  Contents

             3.4.1 CLU Switching Characteristics ...................................................................................... 51
             3.4.2 Clock and I/O Switching Characteristics........................................................................ 52
             3.4.3 Gearbox Switching Characteristics................................................................................ 52
             3.4.4 BSRAM Switching Characteristics................................................................................. 53
             3.4.5 DSP Switching Characteristics ...................................................................................... 53
             3.4.6 On-chip Oscillator Switching Characteristics ................................................................. 53
             3.4.7 PLL Switching Characteristics ....................................................................................... 54
             3.5 Cortex-M3 AC/DC Characteristics .................................................................................... 54
             3.5.1 DC Electrical Characteristics ......................................................................................... 54
             3.5.2 AC Electrical Characteristics ......................................................................................... 54
             3.6 User Flash Characteristics(GW1NSR-4) .......................................................................... 55
             3.6.1 DC Electrical Characteristics ......................................................................................... 55
             3.6.2 AC Electrical Characteristics ......................................................................................... 56
             3.6.3 Timing Diagrams ............................................................................................................ 57
             3.7 Configuration Interface Timing Specification .................................................................... 58
      4 Ordering Information ..................................................................................... 59
             4.1 Part Naming ...................................................................................................................... 59
             4.2 Package Markings ............................................................................................................ 61
      5 About This Manual ......................................................................................... 62
             5.1 Purpose ............................................................................................................................ 62
             5.2 Related Documents .......................................................................................................... 62
             5.3 Terminology and Abbreviations ......................................................................................... 62
             5.4 Support and Feedback ..................................................................................................... 63

                                                                                                                                     List of Figures

      List of Figures

      Figure 2-1 Architecture Overview of GW1NSR-4 .............................................................................. 5
      Figure 2-2 Architecture Overview of GW1NSR-4C ............................................................................ 5
      Figure 2-3 CLU Structure View .......................................................................................................... 10
      Figure 2-4 IOB Structure View ........................................................................................................... 11
      Figure 2-5 I/O Bank Distribution View of GW1NSR-4C/4 .................................................................. 12
      Figure 2-6 True LVDS Design ............................................................................................................ 16
      Figure 2-7 I/O Logic Input and Output ............................................................................................... 17
      Figure 2-8 IODELAY Diagram ............................................................................................................ 18
      Figure 2-9 I/O Register Diagram ........................................................................................................ 18
      Figure 2-10 IEM Diagram................................................................................................................... 19
      Figure 2-11 Pipeline Mode in Single Port Mode, Dual Port Mode, and Semi-dual Port Mode .......... 23
      Figure 2-12 Independent Clock Mode ............................................................................................... 24
      Figure 2-13 Read/Write Clock Mode.................................................................................................. 25
      Figure 2-14 Single Port Clock Mode .................................................................................................. 25
      Figure 2-15 Cortex-M3 Architecture ................................................................................................... 30
      Figure 2-16 DEMCR Register ............................................................................................................ 34
      Figure 2-17 Timer0/Timer1 Structure View ........................................................................................ 35
      Figure 2-18 APB UART Buffering ...................................................................................................... 36
      Figure 2-19 Watchdog Operation....................................................................................................... 38
      Figure 2-20 Memory Mapping ............................................................................................................ 41
      Figure 2-21 GW1NSR-4/4C HCLK Distribution ................................................................................. 42
      Figure 3-1 Read Timing ..................................................................................................................... 57
      Figure 3-2 Program Timing ................................................................................................................ 57
      Figure 3-3 Erase Timing..................................................................................................................... 58
      Figure 4-1 Part Naming Examples for GW1NSR-4 Devices– ES...................................................... 59
      Figure 4-2 Part Naming Examples for GW1NSR-4C Devices– ES ................................................... 60
      Figure 4-3 Part Naming Examples for GW1NSR-4 Devices - Production ......................................... 60
      Figure 4-4 Part Naming Examples for GW1NSR-4C Devices - Production ...................................... 60
      Figure 4-5 Package Marking Examples ............................................................................................. 61

                                                                                                                                                List of Tables

      List of Tables

      Table 1-1 Product Resources............................................................................................................. 3
      Table 1-2 Package-Memory Combinations ........................................................................................ 4
      Table 1-3 Device-Package Combinations and Maximum User I/Os (True LVDS Pairs).................... 4
      Table 2-1 Output I/O Standards and Configuration Options Supported by GW1NSR Series of FPGA
      Products ............................................................................................................................................. 12
      Table 2-2 Input I/O Standards and Configuration Options Supported by GW1NSR Series of FPGA
      Products ............................................................................................................................................. 14
      Table 2-3 Port Description.................................................................................................................. 17
      Table 2-4 Total Delay of IODELAY Module ........................................................................................ 18
      Table 2-5 BSRAM Size Configuration ................................................................................................ 20
      Table 2-6 Dual Port Mixed Read/Write Data Width Configuration ..................................................... 22
      Table 2-7 Semi-dual Port Mixed Read/Write Data Width Configuration ............................................ 22
      Table 2-8 Clock Modes in Different BSRAM Modes .......................................................................... 24
      Table 2-9 List of GW1NSR series of FPGA Products that Support MIPI IO Type ............................. 28
      Table 2-10 NVIC Interrupt Vector Table ............................................................................................. 32
      Table 2-11 Timer0/ Timer1 Registers ................................................................................................. 35
      Table 2-12 UART0/ UART1 Registers ............................................................................................... 37
      Table 2-13 Watchdog Registers ......................................................................................................... 38
      Table 2-14 GPIO Registers ................................................................................................................ 39
      Table 2-15 Output Frequency Options of the On-chip Oscillator of GW1NSR-4/4C ......................... 44
      Table 3-1 Absolute Max. Ratings ....................................................................................................... 45
      Table 3-2 Recommended Operating Conditions ................................................................................ 45
      Table 3-3 Power Supply Ramp Rates ................................................................................................ 46
      Table 3-4 Hot Socketing Specifications ............................................................................................. 46
      Table 3-5 POR Parameters ................................................................................................................ 46
      Table 3-6 GW1NSR ESD - HBM ........................................................................................................ 47
      Table 3-7 GW1NSR ESD - CDM........................................................................................................ 47
      Table 3-8 DC Electrical Characteristics over Recommended Operating Conditions ......................... 47
      Table 3-9 Static Current[1]................................................................................................................... 48
      Table 3-10 Recommended I/O Operating Conditions ........................................................................ 49
      Table 3-11 Single-ended I/O DC Characteristics ............................................................................... 50
      Table 3-12 Differential I/O DC Characteristics (LVDS) ...................................................................... 51

                                                                                                                                    List of Tables

      Table 3-13 CLU Timing Parameters ................................................................................................... 51
      Table 3-14 External Switching Characteristics................................................................................... 52
      Table 3-15 Gearbox Timing Parameters ............................................................................................ 52
      Table 3-16 Single-ended IO Fmax ..................................................................................................... 52
      Table 3-17 BSRAM Timing Parameters ............................................................................................. 53
      Table 3-18 DSP Timing Parameters................................................................................................... 53
      Table 3-19 On-chip Oscillator Parameters ......................................................................................... 53
      Table 3-20 PLL Parameters ............................................................................................................... 54
      Table 3-21 Current Characteristics .................................................................................................... 54
      Table 3-22 Clock Parameters............................................................................................................. 54
      Table 3-23 GW1NSR-4 User Flash DC Characteristics[1], [4] .............................................................. 55
      Table 3-24 GW1NSR-4 User Flash Parameters[1], [4], [5]...................................................................... 56
      Table 5-1 Terminology and Abbreviations .......................................................................................... 62

1 General Description                                                                     1.1 Features

                                                  1      General Description

                             The GW1NSR FPGAs are members of the 1 series of the LittleBee
                        family. The GW1NR devices are system-in-package chips with memory
                        chips integrated into them based on the GW1NS devices. The GW1NSR
                        series consists of the GW1NSR-4C device(embedded with an ARM
                        Cortex-M3 processor) and the GW1NSR-4 device.
                             The GW1NSR-4C device is based on the ARM Cortex-M3 processor
                        and has the minimum memory required to implement system functions. Its
                        adaptable and flexible embedded FPGA logic modules enable the
                        implementation of diverse peripheral control tasks, along with delivering
                        excellent computing capabilities and advanced exception handling.
                        Seamlessly integrating a programmable logic device with an embedded
                        processor, the GW1NSR-4C device is compatible with a range of
                        peripheral standards, resulting in substantial cost savings for users. This
                        makes it a highly versatile choice, suitable for a wide array of applications
                        spanning industrial control, communications, IoT, servo drives, and
                        consumer electronics, among others.
                             In addition, the GW1NS series FPGA products boast high
                        performance, low power consumption, a small pin count, flexible usage,
                        instant-on, low-cost, non-volatility, enhanced security, and a wide range of
                        packaging options.
                             Gowin provides an advanced FPGA hardware development
                        environment that supports FPGA synthesis, placement & routing,
                        bitstream generation and download, etc.

 1.1 Features
     Lower power consumption                                Integrated with HyperRAM/PSRAM
                                                              memory chips
      -    55nm embedded Flash
           technology                                        Integrated with NOR Flash
      -    Core voltage: 1.2V                                Hard core processor
      -    GW1NSR-4C/4 support LV                             -   32-bit Arm Cortex-M3 processor
           version only                                       -   ARM v7-M Thumb2 architecture
      -    Supports dynamically turning                           optimized for small-footprint
           on/off the clock                                       embedded applications

1 General Description                                                              1.1 Features

      -    System timer (SysTick), providing        -   NOR Flash
           a simple, 24-bit clear-on-write,         -   10,000 write cycles
           decrementing, wrap-on-zero
           counter with a flexible control          -   Greater than 10 years of data
           mechanism                                    retention at +85℃
      -    Thumb compatible, Thumb-2               Multiple I/O standards
           instruction set processor core for
           high code density                        -   LVCMOS33/25/18/15/12；
                                                        LVTTL33，SSTL33/25/18 I，
      -    GW1NSR-4C supports up to 80
           MHz operation                                SSTL33/25/18 II，SSTL15；
                                                        HSTL18 I，HSTL18 II，HSTL15
      -    Hardware-division and single-
                                                        I；PCI，LVDS25，RSDS，
           cycle-multiplication
                                                        LVDS25E，BLVDSE，
      -    Integrated nested vectored                   MLVDSE，LVPECLE，RSDSE
           interrupt controller (NVIC)
           providing deterministic interrupt        -   Input hysteresis options
           handling                                 -   Drive strength options
      -    26 interrupts with eight priority        -   Individual Bus Keeper, Pull-
           levels                                       up/Pull-down, and Open Drain
      -    Memory protection unit (MPU),                options
           providing a privileged mode for          -   Hot socketing
           protecting operation system
           functionality                           MIPI D-PHY RX/TX Implemented by
                                                    Using GPIOs
      -    Unaligned data access, enabling
           data to be efficiently packed into       -   Supports MIPI CSI-2 and MIPI
           memory                                       DSI RX/TX with a data rate of up
                                                        to 1.2Gbps per lane
      -    Atomic bit manipulation (bit-
           banding), delivering maximum             -   Three IO types are available:
           memory utilization and                       TLVDS, ELVDS, and MIPI IO.
           streamlined peripheral control          Abundant basic logic cells
      -    Timer0 and Timer1                        -   4-input LUTs (LUT4s)
      -    UART0 and UART1                          -   Supports shift registers
      -    watchdog                                Block SRAMs with multiple modes
      -    Debug port: JTAG and TPIU                -   Supports Dual Port mode, Single
     User Flash (GW1NSR-4)                             Port mode, and Semi-Dual Port
                                                        mode
      -    NOR Flash
                                                   Flexible PLLs
      -    256Kbits storage space
                                                    -   Frequency adjustment
      -    Data width:32bits                            (multiplication and division) and
      -    10,000 write cycles                          phase adjustment
      -    Greater than 10 years of data            -   Supports global clocks
           retention at +85℃                       Built-in Flash programming
     Configuration Flash                           -   Instant-on

1 General Description                                                                       1.2 Product Resources

      -    Supports security bit operation                           -   JTAG configuration
      -    Supports AUTO BOOT and DUAL                               -   Multiple GowinCONFIG
           BOOT                                                          configuration modes: AUTO
                                                                         BOOT, DUAL BOOT, SSPI, MSPI,
     Configuration
                                                                         CPU, SERIAL

 1.2 Product Resources
                        Table 1-1 Product Resources

  Device                                          GW1NSR-4                        GW1NSR-4C
  LUT4s                                           4,608                           4,608
  Flip-Flops (FFs)                                3,456                           3,456
  Block SRAM (BSRAM) Capacity (bits)              180K                            180K
  Number of BSRAMs                                10                              10
  Multiplier (18 x 18 Multiplier)                 16                              16
  User Flash (bits)                               256K                            -
  PSRAM (bits)                                    64M                             64M
  HyperRAM (bits)                                 -                               64M
  NOR FLASH (bits)                                -                               32M
  PLLs                                            2                               2
  OSC                                             1, ±5% tolerance                1, ±5% tolerance
  Hard core processor                             -                               Cortex-M3
  I/O Banks                                       4                               4
  Maximum GPIOs[1]                                106                             106
  Core voltage                                    1.2V                            1.2V
                        Note!
                        [1]
                           This is the maximum number of GPIOs the device can provide without package
                        limitation. Please refer to Table 1-3 for the maximum number of user I/Os available for the
                        specific packages.

1 General Description                                                                  1.3 Package Information

 1.3 Package Information
                        Table 1-2 Package-Memory Combinations
  Device                        Package               Memory Type           Capacity    Width
  GW1NSR-4                      MG64P                 PSRAM                 64Mb        16 bits
                                MG64P                 PSRAM                             16 bits
                                                                            64Mb
  GW1NSR-4C                     QN48P                 HyperRAM                          8 bits
                                QN48G                 NOR FLASH             32Mb        1 bit

                        Table 1-3 Device-Package Combinations and Maximum User I/Os (True LVDS
                        Pairs)

  Package          Pitch (mm)             Size (mm)           GW1NSR-4                 GW1NSR-4C

                        Note!
                           JTAGSEL_N and JTAG pins cannot be used as GPIOs simultaneously. However,
                            when mode [2:0] = 001, the JTAGSEL_N pin is always a GPIO, in other words the
                            JTAGSEL_N pin and the four JTAG pins (TCK, TMS, TDI, TDO) can be used as
                            GPIOs simultaneously. See UG863, GW1NSR series of FPGA Products Package
                            and Pinout User Guide for more details.
                           The package types in this manual are referred to by acronyms, see 4.1 Part Naming
                            for more information.
                           For more information, see UG864, GW1NSR-4 Pinout and UG865, GW1NSR-4C
                            Pinout.

2 Architecture                                                                                                2.1 Architecture Overview

                                                                                               2      Architecture

 2.1 Architecture Overview
                                   Figure 2-1 Architecture Overview of GW1NSR-4

                                                      I/OBank0                     IOB         IOB    IOB      IOB
                                                     CLU      Flash                      CLU          Flash    IOB
                                                   UserFlash   PLL
                                      I/OBank3

                                                                        I/OBank1

                                                         DSP                       User Flash         PLL      IOB
                      PSRAM

                                                     CLU      OSC                              DSP             IOB          PSRAM
                                                        BSRAM
                                                 CLU                               CLU         CLU    OSC       IOB
                                                         CLU                              BSRAM                 IOB
                                                      I/OBank2                     CLU     CLU        CLU       IOB

                                   Figure 2-2 Architecture Overview of GW1NSR-4C

                                                      I/OBank0                     IOB         IOB    IOB      IOB
                                                     CLU        Flash                    CLU          Flash
                 HyperRAM/PSRAM/

                                                                                                               IOB
                                                     CLU         PLL
                    NOR FLASH

                                     I/OBank3

                                                                        I/OBank1

                                                      Cortex M3                          CLU          PLL      IOB         HyperRAM
                                                     CLU        OSC                                            IOB         / PSRAM/
                                                                                          Cortex M3
                                                         DSP                                                               NOR
                                                                                   CLU         CLU    OSC       IOB        FLASH
                                                       BSRAM
                                                         CLU                                   DSP              IOB
                                                      I/OBank2                             BSRAM                IOB

                                       The GW1NSR device is a system-in-package(SIP) chip that combines
                                   the GW1NS device and a memory chip. For the features and overview of
                                   PSRAM, see 2.2 PSRAM. For the features and overview of HyperRAM,
                                   see 2.3 HyperRAM. For the features and overview of NOR FLASH, see

2 Architecture                                                         2.1 Architecture Overview

                 2.4 NOR FLASH.
                     The core of the GW1NSR device is an array of logic cells surrounded
                 by IO blocks. Besides, BSRAMs, DSP blocks, PLLs, an on-chip oscillator,
                 and Flash resources allowing for instant-on are provided. In addition,
                 GW1NSR-4C has an embedded Cortex-M3 processor, see Table 1-1.
                      The Configurable Logic Units (CLUs) are the basic logic blocks that
                 form the core of GW1NSR FPGAs. Devices with different capacities have
                 different numbers of rows and columns of CFUs/CLUs. For more
                 information, see 2.5 Configurable Function Units.
                      The I/O resources in the GW1NSR series of FPGA products are
                 arranged around the periphery of the devices in groups referred to as
                 banks. The I/O resources support multiple I/O standards and can be used
                 for regular mode, SDR mode, and generic DDR mode. For more
                 information, see 2.6 Input/Output Blocks.
                     BSRAMs are arranged in row(s) inside the GW1NSR series of FPGA
                 products. Each BSRAM occupies 3 CLU locations. There are two uses of
                 BSRAMs, but the two uses cannot be used at the same time. Firstly, they
                 function as the SRAM resources for the Cortex-M3 processor system. The
                 capacity of each BSRAM is 16Kbits, and the total capacity is
                 128Kbits(GW1NSR-4/4C). Secondly, they can be utilized for user storage.
                 The capacity of each BSRAM is 18Kbits, and the total capacity is
                 180Kbits(GW1NSR-4/4C). And in this case multiple configuration modes
                 and operation modes are supported. For more information, see 2.7 Block
                 SRAM.
                     GW1NSR-4 has built-in User Flash memory resources, ensuring data
                 retention even when powered off. See 2.8 User Flash (GW1NSR-4) for
                 more information.
                     The GW1NSR series of FPGA products provide DSP blocks. Each
                 DSP block contains two macros, and each macro contains two pre-adders,
                 two 18 x 18 bit multipliers, and one three-input ALU. For more information,
                 see 2.9 Digital Signal Processing.
                      The GW1NSR series of FPGA products have embedded PLL
                 resources. The PLLs can provide synthesizable clock frequencies.
                 Frequency adjustment (multiplication and division), phase adjustment, and
                 duty cycle adjustment can be realized by configuring the parameters. In
                 addition, a programmable on-chip oscillator is provided. For more
                 information, see 2.12 Clocks and 2.16 On-chip Oscillator.
                     The embedded configuration Flash resources in GW1NSR FPGAs
                 support instant-on and security bit operations, catering to AUTO BOOT
                 and DUAL BOOT configuration modes. For more information, see 2.15
                 Programming & Configuration.
                      The Cortex-M3 processor supports 30 MHz program loading when the
                 system starts up and supports higher speed data/instructions
                 transmission. The AHB expansion bus facilitates communication with
                 external storage devices. The APB bus also facilitates communication with
                 external devices, such as UART. GPIO interfaces are convenient for

2 Architecture                                                                       2.2 PSRAM

                 communicating with the external interfaces. The FPGA can be
                 programmed to realize controller functions across different interfaces /
                 standards, such as SPI, I2C, I3C, etc. For more information, see 2.11
                 Cortex-M3.

 2.2 PSRAM
                 Features
                    Clock frequency: 166 MHz
                    Double Data Rate
                    32Mb capacity for each PSRAM
                    8-bit data width for each PSRAM
                    Read-write data strobe (RWDS)
                    Temperature compensated refresh
                    Partial array self-refresh (PASR)
                    Hybrid sleep mode
                    Deep power down(DPD)
                    Drive strengths: 35, 50, 100, and 200 Ohm
                    Burst access
                    Burst lengths: 16/32/64/128
                    Status/control registers
                    1.8V power supply
                      Please refer to the corresponding pinout manual for the power supply
                 of the PSRAM.
                       The IP Core Generator integrated in the Gowin Software supports a
                 PSRAM controller IP that can interface to both embedded and external
                 PSRAMs. This controller IP can be used for the PSRAM power-up
                 initialization, read calibration, etc. For more information, please refer to
                 IPUG525，Gowin PSRAM Memory Interface IP User Guide.

 2.3 HyperRAM
                 Features
                    Clock frequency: 200 MHz
                    Double Data Rate
                    Clock: supports single-ended clock and differential clock
                    Supports chip select
                    Data width: 8bits
                    Supports hardware reset
                    Read-write data strobe (RWDS)
                     -   Bidirectional Data Strobe / Mask
2 Architecture                                                                         2.4 NOR FLASH

                         -     Output at the start of all transactions to indicate refresh latency
                         -     Output during read transactions as Read Data Strobe
                         -     Input during write transactions as Write Data Mask
                        Die Stack Address
                        Performance and Power
                         -    Configurable output drive strength
                         -    Power saving modes: Hybrid Sleep Mode and Deep Power Down
                        Configurable Burst characteristics
                         -     Linear burst
                         -     Wrapped burst lengths: 16 bytes, 32 bytes, 64 bytes, and 128
                               bytes
                         -     Hybrid burst: one wrapped burst followed by linear burst
                        Array Refresh Modes: Full Array Refresh and Partial Array Refresh
                        Power Supply: 1.7V~2.0V
                    For the power supply of the HyperRAM, please refer to UG865,
                 GW1NSR-4C Pinout.
                       The IP Core Generator integrated in the Gowin Software supports a
                 HyperRAM controller IP that can interface to both embedded and external
                 HyperRAMs. This controller IP can be used for the HyperRAM power-up
                 initialization, read calibration, etc. For more information, please refer to
                 IPUG944, Gowin HyperRAM Memory Interface IP User Guide.

 2.4 NOR FLASH
                    The SoC with the package suffix of “G”, such as QN48G, is
                 embedded with NOR Flash.
                     Features
                            32 Mbits of storage, 256 bytes per page
                            Supports SPI
                            Clock frequency: 120 MHz
                            Continuous read with 8/16/32/64 bytes wrap
                            Software/Hardware Write Protection:
                         -     Entire/partial write protection via software settings
                         -     Top/bottom block protection
                            Minimum 100,000 program/erase cycles
                            Fast program/erase operations:
                         -     Page program time: 0.5ms
                         -     Sector erase time: 45ms
                         -     Block erase time: 0.15s/0.25s

2 Architecture                                                      2.5 Configurable Function Units

                      -     Chip erase time: 12s
                         Flexible Architecture:
                      -     Sector: 4K bytes
                      -     Block: 32/64K bytes
                      -     Erase/Program Suspend/Resume
                         Lower power consumption:
                      -     Stand-by current: 12uA
                      -     Power down current: 1uA
                         Security Features
                      -     128-bit unique ID for each device
                      -     3x1024-Byte security registers with OTP Lock
                         Data retention: 20 years
                      Gowin provides a universal SPI NOR Flash Interface IP allowing for
                 interconnection with the SPI NOR Flash chip. For more information, see
                 IPUG945, Gowin SPI Nor Flash Interface IP User Guide.

 2.5 Configurable Function Units
                      Configurable Function Units (CFUs) and/or Configurable Logic Units
                 (CLUs) are the basic cells that make up the core of Gowin FPGAs. Each
                 basic cell consists of four Configurable Logic Sections (CLSs) and their
                 routing resource Configurable Routing Units (CRUs), with three of the
                 CLSs each containing two 4-input LUTs and two registers, and the
                 remaining one only containing two 4-input LUTs, as shown in Figure 2-3.
                      The CLSs in the CLUs cannot be configured as SRAMs, but can be
                 configured as basic LUTs, ALUs, and ROMs. The CLSs in the CFUs can
                 be configured as basic LUTs, ALUs, SRAMs, and ROMs according to
                 application scenarios.
                     For more information on the CFUs/CLUs, see UG288, Gowin
                 Configurable Function Unit (CFU) User Guide.

2 Architecture                                                                   2.6 Input/Output Blocks

                 Figure 2-3 CLU Structure View

                                                 Carry to Right CLU
                     CLU

                                                   REG/
                                          LUT      SREG
                                                             CLS3
                                                   REG/
                                          LUT      SREG

                                          LUT     REG
                                                             CLS2
                                          LUT     REG

                           CRU

                                          LUT     REG
                                                             CLS1
                                          LUT     REG

                                          LUT     REG
                                                             CLS0
                                          LUT     REG

                           Carry from left CLU

                 Note!
                 The SREGs need special patch support. Please contact Gowin’s technical support or
                 local office for this patch.

 2.6 Input/Output Blocks
                      The Input/Output Block (IOB) in the GW1NSR series of FPGA
                 products consists of a buffer pair, IO logic, and corresponding routing
                 units. As shown in the figure below, each IOB connects to two pins
                 (marked as A and B), which can be used as a differential pair or as two
                 single-ended inputs/outputs.

2 Architecture                                                                                  2.6 Input/Output Blocks

                 Figure 2-4 IOB Structure View
                          Differential Pair                      Differential Pair

                     “True”             “Comp”                 “True”              “Comp”
                     PAD A                  PAD B              PAD A               PAD B

                           Buffer Pair A & B                    Buffer Pair A & B
                            DO

                                              DO

                                                                 DO

                                                                                    DO
                     TO

                                       TO

                                                          TO

                                                                              TO
                                  DI

                                                    DI

                                                                         DI

                                                                                          DI
                      IO Logic          IO Logic           IO Logic            IO Logic
                         A                 B                  A                   B
                  CLK

                                                    CLK

                                                          CLK

                                                                                          CLK
                  Routing

                  Routing

                  Routing

                  Routing

                                                          Routing

                                                          Routing

                                                          Routing

                                                          Routing
                  Output

                  Output

                                                          Output

                                                          Output
                   Input

                   Input

                                                           Input

                                                           Input

                                 Routing                                Routing

                          The features of the IOB include:
                     VCCIO supplied to each bank
                     LVCMOS, PCI, LVTTL, LVDS, SSTL, HSTL, etc. Bank3 of GW1NSR-
                      4C/4 only supports single-ended LVCMOS input/output and LVDS25E
                      differential output
                     Input hysteresis options
                     Drive strength options
                     Individual Bus Keeper, Pull-up/Pull-down, and Open Drain options
                     Hot socketing(except Bank3 of GW1NSR-4C/4)
                     IO logic supports basic mode, SDR mode, DDR mode, etc.
                     Bank0/Bank1 of GW1NSR-4C/4 can support MIPI input by using MIPI
                      IO type.
                     Bank2 of GW1NSR-4C/4 can support MIPI output by using MIPI IO
                      type.
                     Bank0/Bank1/Bank2 of GW1NSR-4C/4 support I3C.
                      2.6.1~ 2.6.4 describe I/O standards, true LVDS design, I/O logic, and
                 I/O logic modes. For more information about the IOB, please refer to
                 UG289,Gowin Programmable IO (GPIO) User Guide.
 2.6.1 I/O Standards
                     There are four I/O banks in the GW1NSR series of FPGA products, as
                 shown in Figure 2-5. Each bank has its own I/O power supply VCCIO.

2 Architecture                                                                     2.6 Input/Output Blocks

                      To support SSTL, HSTL, etc., each bank also has one independent
                 voltage source (VREF) as the reference voltage. You can choose to use the
                 internal VREF (0.5 x VCCIO) or the external VREF input via any IO from the
                 bank.
                 Figure 2-5 I/O Bank Distribution View of GW1NSR-4C/4

                            I/O Bank0            I/O Bank1

                                         Top

                                                                 I/O Bank2
                                                         Right
                                  GW1NSR-4C/4

                                        Bottom
                                      I/O Bank3

                      The GW1NSR FPGAs support LV version.
                      The GW1NSR FPGAs support 1.2V VCC (core voltage).
                     VCCX(auxiliary voltage) can be set to 1.8V, 2.5V, or 3.3V, and VCCIO(I/O
                 bank voltage) can be set to 1.2V, 1.5V, 1.8V, 2.5V, or 3.3V as needed.
                 Note!
                    For GW1NSR-4C/4, VCCIO0/VCCIO1 need to be set to 1.2V when Bank0/Bank1 are
                     used for MIPI input, and VCCIO2 needs to be set to 1.2V when Bank2 is used for MIPI
                     output. The MIPI speed with VCCX set to 1.8V is only 60% of the MIPI speed with
                     VCCX set to 2.5V/3.3V.
                    During configuration, all GPIOs of the device are high-impedance with internal weak
                     pull-ups. After the configuration is complete, the I/O states are controlled by user
                     programs and constraints. The states of configuration-related I/Os differ depending
                     on the configuration mode.
                     For the VCCIO requirements of different I/O standards, see Table 2-1
                 and Table 2-2.
                 Table 2-1 Output I/O Standards and Configuration Options Supported by
  I/O Type       Single-
                                        Bank VCCIO(V)        Drive Strength (mA)   Typical Applications
  (output)       ended/Differential
  LVCMOS33/                                                                        Universal interface
                 Single-ended           3.3                  4/8/12/16/24
  LVTTL33
  LVCMOS25       Single-ended           2.5                  4/8/12/16             Universal interface
  LVCMOS18       Single-ended           1.8                  4/8/12                Universal interface
  LVCMOS15       Single-ended           1.5                  4/8                   Universal interface

2 Architecture                                                               2.6 Input/Output Blocks

  I/O Type       Single-
                                       Bank VCCIO(V)   Drive Strength (mA)   Typical Applications
  (output)       ended/Differential
  LVCMOS12       Single-ended          1.2             4/8                   Universal interface
  SSTL25_I       Single-ended          2.5             8                     Memory interface
  SSTL25_II      Single-ended          2.5             8                     Memory interface
  SSTL33_I       Single-ended          3.3             8                     Memory interface
  SSTL33_II      Single-ended          3.3             8                     Memory interface
  SSTL18_I       Single-ended          1.8             8                     Memory interface
  SSTL18_II      Single-ended          1.8             8                     Memory interface
  SSTL15         Single-ended          1.5             8                     Memory interface
  HSTL18_I       Single-ended          1.8             8                     Memory interface
  HSTL18_II      Single-ended          1.8             8                     Memory interface
  HSTL15_I       Single-ended          1.5             8                     Memory interface
                                                                             PC and embedded
  PCI33          Single-ended          3.3             4/8
                                                                             system
                                                                             High-speed data
  LVPECL33E      Differential          3.3             16
                                                                             transmission
                                                                             LCD timing driver
                                                                             interface and
  MVLDS25E       Differential          2.5             16
                                                                             column driver
                                                                             interface
                                                                             Multi-point high-
  BLVDS25E       Differential          2.5             16                    speed data
                                                                             transmission
                                                                             High-speed point-
  RSDS25E        Differential          2.5             8                     to-point data
                                                                             transmission
                                                                             High-speed point-
  LVDS25E        Differential          2.5             8                     to-point data
                                                                             transmission
                                                                             Mobile Industry
  MIPI           Differential (MIPI)   1.2             3.5
                                                                             Processor Interface
                                                                             High-speed point-
                 Differential (True
  LVDS25                               2.5/3.3         2/2.5/3.5/6           to-point data
                 LVDS)
                                                                             transmission
                                                                             High-speed point-
                 Differential (True
  RSDS                                 2.5/3.3         2                     to-point data
                 LVDS)
                                                                             transmission
                                                                             LCD timing driver
                 Differential (True                                          interface and
  MINILVDS                             2.5/3.3         2
                 LVDS)                                                       column driver
                                                                             interface
                 Differential (True                                          LCD row/column
  PPLVDS                               2.5/3.3         3.5
                 LVDS)                                                       driver
  SSTL15D        Differential          1.5             8                     Memory interface
  SSTL25D_I      Differential          2.5             8                     Memory interface
  SSTL25D_II     Differential          2.5             8                     Memory interface
  SSTL33D_I      Differential          3.3             8                     Memory interface
  SSTL33D_II     Differential          3.3             8                     Memory interface
  SSTL18D_I      Differential          1.8             8                     Memory interface

2 Architecture                                                                      2.6 Input/Output Blocks

  I/O Type           Single-
                                             Bank VCCIO(V)    Drive Strength (mA)   Typical Applications
  (output)           ended/Differential
  SSTL18D_II         Differential            1.8              8                     Memory interface
  HSTL18D_I          Differential            1.8              8                     Memory interface
  HSTL18D_II         Differential            1.8              8                     Memory interface
  HSTL15D_I          Differential            1.5              8                     Memory interface
  LVCMOS12D          Differential            1.2              4/8                   Universal interface
  LVCMOS15D          Differential            1.5              4/8                   Universal interface
  LVCMOS18D          Differential            1.8              4/8/12                Universal interface
  LVCMOS25D          Differential            2.5              4/8/12/16             Universal interface
  LVCMOS33D          Differential            3.3              4/8/12/16/24          Universal interface

                     Table 2-2 Input I/O Standards and Configuration Options Supported by GW1NSR
                     Series of FPGA Products
                               Single-                              Hysteresis
  I/O Type (input)             ended/Diffe    Bank VCCIO(V)         Options            VREF Required?
                               rential                              Supported?
                               Single-
  LVCMOS33/ LVTTL33                           3.3                   Yes                No
                               ended
                               Single-
  LVCMOS25                                    2.5                   Yes                No
                               ended
                               Single-
  LVCMOS18                                    1.8                   Yes                No
                               ended
                               Single-
  LVCMOS15                                    1.5                   Yes                No
                               ended
                               Single-
  LVCMOS12                                    1.2                   Yes                No
                               ended
                               Single-
  SSTL15                                      1.5                   No                 Yes
                               ended
                               Single-
  SSTL25_I                                    2.5                   No                 Yes
                               ended
                               Single-
  SSTL25_II                                   2.5                   No                 Yes
                               ended
                               Single-
  SSTL33_I                                    3.3                   No                 Yes
                               ended
                               Single-
  SSTL33_II                                   3.3                   No                 Yes
                               ended
                               Single-
  SSTL18_I                                    1.8                   No                 Yes
                               ended
                               Single-
  SSTL18_II                                   1.8                   No                 Yes
                               ended
                               Single-
  HSTL18_I                                    1.8                   No                 Yes
                               ended
                               Single-
  HSTL18_II                                   1.8                   No                 Yes
                               ended
                               Single-
  HSTL15_I                                    1.5                   No                 Yes
                               ended
                               Single-
  LVCMOS33OD25                                2.5                   No                 No
                               ended
                               Single-
  LVCMOS33OD18                                1.8                   No                 No
                               ended

2 Architecture                                                         2.6 Input/Output Blocks

                     Single-                              Hysteresis
  I/O Type (input)   ended/Diffe    Bank VCCIO(V)         Options         VREF Required?
                     rential                              Supported?
                     Single-
  LVCMOS33OD15                      1.5                   No              No
                     ended
                     Single-
  LVCMOS25OD18                      1.8                   No              No
                     ended
                     Single-
  LVCMOS25OD15                      1.5                   No              No
                     ended
                     Single-
  LVCMOS18OD15                      1.5                   No              No
                     ended
                     Single-
  LVCMOS15OD12                      1.2                   No              No
                     ended
                     Single-
  LVCMOS25UD33                      3.3                   No              No
                     ended
                     Single-
  LVCMOS18UD25                      2.5                   No              No
                     ended
                     Single-
  LVCMOS18UD33                      3.3                   No              No
                     ended
                     Single-
  LVCMOS15UD18                      1.8                   No              No
                     ended
                     Single-
  LVCMOS15UD25                      2.5                   No              No
                     ended
                     Single-
  LVCMOS15UD33                      3.3                   No              No
                     ended
                     Single-
  LVCMOS12UD15                      1.5                   No              No
                     ended
                     Single-
  LVCMOS12UD18                      1.8                   No              No
                     ended
                     Single-
  LVCMOS12UD25                      2.5                   No              No
                     ended
                     Single-
  LVCMOS12UD33                      3.3                   No              No
                     ended
                     Single-
  PCI33                             3.3                   Yes             No
                     ended
                     Single-
  VREF1_DRIVER       ended (Vref    1.2/1.5/1.8/2.5/3.3   No              Yes
                     Input)
                     Differential
  MIPI                              1.2                   No              No
                     (MIPI)
  LVDS25             Differential   2.5/3.3               No              No
  RSDS               Differential   2.5/3.3               No              No
  MINILVDS           Differential   2.5/3.3               No              No
  PPLVDS             Differential   2.5/3.3               No              No
  LVDS25E            Differential   2.5/3.3               No              No
  MLVDS25E           Differential   2.5/3.3               No              No
  BLVDS25E           Differential   2.5/3.3               No              No
  RSDS25E            Differential   2.5/3.3               No              No
  LVPECL33E          Differential   3.3                   No              No
  SSTL15D            Differential   1.5                   No              No
  SSTL25D_I          Differential   2.5                   No              No
  SSTL25D_II         Differential   2.5                   No              No

2 Architecture                                                                                            2.6 Input/Output Blocks

                               Single-                                            Hysteresis
  I/O Type (input)             ended/Diffe      Bank VCCIO(V)                     Options                       VREF Required?
                               rential                                            Supported?
  SSTL33D_I                    Differential     3.3                               No                            No
  SSTL33D_II                   Differential     3.3                               No                            No
  SSTL18D_I                    Differential     1.8                               No                            No
  SSTL18D_II                   Differential     1.8                               No                            No
  HSTL18D_I                    Differential     1.8                               No                            No
  HSTL18D_II                   Differential     1.8                               No                            No
  HSTL15D_I                    Differential     1.5                               No                            No
  LVCMOS12D                    Differential     1.2                               No                            No
  LVCMOS15D                    Differential     1.5                               No                            No
  LVCMOS18D                    Differential     1.8                               No                            No
  LVCMOS25D                    Differential     2.5                               No                            No
  LVCMOS33D                    Differential     3.3                               No                            No

 2.6.2 True LVDS Design
                        Bank2 of GW1NSR-4C/4 supports true LVDS output. In addition,
                     LVDS25E, MLVDS25E, BLVDS25E, etc. are supported.
                         For more information about true LVDS, see UG864, GW1NSR-4
                     Pinout, UG865, GW1NSR-4C Pinout.
                          True LVDS input needs a 100Ω termination resistor, see Figure 2-6 for
                     the reference design. Bank0/1 of the GW1NSR-4C/4 devices support
                     programmable on-chip 100Ω input differential termination resistors, see
                     UG289, Gowin Programmable IO User Guide.
                     Figure 2-6 True LVDS Design

                                                                          GW1NSR
                       Transmitter                                                                                            Receiver
                                     txout+          rxin+                                            txout+         rxin+
                                              50Ω                              Logic                           50Ω
                                                    100Ω                       Array
                                              50Ω                                                              50Ω
                                     txout-          rxin-                                            txout-         rxin-

                                                             Input IO Buffer           Output IO Buffer

                        For information about termination for LVDS25E, MLVDS25E, and
                     BLVDS25E, please refer to UG289, Gowin Programmable IO User Guide.
 2.6.3 I/O Logic
                          Figure 2-7 shows the I/O logic input and output of the GW1NSR
                     series of FPGA products.

2 Architecture                                                                              2.6 Input/Output Blocks

                 Figure 2-7 I/O Logic Input and Output

                                       TX                  TRIREG

                                                                           GND

                                                             SER

                                         D                   OREG

                                                                                         IODELAY

                         DI

                         Q                                          IREG

                                                    IDES            IEM
                                             Rate
                       Q0-Qn-1
                                              Sel

                         CI

                 Table 2-3 Port Description

  Port                           I/O                        Description
                                                            GCLK input signal.
                                                            For the number of GCLK input signals, please refer
  CI[1]                          Input
                                                            to UG864，GW1NSR-4 Pinout and UG865，
                                                            GW1NSR-4C Pinout.
                                                            IO port low-speed input signal input into the fabric
  DI                             Input
                                                            directly.
  Q                              Output                     IREG output signal in the SDR module.
  Q0-Qn-1                        Output                     IDES output signal in the DDR module.
                 Note!
                 [1]
                   When CI is used as GCLK input, DI, Q, and Q0-Qn-1 cannot be used as I/O input and
                 output.
                     Descriptions of the I/O logic modules of the GW1NSR series of FPGA
                 products are presented below.
                 IODELAY
                      See Figure 2-8 for an overview of the IODELAY module. Each I/O of
                 the GW1NSR series of FPGA products contains the IODELAY module,
                 through which you can add additional delays to the I/O to adjust the delay
                 of the signal. The delay time of each step is Tdlyunit, and the number of
                 steps is DLYSTEP. The total delay time of IODELAY can be calculated as

2 Architecture                                                                       2.6 Input/Output Blocks

                 follows: Ttotdly = Tdlyoffset + Tdlyunit * DLYSTEP. See Table 2-4 for the total
                 delay time.
                 Table 2-4 Total Delay of IODELAY Module

                       Min.                      Typ.                        Max.

  Tdlyoffset           450ps                     500ps                       550ps

  Tdlyunit             -                         30ps                        -

  DLYSTEP              0                         -                           127

                 Figure 2-8 IODELAY Diagram

                           DI                                                       DO
                                                 DLY UNIT

                     SDTAP

                      SETN                        DLY ADJ                           DF

                     VALUE

                       There are two ways to control the delay:
                     Static control.
                     Dynamic control: can be used with the IEM module to adjust the
                      dynamic sampling window. The IODELAY module cannot be used for
                      both input and output at the same time.
                 I/O Register
                     See Figure 2-9 for the I/O register in the GW1NSR series of FPGA
                 products. Each I/O provides one input register (IREG), one output register
                 (OREG), and one tristate register (TRIREG).
                 Figure 2-9 I/O Register Diagram

                                D       Q

                                CE

                                CLK

                                SR

                 Note!
                     CE can be programmed as either active low (0: enable) or active high (1: enable).
                     CLK can be programmed as either rising edge triggering or falling edge triggering.
                     SR can be programmed as either synchronous/asynchronous SET/RESET or
                      disabled.
                     The register can be programmed as a register or a latch.

2 Architecture                                                                  2.7 Block SRAM

                 IEM
                     The IEM(Input Edge Monitor) module is used to sample data edges
                 and is used in generic DDR mode, as shown in Figure 2-10.
                 Figure 2-10 IEM Diagram

                       CLK                                          LEAD

                        D                   IEM                     MCLK

                     RESET                                          LAG

                 DES
                     This series of FPGA products provide a simple deserializer(DES) for
                 input I/O logic to support advanced I/O protocols.
                 SER
                     This series of FPGA products provide a simple serializer(SER) for
                 output I/O logic to support advanced I/O protocols.
 2.6.4 I/O Logic Modes
                      The I/O Logic of the GW1NSR series of FPGA products supports
                 several operation modes. In each operation mode, the I/O (or I/O
                 differential pair) can be configured as output, input, INOUT or tristate
                 output (output signal with tristate control).

 2.7 Block SRAM
 2.7.1 Introduction
                     The GW1NSR series of FPGA products provide abundant block
                 SRAM resources. These memory resources are distributed as blocks
                 throughout the FPGA array in the form of rows. Therefore, they are called
                 block static random access memories (BSRAMs).
                       BSRAMs serve two main purposes.
                 1. They function as the SRAM resources for the Cortex-M3 processor
                    system. The capacity of a BSRAM when used as the SRAM for
                    Cortex-M3 is 16Kbits (2K-Byte). The Gowin software supports the
                    configuration of SRAM resources, offering options like 2K-Byte, 4K-
                    Byte, and 8K-Byte. Any unused BSRAMs are available for user
                    storage.
                 2. They can also be used exclusively for FPGA data storage, and each
                    BSRAM can be configured to a maximum of 18,432 bits (18Kbits).
                    There are four configuration modes: Single Port mode, Dual Port
                    mode, Semi-Dual Port mode, and ROM mode.
                     The abundant BSRAM resources are available for implementing high-
                 performance designs. The features of BSRAMs include:
                     Up to 18,432 bits per BSRAM
                     Clock frequency up to 190MHz

2 Architecture                                                                2.7 Block SRAM

                    Supports Single Port mode
                    Supports Dual Port mode
                    Supports Semi-Dual Port mode
                    Provides parity bits
                    Supports ROM Mode
                    Data widths from 1 to 36 bits
                    Mixed clock mode
                    Mixed data width mode
                    Normal Read and Write
                    Read-before-write
                    Write-through
                     For more information on the BSRAMs, see      UG285, Gowin BSRAM
                 & SSRAM User Guide.
 2.7.2 BSRAM Configuration Modes
                     BSRAMs in the GW1NSR series of FPGA products support various
                 data widths, see Table 2-5.
                 Table 2-5 BSRAM Size Configuration

  Single Port Mode   Dual Port Mode         Semi-Dual Port Mode    ROM Mode
  16K x 1            16K x 1                16K x 1                16K x 1
  8K x 2             8K x 2                 8K x 2                 8K x 2
  4K x 4             4K x 4                 4K x 4                 4K x 4
  2K x 8             2K x 8                 2K x 8                 2K x 8
  1K x 16            1K x 16                1K x 16                1K x 16
  512 x 32           -                      512 x 32               512 x 32
  2K x 9             2K x 9                 2K x 9                 2K x 9
  1K x 18            1K x 18                1K x 18                1K x 18
  512 x 36           -                      512 x 36               512 x 36

                 Single Port Mode
                      The single port mode supports 2 read modes (bypass mode and
                 pipeline mode) and 3 write modes (normal mode, write-through mode, and
                 read-before-write mode). In single port mode, writing to or reading from
                 one port is supported. During the write operation, the written data will be
                 transferred to the output of the BSRAM. When the output register is
                 bypassed, the new data will show up at the same write clock rising edge.
                    For more information on single port mode, please refer to UG285,
                 Gowin BSRAM & SSRAM User Guide.
                 Dual Port Mode
                     The Dual Port mode supports 2 read modes (Bypass mode and
                 Pipeline mode) and 2 write modes (Normal mode and Write-through
2 Architecture                                                                           2.7 Block SRAM

                 mode). The applicable operations are as follows:
                    Two independent read operations
                    Two independent write operations
                    An independent read operation and an independent write operation
                 Note!
                 Performing read and write operations to the same address at the same time is not
                 allowed.
                    For more information on semi-dual port mode, please refer to UG285,
                 Gowin BSRAM & SSRAM User Guide.
                 Semi-Dual Port Mode
                      The semi-dual port mode supports 2 read modes (Bypass mode and
                 Pipeline mode) and 1 write mode (Normal mode). Semi-dual Port mode
                 supports simultaneous read and write operations in the form of writing to
                 port A and reading from port B.
                 Note!
                 Performing read and write operations to the same address at the same time is not
                 allowed.
                    For more information on semi-dual port mode, please refer to UG285,
                 Gowin BSRAM & SSRAM User Guide.
                 ROM Mode
                      BSRAMs can be configured as ROMs. The ROM can be initialized
                 during the device configuration stage, and the ROM data needs to be
                 provided in the initialization file. Initialization is completed during the
                 device power-on process.
                      Each BSRAM can be configured as one 16Kbit ROM. For more
                 information on ROM mode, please refer to UG285, Gowin BSRAM &
                 SSRAM User Guide.
 2.7.3 Mixed Data Width Configuration
                      The BSRAMs in the GW1NSR series of FPGA products support
                 mixed data width operations. In dual port mode and semi-dual port mode,
                 the data widths for read and write can be different, see Table 2-6 and
                 Table 2-7.

2 Architecture                                                                                         2.7 Block SRAM

                         Table 2-6 Dual Port Mixed Read/Write Data Width Configuration

                     Write Port
  Read Port
                     16K x 1          8K x 2        4K x 4           2K x 8       1K x 16     2K x 9        1K x 18
  16K x 1            *                *             *                *            *
  8K x 2             *                *             *                *            *
  4K x 4             *                *             *                *            *
  2K x 8             *                *             *                *            *
  1K x 16            *                *             *                *            *
  2K x 9                                                                                      *             *
  1K x 18                                                                                     *             *
                         Note!
                         “*” denotes the modes supported.
                         Table 2-7 Semi-dual Port Mixed Read/Write Data Width Configuration

                 Write Port
  Read
  Port
                 16K x 1          8K x 2       4K x 4   2K x 8   1K x 16      512 x 32   2K x 9   1K x 18       512 x 36
  16K x 1        *                *            *        *        *            *
  8K x 2         *                *            *        *        *            *
  4K x 4         *                *            *        *        *            *
  2K x 8         *                *            *        *        *            *
  1K x 16        *                *            *        *        *            *
  512x32         *                *            *        *        *            *
  2K x 9                                                                                 *        *             *
  1K x 18                                                                                *        *             *
                         Note!
                         “*” denotes the modes supported.

 2.7.4 Parity Bit
                             There are parity bits in BSRAMs. The 9th bit in each byte can be used
                         as a parity bit to check the correctness of data transmission. It can also be
                         used for data storage.
 2.7.5 Synchronous Operation
                              All the input registers of BSRAMs support synchronous write.
                              The output registers can be used as pipeline registers to improve
                               design performance.
                              The output registers are bypass-able.
 2.7.6 BSRAM Operation Modes
                            The BSRAM supports five different operations, including two read
                         modes (Bypass mode and Pipeline mode) and three write modes (Normal
                         mode, Write-through mode, and Read-before-write mode).

2 Architecture                                                                                        2.7 Block SRAM

                 Read Mode
                         The following two read modes are supported.
                        PIPELINE MODE
                      When a synchronous write cycles into a memory array with pipeline
                 registers enabled, the data can be read from pipeline registers in the next
                 clock cycle. The data bus can be up to 36 bits in this mode.
                        BYPASS MODE
                      When a synchronous write cycles into a memory array with pipeline
                 registers bypassed, the outputs are registered at the memory array.
                 Figure 2-11 Pipeline Mode in Single Port Mode, Dual Port Mode, and Semi-dual
                 Port Mode

                  AD
                                      Input      Memory       Pipeline
                   DI                                         Register            DO
                                     Register     Array
                  WRE

                   CLK
                   OCE

                                                                                       ADB
                                                                   Input
                  CLKA                                            Register
                   DIA             Input          Memory
                                                                                           CLKB
                                  Register         Array
                   ADA

                                                                   Pipeline
                                                                   Register
                                                                                    OCEB

                                                                     DOB

                         DIA                                                                 DIB
                         ADA           Input                              Input              ADB
                         WREA         Register                           Register            WREB

                                                     Memory
                   CLKA                               Array                                    CLKB

                                     Pipeline                            Pipeline
                                     Register                            Register          OCEB
                           OCEA

                                        DOA                                 DOB

                 Write Mode
                        NORMAL MODE
                      In this mode, when you write data to one port, the output data of this
                 port does not change. The written data will not appear at the read port.

2 Architecture                                                                   2.7 Block SRAM

                         WRITE-THROUGH MODE
                      In this mode, when you write data to one port, the written data will
                  appear at the output of this port.
                         READ-BEFORE-WRITE MODE
                       In this mode, when you write data to one port, the written data will be
                  stored in the memory according to the address, and the original data in
                  this address will appear at the output of this port.
 2.7.7 Clock Mode
                         Table 2-8 lists the clock modes in different BSRAM modes:
                  Table 2-8 Clock Modes in Different BSRAM Modes

  Clock Mode               Dual Port Mode     Semi-Dual Port Mode         Single Port Mode
  Independent    Clock
                           Yes                No                          No
  Mode
  Read/Write     Clock
                           Yes                Yes                         No
  Mode
  Single Port    Clock
                           No                 No                          Yes
  Mode
                  Independent Clock Mode
                     Figure 2-12 shows the independent clocking operations in dual port
                  mode with one clock at each port. CLKA controls all the registers at Port A;
                  CLKB controls all the registers at Port B.
                  Figure 2-12 Independent Clock Mode
                                   WREA                       WREB

                     ADA                                                 ADB
                                  Input                      Input
                     DIA                                                 DIB
                                 Register                   Register
                                             Memory
                                              Array
                    CLKA                                                 CLKB

                                 Output                     Output
                     DOA                                                 DOB
                                 Register                   Register

                                  WREA                        WREB

                  Read/Write Clock Mode
                       Figure 2-13 shows the read/write clocking operations in semi-dual
                  port mode with one clock at each port. The write clock (CLKA) controls
                  data inputs, write addresses and read/write enable signals of Port A. The
                  read clock (CLKB) controls data outputs, read addresses, and read enable
                  signals of Port B.

2 Architecture                                                                 2.7 Block SRAM

                 Figure 2-13 Read/Write Clock Mode

                                                          Input
                                                         Register
                              Input        Memory
                  CLKA                                                  CLKB
                             Register       Array

                                                         Pipeline
                                                         Register

                 Single Port Clock Mode
                       Figure 2-14 shows the clocking operation in single port mode.
                 Figure 2-14 Single Port Clock Mode
                           WRE    AD

                  DI         Input
                            Register
                                         Memory
                 CLK
                                          Array
                            Output
                  DO
                            Register

                              WRE

2 Architecture                                                              2.8 User Flash (GW1NSR-4)

 2.8 User Flash (GW1NSR-4)
                     The capacity of the User Flash in GW1NSR-4 is 32KB. The User
                 Flash consists of row memories and column memories. One row memory
                 consists of 64 column memories. The capacity of one column memory is
                 32 bits, and the capacity of one row memory is 64*32=2048 bits. Page
                 erase is supported, and the capacity of one page is 2048 bytes, that is,
                 one page contains 8 rows. The key features include:
                    NOR Flash
                    10,000 write cycles
                    Greater than 10 years of data retention at +85℃
                    Data width: 32 bits
                    Capacity: 128 rows x 64 columns x 32 = 256 Kbits
                    Page erase capability: 2,048 bytes per page
                    Fast Page Erase/Word Program Operation
                    Clock frequency: 40 MHz
                    Word Program Time: ≤16μs
                    Page Erase Time: ≤120 ms
                    Current
                     -   Read current/duration: 2.19mA/25ns (VCC) & 0.5mA/25ns
                         (VCCX)(MAX)
                     -   Program/erase operation: 12/12mA(MAX)
                      For more information about the User Flash in GW1NSR-4, please
                 refer to UG295, Gowin User Flash User Guide. For the correspondence
                 between User Flash primitives and devices supported, please refer to
                 Table 3-1 Devices Supported of UG295, Gowin User Flash User Guide.

 2.9 Digital Signal Processing
                      GW1NSR-4C/4 provide abundant DSP resources. Gowin’s DSP
                 solutions can address high-performance digital signal processing needs
                 such as FIR and FFT designs. The DSP resources have the advantages of
                 stable timing performance, high resource utilization, and low power
                 consumption.
                     The DSP resources offer the following functions:
                    Multipliers with three widths: 9-bit, 18-bit, 36-bit
                    54-bit ALU
                    Multipliers cascading to support wider data widths
                    Barrel shifters
                    Adaptive filtering through signal feedback
                    Computing with options to round to a positive number or a prime

2 Architecture                                                             2.9 Digital Signal Processing

                     number
                    Supports pipeline mode and bypass mode.
 2.9.1 Macro
                      The DSP blocks are distributed throughout the FPGA array in the form
                 of rows. Each DSP block contains two macros, and each macro contains
                 two pre-adders, two 18 x 18 bit multipliers, and one three-input ALU.
                 Pre-adder
                     Each DSP macro contains two pre-adders for implementing pre-
                 addition, pre-subtraction, and shifting.
                      The pre-adders are located at the first stage and have two input ports:
                    Parallel 18-bit input B or SBI;
                    Parallel 18-bit input A or SIA.
                 Note!
                 Each input port supports pipeline mode and bypass mode.
                     Gowin’s pre-adders can be used independently as function blocks,
                 which support 9-bit and 18-bit widths.
                 Multiplier
                     The multipliers are located after the pre-adders. The multipliers can
                 be configured as 9 x 9, 18 x 18, 36 x 18, or 36 x 36. Register mode and
                 bypass mode are supported in both input and output ports. The
                 configuration modes that a macro supports include:
                    One 18 x 36 multiplier
                    Two 18 x 18 multipliers
                    Four 9 x 9 multipliers
                 Note!
                 Two macros can form one 36 x 36 multiplier.

                 Arithmetic Logic Unit
                      Each DSP macro contains one 54-bit ALU, which can further enhance
                 multipliers’ functions. Register mode and bypass mode are supported in
                 both input and output ports. The functions include:
                    Addition/subtraction operations of multiplier output data/0, data A, and
                     data B.
                    Addition/subtraction operations of multiplier output data/0, data B, and
                     carry C.
                    Addition/subtraction operations of data A, data B, and carry C.
 2.9.2 DSP Operation Modes
                    Multiplier mode
                    Multiply accumulator mode

2 Architecture                                     2.10 MIPI D-PHY RX/TX Implemented by Using GPIOs

                     Multiply-add accumulator mode
                       For more information on the DSP resources, see UG287, Gowin
                  Digital Signal Processing (DSP) User Guide.

 2.10 MIPI D-PHY RX/TX Implemented by Using GPIOs
                      When implementing soft MIPI D-PHY RX/TX with GPIOs, three IO
                  types are available: TLVDS, ELVDS, and MIPI IO.
                       All GW1NSR FPGAs support the TLVDS/ELVDS types. To implement
                  MIPI D-PHY with the TLVDS/ELVDS types, you need to emulate MIPI HS
                  and MIPI LP by using LVDS25(E)+LVCMOS12 and need to add external
                  resistors.
                       Some GW1NSR FPGAs support the MIPI IO type. The MIPI IO has
                  an internal resistor network and supports automatic switching between HS
                  and LP. The support list of the MIPI IO type is shown in Table 2-9.
                       For information on IO type selection and off-chip termination, please
                  refer to “4 Functional Description” in IPUG948, Gowin MIPI D-PHY RX TX
                  Advance User Guide.
                  Table 2-9 List of GW1NSR series of FPGA Products that Support MIPI IO Type

  MIPI Input/Output                 GW1NSR-4                   GW1NSR-4C
  MIPI Input                        Bank0/1                    Bank0/1
  MIPI Output                       Bank2                      Bank2

                      The key features of the soft MIPI D-PHY RX/TX include:
                     MIPI Alliance Standard for D-PHY Specification, Version 1.2
                     High Speed RX and TX at up to 4.8Gbps
                     Supports up to 4 data lanes and 1 clock lane
                     Supports multiple PHYs(if there are enough IOs available)
                     Supports bidirectional low-power (LP) mode
                     Supports MIPI DSI and MIPI CSI-2 link layers
                     Supports built-in HS Sync, bit and lane alignment
                     Supports MIPI D-PHY RX 1:8 and 1:16 deserialization modes
                     Supports IO Types of ELVDS, TLVDS, MIPI IO, etc.
                     Bank0/Bank1/Bank2 of GW1NSR-4C/4 support I3C
                      For more information, see IPUG948, Gowin MIPI D-PHY RX TX
                  Advance User Guide.

 2.11 Cortex-M3
 2.11.1 Introduction
                       GW1NSR-4C is a system-on-chip FPGA device that incorporates a
                  microprocessor system hard core, Gowin FPGA fabric, and other standard
                  peripherals and hard cores, including BSRAM resources and PLL/OSC
                  clocking resources. The embedded microprocessor system contains a

2 Architecture                                                                  2.11 Cortex-M3

                 low-power, low-cost and high-performance ARM Cortex-M3 32-bit RISC
                 core. The flexible FPGA fabric serves as user programmable peripherals,
                 or soft-core IPs.
                      The embedded microprocessor system consists of a processor block
                 and an associated bus system that connects to standard peripherals. The
                 FPGA fabric contains rich programmable logic resources offering a flexible
                 architecture that allows the user to achieve multiple peripherals by calling
                 soft-core IPs, such as SPI, I2C. The microprocessor system only interfaces
                 with the FPGA fabric and JTAG config-core internally with no access to the
                 I/O blocks of GW1NSR-4C.
                     The bus system consists of an AHB-Lite Bus, an AHB2APB bridge
                 bus, and two APB buses(APB1 and APB2).
                      The microprocessor system accesses the FPGA sub-memory system
                 through the AHB bus. The system includes a controller that implements
                 read-only operations of 32KB of Flash resources and read/write operations
                 of a maximum of 16KB of BSRAM resources. Upon Power-On boot
                 loading, Cortex-M3 loads instructions and data that are pre-stored in the
                 Flash-ROM before initiating the execution.
                      In addition, there are two AHB bus extension ports: INTEXP0 and
                 TARGEXP0. Each of these AHB extension ports provides a 128-bit AHB
                 bus interconnecting to any high-speed User programmable peripherals
                 implemented within the FPGA. A GPIO block interconnects the AHB bus
                 with the FPGA fabric to allow the user to implement general purpose I/O
                 functions in the FPGA.
                      In terms of the two APB Bus (APB1 and APB2), APB1 interconnects
                 with two timers (Timer0 and Timer1), two UARTs (Uart0 and Uart1), and
                 one watchdog. The two UARTs connect to the FPGA directly. The two
                 timers and the watchdog are controlled and used within the
                 microprocessor system and are accessed through registers. The APB2
                 bus connects directly to the FPGA.
                     The processor block consists of a Cortex-M3 core, bus matrix, Nested
                 Vector Interrupt Controller (NVIC), Debug Access Port (DAP), and time
                 stamp, etc.
                     The Cortex-M3 core accesses the bus system through the bus matrix.
                     Six user interrupts are supported. The DAP contains the JTAG DAP
                 and the Trace-Port-Interface-Unit (TPIU).
                      The microprocessor system also provides an interrupt monitor signal,
                 which combines GPIO interrupts as well as APB1 peripherals (UART0,
                 UART1, Timer0, Timer1, Watchdog) interrupts, back to the FPGA fabric to
                 report the current run-time interrupt status of the microprocessor system.
                 FPGA fabric takes advantage of its rich Clocking Resource (PLL, OSC)
                 and provides the Main Clock, Power-On Reset and System Reset signals
                 to the embedded microprocessor system.
                     See Figure 2-15 for the Cortex-M3 architecture.

2 Architecture                                                                                                2.11 Cortex-M3

                      Figure 2-15 Cortex-M3 Architecture

                       Cortex-M3

             Processor Block
                                                                JTAG I/F
                           DAP                                                                                  JTAG
         Cortex-M3
           Core
                           Time
                          Stamp
                                                          TPIU I/F
         Bus-Matrix                         User_int0/1
                          NVIC
                                                          Clk/Reset         Clock
                                                                           Resource
                                                                           PLL/OSC
                                AHB Extension:
                                  INTEXP0
                                                                                        Memory Sub-System
                                AHB Extension:
                                 TARGEXP0                                                         Mem-Cntrl
                                  AHB To
         AHB                   SRAM/FLASH I/F                                                     B-SRAM
          Lite
         Bus                                              GPIO I/F
                                  GPIO
                                                                                                   FLASH

                                  AHB2APB
                                                          IntMonitor
                                                                             Logic Resource
                                                                                Soft-Core
                                                           APB I/F           SPI            I2C
                          APB1              APB2
                                                           UART                         USB
                                                            I/F              I3C
                                          UART1                                        Type-C

          Timer0                                           UART                    Others
                                          UART0             I/F

          Timer1
                                         Watchdog

 2.11.2 Cortex-M3
                      Features
                         Compact core
                         Thumb-2 instruction set, delivering the high-performance expected of
                          an ARM core
                         Associated with 32 bits and 16 bits devices; typically, in the range of a
                          few kilobytes of memory for microcontroller class applications
                         Rapid application execution through Harvard architecture
                          characterized by separate buses for instructions and data
                         Exception and Interrupt handling, implemented through register
                          operations
                         Deterministic, fast interrupt processing
                         Memory protection unit (MPU), providing a privileged mode for
                          protecting operation system functionality

2 Architecture                                                                    2.11 Cortex-M3

                    Migration from the ARM7 processor family for better performance and
                     power efficiency
                    Full-featured debug solution
                     -   JTAG Debug Port
                     -   Flash Patch and Breakpoint (FPB) unit for implementing
                         breakpoints
                     -   Data Watchpoint and Trigger (DWT) unit for implementing
                         watchpoints, trigger resources, and system profiling
                     -   Instrumentation Trace Macrocell (ITM) for printf style debugging
                     -   Trace Port Interface Unit (TPIU) for bridging to a Trace Port
 2.11.3 Bus-Matrix
                     The bus-matrix is used to connect the Cortex-M3 processor and
                 debug port with an external AHB bus. Connections between the bus-
                 matrix and the AHB bus:
                    ICode bus: 32bit AHBLite bus, used for fetching instructions and
                     vectors from code space.
                    DCode bus: 32bit AHBLite bus, used for data loading/storage and
                     debug access.
                    System bus: 32bit AHBLite bus, used for fetching instructions and
                     vectors from system space, data loading/storage and debug access.
                    APB: 32bit APB bus, used for external space data loading/storage and
                     debug access.
                 The bus-matrix also controls the following functions.
                    Unaligned accesses: converts the unaligned processor access to
                     aligned access.
                    Bit-banding: converts the alias access of Bit_band to Bit_band space
                     access.
                    Write buffer: the bus-matrix contains one write-buffer, ensuring that the
                     processor core is not affected by bus delay.
 2.11.4 NVIC
                     The features of NVIC include:
                    Supports up to 26 interrupts
                    Supports 6 user interrupts
                    A programmable priority level of 0-7 for each interrupt. A higher level
                     corresponds to a lower priority; as such level 0 is the highest interrupt
                     priority
                    Level and pulse detection of interrupt signals
                    Dynamic reprioritization of interrupts
                    The processor automatically stacks its state on exception entry and

2 Architecture                                                                           2.11 Cortex-M3

                       unstacks this state on exception exit, with no instruction overhead
                   Table 2-10 NVIC Interrupt Vector Table

  Address               Name                            Type      Description
                                                        Read
  0x00000000            _StackTop                                 Top of interrupt stack
                                                        only
                                                        Read
  0x00000004            Reset_Handler                             Reset interrupt
                                                        only
                                                        Read
  0x00000008            NMI_Handler                               NMI interrupt
                                                        only
                                                        Read
  0x0000000C            HardFault_Handler                         Hard fault interrupt
                                                        only
                                                        Read
  0x00000010            MemMange_Handler                          MPU fault interrupt
                                                        only
                                                        Read/Wr
  0x00000014            BusFault_Handler                          Bus fault interrupt
                                                        ite
                                                        Read
  0x00000018            UsageFault_Handler                        Usage fault interrupt
                                                        only
                                                        Read/Wr
  0x0000002C            SVC_Handler                               SVCall interrupt
                                                        ite
                                                        Read
  0x00000030            DebugMon_Handler                          Debug monitor interrupt
                                                        only
                                                        Read/
                                                        Write/
  0x00000038            PendSV_Handler                            Pending interrupt
                                                        Read
                                                        only
                                                        Read/Wr
  0x0000003C            SysTick_Handler                           System timer interrupt
                                                        ite
  External interrupt
                                                        Read/Wr   UART0 receive and transmit
  0x00000040            UART0_Handler
                                                        ite       interrupt
                                                        Read/Wr
  0x00000044            USER_INT0_Handler                         User interrupt 0
                                                        ite
                                                        Read/Wr   UART1 receive and transmit
  0x00000048            UART1_Handler
                                                        ite       interrupt
                                                        Read/Wr
  0x0000004C            USER_INT1_Handler                         User interrupt 1
                                                        ite
                                                        Read/Wr
  0x00000050            USER_INT2_Handler                         User interrupt 2
                                                        ite
                                                        Read/Wr
  0x00000058            PORT0_COMB_Handler                        GPIO0 interrupt
                                                        ite
                                                        Read/Wr
  0x0000005C            USER_INT3_Handler                         User interrupt 3
                                                        ite
                                                        Read/Wr
  0x00000060            TIMER0_Handler                            TIMER0 interrupt
                                                        ite
                                                        Read/Wr
  0x00000064            TIMER1_Handler                            TIMER1 interrupt
                                                        ite
                                                        Read/Wr
  0x0000006C            I2C_Handler                               I2C interrupt
                                                        ite
                                                        Read/Wr   UART0/UART1                 overflow
  0x00000070            UARTOVF_Handler
                                                        ite       interrupt
                                                        Read/Wr
  0x00000074            USER_INT4_Handler                         User interrupt 4
                                                        ite
                                                        Read/Wr
  0x00000078            USER_INT5_Handler                         User interrupt 5
                                                        ite

2 Architecture                                                                   2.11 Cortex-M3

  Address            Name                            Type      Description
                                                     Read/Wr
  0x00000080         PORT0_0_Handler                           GPIO0 pin0 interrupt
                                                     ite
                                                     Read/Wr
  0x00000084         PORT0_1_Handler                           GPIO0 pin1 interrupt
                                                     ite
                                                     Read/Wr
  0x00000088         PORT0_2_Handler                           GPIO0 pin2 interrupt
                                                     ite
                                                     Read/Wr
  0x0000008C         PORT0_3_Handler                           GPIO0 pin3 interrupt
                                                     ite
                                                     Read/Wr
  0x00000090         PORT0_4_Handler                           GPIO0 pin4 interrupt
                                                     ite
                                                     Read/Wr
  0x00000094         PORT0_5_Handler                           GPIO0 pin5 interrupt
                                                     ite
                                                     Read/Wr
  0x00000098         PORT0_6_Handler                           GPIO0 pin6 interrupt
                                                     ite
                                                     Read/Wr
  0x0000009C         PORT0_7_Handler                           GPIO0 pin7 interrupt
                                                     ite
                                                     Read/Wr
  0x000000A0         PORT0_8_Handler                           GPIO0 pin8 interrupt
                                                     ite
                                                     Read/Wr
  0x000000A4         PORT0_9_Handler                           GPIO0 pin9 interrupt
                                                     ite
                                                     Read/Wr
  0x000000A8         PORT0_10_Handler                          GPIO0 pin10 interrupt
                                                     ite
                                                     Read/Wr
  0x000000AC         PORT0_11_Handler                          GPIO0 pin11 interrupt
                                                     ite
                                                     Read/Wr
  0x000000B0         PORT0_12_Handler                          GPIO0 pin12 interrupt
                                                     ite
                                                     Read/Wr
  0x000000B4         PORT0_13_Handler                          GPIO0 pin13 interrupt
                                                     ite
                                                     Read/Wr
  0x000000B8         PORT0_14_Handler                          GPIO0 pin14 interrupt
                                                     ite
                                                     Read/Wr
  0x000000BC         PORT0_15_Handler                          GPIO0 pin15 interrupt
                                                     ite

 2.11.5 Boot Loader
                      The boot loader loads the initial stack pointer value from the program
                 memory, and branches to the reset handler that the reset vector specifies
                 in the program memory.
                     The current boot loader is based on UART Message Monitor which is
                 easy to interface as a communication port with PC host. Below is an
                 example of how to deploy the boot loader:
                    Power-on reset to enter the reset handler to call the boot loader.
                    Set UART0 registers, such as BAUDIV and CTRL, to configure the
                     appropriate baud rate for transmission and reception.
                    Begin Flash loader subroutine execution such as memory test, timer0,
                     and timer1 tests etc.
                    Write a 0x4 character (EOP) to terminate the program.
 2.11.6 TimeStamp
                     A 48-bit timestamp counter is included in the ITM. It is clock gated and
2 Architecture                                                                             2.11 Cortex-M3

                 enabled by the Trace Enable (TRCENA) bit of DEMCR (Debug Exception
                 and monitor control register), which is a global enable bit that enables both
                 the Data Watch Trace (DWT) and Instrumentation Trace Module (ITM) on
                 behalf of the debug of the Cortex-M3 microprocessor. The time stamp
                 generator is used during the debug process to set up the break point and
                 marching step, etc.
                 Figure 2-16 DEMCR Register
                 DEMCR寄存器

                 31               25 24 23    20 19 18 17 16 15      11 10 9 8 7 6 5 4 3   1 0

                      Reserved          Reserved              Reserved

                         TRCENA        MON_REQ            VC_HARDERR
                                      MON_STEP                VC_INTERR
                                      MON_PEND               VC_BUSERR
                                        MON_EN              VC_STATERR
                                                             VC_CHKERR
                                                           VC_NOCPERR
                                                             VC_MMERR
                                                              Reserved
                                                         VC_CORERESET

                 Note!
                 TRCENA is the global enable for DWT and ITM:
                     0: DWT and ITM units disabled.
                     1: DWT and ITM units enabled.

 2.11.7 Timer
                     GW1NSR-4C offers an embedded microprocessor system that
                 contains two synchronous standard timers: Timer0 and Timer1. These can
                 be accessed and controlled through the APB1 bus.
                      Timer0 and Timer1 are 32-bit down-counters with the following
                 features:
                     Users can generate an interrupt request signal, TIMERINT, when the
                      counter reaches 0. The interrupt request is held until it is cleared by
                      writing to the INTCLEAR Register.
                     Users can employ the zero-to-one transition of the external input
                      signal, EXTIN, as a timer enable.
                     If the timer count reaches 0 and, at the same time, the software clears
                      a previous interrupt status, the interrupt status is set to 1.
                     The external clock, EXTIN, must be slower than half of the peripheral
                      clock because it is sampled by a double flip-flop before going through
                      edge-detection logic when the external inputs act as a clock.
                     Timer0: EXTIN is hard-wired to GPIO[1].
                     Timer1: EXTIN is hard-wired to GPIO[6].

2 Architecture                                                                                                                             2.11 Cortex-M3

                            Figure 2-17 Timer0/Timer1 Structure View

                        PCLK                                                                                                Synchronizer
                                                Reload value                                     Edge detection
                       PCLKG
                                                                                 CTRL[2]
                     PRESETn                                                                                                                      EXTIN
                                                           Decrement                       1
                         PSEL
                                                32bits down
                  PADDR[11:2]                     counter                                  0    1
                                                                                                          CTRL[1]
                     PENABLE                                                                                        1

                      PWRITE                                           CTRL[0]
                                                                                                                    0   1
             PWDATA[31:0]
                                                                                               SET
                      PREADY                      Val==1

                     PSLVERR                                                                                                                       TIMERINT
                                                                  CTRL[3]
                                                                                               CLR
                 PRDATA[31:0]

           ECOREVNUM[3:0]

                                The Timer0/Timer1 registers are shown in the following table. The
                            base address of Timer0 is 0x40000000 and the base address of Timer1 is
                            0x40001000.
                            Table 2-11 Timer0/ Timer1 Registers
                                                    Widt
  Name                    Base Offset   Type                     Reset Value                              Description
                                                    h
                                                                                                          [3]: System timer interrupt enable
                                        Read/                                                             [2]: Select external input as clock
  CTRL                    0x000                     4            0x0
                                        Write                                                             [1]: Select external input as enable
                                                                                                          [0]: Enable
                                        Read/
  VALUE                   0x004                     32           0x00000000                               Current value
                                        Write
                                        Read/                                                             Reload value. Write to this register
  RELOAD                  0x008                     32           0x00000000
                                        Write                                                             to set the current value.
  INTSTATUS/                            Read/
                          0x00C                     1            0x0                                      [0]: Timer interrupt. Write 1 to clear.
  INTCLEAR                              Write

 2.11.8 UART
                                The microprocessor system of GW1NSR-4C is embedded with two
                            UARTs: UART0 and UART1. These can be accessed and controlled
                            through the APB1 bus. The max. baud rate supported is 921.6Kbits/s.
                                UART0 and UART1support 8 bits communication without parity and
                            one stop bit.

2 Architecture                                                                                             2.11 Cortex-M3

                 Figure 2-18 APB UART Buffering

                              You can write a new character to the write buffer
                              while the shift register is sending out a character

                                                 Write buffer               Shift register              TXD

                                                                              TX FSM

                                                  Baud rate
                    APB                           generator
                  interface

                                                                              RX FSM

                                                 Read buffer                Shift register               RXD

                                                         The shift register can receive the next character
                                                         while the data in the receive buffer is waiting for
                                                                      the processor to read it

                      UART0 and UART support a high-speed test mode. When CTRL[6] is
                 set to 1, the serial data is transmitted at one bit per clock cycle. This
                 enables you to send text messages in a much shorter simulation time. The
                 APB interface always sends an “OK” response with no wait state. You
                 must program the baud rate divider register BAUDDIV before enabling the
                 UART.
                      The BAUDTICK output pulses at a frequency of 16 times that of the
                 programmed baud rate. You can use this external signal for capturing
                 UART data in a synchronous environment. The TXEN output signal
                 indicates the status of CTRL[0]. You can use this signal to switch a
                 bidirectional I/O pin in a silicon device to UART data output mode
                 automatically when the UART transmission feature is enabled.
                      The buffer overrun status in the STATE field is used to drive the
                 overrun interrupt signals. Therefore, clearing the buffer overrun status de-
                 asserts the overrun interrupt, and clearing the overrun interrupt bit also
                 clears the buffer overrun status bit in the STATE field.
                      The UART0/UART1 registers are shown in the following table. The
                 base address of UART0 is 0X40004000 and the base address of UART1
                 is 0X40005000.

2 Architecture                                                                       2.11 Cortex-M3

                  Table 2-12 UART0/ UART1 Registers
                                       Widt
  Name           Base Offset   Type           Reset Value      Description
                                       h
                                                               8-bit data
                               Read/
  DATA           0x000                 8      0x--             Read: received data.
                               Write
                                                               Write: transmited data.
                                                               [3]: RX buffer overrun, write 1 to
                                                               clear.
                               Read/                           [2]: TX buffer overrun, write 1 to
  STATE          0x004                 4      0x0
                               Write                           clear.
                                                               [1]: RX buffer full, read-only.
                                                               [0]: TX buffer full, read-only.
                                                               [6]：High-speed test mode for TX
                                                               only.
                                                               [5]：RX overrun interrupt enable.
                               Read/                           [4]：TX overrun interrupt enable.
  CTRL           0x008                 7      0x00
                               Write                           [3]：RX interrupt enable.
                                                               [2]：TX interrupt enable.
                                                               [1]：RX enable.
                                                               [0]：TX enable.
                                                               [3]：RX overrun interrupt, write 1 to
                                                               clear.
  INTSTATUS/                   Read/                           [2]：TX overrun interrupt, write 1 to
                 0x00C                 4      0x0
  INTCLEAR                     Write                           clear.
                                                               [1]：RX interrupt, write 1 to clear.
                                                               [0]：TX interrupt, write 1 to clear.
                               Read/                           [19:0]: Baud rate divider. The
  BAUDDIV        0x010                 20     0x00000
                               Write                           minimum number is 16.

 2.11.9 Watchdog
                      The microprocessor system of GW1NSR-4C is embedded with a
                  watchdog, which can be accessed and controlled through the APB1 bus.
                        The watchdog module is based on a 32-bit down-counter that is
                  initialized from the reload register, WDOGLOAD.
                       The watchdog module generates a regular interrupt, WDOGINT,
                  depending on a programmed value. The counter decrements by one on
                  each positive clock edge of WDOGCLK when the clock enable,
                  WDOGCLKEN, is active high. The watchdog monitors the interrupt and
                  asserts a reset request WDOGRES signal when the counter reaches 0,
                  and the counter is stopped. On the next enabled WDOGCLK clock edge,
                  the counter is reloaded from the WDOGLOAD register and the countdown
                  sequence continues.
                       The watchdog module applies a reset to a system in the event of a
                  software failure, providing a way to recover from software crashes. For
                  example, if the interrupt is not cleared and the counter reaches 0 again,
                  the watchdog module triggers a system reset.
                         The Watchdog operation is shown in the following figure.

2 Architecture                                                                                          2.11 Cortex-M3

                 Figure 2-19 Watchdog Operation

                                    Count down                        Counter reloaded
                                       without                         and count down
                                     reprogram                        without reprogram
                    Watchdog is                     Counter reaches                       Counter reaches
                    programmed                           zero                                  zero

                                                  If the INTEN bit in the              If the RESEN bit in the
                                              WDOGCONTROL register is set          WDOGCONTROL register is set
                                               to 1, WDOGINT is asserted            to 1, WDOGRES is asserted

                     The watchdog registers are shown in the following table. The
                 watchdog base address is 0x40008000.
                 Table 2-13 Watchdog Registers
                     Base
  Name                            Type    Width         Reset Value            Description
                     Offset
                                  Read/
  WDOGLOAD           0x00                 32            0xFFFFFFFF             Watchdog Load Register
                                  Write
                                  Read
  WDOGVALUE          0x04                 32            0xFFFFFFFF             Watchdog Value Register
                                  only
                                                                               Watchdog Control Register
                                  Read/                                        [1]：
  WDOGCONTROL        0x08                 2             0x0
                                  Write
                                                                               [0]：
                                  Write                                        Watchdog     Interrupt    Clear
  WDOGINTCLR         0x0C                 -             0x-
                                  only                                         Register
                                  Read                                         Watchdog Raw Interrupt Status
  WDOGRIS            0x10                 1             0x0
                                  only                                         Register
                                  Read                                         Watchdog    Interrupt    Status
  WDOGMIS            0x14                 1             0x0
                                  only                                         Register
                                  Read/
  WDOGLOCK           0xC00                32            0x0                    Watchdog Lock Register
                                  Write
                                  Read/                                        Watchdog      Integration   Test
  WDOGTCR            0xF00                1             0x0
                                  Write                                        Control Register
                                  Write                                        Watchdog Integration Test Output
  WDOGTOP            0xF04                2             0x0
                                  only                                         Set Register
                                  Read
  WDOGPERIPHID4      0XFD0                8             0x04                   Peripheral ID Register 4
                                  only
                                  Read
  WDOGPERIPHID5      0XFD4                8             0x00                   Peripheral ID Register 5
                                  only
                                  Read
  WDOGPERIPHID6      0XFD8                8             0x00                   Peripheral ID Register 6
                                  only
                                  Read
  WDOGPERIPHID7      0XFDC                8             0x00                   Peripheral ID Register 7
                                  only
                                  Read
  WDOGPERIPHID0      0XFE0                8             0x24                   Peripheral ID Register 0
                                  only
                                  Read
  WDOGPERIPHID1      0XFE4                8             0XB8                   Peripheral ID Register 1
                                  only
                                  Read
  WDOGPERIPHID2      0XFE8                8             0X1B                   Peripheral ID Register 2
                                  only
                                  Read
  WDOGPERIPHID3      0XFEC                8             0X00                   Peripheral ID Register 3
                                  only

2 Architecture                                                                         2.11 Cortex-M3

                     Base
  Name                        Type       Width      Reset Value   Description
                     Offset
                              Read
  WDOGPCELLID0       0XFF0               8          0X0D          Component ID Register 0
                              only
                              Read
  WDOGPCELLID1       0XFF4               8          0XF0          Component ID Register 1
                              only
                              Read
  WDOGPCELLID2       0XFF8               8          0X05          Component ID Register 2
                              only
                              Read
  WDOGPCELLID3       0XFFC               8          0XB1          Component ID Register 3
                              only

 2.11.10 GPIO
                      The microprocessor system of GW1NSR-4C communicates with the
                 GPIO block through the AHB bus. The GIPO block interconnects with the
                 FPGA. The GPIO block provides a 16-bit I/O interface with the following
                 features:
                    Programmable interrupt generation capability. You can configure each
                     bit of the I/O pins to generate interrupts.
                    Bit masking supports the use of address values.
                    Registers for alternate function switching with pin multiplexing support.
                    Thread safe operation by providing separate set and clear addresses
                     for control registers.
                     The GPIO registers are shown in the following table. The base
                 address of GPIO is 0x40010000.
                 Table 2-14 GPIO Registers
                     Base                    Widt
  Name                           Type               Reset Value   Description
                     Offset                  h
                                 Read/
  DATA               0x0000                  16     0x----        Data value [15:0]
                                 Write
                                 Read/
  DATAOUT            0x0004                  16     0x0000        Data output register value [15:0]
                                 Write
                                                                  Output enable set [15:0]
                                                                  Write 1: Sets the output enable
                                                                  bit.
                                 Read/                            Write 0: No effect.
  OUTENSET           0x0010                  16     0x0000
                                 Write                            Read 1: Indicates the signal
                                                                  direction as output.
                                                                  Read 0: Indicates the signal
                                                                  direction as input.
                                 Read/
  OUTENCLR           0x0014                  16     0x0000        Output enable clear [15:0]
                                 Write
                                                                  Alternative function set [15:0]
                                                                  Write 1: Sets the ALTFUNC bit.
                                 Read/
  ALTFUNCSET         0x0018                  16     0x0000        Write 0: No effect.
                                 Write
                                                                  Read 0: GPIO as I/O
                                                                  Read 1: ALTFUNC Function
                                 Read/
  ALTFUNCCLR         0x001C                  16     0x0000        Alternative function clear [15:0]
                                 Write
                                                                  Interrupt enable set [15:0]
                                 Read/
  INTENSET           0x0020                  16     0x0000        Write 1: Sets the enable bit.
                                 Write
                                                                  Write 0: No effect.

2 Architecture                                                                      2.11 Cortex-M3

                     Base               Widt
  Name                          Type           Reset Value    Description
                     Offset             h
                                                              Read 0: Interrupt disabled.
                                                              Read 1: Interrupt enabled.
                                                              Interrupt enable clear [15:0]
                                                              Write 1: Clears the enable bit.
                                Read/
  INTENCLR           0x0024             16     0x0000         Write 0: No effect.
                                Write
                                                              Read 0: Interrupt disabled.
                                                              Read 1: Interrupt enabled.
                                Read/
  INTTYPESET         0x0028             16     0x0000         Interrupt type set [15:0]
                                Write
                                Read/
  INTTYPECLR         0x002C             16     0x0000         Interrupt type clear [15:0]
                                Write
                                Read/
  INTPOLSET          0x0030             16     0x0000         Interrupt polarity set [15:0]
                                Write
                                Read/
  INTPOLCLR          0x0034             16     0x0000         Interrupt polarity clear [15:0]
                                Write
                                                              Read interrupt status register
  INTSTATUS/                    Read/
                     0x0038             16     0x0000         Write 1: Clears the interrupt
  INTCLEAR                      Write
                                                              request
                     0x0400-    Read/
  MASKLOWBYTE                           16     0x0000         –
                     0x07FC     Write
                     0x0800-    Read/
  MASKHIGHBYTE                          16     0x0000         –
                     0x0BFC     Write
                     0x0C00-
  Reserved                      –       –      –              Reserved
                     0x0FCF

 2.11.11 Debug Access Port
                      The Cortex-M3 processor contains a DAP that consists of a JTAG
                 interface and a TPIU interface. Both of them interface to the FPGA Fabric.
                 The JTAG-DAP is based on the IEEE1149.1 Joint Test Action Group
                 Boundary-Scan Standard.
                      JTAG-DP functions consist of the following three parts:
                    JTAG-DP sate machine
                    Instruction register (IR) and the related IR scan chain, which are used
                     to control JTAG and the current register actions
                    DR register and the related DR scan chain, which connect with the
                     JTAG-DP register.

2 Architecture                                                                          2.12 Clocks

 2.11.12 Memory Mapping
                 Figure 2-20 Memory Mapping

                               0xFFFF_FFFF
                                              SCB
                   Reserved                            0xE000_ED00
                                              NVIC
                    System                             0xE000_E100
                    Control                  SysTick
                     Space                             0xE000_E010
                               0xE000_0000    SCS                               0x4001_1000
                   Reserved                            0xE000_E000     GPIO
                  For External                                                  0x4001_0000
                    Devices                                          Watchdog
                               0xA000_0000
                   Reserved                                                     0x4000_8000
                  For External                                        UART1
                     SRAM                                                       0x4000_5000
                               0x6000_0000                            UART0
                   Peripheral                                                   0x4000_4000
                               0x4000_0000                            Timer1
                   Reserved                                                     0x4000_1000
                               0x2000_4000
                    SRAM                                              Timer0
                               0x2000_0000
                                                                                0x4000_0000
                   Reserved
                               0x0002_0000
                  Code flash
                               0x0000_0000

 2.11.13 Application
                      The Gowin software supports the call of Cortex-M3. For more
                 information, please refer to IPUG932, Gowin_EMPU(GW1NS-4C)
                 Hardware Design Reference Manual.

 2.12 Clocks
                      The clock resources and wiring are critical for high-performance
                 applications in FPGA. The GW1NSR series of FPGA products provide
                 global clocks (GCLKs) which connect to all the registers directly. In
                 addition, high-speed clocks (HCLKs), PLLs, etc. are provided.
                    For more information on the GCLKs, HCLKs, PLLs, see UG286,
                 Gowin Clock User Guide.
 2.12.1 Global Clocks
                     The Global Clock(GCLK) resources are distributed across multiple
                 quadrants within the GW1NSR series of FPGA products
                 (Automotive).Each quadrant provides eight GCLKs. The clock sources of
                 GCLKs include dedicated clock input pins and CRUs, and better clock
                 performance can be achieved by using the dedicated clock input pins.
 2.12.2 PLLs
                     The PLL (Phase-locked Loop) is a feedback control circuit. The
                 frequency and phase of the internal oscillator signal are controlled by the
                 external input reference clock.
                     PLLs in the GW1NSR series of FPGA products can provide
                 synthesizable clock frequencies. Frequency adjustment (multiplication and

2 Architecture                                                                  2.13 Long Wires

                 division), phase adjustment, and duty cycle adjustment can be achieved
                 by configuring the parameters.
 2.12.3 High-speed Clocks
                     The high-speed clocks (HCLKs) are designed to facilitate high-
                 performance I/O data transmission and are specifically tailored for source
                 synchronous data transmission protocols. The GW1NSR-4C/4 devices
                 have two HCLKs on each side, see Figure 2-21.
                 Figure 2-21 GW1NSR-4/4C HCLK Distribution
                          I/O Bank0         I/O Bank1

                                      T

                                                        I/O Bank2
                                                  R

                                      B

                                 I/O Bank3
                                  IO Bank       HCLK

 2.13 Long Wires
                     As a supplement to the CRU, the GW1NSR series of FPGA products
                 provide another kind of routing resource - the long wire, which can be
                 used for clock, clock enable, set/reset, or other high fan-out signals.

 2.14 Global Set/Reset
                      The GW1NSR series of FPGA products offer a dedicated global
                 set/reset (GSR) network that connects directly to the device's internal logic
                 and can be used as asynchronous/synchronous set or
                 asynchronous/synchronous reset, with the registers in the CLUs and I/Os
                 being able to be configured independently.

2 Architecture                                                        2.15 Programming & Configuration

 2.15 Programming & Configuration
                     The GW1NSR series of FPGA products support SRAM configuration
                 and Flash programming. Flash programming includes on-chip Flash
                 programming and off-chip Flash programming.
                      In addition to JTAG, the GW1NSR series of FPGA products also
                 support Gowin’s own GowinCONFIG configuration modes: AUTO BOOT,
                 SSPI, MSPI, DUAL BOOT, SERIAL, and CPU. All the GW1NSR FPGAs
                 support JTAG mode and AUTO BOOT mode. For more information, please
                 refer to UG290, Gowin FPGA Products Programming and Configuration
                 User Guide.
 2.15.1 SRAM Configuration
                    If SRAM configuration is used, the configuration data needs to be re-
                 downloaded after each power-up.
 2.15.2 Flash Programming
                       The Flash programming data is stored in the on-chip Flash. Each time
                 the device is powered up, the configuration data is transferred from the
                 Flash to the SRAM. Configuration can be completed within a few
                 milliseconds after power-up, which is why this kind of configuration is also
                 known as “instant on”.
                     In addition, the GW1NSR series of FPGA products support off-chip
                 Flash programming and DUAL BOOT. For more information, please refer
                 to UG290, Gowin FPGA Products Programming and Configuration User
                 Guide.
                      The GW1NSR series of FPGA products support the feature of
                 background upgrade. That is to say, you can program the on-chip Flash or
                 off-chip Flash via the JTAG[1] interface without affecting the current
                 working state. During programming, the device works according to the
                 previous configuration. After the programming is done, you can trigger
                 RECONFIG_N[2] with a low level to complete the upgrade. This feature is
                 suitable for the applications requiring long online time and irregular
                 upgrades.
                 Note!
                     [1]
                     For the GW1NSR-4C device, the JTAG background upgrade feature is not
                     available if its embedded Cortex-M3 is used.
                     [2]
                      As a configuration pin, RECONFIG_N is an input pin with internal weak pull-up,
                     but as a GPIO, RECONFIG_N can only be used for output. For more information,
                     please refer to UG290, Gowin FPGA Products Programming and Configuration User
                     Guide.

 2.16 On-chip Oscillator
                     The GW1NSR series of FPGA products have an embedded
                 programmable on-chip clock oscillator which provides a clock source for
                 the MSPI configuration mode with a tolerance of ±5%.
                      The on-chip oscillator of the GW1NSR-4C/4 device supports user-

2 Architecture                                                                              2.16 On-chip Oscillator

                     configurable power saving mode.
                         The on-chip oscillator also provides a clock resource for user designs.
                     Up to 64 clock frequencies can be obtained by setting the parameters.
                         The following formula is used to get the output clock frequency of the
                     on-chip oscillator of GW1NSR-4C/4:
                                                    fout=fosc/Param
                     Note!
                     For C7/I6 speed grade devices, fosc is 260MHz; for other speed grade devices, fosc is
                     250MHz. “Param” should be even numbers from 2 to 128.
                          The table below lists some frequencies provided by the on-chip
                     oscillator for fosc = 250 MHz.
                     Table 2-15 Output Frequency Options of the On-chip Oscillator of GW1NSR-4/4C

  Mode           Frequency                     Mode          Frequency               Mode     Frequency
  0              2.5MHz[1]                     8             7.8MHz                  16       15.6MHz
  1              5.4MHz                        9             8.3MHz                  17       17.9MHz
  2              5.7MHz                        10            8.9MHz                  18       21MHz
  3              6.0MHz                        11            9.6MHz                  19       25MHz
  4              6.3MHz                        12            10.4MHz                 20       31.3MHz
  5              6.6MHz                        13            11.4MHz                 21       41.7MHz
  6              6.9MHz                        14            12.5MHz                 22       62.5MHz
  7              7.4MHz                        15            13.9MHz                 23       125MHz[2]
                     Note!
                             [1]
                                  Default frequency.
                             [2]
                                  This is not available for the MSPI configuration mode.

3 DC and Switching Characteristics                                                          3.1 Operating Conditions

                   3          DC and Switching Characteristics

                     Note!
                     Please ensure that you use Gowin’s devices within the recommended operating
                     conditions and ranges. Data beyond the working conditions and ranges are for reference
                     only. Gowin does not guarantee that all devices will operate normally beyond the
                     operating conditions and ranges.

 3.1 Operating Conditions
 3.1.1 Absolute Max. Ratings
                     Table 3-1 Absolute Max. Ratings

  Name                                               Description                          Min.         Max.
  VCC                                                Core voltage                         -0.5V        1.32V
  VCCIOx                                             I/O Bank voltage                     -0.5V        3.75V
  VCCX                                               Auxiliary voltage(LV version)        -0.5V        3.75V
  -                                                  I/O voltage applied[1]               -0.5V        3.75V
  Storage Temperature                                Storage temperature                  -65℃         +150℃
  Junction Temperature                               Junction temperature                 -40℃         +125℃
                     Note!
                     [1]
                           Overshoot and undershoot of -2V to (VIHMAX + 2)V are allowed for a duration of <20 ns.

 3.1.2 Recommended Operating Conditions
                     Table 3-2 Recommended Operating Conditions

  Name              Description                                                    Min.               Max.
  VCC               Core voltage                                                   1.14V              1.26V
  VCCX              Auxiliary voltage(LV version)                                  1.71V              3.6V
  VCCIOx            I/O Bank voltage (LV version)                                  1.14V              3.6V
  TJCOM             Junction temperature for commercial operations                 0℃                 +85℃
  TJIND             Junction temperature for industrial operations                 -40℃               +100℃
                     Note!
                            For more information on the power supplies, please refer to UG864, GW1NSR-4
                             Pinout and UG865, GW1NSR-4C Pinout .

3 DC and Switching Characteristics                                                         3.1 Operating Conditions

                           The allowable ripples on VCC, VCCIO, and VCCX are 3%, 5%, and 5% respectively. 1).
                            For devices of which the PLL is powered directly with VCC, the ripple on VCC can
                            affect the jitter characteristics of the PLL output clock; 2). The ripple on VCCIO can
                            eventually be passed on to the output waveform of the IO Buffer.

 3.1.3 Power Supply Ramp Rates
                     Table 3-3 Power Supply Ramp Rates

  Name             Description                              Min.              Typ.               Max.
  VCC Ramp         Power supply ramp rates for VCC          0.6mV/μs          -                  6mV/μs
  VCCX Ramp        Power supply ramp rates for VCCX         0.6mV/μs          -                  10mV/μs
  VCCIO Ramp       Power supply ramp rates for VCCIO        0.1mV/μs          -                  10mV/μs
                     Note!
                           A monotonic ramp is required for all power supplies.
                           All power supplies need to be in the operating range as defined in Table 4-2 before
                            configuration. Power supplies that are not in the operating range need to be adjusted
                            to a faster ramp rate, or you have to delay configuration.

 3.1.4 Hot Socketing Specifications
                     Table 3-4 Hot Socketing Specifications

  Name        Description                               Condition                    I/O Type        Max.
  IHS         Input or I/O leakage current              0<VIN<VIH(MAX)               I/O             150uA
                                                                                     TDI,TDO,
  IHS         Input or I/O leakage current              0<VIN<VIH(MAX)                               120uA
                                                                                     TMS,TCK

 3.1.5 POR Specifications
                     Table 3-5 POR Parameters

  Name                Description                                   Min.                      Max.
  POR Voltage         Power on reset voltage of Vcc                 TBD                       TBD

3 DC and Switching Characteristics                                                            3.2 ESD performance

 3.2 ESD performance
                     Table 3-6 GW1NSR ESD - HBM

  Device                              QN48                                      MG64
  GW1NSR-4C                           HBM>1,000V                                HBM>1,000V
  GW1NSR-4                            -                                         HBM>1,000V
                     Table 3-7 GW1NSR ESD - CDM

  Device                                           QN48                            MG64
  GW1NSR-4C                                        CDM>500V                        CDM>500V
  GW1NSR-4                                         -                               CDM>500V

 3.3 DC Electrical Characteristics
 3.3.1 DC Electrical Characteristics over Recommended Operating
 Conditions
                     Table 3-8 DC Electrical Characteristics over Recommended Operating Conditions

  Name       Description             Condition                              Min.          Typ.        Max.
             Input    or     I/O     VCCIO<VIN<VIH(MAX)                     -             -           210µA
  IIL,IIH
             leakage current         0V<VIN<VCCIO                           -             -           10µA
             I/O Active Pull-up
  IPU                                0<VIN<0.7VCCIO                         -30µA         -           -150µA
             Current
             I/O Active Pull-
  IPD                                VIL(MAX)<VIN<VCCIO                     30µA          -           150µA
             down Current
             Bus Hold Low
  IBHLS                              VIN=VIL(MAX)                           30µA          -           -
             Sustaining Current
             Bus Hold High
  IBHHS                              VIN=0.7VCCIO                           -30µA         -           -
             Sustaining Current
             Bus Hold Low
  IBHLO                              0≤VIN≤VCCIO                            -             -           150µA
             Overdrive Current
             Bus Hold High
  IBHHO                              0≤VIN≤VCCIO                            -             -           -150µA
             Overdrive Current
             Bus    Hold    Trip
  VBHT                                                                      VIL(MAX)      -           VIH(MIN)
             Points
  C1         I/O Capacitance                                                              5pF         8pF
                                     VCCIO   =3.3V, Hysteresis=L2H[1],[2]   -             200mV       -
                                     VCCIO=2.5V, Hysteresis= L2H            -             125mV       -
                                     VCCIO=1.8V, Hysteresis= L2H            -             60mV        -
                                     VCCIO=1.5V, Hysteresis= L2H            -             40mV        -
             Hysteresis      for     VCCIO=1.2V, Hysteresis= L2H            -             20mV        -
  VHYST      Schmitt    Trigger
             inputs                  VCCIO=3.3V, Hysteresis= H2L[1],[2]     -             200mV       -
                                     VCCIO=2.5V, Hysteresis= H2L            -             125mV       -
                                     VCCIO=1.8V, Hysteresis= H2L            -             60mV        -
                                     VCCIO=1.5V, Hysteresis= H2L            -             40mV        -
                                     VCCIO=1.2V, Hysteresis= H2L            -             20mV        -

3 DC and Switching Characteristics                                                         3.3 DC Electrical Characteristics

  Name        Description                 Condition                              Min.               Typ.       Max.
                                          VCCIO=3.3V,          Hysteresis=
                                                                                 -                  400mV      -
                                          HIGH[1],[2]
                                          VCCIO=2.5V, Hysteresis= HIGH           -                  250mV      -
                                          VCCIO=1.8V, Hysteresis= HIGH           -                  120mV      -
                                          VCCIO=1.5V, Hysteresis= HIGH           -                  80mV       -
                                          VCCIO=1.2V, Hysteresis= HIGH           -                  40mV       -
                     Note!
                            [1]
                             Hysteresis=“NONE”, “L2H”, “H2L”, “HIGH” indicates the Hysteresis options that
                            can be set when setting I/O Constraints in the FloorPlanner tool of Gowin EDA, for
                            more details, see SUG935, Gowin Design Physical Constraints User Guide.
                            [2]
                             Enabling the L2H (low to high) option means raising VIH by VHYST; enabling the
                            H2L (high to low) option means lowering VIL by VHYST; enabling the HIGH option
                            means enabling both L2H and H2L options, i.e. VHYST(HIGH) = VHYST(L2H) +
                            VHYST(H2L). The diagram is shown below.

                                                               VIH (L2H on)
                                                      VHYST

                                         VIH (None)                           VIL (None)

                                                                                            VHYST
                                                                                                     VIL (H2L on)

 3.3.2 Static Current
                     Table 3-9 Static Current[1]

                                                      Device
  Name       Description                                           Device              C7/I6         C6/I5         C5/I4
                                                      type

                                                                   GW1NSR-
  ICC        VCC current (VCC=1.2V)                   LV version                       12mA          2.8mA         2.8mA
                                                                   4/4C

                                                                   GW1NSR-
             VCCX current (VCCX=2.5V)                 LV version                       -             1.2mA         1.2mA
                                                                   4/4C
  ICCX
                                                                   GW1NSR-
             VCCX current (VCCX=3.3V)                 LV version                       3mA           -             -
                                                                   4/4C

                                                                   GW1NSR-
  ICCIO[2]   VCCIO current (VCCIO=2.5V)               LV version                       1mA           0.7mA         0.7mA
                                                                   4/4C

                     Note!
                            [1]
                                 The values in the table are typical values at 25℃.
                            [2]
                              There are two PSRAMs integrated in GW1NSR-4/4C MG64P, and the VCCIO static
                            current will increase by 300uA x 2=600uA when it is used. There is one HyperRAM
                            integrated in GW1NSR-4C QN48P, and the VCCIO static current will increase by
                            220uA when it is used. There is one NOR Flash integrated in GW1NSR-4C QN48G,
                            and the VCCIO static current will increase by 40uA when it is used.

3 DC and Switching Characteristics                                     3.3 DC Electrical Characteristics

 3.3.3 Recommended I/O Operating Conditions
                     Table 3-10 Recommended I/O Operating Conditions

                          VCCIO (V) for Output              VREF (V) for Input
  Name
                          Min.          Typ.     Max.       Min.          Typ.            Max.
  LVTTL33                 3.135         3.3      3.6        -             -               -
  LVCMOS33                3.135         3.3      3.6        -             -               -
  LVCMOS25                2.375         2.5      2.625      -             -               -
  LVCMOS18                1.71          1.8      1.89       -             -               -
  LVCMOS15                1.425         1.5      1.575      -             -               -
  LVCMOS12                1.14          1.2      1.26       -             -               -
  SSTL15                  1.425         1.5      1.575      0.68          0.75            0.9
  SSTL18_I                1.71          1.8      1.89       0.833         0.9             0.969
  SSTL18_II               1.71          1.8      1.89       0.833         0.9             0.969
  SSTL25_I                2.375         2.5      2.645      1.15          1.25            1.35
  SSTL25_II               2.375         2.5      2.645      1.15          1.25            1.35
  SSTL33_I                3.135         3.3      3.6        1.3           1.5             1.7
  SSTL33_II               3.135         3.3      3.6        1.3           1.5             1.7
  HSTL18_I                1.71          1.8      1.89       0.816         0.9             1.08
  HSTL18_II               1.71          1.8      1.89       0.816         0.9             1.08
  HSTL15                  1.425         1.5      1.575      0.68          0.75            0.9
  PCI33                   3.135         3.3      3.6        -             -               -
  LVPECL33E               3.135         3.3      3.6        -             -               -
  MLVDS25E                2.375         2.5      2.625      -             -               -
  BLVDS25E                2.375         2.5      2.625      -             -               -
  RSDS25E                 2.375         2.5      2.625      -             -               -
  LVDS25E                 2.375         2.5      2.625      -             -               -
  SSTL15D                 1.425         1.5      1.575      -             -               -
  SSTL18D_I               1.71          1.8      1.89       -             -               -
  SSTL18D_II              1.71          1.8      1.89       -             -               -
  SSTL25D_I               2.375         2.5      2.625      -             -               -
  SSTL25D_II              2.375         2.5      2.625      -             -               -
  SSTL33D_I               3.135         3.3      3.6        -             -               -
  SSTL33D_II              3.135         3.3      3.6        -             -               -
  HSTL15D                 1.425         1.575    1.89       -             -               -
  HSTL18D_I               1.71          1.8      1.89       -             -               -
  HSTL18D_II              1.71          1.8      1.89       -             -               -

3 DC and Switching Characteristics                                               3.3 DC Electrical Characteristics

 3.3.4 Single-ended I/O DC Characteristics
                     Table 3-11 Single-ended I/O DC Characteristics

                  VIL                        VIH                     VOL          VOH             IOL[1]    IOH[1]
  Name
                  Min      Max               Min              Max    (Max)        (Min)           (mA)      (mA)
                                                                                                  4         -4
                                                                                                  8         -8
  LVCMOS33                                                           0.4V         VCCIO-0.4V      12        -12
                  -0.3V    0.8V              2.0V             3.6V
  LVTTL33                                                                                         16        -16
                                                                                                  24        -24
                                                                     0.2V         VCCIO-0.2V      0.1       -0.1
                                                                                                  4         -4
                                                                                                  8         -8
                                                                     0.4V         VCCIO-0.4V
  LVCMOS25        -0.3V    0.7V              1.7V             3.6V                                12        -12
                                                                                                  16        -16
                                                                     0.2V         VCCIO-0.2V      0.1       -0.1
                                                                                                  4         -4
                                                                     0.4V         VCCIO-0.4V      8         -8
  LVCMOS18        -0.3V    0.35*VCCIO        0.65*VCCIO       3.6V                                12        -12
                                                                                  VCCIO-0.2V      0.1       -0.1
                                                                     0.2V
                                                                                                  4         -4
                                                                     0.4V         VCCIO-0.4V
  LVCMOS15        -0.3V    0.35*VCCIO        0.65*VCCIO       3.6V                                8         -8
                                                                     0.2V         VCCIO-0.2V      0.1       -0.1
                                                                                                  4         -4
                                                                     0.4V         VCCIO-0.4V
  LVCMOS12        -0.3V    0.35*VCCIO        0.65*VCCIO       3.6V                                8         -8
                                                                     0.2V         VCCIO-0.2V      0.1       -0.1
  PCI33           -0.3V    0.3*VCCIO         0.5*VCCIO        3.6V   0.1*VCCIO 0.9*VCCIO          1.5       -0.5
  SSTL33_I        -0.3V    VREF-0.2V         VREF+0.2V        3.6V   0.7          VCCIO-1.1V      8         -8
  SSTL25_I        -0.3V    VREF-0.18V        VREF+0.18V       3.6V   0.54V        VCCIO-0.62V 8             -8
  SSTL25_II       -0.3V    VREF-0.18V        VREF+0.18V       3.6V   NA           NA              NA        NA
  SSTL18_II       -0.3V    VREF-0.125V       VREF+0.125V      3.6V   NA           NA              NA        NA
  SSTL18_I        -0.3V    VREF-0.125V       VREF+0.125V      3.6V   0.40V        VCCIO-0.40V 8             -8
  SSTL15          -0.3V    VREF-0.1V         VREF+ 0.1V       3.6V   0.40V        VCCIO-0.40V 8             -8
  HSTL18_I        -0.3V    VREF-0.1V         VREF+ 0.1V       3.6V   0.40V        VCCIO-0.40V 8             -8
  HSTL18_II       -0.3V    VREF-0.1V         VREF+ 0.1V       3.6V   NA           NA              NA        NA
  HSTL15_I        -0.3V    VREF-0.1V         VREF+ 0.1V       3.6V   0.40V        VCCIO-0.40V 8             -8
  HSTL15_II       -0.3V    VREF-0.1V         VREF+ 0.1V       3.6V   NA           NA              NA        NA
                     Note!
                     [1]
                        The total DC current limit(sourced and sunk current) of all IOs in the same bank: the
                     total DC current of all IOs in the same bank shall not be greater than n*8mA, where n
                     represents the number of IOs bonded out from a bank.

3 DC and Switching Characteristics                                                    3.4 Switching Characteristics

 3.3.5 Differential I/O DC Characteristics
                     Table 3-12 Differential I/O DC Characteristics (LVDS)

  Name          Description                            Test conditions      Min.        Typ.        Max.      Unit
  VINA,VINB     Input Voltage                                               0           -           2.15      V
                                                       Half the Sum of
  VCM           Input Common Mode Voltage                                   0.05        -           2.1       V
                                                       the Two Inputs
                                                       Difference
  VTHD          Differential Input Threshold           Between the Two      ±100        -           ±600      mV
                                                       Inputs
                                                       Power     On   or
  IIN           Input Current                                               -           -           ±20       µA
                                                       Power Off
                Output High Voltage for VOP or
  VOH                                                  RT = 100Ω            -           -           1.60      V
                VOM
  VOL           Output Low Voltage for VOP or VOM      RT = 100Ω            0.9         -           -         V
                                                       (VOP    -    VOM),
  VOD           Output Voltage Differential                                 250         350         450       mV
                                                       RT=100Ω
                Change in VOD Between High and
  ΔVOD                                                                      -           -           50        mV
                Low
                                                       (VOP + VOM)/2,
  VOS           Output Voltage Offset                                       1.125       1.20        1.375     V
                                                       RT=100Ω
                Change in VOS Between High and
  ΔVOS                                                                      -           -           50        mV
                Low
                                                       VOD = 0V outputs
  IS            Short-circuit current                                       -           -           15        mA
                                                       short-circuited

 3.4 Switching Characteristics
 3.4.1 CLU Switching Characteristics
                     Table 3-13 CLU Timing Parameters

                                                                                Speed Grade
  Name                  Description                                                                         Unit
                                                                                Min         Max
  tLUT4_CLU             LUT4 delay                                              -           0.674           ns
  tSR_CLU               Set/Reset to Register output                            -           1.86            ns
  tCO_CLU               Clock to Register output                                -           0.76            ns

3 DC and Switching Characteristics                                              3.4 Switching Characteristics

 3.4.2 Clock and I/O Switching Characteristics
                     Table 3-14 External Switching Characteristics

                                      C5/I4                     C6/I5
  Name                                                                                            Unit
                                      Min         Max           Min              Max
  HCLK Tree delay                     0.8         1.4           0.5              1.2              ns
  PCLK Tree delay(GCLK0~5)            1.4         2.6           1.0              2.2              ns
  PCLK Tree delay(GCLK6~7)            1.8         3.2           1.4              2.9              ns
  Pin-LUT-Pin Delay                   3.4         5             3                4.5              ns

 3.4.3 Gearbox Switching Characteristics
                     Table 3-15 Gearbox Timing Parameters

  Name               Description                                              Typ.                 Unit
  FMAXIDDR           1:2 Gearbox maximum serial input rate                    400                  Mbps
  FMAXIDES4          1:4 Gearbox maximum serial input rate                    800                  Mbps
  FMAXIDES7          1:7 Gearbox maximum serial input rate                    1000                 Mbps
  FMAXIDESx          1:8/1:10/1:16 Gearbox maximum serial input rate          1100                 Mbps
  FMAXODDR           2:1 Gearbox maximum serial output rate                   400                  Mbps
  FMAXOSER4          4:1 Gearbox maximum serial output rate                   800                  Mbps
  FMAXOSER7          7:1 Gearbox maximum serial output rate                   1000                 Mbps
  FMAXOSERx          8:1/10:1/16:1 Gearbox maximum serial output rate         1100                 Mbps
                     Table 3-16 Single-ended IO Fmax

                          Fmax
  Name
                          Min.(MHz)
                          Drive Strength = 4mA                       Drive Strength > 4mA
  LVTTL33                 150                                        300
  LVCMOS33                150                                        300
  LVCMOS25                150                                        300
  LVCMOS18                150                                        300
  LVCMOS15                150                                        200
  LVCMOS12                150                                        150
                     Note!
                     Test load = 30pF.

3 DC and Switching Characteristics                                            3.4 Switching Characteristics

 3.4.4 BSRAM Switching Characteristics
                     Table 3-17 BSRAM Timing Parameters
                                                                           Speed Grade
  Name                  Description                                                               Unit
                                                                           Min     Max
  tCOAD_BSRAM           Clock to output time of read address/data          -       5.10           ns
  tCOOR_BSRAM           Clock to output time of output register            -       0.56           ns

 3.4.5 DSP Switching Characteristics
                     Table 3-18 DSP Timing Parameters
                                                                           Speed Grade
  Name                  Description                                                               Unit
                                                                           Min     Max
  tCOIR_DSP             Clock to output time of input register             -       4.80           ns
  tCOPR_DSP             Clock to output time of pipeline register          -       2.40           ns
  tCOOR_DSP             Clock to output time of output register            -       0.84           ns

 3.4.6 On-chip Oscillator Switching Characteristics
                     Table 3-19 On-chip Oscillator Parameters

  Name          Description                                    Min.        Typ.            Max.
                On-chip Oscillator
                Output Frequency        GW1NSR-4/4C            118.75MHz   125MHz          131.25MHz
                (0 ~ +85℃)
  fMAX
                On-chip Oscillator
                Output Frequency        GW1NSR-4/4C            112.5MHz    125MHz          137.5MHz
                (-40 ~ +100℃)
  tDT           Output Clock Duty Cycle                        43%         50%             57%
  tOPJIT        Output Clock Period Jitter                     0.01UIPP    0.012UIPP       0.02UIPP

3 DC and Switching Characteristics                                              3.5 Cortex-M3 AC/DC Characteristics

 3.4.7 PLL Switching Characteristics
                     Table 3-20 PLL Parameters

  Device                Speed Grade                 Name                   Min.                  Max.
                                                    CLKIN                  3MHz                  400MHz
                        C7/I6                       PFD                    3MHz                  400MHz
                        C6/I5                       VCO                    400MHz                1200MHz
  GW1NSR-4/                                         CLKOUT                 3.125MHz              600MHz
  GW1NSR-4C                                         CLKIN                  3MHz                  320MHz
                                                    PFD                    3MHz                  320MHz
                        C5/I4
                                                    VCO                    320MHz                960MHz
                                                    CLKOUT                 2.5MHz                480MHz

 3.5 Cortex-M3 AC/DC Characteristics
 3.5.1 DC Electrical Characteristics
                     Table 3-21 Current Characteristics

                                          Specification
  Symbol         Description                                                                             Unit
                                          Min.                      Max.
  IVCC           Max. current of VCC      -                         100                                  mA
  IVSS           Max. current of VSS      -                         -100                                 mA
  IINJ           Leakage current          -                         +/-5                                 mA

 3.5.2 AC Electrical Characteristics
                     Table 3-22 Clock Parameters

                                                          Specification
  Symbol          Description        Device                                                       Unit
                                                          Min.             Max.
                  AHB clock
  fHCLK                              GW1NSR-4C            0                80                     MHz
                  frequency
                  APB clock
  fPCLK                              GW1NSR-4C            0                80                     MHz
                  frequency

3 DC and Switching Characteristics                                                    3.6 User Flash Characteristics(GW1NSR-4)

 3.6 User Flash Characteristics(GW1NSR-4)
 3.6.1 DC Electrical Characteristics
                        Table 3-23 GW1NSR-4 User Flash DC Characteristics[1], [4]

                            Parame            Max.                            Wake-up
  Name                                                             Unit                     Condition
                            ter               VCC[3]     VCCX                 time
  Read mode(w/I                                                                             Minimum clock period, 100%
                                              2.19       0.5       mA         NA
  25ns)                                                                                     duty cycle , VIN = “1/0”
  Write mode                                  0.1        12        mA         NA            –
                            ICC1[2]
  Erase mode                                  0.1        12        mA         NA            –
  Page     erase
                                              0.1        12        mA         NA            –
  mode
                                                                                            XE=YE=SE=“1”,           between
                                                                                            T=Tacc and T=50ns, the I/O
  Static        read
                                                                                            current is 0mA. After T=50ns,
  current        (25-       ICC2              980        25        μA         NA
                                                                                            the internal timer turns off read
  50ns)
                                                                                            mode, and the I/O current turns
                                                                                            out to be the standby current.
  Standby mode              ISB               5.2        20        μA         0             VSS, VCCX, and VCC
                        Note!
                                  [1]
                                   These values are average DC currents and the peak currents will be higher than
                                  these average currents.
                                  [2]
                                       ICC1 calculation in different cycle time of Tnew.
                                  -       Tnew< Tacc: not allowed.
                                  -       Tnew = Tacc : see the table above.
                                  -       Tacc<Tnew - 50ns：ICC1 (new) = (ICC1 - ICC2)(Tacc/Tnew) + ICC2
                                  -       Tnew>50ns：ICC1 (new) = (ICC1 - ICC2)(Tacc/Tnew) + 50ns*ICC2/Tnew + ISB
                                  -       t > 50ns：ICC2 = ISB
                                  [3]
                                       VCC must be greater than 1.08V from time zero of the wake-up time.

3 DC and Switching Characteristics                                         3.6 User Flash Characteristics(GW1NSR-4)

 3.6.2 AC Electrical Characteristics
                     Table 3-24 GW1NSR-4 User Flash Parameters[1], [4], [5]

  User Mode                      Parameter               Symbol        Min.             Max.            Unit
                                 WC1                                   -                25              ns
                                 TC                                    -                22              ns
  Access time                    BC                      Tacc   [2]    -                21              ns
                                 LT                                    -                21              ns
                                 WC                                    -                25              ns
  Program/Erase to data storage setup time               Tnvs          5                -               μs
  Data storage hold time                                 Tnvh          5                -               μs
  Data storage hold time(mass erase)                     Tnvh1         100              -               μs
  Data storage to program setup time                     Tpgs          10               -               μs
  Program hold time                                      Tpgh          20               -               ns
  Program time                                           Tprog         8                16              μs
  Write prepare time                                     Twpr          >0               -               ns
  Write hold time                                        Twhd          >0               -               ns
  Control to program/erase setup time                    Tcps          -10              -               ns
  SE to read control setup time                          Tas           0.1              -               ns
  Positive pulse width of SE                             Tpws          5                -               ns
  Address/data setup time                                Tads          20               -               ns
  Address/data hold time                                 Tadh          20               -               ns
  Data hold time                                         Tdh           0.5              -               ns
                                 WC1                     Tah           25               -               ns
                                 TC                      -             22               -               ns
  Address hold time in
                                 BC                      -             21               -               ns
  read mode
                                 LT                      -             21               -               ns
                                 WC                      -             25               -               ns
  Negative pulse width of SE                             Tnws          2                -               ns
  Recovery time                                          Trcv          10               -               μs
  Data storage time                                      Thv[3]        -                6               ms
  Erase time                                             Terase        100              120             ms
  Mass erase time                                        Tme           100              120             ms
  Wake-up time of power-down to standby                  Twk_pd        7                -               μs
  Standby hold time                                      Tsbh          100              -               ns
  VCC setup time                                         Tps           0                -               ns
  VCCX hold time                                         Tph           0                -               ns
                     Note!
                          [1]
                               The values are simulation data and are subject to change.
                          [2]
                          After XADR, YADR, XE, and YE are valid, Tacc starts at the rising edge of SE.
                          DOUT will be kept before the next valid read operation starts.

3 DC and Switching Characteristics                                        3.6 User Flash Characteristics(GW1NSR-4)

                          [3]
                            Thv is the cumulative time from the start of the write operation to the next data
                          erase operation. The same address cannot be written twice before the next erase;
                          the same memory cell cannot be written twice before the next erase. This limitation
                          is for security reasons.
                          [4]
                               All waveforms have a 1ns rising time and a 1ns falling time.
                          [5]
                           Control signals(X, YADR, XE, and YE) need to be held for at least Tacc, which
                          starts at the rising edge of SE.

 3.6.3 Timing Diagrams
                     Figure 3-1 Read Timing

                     Figure 3-2 Program Timing

3 DC and Switching Characteristics                   3.7 Configuration Interface Timing Specification

                     Figure 3-3 Erase Timing

 3.7 Configuration Interface Timing Specification
                         The GW1NSR series of FPGA products support 6 GowinCONFIG
                     modes: AUTO BOOT, SSPI, MSPI, DUAL BOOT, SERIAL, and CPU. For
                     more information, please refer to UG290, Gowin FPGA Products
                     Programming and Configuration User Guide.

4 Ordering Information                                                                          4.1 Part Naming

                                                  4       Ordering Information

 4.1 Part Naming
                         Note!
                            For more information about the packages, please refer to 1.2 Product Resources
                             and 1.3 Package Information.
                            The LittleBee family devices and Arora family devices of the same speed grade have
                             different speeds.
                            Both “C” and “I” are used in Gowin’s part name marking for one device. GOWIN
                             devices are screened using industrial standards, so the same device can be used for
                             both industrial (I) and commercial (C) applications. The maximum temperature of the
                             industrial grade is 100℃, and the maximum temperature of the commercial grade is
                             85℃. Therefore, if the chip meets speed grade 6 in commercial grade applications,
                             its speed grade will be 5 in industrial grade applications.
                         Figure 4-1 Part Naming Examples for GW1NSR-4 Devices– ES
                                   GW1NSR - XX XX XXXXXX ES
           Product Series                                                        Optional Suffix
           GW1NSR                                                                ES Engineering Sample

           Core Supply Voltage                                                   Package Type
           LV Vcc: 1.2V                                                          QN48P (QFN48P, 0.4mm)
                                                                                 MG64P (MBGA64P, 0.5mm)

           Logic Density
           4: 4,608 LUTs

4 Ordering Information                                                                  4.1 Part Naming

                         Figure 4-2 Part Naming Examples for GW1NSR-4C Devices– ES
                               GW1NSR - XX XX      C   XXXXXX ES
       Product Series                                                     Optional Suffix
       GW1NSR                                                             ES Engineering Sample
                                                                          Package Type
       Core Supply Voltage                                                QN48P (QFN48P, 0.4mm)
       LV Vcc: 1.2V                                                       QN48G (QFN48G, 0.4mm)
                                                                          MG64P (MBGA64P, 0.5mm)
       Logic Density
       4: 4,608 LUTs

       C: ARM Cortex-M3

                         Figure 4-3 Part Naming Examples for GW1NSR-4 Devices - Production
                               GW1NSR - XX XX XXXXXX CX/IX
       Product Series                                                  Temperature Range
       GW1NSR                                                          C Commercial 0 to 85
                                                                       I Industrial -40 to 100
       Core Supply Voltage
       LV Vcc: 1.2V                                                    Speed Grade
                                                                       4 Slowest
                                                                       5
                                                                       6
       Logic Density
                                                                       7 Fastest
       4: 4,608 LUTs
                                                                       Package Type
                                                                       QN48P (QFN48P, 0.4mm)
                                                                       MG64P (MBGA64P, 0.5mm)

                         Figure 4-4 Part Naming Examples for GW1NSR-4C Devices - Production
                            GW1NSR - XX XX C       XXXXXX CX/IX
   Product Series                                                      Temperature Range
   GW1NSR                                                              C Commercial 0 to 85
                                                                       I Industrial -40 to 100
   Core Supply Voltage
   LV Vcc: 1.2V                                                        Speed Grade
                                                                       4 Slowest
                                                                       5
   Logic Density                                                       6
   4: 4,608 LUTs                                                       7 Fastest

                                                                       Package Type
  C: ARM Cortex-M3                                                     QN48P (QFN48P, 0.4mm)
                                                                       QN48G (QFN48G, 0.4mm)
                                                                       MG64P (MBGA64P, 0.5mm)

4 Ordering Information                                                                                 4.2 Package Markings

 4.2 Package Markings
                             Gowin’s devices have markings on the their surfaces, as shown in
                         Figure 4-5.
                         Figure 4-5 Package Marking Examples

                                         [3]                                 XXXXXXXXXX            Part Number [1]
                          Part Number                                        XXXXXXXXXX
                                                 XXXXXXXXXXXXXXXXX
                            Date Code                                        YYWW                  Date Code
                                                 YYWW
                           Lot Number                                        LLLLLLLLL             Lot Number
                                                 LLLLLLLLL

                                         [3]                                 XXXXXXXXXX            Part Number[1]
                          Part Number                                        XXXXXXXXXX
                                                 XXXXXXXXXXXXXXXXX                                 Date Code[2]
                          Date Code [2]                                      YYWWX
                                                 YYWWX                                             Lot Number
                           Lot Number                                        LLLLLLLLL
                                                 LLLLLLLLL

                                        [3]
                                                                        Part Number [1]   XXXXXXXXXX
                             Part Number         XXXXXXXXXXXXXXXXX                        XXXXXXXXXX
                               Date Code        YYWWXXXX                   Date Code      YYWWXXXX
                              Lot Number        LLLLLLLLL                 Lot Number      LLLLLLLLL

                         Note!
                                [1]
                                     The first two lines in the right figure(s) above are both the “Part Number”.
                                [2]
                                     The fifth character of the Date Code denotes the version of the device.
                                [3]
                                 Whether the package marking bears the Gowin Logo or not depends on the
                                package type, package size, and Part Number length. The above figure are only
                                examples of the package markings.

5About This Manual                                                                    5.1 Purpose

                                                  5        About This Manual

 5.1 Purpose
                          This data sheet provides a comprehensive overview of the GW1NSR
                     series of FPGA products, including their features, resources, architecture,
                     AC/DC characteristics, and ordering details.

 5.2 Related Documents
                         The latest documents are available at www.gowinsemi.com.
                        UG863, GW1NSR series of FPGA Products Package & Pinout User
                         Guide
                        UG864, GW1NSR-4 Pinout
                        UG865, GW1NSR-4C Pinout

 5.3 Terminology and Abbreviations
                         The terminology and abbreviations used in this manual are shown in
                     Table 5-1.
                     Table 5-1 Terminology and Abbreviations

  Terminology and Abbreviations    Full Name
  AHB                              Advanced High performance Bus
  ALU                              Arithmetic Logic Unit
  APB                              Advanced Peripheral Bus
  ARM                              Advanced RISC Machine
  BSRAM                            Block Static Random Access Memory
  CFU                              Configurable Function Unit
  CLS                              Configurable Logic Section
  CRU                              Configurable Routing Unit
  DAP                              Debug Access Port
  DCS                              Dynamic Clock Selector
  DNL                              Differential Nonlinearity
  DP                               True Dual Port 16K BSRAM

5About This Manual                                                           5.4 Support and Feedback

  Terminology and Abbreviations    Full Name
  DQCE                             Dynamic Quadrant Clock Enable
  DWT                              Data Watchpoint Trace
  FPGA                             Field Programmable Gate Array
  GPIO                             Gowin Programmable Input/output
  INL                              Integral Nonlinearity
  IOB                              Input/Output Block
  ITM                              Instrumentation Trace Macrocell
  LSB                              Least Significant Bit
  LUT4                             4-input Look-up Table
  MG                               MBGA
  NVIC                             Nested Vector Interrupt Controller
  PHY                              Physical Layer
  PLL                              Phase-locked Loop
  QN                               QFN
  REG                              Register
  SAR                              Successive Approximation Register
  SDP                              Semi Dual Port 16K BSRAM
  SFDR                             Spurious-freeDynamic Range
  SINAD                            Signal to Noise And Distortion
  SoC                              System on Chip
  SP                               Single Port 16K BSRAM
  SSRAM                            Shadow Static Random Access Memory
  TDM                              Time Division Multiplexing
  Timer                            Timer
  TimeStamp                        TimeStamp
  TPIU                             Trace Port Interface Unit
  UART                             Universal Asynchronous Receiver/Transmitter
  USB                              Universal Serial Bus
  Watchdog                         Watchdog

 5.4 Support and Feedback
                         Gowin Semiconductor provides customers with comprehensive
                     technical support. If you have any questions, comments, or suggestions,
                     please feel free to contact us directly using the information provided below.
                         Website: www.gowinsemi.com
                         E-mail：support@gowinsemi.com

