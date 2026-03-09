BL702/704/706
Datasheet

Features

 • Wireless                                              • Security

     – 2.4 GHz RF transceiver                                – Secure boot

     – Bluetooth® Specification v5.0                         – Secure debug ports

     – Bluetooth® Low Energy 1Mbps and 2Mbps                 – QSPI Flash On-The-Fly AES Decryption (OTFAD)
                                                               - AES-128, CTR+ mode
     – Bluetooth® Long Range Coded 500Kbps and
       125Kbps                                               – Support AES 128/192/256 bits

     – Zigbee 3.0, Base Device Behavior, Core Stack          – Support MD5, SHA-1/224/256/384/512
       R21, Green Power
                                                             – Support TRNG (True Random Number Genera-
     – IEEE 802.15.4 MAC/PHY                                   tor)

     – Support BLE/zigbee coexistence                        – Support PKA (Public Key Accelerator)

     – Integrated balun, PA/LNA                          • Peripheral

 • MCU Subsystem                                             – USB2.0 FS (Full-Speed) device interface

     – 32-bit RISC CPU with FPU                              – IR remote control interface

     – Level-1 cache                                         – One SPI master/slave

     – One RTC timer update to one year                      – Two UARTs

     – Two 32-bit general purpose timers                       Support ISO 17987(Local Interconnect Network)

     – Eight DMA channels                                    – One I2C master

     – CPU frequency configurable from 1MHz to               – One I2S master/slave
       144MHz
                                                             – Five PWM channels
     – JTAG development support
                                                             – Quadrature decoder
     – XIP QSPI Flash/pSRAM with hardware encryp-
                                                             – Key-Scan-Matrix interface
       tion support
                                                             – 12-bit general ADC
 • Memory
                                                             – 10-bit general DAC
     – 132KB RAM
                                                             – PIR (Passive Infra-Red) detection
     – 192KB ROM
                                                             – Ethernet RMII interface(BL704/BL706)
     – 1Kb eFuse
                                                             – Camera interface(BL706)
     – Embedded Flash (optional)
                                                             – 15(BL702)/23(BL704)/31(BL706) Flexible GPIOs
     – Embedded pSRAM (BL704/BL706,optional)

       (flexible)                               – Active Tx

 • Power Management                          • Clock

     – Active CPU                               – External main clock XTAL 32MHz

     – Idle                                     – External low power consumption and the RTC
                                                  clock XTAL 32/32.768kHz
     – Power Down Sleep (flexible)
                                                – Internal RC 32kHz oscillator
     – Hibernate
                                                – Internal RC 32MHz oscillator
     – Off
                                                – Internal System PLL
     – Active Rx
                                                – Internal Audio PLL

                                                                                               Contents

    1 Overview . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .          8
    2 Functional Description      . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     9
      2.1     CPU     . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    10
      2.2     Cache     . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    10
      2.3     Memory . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .       10
      2.4     DMA . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .        10
      2.5     Bus . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      10
      2.6     Interrupt . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    12
      2.7     Boot    . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    12
      2.8     Power . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      12
      2.9     Clock . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      12
      2.10 Peripherals . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .         13
            2.10.1   GPIO . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      14
            2.10.2   UART . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      14
            2.10.3   SPI . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     14
            2.10.4   I2C . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     14
            2.10.5   I2S . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     15
            2.10.6   TIMER . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .       15
            2.10.7   PWM . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .       15
            2.10.8   IR (IR-remote) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    16
            2.10.9   USB2.0(Full Speed) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      16
            2.10.10 EMAC      . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    16
            2.10.11 QDEC      . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    17
            2.10.12 ADC . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .        18
            2.10.13 DAC . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .        18
            2.10.14 debug interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      18

    3 Pin Definition . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .            19
    4 Electrical Specifications . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .           37
      4.1     Absolute Maximum Rating . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .             37
      4.2     Operating Condition . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .           37
            4.2.1   Power characteristics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .           37
            4.2.2   Temperature sensor characteristics         . . . . . . . . . . . . . . . . . . . . . . .    38
            4.2.3   General operating conditions . . . . . . . . . . . . . . . . . . . . . . . . . . .          38
            4.2.4   GPADC characteristics       . . . . . . . . . . . . . . . . . . . . . . . . . . . . .       38
    5 Product use      . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .          41
      5.1     Moisture Sensitivity Level(MSL)     . . . . . . . . . . . . . . . . . . . . . . . . . . . .       41
      5.2     Electro-Static discharge（ESD） . . . . . . . . . . . . . . . . . . . . . . . . . . . .             42
      5.3     Reflow Profile . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .          42
    6 Reference Design       . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .          44
    7 Package Information(QFN32) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .                45
    8 Package Information(QFN40) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .                47
    9 Package Information(QFN48) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .                49
    10 Top Marking Definition    . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .          51
    11 Ordering Information . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .             52
    12 Revision history . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .           54

                                                                                                   List of Figures

  1.1 Block Diagram . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      8

  2.1 System Architecture . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      9
  2.2 Clock Architecture . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    13
  2.3 EMAC Timing Diagram . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .       17

  3.1 Pin layout (QFN32) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    19
  3.2 Pin layout (QFN40) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    20
  3.3 Pin layout (QFN48) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    20

  5.1 Classification Profile (Not to scale) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   42

  6.1 Reference Design . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      44

  7.1 QFN32 Package drawing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .         45

  8.1 QFN40 Package drawing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .         47

  9.1 QFN48 Package drawing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .         49

  10.1 Top Marking Definition . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   51

  11.1 Part Number . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    52

                                                                                                    List of Tables

  2.1 Bus Connection . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    10
  2.2 Memory Map . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      11
  2.3 Timing conditions for using RX Clock . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      17
  2.4 Timing conditions without using RX Clock . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .        17

  3.1 Pin Description . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   21

  4.1 Absolute Maximum Rating . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .       37
  4.2 Recommended Power Operating Range . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .             37
  4.3 Recommended Temperature Operating Range . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .               38
  4.4 General Operating Conditions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      38
  4.5 GPADC characteristics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     38
  4.6 ADC electrical characteristic . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   39

  5.1 Reference Conditions for Drying Mounted or Unmounted SMD Packages (User Bake: Floor life be-
       gins counting at time = 0 after bake) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    41
  5.2 Classification Reflow Profiles . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    43

  7.1 QFN32 Size Description . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      45

  8.1 QFN40 Size Description . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      47

  9.1 QFN48 Size Description . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      49

  11.1 Part Order Options . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   52

  12.1 Document revision history . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    54

                                                                                                    Overview
                                                                                                             1
BL702/BL704/BL706 is highly integrated BLE and zigbee combo chipsets for IoT applications.

Wireless subsystem contains 2.4G radio, BLE+zigbee baseband and MAC designs. Microcontroller subsystem con-
tains 32-bit RISC CPU, high-speed cache and memories. Power Management Unit controls ultra-low-power modes.
Moreover, variety of security features are supported.

Peripheral interfaces include USB2.0, Ethernet(BL704/BL706), IR-remote, SPI, UART, ISO 17987, I2C, I2S, PWM,
QDEC, KeyScan, ADC, DAC, PIR, Camera(BL706), and GPIOs.

                                                                                  USB2.0     USB host
                                                         32-bit RISC CPU
                                     BLE                                         IR remote
                        RF                                                          SPI
                                    Zigbee            Cache / RAM / ROM           UART
                                                                                 ISO 17987   Car System

                                                                                   I2C
                                 PMU                            DMA                 I2S
                                                                                   PWM
                              Clock                                               Timers
                           System PLL                     Crypto Engine
                                                                                  QDEC
                            Audio PLL                                                        HID Device
                                                                                 KeyScan
                                RC Clock
                                                               eFuse               DAC
                                 XTAL
                                                                                   ADC
                                                                                    PIR
                      XIP Flash       pSRAM         Ethernet I/F Camera DVP
                      Controller    (BL704/BL706)   (BL704/BL706)      (BL706)     GPIO

                                                         RJ45         Camera
                        Flash           pSRAM
                                                      (10/100M)       Sensor

                                                      Fig. 1.1: Block Diagram

                                                                                      Functional Description
                                                                                                                           2
BL702/BL704/BL706 main functions described as follows：

                                                                        eFUSE

                                       RISC                           SYSRAM
                                       32-bit
                                       CPU                            GLB REG

                                                                        PMU
                               ROM     Cache      TCM
                                                                         RTC

                                                                        Timer x6
                      QSPI       Flash Control
                                                                          SPI
                                                                         UART x2
                                 DMA Channels
                                                    x8                    I2C
                                                                          I2S
                                 Crypto Engines
                                                                        EMAC
                                                                                       General Pinmux

                                                                      (BL704/BL706)
                     USB             USB2.0                              PWM x5
                                                                      IR-Remote                         GPIO
                      pSRAM    pSRAM (BL704/BL706)                      QDEC x3
                                                                         KYS
                                     BLE 5.0
                                                                         DAC
                       RF
                                                                         ADC
                                   Zigbee 3.0
                                                                        EINT
                                                                        GPIO
                                                                         CAM
                                                                         (BL706)

                                                                Bus

                                        Fig. 2.1: System Architecture

2.1 CPU
BL702/BL704/BL706 32-bit RISC CPU contains FPU (floating-point unit) for 32-bit single-precision arithmetic, three-
stage pipelined (IF, EXE, WB), compressed 16 and 32-bit instruction set, standard JTAG debugger port including 4
hardware-programmable breakpoints, interrupt controller including 64 interrupts and 16 interrupt levels/priorities for
low latency interrupt processing. Up to 144MHz clock frequency, can be dynamically configured to change clock
frequency, enter the power saving mode to achieve low power consumption.

Both zigbee/BLE stack and application run on single 32-bit RISC CPU for simple and ultra-low power applications.
CPU performance ~1.46 DMIPS/MHz. ~3.1 CoreMark/MHz.

2.2 Cache
BL702/BL704/BL706 cache improves CPU performance to access external memory. Cache memories can be partially
or fully configured as TCM (tightly coupled memory).

2.3 Memory
BL702/BL704/BL706 memories include: on-chip zero-delay SRAM memories, read-only memories, write-once memories,
embedded flash memory (optional), embedded pSRAM (BL704/BL706,optional).

2.4 DMA
BL702/BL704/BL706 DMA (direct memory access) controller has eight dedicated channels that manage data transfer
between peripherals and memories to improve cpu/bus efficiency.

There are four main types of transfers including memory to memory, memory to peripheral, peripheral to peripheral
and peripheral to memory. DMA also supports LLI (link list item) that multiple transfers are pre-defined by a series of
linked lists, then hardware automatically complete all transfers according to each LLI size and address. DMA supports
peripheral USB, UART, I2C, I2S, SPI, ADC and DAC.

2.5 Bus
BL702/BL704/BL706 bus fabric connection and memory-map summarized as follows：

                                             Table 2.1: Bus Connection

 Slave/ Master          CPU              Ethernet          DMA               Crypto Engine         Debug

 SRAM                   V                V                 V                 V                     V

 Peripheral             V                -                 V                 -                     V

 BLE/zigbee             V                -                 V                 -                     V

                                         Table 2.2: Memory Map

 Module           Base Address   Size     Description

 RETRAM           0x40010000     4KB      Deep sleep memory (Retention RAM)

 HBN              0x4000F000     4KB      Deep sleep control (Hibernate)

 PDS              0x4000E000     4KB      Sleep control (Power Down Sleep)

 USB              0x4000D800     1KB      USB control

 EMAC             0x4000D000     2KB      Ethernet MAC control (BL704/BL706)

 DMA              0x4000C000     4KB      DMA control

 QSPI             0x4000B000     4KB      Flash/pSRAM QSPI control

 CAM              0x4000AD00     256B     CAM control (BL706)

 I2S              0x4000AA00     256B     I2S control

 KYS              0x4000A900     256B     Key-Scan control

 QDEC2            0x4000A880     64B      Quadrature decoder control

 QDEC1            0x4000A840     64B      Quadrature decoder control

 QDEC0            0x4000A800     64B      Quadrature decoder control

 IRR              0x4000A600     256B     IR Remote control

 TIMER            0x4000A500     256B     Timer control

 PWM              0x4000A400     256B     Pulse Width Modulation * 5 control

 I2C              0x4000A300     256B     I2C control

 SPI              0x4000A200     256B     SPI master/slave control

 UART1            0x4000A100     256B     UART control (support ISO 17987)

 UART0            0x4000A000     256B     UART control (support ISO 17987)

 L1C              0x40009000     4KB      Cache control

 eFuse            0x40007000     4KB      eFuse memory control

 SEC              0x40004000     4KB      Security engine

 GPIP             0x40002000     4KB      General purpose DAC/ADC/ACOMP interface control

 MIX              0x40001000     4KB      Mixed signal register

 GLB              0x40000000     4KB      Global control register

 pSRAM            0x24000000     8MB      pSRAM memory

 XIP              0x23000000     8MB      XIP Flash memory

 OCRAM            0x22020000     64KB     On-chip memory

 DTCM             0x22014000     48KB     Data cache memory

 ITCM             0x22010000     16KB     Instruction cache memory

 ROM              0x21000000     192KB    Read-only memory

2.6 Interrupt
BL702/BL704/BL706 supports internal RTC wake-up and external GPIO interrupts wake-up.

The CPU interrupt controller supports a total of 64 maskable interrupt trigger sources including UART interrupt, I2C
interrupt, SPI interrupt, timer interrupt, DMA interrupt, etc. All I/O pins can be configured as external interrupt input
mode. The external interrupt supports four trigger types: high level trigger, low level trigger, rising edge trigger and
falling edge trigger.

2.7 Boot
BL702/BL704/BL706 supports multiple boot options: UART, USB, and Flash.

2.8 Power
PMU (power management unit) manages the power of the entire chip and is divided into running, idle, sleep, hiber-
nation and power off modes. The software can be configured to enter sleep mode and wake-up via RTC timer or EINT to
achieve low-power sleep and accurate wake-up management.

Power down sleep modes are flexible for applications to configure as the lowest power consumption.

2.9 Clock
Clock control unit generates clocks to the core MCU and the peripheral SOC devices. The root clock source can be
XTAL, PLL or RC oscillator. Dynamic power-saved by proper configurations such as sel, div, en, etc. PMU runs at
32KHz clock to keep system low-power in sleep mode.

                                  DIV              CG
                                   11bit           en
                                                                      f32k_clk
                   XTAL32K                                                                                                                                                                                      PMU
                     RC32K
                                                               f32k_sel

                                                                                            1
                                                                                                           CG          general adc clk                                          DIV               CG         qdec clk(1MHz)
                                                                  1                                         en                                                       sel        5bit              en
                                                                            DIV
                                                                            6bit                pir
                                                                      sel
                                                                                                                                                                                                  CG         kys clk(1MHz)
                                                                                                                                                                                                  en
                              AUPLL                                                                        CG             i2s clk(~2MHz)
                              24.576MHz                                                                    en                                                                              /8     CG          kys clk(128KHz)
                              32.768MHz                                                                                                                                                           en

                                                                                                                          gpdac clk
                                                                   32MHz
                                                                                       DIV                  CG            (~512KHz)
                                                                                                             en
                                                                              sel

                                        xtal_clk
                                                    1   xclk
                                                                                                                                                                               Cnt                CG           pwm clk
                              RC32M                                                                                                                            0                 16bit            en
                                             root_clk_sel[0]
                                                 1                                                                                                                  sel
                                                                                                        ir clk
                                                                                                      (~2MHz)                                                                       DIV           CG             i2c clk
                                                                                                                                                                                    8bit          en
                                                                             DIV                CG
                                                                            6bit                en                                                                                  duty
                                                                                                                                                                                    DIV           CG             spi clk
                                                                                                                                                                                    5bit          en

                                                                                                                                                           duty
                                                                                                                                                                                           bclk
                                                                                                                                                           DIV             CG                     SOC
                                                                                                                                                          bclk_div         bclk_en
                                                                  96MHz             DIV               CG              ash clk                                                          hclk
                                                                                     3bit             en                                       DIV                          CG
                                                                 72MHz                                                                        hclk_div                    hclk_en
                                                                             sel
                                                                                            57.6MHz
                                                                                                                                                                                                  MCU
                                                                                                                                   1                                                   fclk
                                                                                            144MHz                   CG
  32MHz                                                                                                           pll_en
                                                                                            120MHz                          root_clk_sel[1]
   XTAL                   1
                                  DLL
                                                                                            96MHz      0
          clkpll_xtal_rc32m_sel                                                                            pll_sel
                                                                                                                                                                                    DIV            CG          uart clk
                                                                                                                                                                                    3bit           en
                                                                                                                                                              sel

                                                                                                                                                             48MHz
                                                                                                                                        /2                                                         CG          usb clk
                                                                                                                                                           (duty 50/50)
                                                                                                                                                                                                   en

                                                                                    Fig. 2.2: Clock Architecture

2.10 Peripherals
Peripherals include USB2.0, Ethernet, IR-remote, SPI, UART, ISO 17987, I2C, I2S, PWM, QDEC, KeyScan, ADC,
DAC, PIR, Camera.

Each peripheral can be assigned to different groups of GPIOs through flexible configurations. Each GPIO can be
used as a general-purpose input and output function.

2.10.1 GPIO

The BL702 has 15 GPIOs, the BL704 has 23 GPIOs, and the BL706 has 31 GPIOs with the following features:

 • Each GPIO can be used as general purpose input and output function, pull-up/pull-down/float can be configured
   by software

 • Each GPIO supports interrupt function, the interrupt supports rising edge trigger, falling edge trigger, high level
   trigger and low level trigger

 • Each GPIO can be set to high impedance state for low power mode

2.10.2 UART

The chip has two built-in UARTs (UART0 and UART1) with the following features:

 • Support LIN master/slave function

 • The working clock can be selected as FCLK or 96MHz, and the maximum baud rate supports 8M

 • Supports CTS and RTS signal management for hardware

 • TX and RX have independent FIFO, FIFO depth is 128 bytes, support DMA function

2.10.3 SPI

The chip has a built-in SPI, which can be configured in master mode or slave mode. The clock of the SPI module is
BCLK, which has the following characteristics:

 • As master, clock frequency up to 36MHz

 • As a slave, the maximum clock frequency of the master is allowed to be 24MHz

 • The bit width of each frame can be configured as 8bit/16bit/24bit/32bit

 • The transceiver of SPI has an independent FIFO, and the FIFO depth is fixed to 4 frames (that is, if the bit width
   of the frame is 8 bits, the depth of the FIFO is 4 bytes)

 • Support DMA transfer mode

2.10.4 I2C

The chip has a built-in I2C interface with the following features:

 • Support host mode and 7bit addressing

 • The working clock is BCLK

 • With device address register, register address register, register address length can be configured as 1 byte/2
   bytes/3 bytes/4 bytes

 • I2C transceiver has independent FIFO, FIFO depth is 2 words

 • Support DMA function

2.10.5 I2S

The chip has a built-in I2S interface with the following features:

 • Support Left-justified/ Right-justified/ DSP and other data formats, the data width can be configured as 8/16/24/32
   bits

 • In addition to mono/dual-channel mode, supports quad-channel mode at the same time

 • I2S transceiver has an independent FIFO with a FIFO depth of 16 frames; when the data width is 16 bits, the FIFO
   depth can be set to 32 frames

 • The I2S module has an independent Audio PLL that supports 48K (and its integer division) and 44.1K (and its
   integer division) sample rates

2.10.6 TIMER

The chip has two built-in general-purpose timers and a watchdog timer with the following features:

 • The clock source of the general timer can be selected from FCLK/32K/1K/XTAL

 • The clock source of the watchdog timer can be selected from FCLK/32K/XTAL

 • 8-bit divider for each counter

 • Each group of general-purpose timers includes three compare registers, supports compare interrupts, and sup-
   ports FreeRun mode and PreLoad mode in counting mode

 • 16-bit watchdog timer, supports two watchdog overflow methods: interrupt or reset

2.10.7 PWM

The chip has five built-in PWM signals with the following characteristics:

 • Three clock sources BCLK/XCLK/32K

 • Frequency divider register and period register are 16-bit wide

 • Each channel PWM supports adjustable output polarity, dual threshold setting, increasing the flexibility of pulse
   output

 • Support PWM cycle count interrupt for counting the number of output pulses

2.10.8 IR (IR-remote)

The chip has a built-in infrared remote control with the following features:

 • Support both sending and receiving modes

 • Supports receiving data with fixed protocols NEC, RC-5, and receiving data in any format with pulse width counting

 • The clock source is XCLK, which has a powerful infrared waveform editing capability, which can send waveforms
   conforming to various protocols, and the transmit power can be adjusted in 15 steps

 • Receive FIFO depth of 64 bytes

2.10.9 USB2.0(Full Speed)

The chip embeds a full-speed USB compatible device controller with the following features:

 • Compliant with full-speed USB device standards

 • Has 8 endpoints, each with a 64-byte deep FIFO

 • All endpoints except endpoint 0 support interrupt/bulk/isochronous transfers

 • With standby/resume function

 • USB dedicated 48MHz clock directly generated by internal main PLL

2.10.10 EMAC

The EMAC module is an IEEE 802.3 compliant 10/100Mbps Ethernet controller with the following features:

 • Compatible with MAC layer functions defined by IEEE 802.3

 • PHY that supports RMII interface defined by IEEE 802.3, interacts with PHY through MDIO

 • Supports 10Mbps and 100Mbps Ethernet

 • Support half-duplex and full-duplex, data transmission and reception are realized through Buffer Descriptor data
   structure, EMAC control embedded AHB Master, can directly read or write data from memory

 • The Buffer Descriptor data structure is stored in the internal RAM of the EMAC. The total number of Buffer De-
   scriptors is up to 128. Users can flexibly configure the number of Buffer Descriptors to send and receive accord-
   ing to the scene

The EMAC timing diagram is shown below:

                                        Tcyc

                                                    Tvld
                        TXD[1:0]
                         TXEN
                                                                   Tsu
                                                                         Th
                         RXD[1:0]
                          RX_DV
                          RXERR

                                                       Fig. 2.3: EMAC Timing Diagram

                                        Table 2.3: Timing conditions for using RX Clock

        Set the corresponding bit of register clk_cfg3:cfg_inv_eth_rx_clk = 1,cfg_inv_eth_tx_clk = 0,cfg_sel_eth_ref_clk_o = 0

 Timing parameters(1.8V, Load = 20PF)          Min.         Typ           Max.    Unit          Note

 Tcyc         Clock Cycle                      -            20            -       ns            Clock From ETH PHY

 Tvld         Output Valid Delay               7.38         -             16.3    ns            TXD/TX_EN

 Tsu          Input Setup Time                 10           -             -       ns            RXD/RX_DV/RXERR

 Th           Input Hold Time                  0            -             -       ns            RXD/RX_DV/RXERR

                                    Table 2.4: Timing conditions without using RX Clock

        Set the corresponding bit of register clk_cfg3:cfg_inv_eth_rx_clk = 0,cfg_inv_eth_tx_clk = 0,cfg_sel_eth_ref_clk_o = 0

 Timing parameters(1.8V, Load = 20PF)          Min.         Typ           Max.    Unit          Note

 Tcyc         Clock Cycle                      -            20            -       ns            Clock From ETH PHY

 Tvld         Output Valid Delay               7.38         -             16.3    ns            TXD/TX_EN

 Tsu          Input Setup Time                 2            -             -       ns            RXD/RX_DV/RXERR

 Th           Input Hold Time                  3            -             -       ns            RXD/RX_DV/RXERR

2.10.11 QDEC

The chip has built-in three sets of quadrature decoders, which are used to decode the two sets of pulses with a
phase difference of 90 degrees generated by the two-way rotary encoder into the corresponding speed and rotation.
direction, with the following properties:

 • The clock source can be selected from 32K (f32k_clk) or 32M (xclk)

 • With 16-bit pulse count range (-32768~32767 pulse/sample)

 • Has 12 configurable sample periods (32us~131ms per sample at 1MHz)

 • 16-bit configurable report period (0~65535 sample/report)

2.10.12 ADC

The chip has a built-in 12bits successive approximation analog-to-digital converter (ADC) with the following features:

 • The maximum operating clock is 2MHz, supports 12 external analog inputs and several internal analog signal
   selections, supports single-channel conversion and multi-channel scanning modes

 • Support 2.0V, 3.2V optional internal reference voltage, the conversion result is 12/14/16bits (through oversampling)
   left-justified mode

 • Has a FIFO with a depth of 32, supports multiple interrupts, and supports DMA functions

 • ADC can be used to measure supply voltage in addition to ordinary analog signal measurement

 • Can be used for temperature detection by measuring internal/external diode voltage

2.10.13 DAC

The chip has a built-in 10bits digital-to-analog converter (DAC) with the following features:

 • FIFO depth is 1, supports 2-channel DAC modulation output

 • Can be used for audio playback, conventional analog signal modulation

 • The working clock can be selected as 32M or Audio PLL

 • Supports DMA transfer of memory to DAC modulation registers

 • The output pin is fixed as ChannelA is GPIO11, ChannelB is GPIO17

2.10.14 debug interface

It supports standard JTAG 4-wire debugging interface, and supports debugging with debuggers such as Jlink/OpenOCD/CK
Link.

                                                                                                                                                                          Pin Definition
                                                                                                                                                                                        3
BL702 32-pin package includes 11 power pins, 6 analog pins, and 15 flexible GPIO pins.

                                            32          31             30              29            28            27             26           25
                                                                       PAD_GPIO_27

                                                                                      PAD_GPIO_26

                                                                                                                                PAD_GPIO_23
                                                        PAD_GPIO_28

                                                                                                    PAD_GPIO_25

                                                                                                                  PAD_GPIO_24
                                            VDDIO_1

                                                                                                                                              VDDIO_3
                                          VDDIO_1 1.8V or 3.3V GPIO0-8 / GPIO23-31
                           1 PAD_GPIO_0 VDDIO_2     3.3V       GPIO9-13                                                                                 PAD_GPIO_17 24
                                          VDDIO_3 1.8V or 3.3V GPIO14-22/PAD32-37(Embedded pad)
                           2 PAD_GPIO_1                                                                                                                 PAD_GPIO_15 23

                           3 PAD_GPIO_2                                                                                                                 PAD_GPIO_14 22

                           4 PAD_GPIO_7                                                                                                                 XTAL_HF_OUT 21
                                                                                     QFN32
                                                                                     (15GPIOs)
                           5 PAD_GPIO_8                                                                                                                 XTAL_HF_IN   20

                           6 VDDBUS_USB                                                                                                                  AVDD_RF     19

                           7   VDDCORE                                                                                                                    AVDD15     18

                           8   DCDC_OUT                                                                                                                 AVDD33_PA    17
                                                                                                    XTAL32K_OUT

                                                                                                                  AVDD33_AON
                                                                      PAD_GPIO_9

                                                                                      XTAL32K_IN
                                            SW_DCDC

                                                                                                                                PU_CHIP
                                                       VDDIO_2

                                                                                                                                              ANT

                                              9         10            11              12            13            14            15            16

                                                      Fig. 3.1: Pin layout (QFN32)

BL704 40-pin package includes 11 power pins, 6 analog pins, and 23 flexible GPIO pins.

                                                  40                        39                             38                            37                    36                   35                         34                                   33                      32                       31

                                                                          PAD_GPIO_28

                                                                                                              PAD_GPIO_27

                                                                                                                                            PAD_GPIO_26

                                                                                                                                                                   PAD_GPIO_25

                                                                                                                                                                                         PAD_GPIO_24

                                                                                                                                                                                                                      PAD_GPIO_23

                                                                                                                                                                                                                                               PAD_GPIO_22

                                                                                                                                                                                                                                                                            PAD_GPIO_21
                                                       VDDIO_1

                                                                                                                                                                                                                                                                                                   VDDIO_3
                                             VDDIO_1 1.8V or 3.3V GPIO0-8 / GPIO23-31
                            1 PAD_GPIO_0 VDDIO_2                                                                                                                                                                                                                                                                       PAD_GPIO_20 30
                                                        3.3V      GPIO9-13
                                             VDDIO_3 1.8V or 3.3V GPIO14-22/PAD32-37(Embedded pad)
                            2 PAD_GPIO_1                                                                                                                                                                                                                                                                               PAD_GPIO_19 29

                            3 PAD_GPIO_2                                                                                                                                                                                                                                                                               PAD_GPIO_18 28

                            4 PAD_GPIO_3                                                                                                                                                                                                                                                                               PAD_GPIO_17 27

                            5 PAD_GPIO_7                                                                                                                                                                                                                                                                               PAD_GPIO_15 26
                                                                                                                                                          QFN40
                            6 PAD_GPIO_8                                                                                                                     (23GPIOs)                                                                                                                                                 PAD_GPIO_14 25

                            7 VDDBUS_USB                                                                                                                                                                                                                                                                               XTAL_HF_OUT 24

                            8    VDDCORE                                                                                                                                                                                                                                                                               XTAL_HF_IN 23

                            9    DCDC_OUT                                                                                                                                                                                                                                                                               AVDD_RF    22

                            10   SW_DCDC                                                                                                                                                                                                                                                                                 AVDD15    21
                                                                                                           PAD_GPIO_10

                                                                                                                                       PAD_GPIO_11

                                                                                                                                                                                  XTAL32K_OUT

                                                                                                                                                                                                            AVDD33_AON
                                                                                PAD_GPIO_9

                                                                                                                                                                                                                                                                                                   AVDD33_PA
                                                                                                                                                              XTAL32K_IN
                                                       VDDIO_2

                                                                                                                                                                                                                                              PU_CHIP

                                                                                                                                                                                                                                                                            ANT
                                                       11                       12                           13                            14                   15                   16                          17                                 18                      19                       20

                                                                            Fig. 3.2: Pin layout (QFN40)

BL706 48-pin package includes 11 power pins, 6 analog pins, and 31 flexible GPIO pins.

                                             48                  47                      46                           45                       44                43               42                     41                           40                      39                      38                  37
                                                                                                                                               PAD_GPIO_28
                                                                  PAD_GPIO_31

                                                                                             PAD_GPIO_30

                                                                                                                         PAD_GPIO_29

                                                                                                                                                                    PAD_GPIO_27

                                                                                                                                                                                     PAD_GPIO_26

                                                                                                                                                                                                            PAD_GPIO_25

                                                                                                                                                                                                                                      PAD_GPIO_24

                                                                                                                                                                                                                                                              PAD_GPIO_23

                                                                                                                                                                                                                                                                                     PAD_GPIO_22

                                                                                                                                                                                                                                                                                                         PAD_GPIO_21
                                               VDDIO_1

                                            VDDIO_1 1.8V or 3.3V GPIO0-8 / GPIO23-31
                             1 PAD_GPIO_0 VDDIO_2                                                                                                                                                                                                                                                                        VDDIO_3   36
                                                       3.3V      GPIO9-13
                                            VDDIO_3 1.8V or 3.3V GPIO14-22/PAD32-37(Embedded pad)
                             2 PAD_GPIO_1                                                                                                                                                                                                                                                                              PAD_GPIO_20 35

                             3 PAD_GPIO_2                                                                                                                                                                                                                                                                              PAD_GPIO_19 34

                             4 PAD_GPIO_3                                                                                                                                                                                                                                                                              PAD_GPIO_18 33

                             5 PAD_GPIO_4                                                                                                                                                                                                                                                                              PAD_GPIO_17 32

                             6 PAD_GPIO_5                                                                                                                    QFN48                                                                                                                                                     PAD_GPIO_16 31
                                                                                                                                                             (31GPIOs)
                             7 PAD_GPIO_6                                                                                                                                                                                                                                                                              PAD_GPIO_15 30

                             8 PAD_GPIO_7                                                                                                                                                                                                                                                                              PAD_GPIO_14 29

                             9 PAD_GPIO_8                                                                                                                                                                                                                                                                              XTAL_HF_OUT 28

                            10 VDDBUS_USB                                                                                                                                                                                                                                                                               XTAL_HF_IN 27

                            11   VDDCORE                                                                                                                                                                                                                                                                                AVDD_RF    26

                            12 DCDC_OUT                                                                                                                                                                                                                                                                                  AVDD15    25
                                                                                                                      PAD_GPIO_10

                                                                                                                                              PAD_GPIO_11

                                                                                                                                                                PAD_GPIO_12

                                                                                                                                                                                                       XTAL32K_OUT

                                                                                                                                                                                                                                    AVDD33_AON
                                                                                        PAD_GPIO_9

                                                                                                                                                                                                                                                                                                         AVDD33_PA
                                                                                                                                                                                  XTAL32K_IN
                                             SW_DCDC

                                                                 VDDIO_2

                                                                                                                                                                                                                                                             PU_CHIP

                                                                                                                                                                                                                                                                                     ANT

                                              13                  14                         15                          16                     17                18               19                     20                          21                      22                          23               24

                                                                            Fig. 3.3: Pin layout (QFN48)

                                                             Table 3.1: Pin Description

                                                                      GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                        Description
                                                                      Select Number   Function Select       Function

                                                                      2               -                     -                     -

                                                                      3               -                     I2S_BCLK              I2S_BCLK

                                                                      4               -                     SPI_MOSI 1            SPI_MOSI

                                                                      6               -                     I2C_SCL               I2C_SCL

                                                                                      uart_sig_0_sel=0      UART0_RTS             UART0_RTS

                                                                                      uart_sig_0_sel=1      UART0_CTS             UART0_CTS

                                                                                      uart_sig_0_sel=2      UART0_TXD             UART0_TXD

                                                                                      uart_sig_0_sel=3      UART0_RXD             UART0_RXD
                                                                      7
                                                                                      uart_sig_0_sel=4      UART1_RTS             UART1_RTS

                                                                                      uart_sig_0_sel=5      UART1_CTS             UART1_CTS

                                                                                      uart_sig_0_sel=6      UART1_TXD             UART1_TXD
 1       1       1       VDDIO_1          DI/DO   PAD_GPIO_0
                                                                                      uart_sig_0_sel=7      UART1_RXD             UART1_RXD

                                                                      8               -                     PWM_CH0               PWM_CH0

                                                                      9               -                     CAM_PIX_CLK           CAM_PIX_CLK

                                                                      10              -                     -                     -

                                                                      11              -                     SWGPIO0               SWGPIO0

                                                                      14              -                     TMS                   TMS

                                                                      16              -                     EXTERNAL_PA_FEM0      EXTERNAL_PA_FEM0

                                                                      19              -                     MII_REF_CLK           MII_REF_CLK

                                                                      20              -                     QDEC0_a               QDEC0_a

                                                                      21              -                     Key_Scan_In_ROW0      Key_Scan_In_ROW0

                                                                      22              -                     Key_Scan_Drive_COL0   Key_Scan_Drive_COL0

                                                                      2               -                     -                     -

                                                                      3               -                     I2S_FS                I2S_FS

                                                                      4               -                     SPI_MISO              SPI_MISO

                                                                      6               -                     I2C_SDA               I2C_SDA

                                                                                      uart_sig_1_sel=0      UART0_RTS             UART0_RTS

                                                                                      uart_sig_1_sel=1      UART0_CTS             UART0_CTS

                                                                                      uart_sig_1_sel=2      UART0_TXD             UART0_TXD

                                                                                      uart_sig_1_sel=3      UART0_RXD             UART0_RXD
                                                                      7
                                                                                      uart_sig_1_sel=4      UART1_RTS             UART1_RTS

                                                                                      uart_sig_1_sel=5      UART1_CTS             UART1_CTS

                                                                                      uart_sig_1_sel=6      UART1_TXD             UART1_TXD
 2       2       2       VDDIO_1          DI/DO   PAD_GPIO_1
                                                                                      uart_sig_1_sel=7      UART1_RXD             UART1_RXD

                                                                      8               -                     PWM_CH1               PWM_CH1

                                                                      9               -                     CAM_FRAME_VLD         CAM_FRAME_VLD

                                                                      10              -                     -                     -

                                                                      11              -                     SWGPIO1               SWGPIO1

                                                                      14              -                     TDI                   TDI

                                                                      16              -                     EXTERNAL_PA_FEM1      EXTERNAL_PA_FEM1

                                                                      19              -                     MII_TXD[0]            MII_TXD[0]

                                                                      20              -                     QDEC0_b               QDEC0_b

                                                                      21              -                     Key_Scan_In_ROW1      Key_Scan_In_ROW1

                                                                      22              -                     Key_Scan_Drive_COL1   Key_Scan_Drive_COL1

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                   Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     -                     -

                                                                 3               -                     I2S_DIO/I2S_DO        I2S_DIO/I2S_DO

                                                                 4               -                     SPI_SS                SPI_SS

                                                                 6               -                     I2C_SCL               I2C_SCL

                                                                                 uart_sig_2_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_2_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_2_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_2_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_2_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_2_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_2_sel=6      UART1_TXD             UART1_TXD
 3       3       3       VDDIO_1          DI/DO   PAD_GPIO_2
                                                                                 uart_sig_2_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH2               PWM_CH2

                                                                 9               -                     CAM_LINE_VLD          CAM_LINE_VLD

                                                                 10              -                     -                     -

                                                                 11              -                     SWGPIO2               SWGPIO2

                                                                 14              -                     TCK                   TCK

                                                                 16              -                     EXTERNAL_PA_FEM2      EXTERNAL_PA_FEM2

                                                                 19              -                     MII_TXD[1]            MII_TXD[1]

                                                                 20              -                     QDEC0_led             QDEC0_led

                                                                 21              -                     Key_Scan_In_ROW2      Key_Scan_In_ROW2

                                                                 22              -                     Key_Scan_Drive_COL2   Key_Scan_Drive_COL2

                                                                 2               -                     -                     -

                                                                 3               -                     I2S_RCLK_O/I2S_DI     I2S_RCLK_O/I2S_DI

                                                                 4               -                     SPI_SCLK              SPI_SCLK

                                                                 6               -                     I2C_SDA               I2C_SDA

                                                                                 uart_sig_3_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_3_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_3_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_3_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_3_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_3_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_3_sel=6      UART1_TXD             UART1_TXD
 -       4       4       VDDIO_1          DI/DO   PAD_GPIO_3
                                                                                 uart_sig_3_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH3               PWM_CH3

                                                                 9               -                     CAM_PIX_DAT0          CAM_PIX_DAT0

                                                                 10              -                     -                     -

                                                                 11              -                     SWGPIO3               SWGPIO3

                                                                 14              -                     TDO                   TDO

                                                                 16              -                     EXTERNAL_PA_FEM3      EXTERNAL_PA_FEM3

                                                                 19              -                     -                     -

                                                                 20              -                     QDEC1_a               QDEC1_a

                                                                 21              -                     Key_Scan_In_ROW3      Key_Scan_In_ROW3

                                                                 22              -                     Key_Scan_Drive_COL3   Key_Scan_Drive_COL3

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                   Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     -                     -

                                                                 3               -                     I2S_BCLK              I2S_BCLK

                                                                 4               -                     SPI_MOSI              SPI_MOSI

                                                                 6               -                     I2C_SCL               I2C_SCL

                                                                                 uart_sig_4_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_4_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_4_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_4_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_4_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_4_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_4_sel=6      UART1_TXD             UART1_TXD
 -       -       5       VDDIO_1          DI/DO   PAD_GPIO_4
                                                                                 uart_sig_4_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH4               PWM_CH4

                                                                 9               -                     CAM_PIX_DAT1          CAM_PIX_DAT1

                                                                 10              -                     -                     -

                                                                 11              -                     SWGPIO4               SWGPIO4

                                                                 14              -                     TMS                   TMS

                                                                 16              -                     EXTERNAL_PA_FEM4      EXTERNAL_PA_FEM4

                                                                 19              -                     -                     -

                                                                 20              -                     QDEC1_b               QDEC1_b

                                                                 21              -                     Key_Scan_In_ROW4      Key_Scan_In_ROW4

                                                                 22              -                     Key_Scan_Drive_COL4   Key_Scan_Drive_COL4

                                                                 2               -                     -                     -

                                                                 3               -                     I2S_FS                I2S_FS

                                                                 4               -                     SPI_MISO              SPI_MISO

                                                                 6               -                     I2C_SDA               I2C_SDA

                                                                                 uart_sig_5_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_5_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_5_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_5_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_5_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_5_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_5_sel=6      UART1_TXD             UART1_TXD
 -       -       6       VDDIO_1          DI/DO   PAD_GPIO_5
                                                                                 uart_sig_5_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH0               PWM_CH0

                                                                 9               -                     CAM_PIX_DAT2          CAM_PIX_DAT2

                                                                 10              -                     -                     -

                                                                 11              -                     SWGPIO5               SWGPIO5

                                                                 14              -                     TDI                   TDI

                                                                 16              -                     EXTERNAL_PA_FEM0      EXTERNAL_PA_FEM0

                                                                 19              -                     -                     -

                                                                 20              -                     QDEC1_led             QDEC01_led

                                                                 21              -                     Key_Scan_In_ROW5      Key_Scan_In_ROW5

                                                                 22              -                     Key_Scan_Drive_COL5   Key_Scan_Drive_COL5

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                   Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     -                     -

                                                                 3               -                     I2S_DIO/I2S_DO        I2S_DIO/I2S_DO

                                                                 4               -                     SPI_SS                SPI_SS

                                                                 6               -                     I2C_SCL               I2C_SCL

                                                                                 uart_sig_6_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_6_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_6_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_6_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_6_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_6_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_6_sel=6      UART1_TXD             UART1_TXD
 -       -       7       VDDIO_1          DI/DO   PAD_GPIO_6
                                                                                 uart_sig_6_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH1               PWM_CH1

                                                                 9               -                     CAM_PIX_DAT3          CAM_PIX_DAT3

                                                                 10              -                     -                     -

                                                                 11              -                     SWGPIO6               SWGPIO6

                                                                 14              -                     TCK                   TCK

                                                                 16              -                     EXTERNAL_PA_FEM1      EXTERNAL_PA_FEM1

                                                                 19              -                     -                     -

                                                                 20              -                     QDEC2_a               QDEC2_a

                                                                 21              -                     Key_Scan_In_ROW6      Key_Scan_In_ROW6

                                                                 22              -                     Key_Scan_Drive_COL6   Key_Scan_Drive_COL6

                                                                 2               -                     -                     -

                                                                 3               -                     I2S_RCLK_O/I2S_DI     I2S_RCLK_O/I2S_DI

                                                                 4               -                     SPI_SCLK              SPI_SCLK

                                                                 6               -                     I2C_SDA               I2C_SDA

                                                                                 uart_sig_7_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_7_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_7_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_7_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_7_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_7_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_7_sel=6      UART1_TXD             UART1_TXD
 4       5       8       VDDIO_1          DI/DO   PAD_GPIO_7
                                                                                 uart_sig_7_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH2               PWM_CH2

                                                                 9               -                     -                     -

                                                                 10              -                     ADC_CH6               ADC_CH6

                                                                 11              -                     SWGPIO7               SWGPIO7

                                                                 14              -                     TDO                   TDO

                                                                 16              -                     EXTERNAL_PA_FEM2      EXTERNAL_PA_FEM2

                                                                 19              -                     MII_RXD[0]            MII_RXD[0]

                                                                 20              -                     QDEC2_b               QDEC2_b

                                                                 21              -                     Key_Scan_In_ROW7      Key_Scan_In_ROW7

                                                                 22              -                     Key_Scan_Drive_COL7   Key_Scan_Drive_COL7

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                   Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     -                     -

                                                                 3               -                     I2S_BCLK              I2S_BCLK

                                                                 4               -                     SPI_MOSI              SPI_MOSI

                                                                 6               -                     I2C_SCL               I2C_SCL

                                                                                 uart_sig_0_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_0_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_0_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_0_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_0_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_0_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_0_sel=6      UART1_TXD             UART1_TXD
 5       6       9       VDDIO_1          DI/DO   PAD_GPIO_8
                                                                                 uart_sig_0_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH3               PWM_CH3

                                                                 9               -                     -                     -

                                                                 10              -                     ADC_CH0               ADC_CH0

                                                                 11              -                     SWGPIO8               SWGPIO8

                                                                 14              -                     TMS                   TMS

                                                                 16              -                     EXTERNAL_PA_FEM3      EXTERNAL_PA_FEM3

                                                                 19              -                     MII_RXD[1]            MII_RXD[1]

                                                                 20              -                     QDEC2_led             QDEC2_led

                                                                 21              -                     Key_Scan_In_ROW0      Key_Scan_In_ROW0

                                                                 22              -                     Key_Scan_Drive_COL8   Key_Scan_Drive_COL8

                                                                 2               -                     -                     -

                                                                 3               -                     I2S_FS                I2S_FS

                                                                 4               -                     SPI_MISO              SPI_MISO

                                                                 6               -                     I2C_SDA               I2C_SDA

                                                                                 uart_sig_1_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_1_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_1_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_1_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_1_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_1_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_1_sel=6      UART1_TXD             UART1_TXD
 11      12      15      VDDIO_2          DI/DO   PAD_GPIO_9
                                                                                 uart_sig_1_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH4               PWM_CH4

                                                                 9               -                     -                     -

                                                                 10              -                     ADC_CH7               ADC_CH7

                                                                 11              -                     SWGPIO9               SWGPIO9

                                                                 14              -                     TDI                   TDI

                                                                 16              -                     EXTERNAL_PA_FEM4      EXTERNAL_PA_FEM4

                                                                 19              -                     -                     -

                                                                 20              -                     QDEC0_a               QDEC0_a

                                                                 21              -                     Key_Scan_In_ROW1      Key_Scan_In_ROW1

                                                                 22              -                     Key_Scan_Drive_COL9   Key_Scan_Drive_COL9

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                    Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     -                      -

                                                                 3               -                     I2S_DIO/I2S_DO         I2S_DIO/I2S_DO

                                                                 4               -                     SPI_SS                 SPI_SS

                                                                 6               -                     I2C_SCL                I2C_SCL

                                                                                 uart_sig_2_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_2_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_2_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_2_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_2_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_2_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_2_sel=6      UART1_TXD              UART1_TXD
 -       13      16      VDDIO_2          DI/DO   PAD_GPIO_10
                                                                                 uart_sig_2_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH0                PWM_CH0

                                                                 9               -                     -                      -

                                                                 10              -                     -                      -

                                                                 11              -                     SWGPIO10               SWGPIO10

                                                                 14              -                     TCK                    TCK

                                                                 16              -                     EXTERNAL_PA_FEM0       EXTERNAL_PA_FEM0

                                                                 19              -                     -                      -

                                                                 20              -                     QDEC0_b                QDEC0_b

                                                                 21              -                     Key_Scan_In_ROW2       Key_Scan_In_ROW2

                                                                 22              -                     Key_Scan_Drive_COL10   Key_Scan_Drive_COL2

                                                                 2               -                     -                      -

                                                                 3               -                     I2S_RCLK_O/I2S_DI      I2S_RCLK_O/I2S_DI

                                                                 4               -                     SPI_SCLK               SPI_SCLK

                                                                 6               -                     I2C_SDA                I2C_SDA

                                                                                 uart_sig_3_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_3_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_3_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_3_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_3_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_3_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_3_sel=6      UART1_TXD              UART1_TXD
 -       14      17      VDDIO_2          DI/DO   PAD_GPIO_11
                                                                                 uart_sig_3_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH1                PWM_CH1

                                                                 9               -                     -                      -

                                                                 10              -                     ADC_CH3                ADC_CH3

                                                                 11              -                     SWGPIO11               SWGPIO11

                                                                 14              -                     TDO                    TDO

                                                                 16              -                     EXTERNAL_PA_FEM1       EXTERNAL_PA_FEM1

                                                                 19              -                     -                      -

                                                                 20              -                     QDEC0_led              QDEC0_led

                                                                 21              -                     Key_Scan_In_ROW3       Key_Scan_In_ROW3

                                                                 22              -                     Key_Scan_Drive_COL11   Key_Scan_Drive_COL11

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                    Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     -                      -

                                                                 3               -                     I2S_BCLK               I2S_BCLK

                                                                 4               -                     SPI_MOSI               SPI_MOSI

                                                                 6               -                     I2C_SCL                I2C_SCL

                                                                                 uart_sig_4_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_4_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_4_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_4_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_4_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_4_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_4_sel=6      UART1_TXD              UART1_TXD
 -       -       18      VDDIO_2          DI/DO   PAD_GPIO_12
                                                                                 uart_sig_4_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH2                PWM_CH2

                                                                 9               -                     CAM_PIX_DAT4           CAM_PIX_DAT4

                                                                 10              -                     ADC_CH4                ADC_CH4

                                                                 11              -                     SWGPIO12               SWGPIO12

                                                                 14              -                     TMS                    TMS

                                                                 16              -                     EXTERNAL_PA_FEM2       EXTERNAL_PA_FEM2

                                                                 19              -                     -                      -

                                                                 20              -                     QDEC1_a                QDEC1_a

                                                                 21              -                     Key_Scan_In_ROW4       Key_Scan_In_ROW4

                                                                 22              -                     Key_Scan_Drive_COL12   Key_Scan_Drive_COL12

                                                                 2               -                     -                      -

                                                                 3               -                     I2S_DIO/I2S_DO         I2S_DIO/I2S_DO

                                                                 4               -                     SPI_SS                 SPI_SS

                                                                 6               -                     I2C_SCL                I2C_SCL

                                                                                 uart_sig_6_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_6_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_6_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_6_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_6_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_6_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_6_sel=6      UART1_TXD              UART1_TXD
 22      25      29      VDDIO_3          DI/DO   PAD_GPIO_14
                                                                                 uart_sig_6_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH4                PWM_CH4

                                                                 9               -                     -                      -

                                                                 10              -                     ADC_CH5                ADC_CH5

                                                                 11              -                     SWGPIO14               SWGPIO14

                                                                 14              -                     TCK                    TCK

                                                                 16              -                     EXTERNAL_PA_FEM4       EXTERNAL_PA_FEM4

                                                                 19              -                     -                      -

                                                                 20              -                     QDEC1_led              QDEC1_led

                                                                 21              -                     Key_Scan_In_ROW6       Key_Scan_In_ROW6

                                                                 22              -                     Key_Scan_Drive_COL14   Key_Scan_Drive_COL14

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                    Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     -                      -

                                                                 3               -                     I2S_RCLK_O/I2S_DI      I2S_RCLK_O/I2S_DI

                                                                 4               -                     SPI_SCLK               SPI_SCLK

                                                                 6               -                     I2C_SDA                I2C_SDA

                                                                                 uart_sig_7_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_7_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_7_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_7_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_7_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_7_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_7_sel=6      UART1_TXD              UART1_TXD
 23      26      30      VDDIO_3          DI/DO   PAD_GPIO_15
                                                                                 uart_sig_7_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH0                PWM_CH0

                                                                 9               -                     -                      -

                                                                 10              -                     ADC_CH1                ADC_CH1

                                                                 11              -                     SWGPIO15               SWGPIO15

                                                                 14              -                     TDO                    TDO

                                                                 16              -                     EXTERNAL_PA_FEM0       EXTERNAL_PA_FEM0

                                                                 19              -                     -                      -

                                                                 20              -                     QDEC2_a                QDEC2_a

                                                                 21              -                     Key_Scan_In_ROW7       Key_Scan_In_ROW7

                                                                 22              -                     Key_Scan_Drive_COL15   Key_Scan_Drive_COL15

                                                                 2               -                     -                      -

                                                                 3               -                     I2S_BCLK               I2S_BCLK

                                                                 4               -                     SPI_MOSI               SPI_MOSI

                                                                 6               -                     I2C_SCL                I2C_SCL

                                                                                 uart_sig_0_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_0_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_0_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_0_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_0_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_0_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_0_sel=6      UART1_TXD              UART1_TXD
 -       -       31      VDDIO_3          DI/DO   PAD_GPIO_16
                                                                                 uart_sig_0_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH1                PWM_CH1

                                                                 9               -                     -                      -

                                                                 10              -                     -                      -

                                                                 11              -                     SWGPIO16               SWGPIO16

                                                                 14              -                     TMS                    TMS

                                                                 16              -                     EXTERNAL_PA_FEM1       EXTERNAL_PA_FEM1

                                                                 19              -                     -                      -

                                                                 20              -                     QDEC2_b                QDEC2_b

                                                                 21              -                     Key_Scan_In_ROW0       Key_Scan_In_ROW0

                                                                 22              -                     Key_Scan_Drive_COL16   Key_Scan_Drive_COL16

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                    Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     SF_IO_0/SF2_CS2        SF_IO_0/SF2_CS2

                                                                 3               -                     I2S_FS                 I2S_FS

                                                                 4               -                     SPI_MISO               SPI_MISO

                                                                 6               -                     I2C_SDA                I2C_SDA

                                                                                 uart_sig_1_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_1_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_1_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_1_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_1_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_1_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_1_sel=6      UART1_TXD              UART1_TXD
 24      27      32      VDDIO_3          DI/DO   PAD_GPIO_17
                                                                                 uart_sig_1_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH2                PWM_CH2

                                                                 9               -                     CAM_PIX_DAT4           CAM_PIX_DAT4

                                                                 10              -                     ADC_CH2                ADC_CH2

                                                                 11              -                     SWGPIO17               SWGPIO17

                                                                 14              -                     TDI                    TDI

                                                                 16              -                     EXTERNAL_PA_FEM2       EXTERNAL_PA_FEM2

                                                                 19              -                     -                      -

                                                                 20              -                     QDEC2_led              QDEC2_led

                                                                 21              -                     Key_Scan_In_ROW1       Key_Scan_In_ROW1

                                                                 22              -                     Key_Scan_Drive_COL17   Key_Scan_Drive_COL17

                                                                 2               -                     SF_IO_1                SF_IO_1

                                                                 3               -                     I2S_DIO/I2S_DO         I2S_DIO/I2S_DO

                                                                 4               -                     SPI_SS                 SPI_SS

                                                                 6               -                     I2C_SCL                I2C_SCL

                                                                                 uart_sig_2_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_2_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_2_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_2_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_2_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_2_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_2_sel=6      UART1_TXD              UART1_TXD
 -       28      33      VDDIO_3          DI/DO   PAD_GPIO_18
                                                                                 uart_sig_2_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH3                PWM_CH3

                                                                 9               -                     CAM_PIX_DAT5           CAM_PIX_DAT5

                                                                 10              -                     ADC_CH8                ADC_CH8

                                                                 11              -                     SWGPIO18               SWGPIO18

                                                                 14              -                     TCK                    TCK

                                                                 16              -                     EXTERNAL_PA_FEM3       EXTERNAL_PA_FEM3

                                                                 19              -                     RMII_MDC               RMII_MDC

                                                                 20              -                     QDEC0_a                QDEC0_a

                                                                 21              -                     Key_Scan_In_ROW2       Key_Scan_In_ROW2

                                                                 22              -                     Key_Scan_Drive_COL18   Key_Scan_Drive_COL18

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                    Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     SF_CS                  SF_CS

                                                                 3               -                     I2S_RCLK_O/I2S_DI      I2S_RCLK_O/I2S_DI

                                                                 4               -                     SPI_SCLK               SPI_SCLK

                                                                 6               -                     I2C_SDA                I2C_SDA

                                                                                 uart_sig_3_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_3_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_3_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_3_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_3_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_3_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_3_sel=6      UART1_TXD              UART1_TXD
 -       29      34      VDDIO_3          DI/DO   PAD_GPIO_19
                                                                                 uart_sig_3_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH4                PWM_CH4

                                                                 9               -                     CAM_PIX_DAT6           CAM_PIX_DAT6

                                                                 10              -                     ADC_CH9                ADC_CH9

                                                                 11              -                     SWGPIO19               SWGPIO19

                                                                 14              -                     TDO                    TDO

                                                                 16              -                     EXTERNAL_PA_FEM4       EXTERNAL_PA_FEM4

                                                                 19              -                     RMII_MDIO              RMII_MDIO

                                                                 20              -                     QDEC0_b                QDEC0_b

                                                                 21              -                     Key_Scan_In_ROW3       Key_Scan_In_ROW3

                                                                 22              -                     Key_Scan_Drive_COL19   Key_Scan_Drive_COL19

                                                                 2               -                     SF_IO_3                SF_IO_3

                                                                 3               -                     I2S_BCLK               I2S_BCLK

                                                                 4               -                     SPI_MOSI               SPI_MOSI

                                                                 6               -                     I2C_SCL                I2C_SCL

                                                                                 uart_sig_4_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_4_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_4_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_4_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_4_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_4_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_4_sel=6      UART1_TXD              UART1_TXD
 -       30      35      VDDIO_3          DI/DO   PAD_GPIO_20
                                                                                 uart_sig_4_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH0                PWM_CH0

                                                                 9               -                     CAM_PIX_DAT7           CAM_PIX_DAT7

                                                                 10              -                     ADC_CH10               ADC_CH10

                                                                 11              -                     SWGPIO20               SWGPIO20

                                                                 14              -                     TMS                    TMS

                                                                 16              -                     EXTERNAL_PA_FEM0       EXTERNAL_PA_FEM0

                                                                 19              -                     RMII_RXERR             RMII_RXERR

                                                                 20              -                     QDEC0_led              QDEC0_led

                                                                 21              -                     Key_Scan_In_ROW4       Key_Scan_In_ROW4

                                                                 22              -                     Key_Scan_Drive_COL0    Key_Scan_Drive_COL0

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                   Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     SF_CLK                SF_CLK

                                                                 3               -                     I2S_FS                I2S_FS

                                                                 4               -                     SPI_MISO              SPI_MISO

                                                                 6               -                     I2C_SDA               I2C_SDA

                                                                                 uart_sig_5_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_5_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_5_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_5_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_5_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_5_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_5_sel=6      UART1_TXD             UART1_TXD
 -       32      37      VDDIO_3          DI/DO   PAD_GPIO_21
                                                                                 uart_sig_5_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH1               PWM_CH1

                                                                 9               -                     -                     -

                                                                 10              -                     ADC_CH11              ADC_CH11

                                                                 11              -                     SWGPIO21              SWGPIO21

                                                                 14              -                     TDI                   TDI

                                                                 16              -                     EXTERNAL_PA_FEM1      EXTERNAL_PA_FEM1

                                                                 19              -                     RMII_TX_EN            RMII_TX_EN

                                                                 20              -                     QDEC1_a               QDEC01_led

                                                                 21              -                     Key_Scan_In_ROW5      Key_Scan_In_ROW5

                                                                 22              -                     Key_Scan_Drive_COL1   Key_Scan_Drive_COL1

                                                                 2               -                     SF_IO_2               SF_IO_2

                                                                 3               -                     I2S_DIO/I2S_DO        I2S_DIO/I2S_DO

                                                                 4               -                     SPI_SS                SPI_SS

                                                                 6               -                     I2C_SCL               I2C_SCL

                                                                                 uart_sig_6_sel=0      UART0_RTS             UART0_RTS

                                                                                 uart_sig_6_sel=1      UART0_CTS             UART0_CTS

                                                                                 uart_sig_6_sel=2      UART0_TXD             UART0_TXD

                                                                                 uart_sig_6_sel=3      UART0_RXD             UART0_RXD
                                                                 7
                                                                                 uart_sig_6_sel=4      UART1_RTS             UART1_RTS

                                                                                 uart_sig_6_sel=5      UART1_CTS             UART1_CTS

                                                                                 uart_sig_6_sel=6      UART1_TXD             UART1_TXD
 -       33      38      VDDIO_3          DI/DO   PAD_GPIO_22
                                                                                 uart_sig_6_sel=7      UART1_RXD             UART1_RXD

                                                                 8               -                     PWM_CH2               PWM_CH2

                                                                 9               -                     -                     -

                                                                 10              -                     -                     -

                                                                 11              -                     SWGPIO22              SWGPIO22

                                                                 14              -                     TCK                   TCK

                                                                 16              -                     EXTERNAL_PA_FEM2      EXTERNAL_PA_FEM2

                                                                 19              -                     RMII_RX_DV            RMII_RX_DV

                                                                 20              -                     QDEC1_b               QDEC1_b

                                                                 21              -                     Key_Scan_In_ROW6      Key_Scan_In_ROW6

                                                                 22              -                     Key_Scan_Drive_COL2   Key_Scan_Drive_COL2

                                                  Table 3.1: Pin Description(continued)

                                                                  GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                    Description
                                                                  Select Number   Function Select       Function

                                                                  2               -                     SF2_IO_2              SF2_IO_2

                                                                  3               -                     I2S_RCLK_O/I2S_DI     I2S_RCLK_O/I2S_DI

                                                                  4               -                     SPI_SCLK              SPI_SCLK

                                                                  6               -                     I2C_SDA               I2C_SDA

                                                                                  uart_sig_7_sel=0      UART0_RTS             UART0_RTS

                                                                                  uart_sig_7_sel=1      UART0_CTS             UART0_CTS

                                                                                  uart_sig_7_sel=2      UART0_TXD             UART0_TXD

                                                                                  uart_sig_7_sel=3      UART0_RXD             UART0_RXD
                                                                  7
                                                                                  uart_sig_7_sel=4      UART1_RTS             UART1_RTS

                                                                                  uart_sig_7_sel=5      UART1_CTS             UART1_CTS

                                                                                  uart_sig_7_sel=6      UART1_TXD             UART1_TXD
 26      34      39      VDDIO_1          DI/DO   PAD_GPIO_23 2
                                                                                  uart_sig_7_sel=7      UART1_RXD             UART1_RXD

                                                                  8               -                     PWM_CH3               PWM_CH3

                                                                  9               -                     CAM_PIX_DAT4          CAM_PIX_DAT4

                                                                  10              -                     -                     -

                                                                  11              -                     SWGPIO23              SWGPIO23

                                                                  14              -                     TDO                   TDO

                                                                  16              -                     EXTERNAL_PA_FEM3      EXTERNAL_PA_FEM3

                                                                  19              -                     -                     -

                                                                  20              -                     QDEC1_led             QDEC1_led

                                                                  21              -                     Key_Scan_In_ROW7      Key_Scan_In_ROW7

                                                                  22              -                     Key_Scan_Drive_COL3   Key_Scan_Drive_COL3

                                                                  2               -                     SF2_IO_1              SF2_IO_1

                                                                  3               -                     I2S_BCLK              I2S_BCLK

                                                                  4               -                     SPI_MOSI              SPI_MOSI

                                                                  6               -                     I2C_SCL               I2C_SCL

                                                                                  uart_sig_0_sel=0      UART0_RTS             UART0_RTS

                                                                                  uart_sig_0_sel=1      UART0_CTS             UART0_CTS

                                                                                  uart_sig_0_sel=2      UART0_TXD             UART0_TXD

                                                                                  uart_sig_0_sel=3      UART0_RXD             UART0_RXD
                                                                  7
                                                                                  uart_sig_0_sel=4      UART1_RTS             UART1_RTS

                                                                                  uart_sig_0_sel=5      UART1_CTS             UART1_CTS

                                                                                  uart_sig_0_sel=6      UART1_TXD             UART1_TXD
 27      35      40      VDDIO_1          DI/DO   PAD_GPIO_24 2
                                                                                  uart_sig_0_sel=7      UART1_RXD             UART1_RXD

                                                                  8               -                     PWM_CH4               PWM_CH4

                                                                  9               -                     CAM_PIX_DAT5          CAM_PIX_DAT5

                                                                  10              -                     -                     -

                                                                  11              -                     SWGPIO24              SWGPIO24

                                                                  14              -                     TMS                   TMS

                                                                  16              -                     EXTERNAL_PA_FEM4      EXTERNAL_PA_FEM4

                                                                  19              -                     RMII_MDC              RMII_MDC

                                                                  20              -                     QDEC2_a               QDEC2_a

                                                                  21              -                     Key_Scan_In_ROW0      Key_Scan_In_ROW0

                                                                  22              -                     Key_Scan_Drive_COL4   Key_Scan_Drive_COL4

                                                  Table 3.1: Pin Description(continued)

                                                                  GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                    Description
                                                                  Select Number   Function Select       Function

                                                                  2               -                     SF2_CS                SF2_CS

                                                                  3               -                     I2S_FS                I2S_FS

                                                                  4               -                     SPI_MISO              SPI_MISO

                                                                  6               -                     I2C_SDA               I2C_SDA

                                                                                  uart_sig_1_sel=0      UART0_RTS             UART0_RTS

                                                                                  uart_sig_1_sel=1      UART0_CTS             UART0_CTS

                                                                                  uart_sig_1_sel=2      UART0_TXD             UART0_TXD

                                                                                  uart_sig_1_sel=3      UART0_RXD             UART0_RXD
                                                                  7
                                                                                  uart_sig_1_sel=4      UART1_RTS             UART1_RTS

                                                                                  uart_sig_1_sel=5      UART1_CTS             UART1_CTS

                                                                                  uart_sig_1_sel=6      UART1_TXD             UART1_TXD
 28      36      41      VDDIO_1          DI/DO   PAD_GPIO_25 2
                                                                                  uart_sig_1_sel=7      UART1_RXD             UART1_RXD

                                                                  8               -                     PWM_CH0               PWM_CH0

                                                                  9               -                     CAM_PIX_DAT6          CAM_PIX_DAT6

                                                                  10              -                     -                     -

                                                                  11              -                     SWGPIO25              SWGPIO25

                                                                  14              -                     TDI                   TDI

                                                                  16              -                     EXTERNAL_PA_FEM0      EXTERNAL_PA_FEM0

                                                                  19              -                     RMII_MDIO             RMII_MDIO

                                                                  20              -                     QDEC2_b               QDEC2_b

                                                                  21              -                     Key_Scan_In_ROW1      Key_Scan_In_ROW1

                                                                  22              -                     Key_Scan_Drive_COL5   Key_Scan_Drive_COL5

                                                                  2               -                     SF2_IO_3              SF2_IO_3

                                                                  3               -                     I2S_DIO/I2S_DO        I2S_DIO/I2S_DO

                                                                  4               -                     SPI_SS                SPI_SS

                                                                  6               -                     I2C_SCL               I2C_SCL

                                                                                  uart_sig_2_sel=0      UART0_RTS             UART0_RTS

                                                                                  uart_sig_2_sel=1      UART0_CTS             UART0_CTS

                                                                                  uart_sig_2_sel=2      UART0_TXD             UART0_TXD

                                                                                  uart_sig_2_sel=3      UART0_RXD             UART0_RXD
                                                                  7
                                                                                  uart_sig_2_sel=4      UART1_RTS             UART1_RTS

                                                                                  uart_sig_2_sel=5      UART1_CTS             UART1_CTS

                                                                                  uart_sig_2_sel=6      UART1_TXD             UART1_TXD
 29      37      42      VDDIO_1          DI/DO   PAD_GPIO_26 2
                                                                                  uart_sig_2_sel=7      UART1_RXD             UART1_RXD

                                                                  8               -                     PWM_CH1               PWM_CH1

                                                                  9               -                     CAM_PIX_DAT7          CAM_PIX_DAT7

                                                                  10              -                     -                     -

                                                                  11              -                     SWGPIO26              SWGPIO26

                                                                  14              -                     TCK                   TCK

                                                                  16              -                     EXTERNAL_PA_FEM1      EXTERNAL_PA_FEM1

                                                                  19              -                     RMII_RXERR            RMII_RXERR

                                                                  20              -                     QDEC2_led             QDEC2_led

                                                                  21              -                     Key_Scan_In_ROW2      Key_Scan_In_ROW2

                                                                  22              -                     Key_Scan_Drive_COL6   Key_Scan_Drive_COL6

                                                  Table 3.1: Pin Description(continued)

                                                                  GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                    Description
                                                                  Select Number   Function Select       Function

                                                                  2               -                     SF2_CLK               SF2_CLK

                                                                  3               -                     I2S_RCLK_O/I2S_DI     I2S_RCLK_O/I2S_DI

                                                                  4               -                     SPI_SCLK              SPI_SCLK

                                                                  6               -                     I2C_SDA               I2C_SDA

                                                                                  uart_sig_3_sel=0      UART0_RTS             UART0_RTS

                                                                                  uart_sig_3_sel=1      UART0_CTS             UART0_CTS

                                                                                  uart_sig_3_sel=2      UART0_TXD             UART0_TXD

                                                                                  uart_sig_3_sel=3      UART0_RXD             UART0_RXD
                                                                  7
                                                                                  uart_sig_3_sel=4      UART1_RTS             UART1_RTS

                                                                                  uart_sig_3_sel=5      UART1_CTS             UART1_CTS

                                                                                  uart_sig_3_sel=6      UART1_TXD             UART1_TXD
 30      38      43      VDDIO_1          DI/DO   PAD_GPIO_27 2
                                                                                  uart_sig_3_sel=7      UART1_RXD             UART1_RXD

                                                                  8               -                     PWM_CH2               PWM_CH2

                                                                  9               -                     -                     -

                                                                  10              -                     -                     -

                                                                  11              -                     SWGPIO27              SWGPIO27

                                                                  14              -                     TDO                   TDO

                                                                  16              -                     EXTERNAL_PA_FEM2      EXTERNAL_PA_FEM2

                                                                  19              -                     RMII_TX_EN            RMII_TX_EN

                                                                  20              -                     QDEC0_a               QDEC0_a

                                                                  21              -                     Key_Scan_In_ROW3      Key_Scan_In_ROW3

                                                                  22              -                     Key_Scan_Drive_COL7   Key_Scan_Drive_COL7

                                                                  2               -                     SF2_IO_0              SF2_IO_0

                                                                  3               -                     I2S_BCLK              I2S_BCLK

                                                                  4               -                     SPI_MOSI              SPI_MOSI

                                                                  6               -                     I2C_SCL               I2C_SCL

                                                                                  uart_sig_4_sel=0      UART0_RTS             UART0_RTS

                                                                                  uart_sig_4_sel=1      UART0_CTS             UART0_CTS

                                                                                  uart_sig_4_sel=2      UART0_TXD             UART0_TXD

                                                                                  uart_sig_4_sel=3      UART0_RXD             UART0_RXD
                                                                  7
                                                                                  uart_sig_4_sel=4      UART1_RTS             UART1_RTS

                                                                                  uart_sig_4_sel=5      UART1_CTS             UART1_CTS

                                                                                  uart_sig_4_sel=6      UART1_TXD             UART1_TXD
 31      39      44      VDDIO_1          DI/DO   PAD_GPIO_28 2
                                                                                  uart_sig_4_sel=7      UART1_RXD             UART1_RXD

                                                                  8               -                     PWM_CH3               PWM_CH3

                                                                  9               -                     CAM_PIX_DAT4          CAM_PIX_DAT4

                                                                  10              -                     -                     -

                                                                  11              -                     SWGPIO28              SWGPIO28

                                                                  14              -                     TMS                   TMS

                                                                  16              -                     EXTERNAL_PA_FEM3      EXTERNAL_PA_FEM3

                                                                  19              -                     RMII_RX_DV            RMII_RX_DV

                                                                  20              -                     QDEC0_b               QDEC0_b

                                                                  21              -                     Key_Scan_In_ROW4      Key_Scan_In_ROW4

                                                                  22              -                     Key_Scan_Drive_COL8   Key_Scan_Drive_COL8

                                                  Table 3.1: Pin Description(continued)

                                                                 GPIO Function   Peripheral Internal   PAD Main
 BL702   BL704   BL706   Voltage Domain   Type    Pin Name                                                                    Description
                                                                 Select Number   Function Select       Function

                                                                 2               -                     -                      -

                                                                 3               -                     I2S_FS                 I2S_FS

                                                                 4               -                     SPI_MISO               SPI_MISO

                                                                 6               -                     I2C_SDA                I2C_SDA

                                                                                 uart_sig_5_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_5_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_5_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_5_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_5_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_5_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_5_sel=6      UART1_TXD              UART1_TXD
 -       -       45      VDDIO_1          DI/DO   PAD_GPIO_29
                                                                                 uart_sig_5_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH4                PWM_CH4

                                                                 9               -                     CAM_PIX_DAT5           CAM_PIX_DAT5

                                                                 10              -                     -                      -

                                                                 11              -                     SWGPIO29               SWGPIO29

                                                                 14              -                     TDI                    TDI

                                                                 16              -                     EXTERNAL_PA_FEM4       EXTERNAL_PA_FEM4

                                                                 19              -                     -                      -

                                                                 20              -                     QDEC0_led              QDEC0_led

                                                                 21              -                     Key_Scan_In_ROW5       Key_Scan_In_ROW5

                                                                 22              -                     Key_Scan_Drive_COL9    Key_Scan_Drive_COL9

                                                                 2               -                     -                      -

                                                                 3               -                     I2S_DIO/I2S_DO         I2S_DIO/I2S_DO

                                                                 4               -                     SPI_SS                 SPI_SS

                                                                 6               -                     I2C_SCL                I2C_SCL

                                                                                 uart_sig_6_sel=0      UART0_RTS              UART0_RTS

                                                                                 uart_sig_6_sel=1      UART0_CTS              UART0_CTS

                                                                                 uart_sig_6_sel=2      UART0_TXD              UART0_TXD

                                                                                 uart_sig_6_sel=3      UART0_RXD              UART0_RXD
                                                                 7
                                                                                 uart_sig_6_sel=4      UART1_RTS              UART1_RTS

                                                                                 uart_sig_6_sel=5      UART1_CTS              UART1_CTS

                                                                                 uart_sig_6_sel=6      UART1_TXD              UART1_TXD
 -       -       46      VDDIO_1          DI/DO   PAD_GPIO_30
                                                                                 uart_sig_6_sel=7      UART1_RXD              UART1_RXD

                                                                 8               -                     PWM_CH0                PWM_CH0

                                                                 9               -                     CAM_PIX_DAT6           CAM_PIX_DAT6

                                                                 10              -                     -                      -

                                                                 11              -                     SWGPIO30               SWGPIO30

                                                                 14              -                     TCK                    TCK

                                                                 16              -                     EXTERNAL_PA_FEM0       EXTERNAL_PA_FEM0

                                                                 19              -                     -                      -

                                                                 20              -                     QDEC1_a                QDEC1_a

                                                                 21              -                     Key_Scan_In_ROW6       Key_Scan_In_ROW6

                                                                 22              -                     Key_Scan_Drive_COL10   Key_Scan_Drive_COL10

                                                                          Table 3.1: Pin Description(continued)

                                                                                                GPIO Function   Peripheral Internal   PAD Main
 BL702        BL704         BL706        Voltage Domain      Type          Pin Name                                                                          Description
                                                                                                Select Number   Function Select       Function

                                                                                                2               -                     -                      -

                                                                                                3               -                     I2S_RCLK_O/I2S_DI      I2S_RCLK_O/I2S_DI

                                                                                                4               -                     SPI_SCLK               SPI_SCLK

                                                                                                6               -                     I2C_SDA                I2C_SDA

                                                                                                                uart_sig_7_sel=0      UART0_RTS              UART0_RTS

                                                                                                                uart_sig_7_sel=1      UART0_CTS              UART0_CTS

                                                                                                                uart_sig_7_sel=2      UART0_TXD              UART0_TXD

                                                                                                                uart_sig_7_sel=3      UART0_RXD              UART0_RXD
                                                                                                7
                                                                                                                uart_sig_7_sel=4      UART1_RTS              UART1_RTS

                                                                                                                uart_sig_7_sel=5      UART1_CTS              UART1_CTS

                                                                                                                uart_sig_7_sel=6      UART1_TXD              UART1_TXD
 -            -             47           VDDIO_1             DI/DO         PAD_GPIO_31 3
                                                                                                                uart_sig_7_sel=7      UART1_RXD              UART1_RXD

                                                                                                8               -                     PWM_CH1                PWM_CH2

                                                                                                9               -                     CAM_PIX_DAT7           CAM_PIX_DAT7

                                                                                                10              -                     -                      -

                                                                                                11              -                     SWGPIO31               SWGPIO31

                                                                                                14              -                     TDO                    TDO

                                                                                                16              -                     EXTERNAL_PA_FEM1       EXTERNAL_PA_FEM1

                                                                                                19              -                     -                      -

                                                                                                20              -                     QDEC1_b                QDEC1_b

                                                                                                21              -                     Key_Scan_In_ROW7       Key_Scan_In_ROW7

                                                                                                22              -                     Key_Scan_Drive_COL11   Key_Scan_Drive_COL11

 -            -             -            VDDIO_3             DI/DO         PAD_32               -               -                     -                      Embedded pad for embedded psram or
                                                                                                                                                             flash

 -            -             -            VDDIO_3             DI/DO         PAD_33               -               -                     -                      Embedded pad for embedded psram or
                                                                                                                                                             flash

 -            -             -            VDDIO_3             DI/DO         PAD_34               -               -                     -                      Embedded pad for embedded psram or
                                                                                                                                                             flash

 -            -             -            VDDIO_3             DI/DO         PAD_35               -               -                     -                      Embedded pad for embedded psram or
                                                                                                                                                             flash

 -            -             -            VDDIO_3             DI/DO         PAD_36               -               -                     -                      Embedded pad for embedded psram or
                                                                                                                                                             flash

 -            -             -            VDDIO_3             DI/DO         PAD_37               -               -                     -                      Embedded pad for embedded psram or
                                                                                                                                                             flash

 12           15            19           AVDD33_AON          Analog        XTAL32K_IN           -               -                     -                      Crystal oscillator 32.768kHz input

 13           16            20           AVDD33_AON          Analog        XTAL32K_OUT          -               -                     -                      Crystal oscillator 32.768kHz output

 20           23            27           AVDD33_AON          Analog        XTAL_HF_IN           -               -                     -                      External crystal input, 32MHz

 21           24            28           AVDD33_AON          Analog        XTAL_HF_OUT          -               -                     -                      External crystal output, 32MHz

 15           18            22           AVDD33_AON          Analog        PU_CHIP              -               -                     -                      Chip power-up

 16           19            23           AVDD15              Analog        ANT                  -               -                     -                      RF input and output (single pin)

 32           40            48           -                   Power         VDDIO_1              -               -                     -                      Externally powered 3.3V or 1.8V

 10           11            14           -                   Power         VDDIO_2              -               -                     -                      Externally powered 3.3V

 25           31            36           -                   Power         VDDIO_3              -               -                     -                      Externally powered 3.3V or 1.8V

 14           17            21           -                   Power         AVDD33_AON           -               -                     -                      Externally powered 3.3V

 17           20            24           -                   Power         AVDD33_PA            -               -                     -                      Externally powered 3.3V

 19           22            26           -                   Power         AVDD_RF              -               -                     -                      Externally powered 3.3/1.8/1.5V

 18           21            25           -                   Power         AVDD15               -               -                     -                      Internal LDO output (for internal use only)

 9            10            13           -                   Power         SW_DCDC              -               -                     -                      DCDC power 1.8V

 8            9             12           -                   Power         DCDC_OUT             -               -                     -                      DCDC power 1.8V

 6            7             10           -                   Power         VDDBUS_USB           -               -                     -                      USB power

 7            8             11           -                   Power         VDDCORE              -               -                     -                      Internal LDO output (for internal use only)

1 This function defaults to SPI_MOSI , which can be converted to SPI_MISO through a register.
2 BL706C-22-Q2I does not support the use of this pin.
3 BL706C-22-Q2I bootstrap pin: GPIO31 , other BL70x bootstrap pin: GPIO28.

                                                                            Electrical Specifications
                                                                                                          4
4.1 Absolute Maximum Rating

                                       Table 4.1: Absolute Maximum Rating

 Pin Name                       Min.                     Max.                      Unit

 VDDIO_1                        -0.3                     3.63                      V

 VDDIO_2                        -0.3                     3.63                      V

 VDDIO_3                        -0.3                     3.63                      V

 VSSBUS_USB                     -0.3                     5.5                       V

 AVDD33_AON                     -0.3                     3.63                      V

 AVDD33_PA                      -0.3                     3.63                      V

 AVDD33_RF                      -0.3                     3.63                      V

 ESD Protection (HBM)                                    2000                      V

 Storage Temperature            -40                      125                       �

4.2 Operating Condition

4.2.1 Power characteristics

                                  Table 4.2: Recommended Power Operating Range

 Pin Name               Min.                   Typ                 Max.                   Unit

 VDDIO_1                1.8 1                  3.3                 3.63                   V

 VDDIO_2                1.8                    3.3                 3.63                   V

 VDDIO_3                1.8                    3.3                 3.63                   V

                                   Table 4.2: Recommended Power Operating Range(continued)

 Pin Name                       Min.                        Typ                            Max.                     Unit

 VDDBUS_USB                     4.5                         5                              5.5                      V

 AVDD33_AON                     1.8                         3.3                            3.63                     V

 AVDD33_PA                      1.4/2.97                    1.5/3.3                        1.6/3.63                 V

 AVDD33_RF                      1.4/2.97                    1.5/3.3                        1.6/3.63                 V

 1   The minimum operating voltage of the main chip is 1.8V. For Flash co-packaged chips, the minimum operating voltage depends on the minimum
     Flash operating voltage, such as 2.3 V.

4.2.2 Temperature sensor characteristics

                                        Table 4.3: Recommended Temperature Operating Range

                               Item                               Min.              Max.                                Unit

                              Main Die                            -40               105                                 °C
 Temperature
                              Multi-Die SiP                       -40               85 1                                °C

 1   The maximum temperature of BL702C-10-Q2H is 105°C.

4.2.3 General operating conditions

                                                Table 4.4: General Operating Conditions

 Item                    Description                                  Min.                 Typ              Max.                  Unit

 FCPU                    CPU/TCM/Cache clock frequency                0                    32               144                   MHz

 FSYS                    System clock frequency                       0                    32               72                    MHz

4.2.4 GPADC characteristics

                                                    Table 4.5: GPADC characteristics

 Symbol           Parameter                    Conditions                          Min                Typ         Max           Units

 VDD33            Vbat supply voltage                                              2.3                            3.6           V

 T                Working tempreture                                               -40                            125           �

                  Current consumption of       PGA1&2 off (2M clock)                                  150
 Ivdd33                                                                                                                         μA
                  ADC on VDD33
                                               PGA1&2 on(2M clock)                                    350

                                               Table 4.5: GPADC characteristics(continued)

 Symbol         Parameter                      Conditions                      Min          Typ   Max          Units

                ADC input top clock
 Fclk                                          Clock from SOC                  1.5                32           MHz
                frequency

                                               2.048M(12bit mode)
 Fsample        Sampling rate                  32K-128K(14bit mode)                               2            MHz
                                               8K-16K(16bit mode)

                Input conversion               Differential mode                                  6.4
 Vin                                                                                                           V(vpp)
                voltage range
                                               Single-ended mode                                  3.2

                Total input channel
 Rin                                                                                              2            KΩ
                resistance

 Tcal           Calibration time               Fsample=2M(16bit mode)                             140          uS

 Tpu            Power up time                                                                     1            uS

                                               12bit mode                                         1

                                               14bit mode 1                                       16

 Tconv          Total conversion time          14bit mode 2                                       64           1/Fsample

                                               16bit mode 3                                       128

                                               16bit mode 4                                       256

 1   14-bit mode with 16 times average
 2   14-bit mode with 64 times average
 3   16-bit mode with 128 times average
 4   16-bit mode with 256 times average

Note: Unless otherwise specified, the parameters given in Table 1 are derived from test under -40 to 125oC, supply
AVDD=3.3V, DVDD=1.1V.

                                                 Table 4.6: ADC electrical characteristic

 Symbol         Parameter                      Conditions                      Min          Typ   Max          Units

 DNL 1          Differential linearity error                                                      +/-1         LSB

 INL 1          Integral linearity error                                                          +/-2         LSB

 Offset         Input offset                                                                      +/-2         LSB

 Ge 1& 2        Gain error                                                                        +/-1         %

                                             Table 4.6: ADC electrical characteristic(continued)

 Symbol           Parameter                     Conditions                     Min         Typ     Max         Units

                                                12bit mode(201KHz input)       9.7         10.5

 ENOB             Effective number of bits      14bit mode(2.5KHz input)       10.8        11.4                bit

                                                16bit mode(1KHz input)         11.5        12.3

                                                12bit mode(201KHz input)       59          65
                  Signal-to-noise-distortion
 SNDR                                           14bit mode(2.5KHz input)       66          72.4                dB
                  (PGA on)
                                                16bit mode(1KHz input)         71          76.8

                                                12bit mode(201KHz input)       58          64
                  Signal-to-noise-distortion
 SNDR                                           14bit mode(2.5KHz input)       64          69.5                dB
                  (PGA gain=4)
                                                16bit mode(1KHz input)         70          74

 1   more test needed
 2   after calibration

                                                                                                             Product use
                                                                                                                                    5
5.1 Moisture Sensitivity Level(MSL)
The moisture sensitivity level of the chip is: MSL3. After the vacuum package is opened, it needs to be used up within
168 hours (7 days) at ≤30°C/60%RH, otherwise it needs to be baked and put online.

For baking temperature and time, please refer to IPC/JEDECJ-STD-033B01.

 Table 5.1: Reference Conditions for Drying Mounted or Unmounted SMD Packages (User Bake: Floor life begins
                                              counting at time = 0 after bake)

                                                                               Bake @ 90°C                      Bake @ 40°C
                                          Bake @ 125°C
                                                                               ≤5% RH                           ≤5% RH

 Package Body   Level          Exceeding         Exceeding        Exceeding           Exceeding    Exceeding           Exceeding
                               Floor Life        Floor Life       Floor Life          Floor Life   Floor Life          Floor Life
                               by >72 h          by ≤72 h         by >72 h            by ≤72 h     by >72 h            by ≤72 h

                2              5 hours           3 hours          17 hours            11 hours     8 days              5 days

                2a             7 hours           5 hours          23 hours            13 hours     9 days              7 days

 Thickness      3              9 hours           7 hours          33 hours            23 hours     13 days             9 days
 ≤1.4 mm
                4              11 hours          7 hours          37 hours            23 hours     15 days             9 days

                5              12 hours          7 hours          41 hours            24 hours     17 days             10 days

                5a             16 hours          10 hours         54 hours            24 hours     22 days             10 days

5.2 Electro-Static discharge（ESD）
 • Human Body Model(HBM): 2000V

 • Charged-Device Model(CDM): 500V

5.3 Reflow Profile
For details, please refer to IPC/JEDEC J-STD-020E.

                                  Fig. 5.1: Classification Profile (Not to scale)

                                               Table 5.2: Classification Reflow Profiles

 Profile Feature                                  Sn-Pb Eutectic Assembly                        Pb-Free Assembly

 Preheat/Soak
 Temperature Min (Tsmin )                         100 °C                                         150 °C
                                                  150 °C                                         200 °C
 Temperature Max (Tsmax )
                                                  60-120 seconds                                 60-120 seconds
 Time (ts ) from (Tsmin to Tsmax )

 Ramp-up rate (TL to Tp )                         3 °C/second max.                               3 °C/second max.

 Liquidous temperature (TL )                      183 °C                                         217 °C
 Time (tL ) maintained above TL                   60-150 seconds                                 60-150 seconds

 Peak package body temperature (Tp )              240 °C+0/-5 °C                                 250 °C+0/-5 °C

 Time (tp )* within 5 °C of the specified
                                                  10-30 seconds                                  20-40 seconds
 classification temperature (Tc )

 Ramp-down rate (Tp to TL )                       6 °C/second max                                6 °C/second max

 Time 25 °C to peak temperature                   6 minutes max                                  8 minutes max

                       - Tolerance for peak profile temperature (Tp) is defined as a supplier minimum and a user maximum.

                                                                                                                             Reference Design
                                                                                                                                                     6
                                                                             Antenna

                                                                    C16

                                                                                                              GPIO28

                                                                                    L2
                                                                    C15                                      R1
                         5V         3.3V

            C8
                                                                                                                       AVDD33_AON

            C9                                                                ANT
                                           AVDD15 (1.5V Output)                                                        R3
                                           Internal Use Only
            C6                                                                                             PU_CHIP
                                           VDDCORE
                                                                                                                       C14
            C5
                                           VDDBUS_USB

            C10
                                                                                                              GPIO     15/23/31x GPIO
            C11
                                           AVDD33_PA

            C12
                                           AVDD33_AON                                                                   1.8 or 3.3V
                      GPOP9~12
            C13       (Interrupt)
                                           VDDIO_2                                                         VDDIO_1               GPOP0~8/GPIO23~31

                                                         BL702/4/6
                       R2
                      (NM)          L1                                                                                 C1
                                           SW_DCDC

            C7                                                                                                          1.8 or 3.3V
                                           DCDC_OUT

            C3                                                                                             VDDIO_3               GPOP14~22
                                           AVDD_RF
                                                                                                                       C2
            C4                                XTAL_IN             XTAL_OUT          XTAL32K_IN        XTAL32K_OUT

                                                        32MHz                               32.768kHz
                  DCDC can be bypassed
                  (L1 removed) with R2
                  mounted for low cost
                                                          X1                                     X2

                                                         Fig. 6.1: Reference Design

                                                            Package Information(QFN32)
                                                                                                  7

                                 Fig. 7.1: QFN32 Package drawing

                                 Table 7.1: QFN32 Size Description

                                                UNIT OF MEASURE = MILLIMETER
 SYMBOL
                          MIN                     NOM                          MAX

 A                        0.70                    0.75                         0.80

                                 Table 7.1: QFN32 Size Description(continued)

                                                     UNIT OF MEASURE = MILLIMETER
 SYMBOL
                          MIN                           NOM                         MAX

 A1                       0.00                          0.02                        0.05

 A2                       0.50                          0.55                        0.60

 A3                                                              0.20REF

 b                        0.15                          0.20                        0.25

 D                        3.90                          4.00                        4.10

 E                        3.90                          4.00                        4.10

 D2                       2.80                          2.90                        3.00

 E2                       2.80                          2.90                        3.00

 e                        0.30                          0.40                        0.50

 H                                                               0.30REF

 K                                                               0.25REF

 L                        0.25                          0.30                        0.35

 R                        0.09                          -                           -

 c1                       -                             0.10                        -

 c2                       -                             0.10                        -

                                                            Package Information(QFN40)
                                                                                                  8

                                 Fig. 8.1: QFN40 Package drawing

                                 Table 8.1: QFN40 Size Description

                                                UNIT OF MEASURE = MILLIMETER
 SYMBOL
                          MIN                     NOM                          MAX

 A                        0.80                    0.85                         0.90

                                 Table 8.1: QFN40 Size Description(continued)

                                                     UNIT OF MEASURE = MILLIMETER
 SYMBOL
                          MIN                           NOM                         MAX

 A1                       0                             0.02                        0.05

 A2                       0.60                          0.65                        0.70

 A3                                                              0.20REF

 b                        0.15                          0.20                        0.25

 D                        4.90                          5.00                        5.10

 E                        4.90                          5.00                        5.10

 D2                       3.60                          3.70                        3.80

 E2                       3.60                          3.70                        3.80

 e                        0.35                          0.40                        0.45

 K                        0.20                          -                           -

 L                        0.35                          0.40                        0.45

 R                        0.075                         -                           -

 C1                       -                             0.12                        -

 C2                       -                             0.12                        -

                                                            Package Information(QFN48)
                                                                                                  9

                                 Fig. 9.1: QFN48 Package drawing

                                 Table 9.1: QFN48 Size Description

                                                UNIT OF MEASURE = MILLIMETER
 SYMBOL
                          MIN                     NOM                          MAX

 A                        0.80                    0.85                         0.90

                                 Table 9.1: QFN48 Size Description(continued)

                                                     UNIT OF MEASURE = MILLIMETER
 SYMBOL
                          MIN                           NOM                         MAX

 A1                       0                             0.02                        0.05

 A3                                                              0.20REF

 b                        0.15                          0.20                        0.25

 D                        5.90                          6.00                        6.10

 E                        5.90                          6.00                        6.10

 D2                       4.30                          4.40                        4.50

 E2                       4.30                          4.40                        4.50

 e                        0.30                          0.40                        0.50

 H                                                               0.35REF

 K                        0.30                          0.40                        0.50

 L                        0.30                          0.40                        0.50

 R                        0.075                         -                           -

                                                                     Top Marking Definition
                                                                                              10
                                                             Temperature code:I/H
  Pin1 Loca�on
                                                             I：-40°~85°
                                                             H：-40°~105°

                                             I

                                                      Part number: BL702/4/6(C/S):
                                                           C:BLE+Zigbee Combo, S:BLE+802.15.4 Slim
                          BL702C-A0                   00:
  Lot number              Lot Number                       MSB=ﬂash, 0: no ﬂash, A:4Mb, 1: 8Mb, 2: 16Mb,...
                           YYWW-AC                         LSB=pSRAM, 0:no pSRAM, 2: 16Mb

                          Date code

                                Fig. 10.1: Top Marking Definition

                                                                                  Ordering Information
                                                                                                         11
 Show in package

                 BL70xC- 00-Q 2I

                                                    Environment code :
                                                    +=RoHS 0/6 , - = RoHS 5 /6 , 1 =RoHS 6 / 6 , 2 = Green
                                                    Temperature code : I /H
                                                                        I: -40°~85°; H: -40°~125°
                                                    Package code: Q(QFN), B(BGA),CSP

                                                    Band: S: Single-band 2.4G; D: dualband, 2.4G/5G; NA;
                                                    MSB=ﬂash, 0: no ﬂash, 1: 8Mb, 2: 16Mb, 4:32Mb,A:4Mb,
                                                    LSB=pSRAM, 0:no pSRAM, 2: 16Mb

                                                   Part number: C/S: BLE+Zigbee Combo, BLE+802.15.4 Slim,
                                                   BL70xC-> 702C: QFN32 Zigbee/BLE Combo
                                                            702S: QFN32 BLE+802.15.4 Slim(no zigbee stack), Or MCU
                                                            704S: QFN40 BLE+802.15.4 Slim(no zigbee stack), Or MCU
                                                            706C: QFN48 Zigbee/BLE Combo
                                                            706S: QFN48 BLE+802.15.4 Slim(no zigbee stack), Or MCU

                                           Fig. 11.1: Part Number

                                        Table 11.1: Part Order Options

 Product No.              Description

 BL702S-A0-Q2I            BLE+802.15.4 Slim, MCU, QFN32, 4Mb flash

 BL702C-10-Q2H            Zigbee+BLE Combo, QFN32, 8Mb flash

                                 Table 11.1: Part Order Options(continued)

 Product No.              Description

 BL702S-10-Q2I            BLE+802.15.4 Slim, MCU, QFN32, 8Mb flash

 BL706C-10-Q2I            Zigbee+BLE Combo, QFN48, 8Mb flash

 BL706S-10-Q2I            BLE+802.15.4 Slim, MCU, QFN48, 8Mb flash

 BL706C-22-Q2I            Zigbee+BLE Combo, QFN48, 16Mb flash, 16Mb pSRAM

                                                                                              Revision history
                                                                                                              12
                                Table 12.1: Document revision history

 Date                Revision     Changes

 2020/9/15           1.0          Initial release

 2020/9/22           1.1          Add package information(QFN48)

 2020/10/20          1.2          Modify the number of TIMER

 2020/12/4           1.4          Differentiate different package information

 2021/1/11           1.5          Add GPIO Muxed Pins

 2021/1/22           1.6          Add Reference design

 2021/3/16           1.7          Add Product use, ADC characteristics, modify the default function of SPI pins

 2021/4/9            1.8          Add peripheral introduction

 2021/5/27           1.9          Modify Pinmux description and minimum temperature value

 2021/6/9            2.0          Update product number

 2021/7/1            2.1          Modify the description of embedded pad

 2021/11/22          2.3          Modify ordering information, add BL702C-10-Q2H temperature characteristics

 2022/1/14           2.4          Update power characteristics and power consumption

 2022/5/17           2.5          Add EMAC timing description and GPIO0 default pin function description

 2022/8/10           2.6          Add description of BL706C-22-Q2I
