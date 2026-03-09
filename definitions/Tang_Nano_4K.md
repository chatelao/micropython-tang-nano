Sipeed Tang Nano 4K Datasheet v1.0

Sipeed Tang Nano 4K Datasheet v1.0

 Characteristic：
    Main Chip : GW1NSR-LV4C with arm Cortex-M3 hard core
    Embedded FPGA logic module unit (4608 lut4)
    SOC device realizes the seamless connection between programmable
     logic device and embedded processor
    Onboard usb-jtag debugger
    On board HDMI connector and its circuit
    Onboard camera connector (DVP interface)
    Onboard wson8 pad (32Mbit nor flash default)

深圳矽速科技有限公司                                                              1
Sipeed Tang Nano 4K Datasheet v1.0

                                 Update record of this document

         V1.0             Edited on August 7, 2021; Original document

                                         Hardware overview

                           • Cortex-M3 32-bit RISC kernel；ARM3v7M Architecture
                           • Maximum operating frequency : 80MHz
  Hard core processor
                           • Hardware division and single cycle multiplication
                           • 26 interrupts with 8 priorities
      Logic cells
                          Quantity：4608
    (4-input LUT4)

      Register(FF)        Quantity：3456

  Block static random
    access memory         Capacity：180K
     B-SRAM(bits)

   18 x 18 Multiplier     Quantity：16

  User flash memory       Embedded 256Kb storage space

      HyperRAM            Capacity：64Mb ； Bit width：8bits

                           • 2 PLL
 Flexible PLL resources    • Realize the frequency doubling, frequency division and phase shift
                           • Global clock network resources
    Display screen
                          HDMI connector and its circuit
       interface

  Camera connector        24P 0.5mm spacing FPC connector (common DVP camera sequence)

      Debugger            On board bl702 chip provides JTAG debugging function for GW1NSR

                           •   Support 4mA, 8mA, 16mA, 24mA and other driving capabilities
                           •   Independent bus keeper, pull-up / pull-down resistor and open drain
          IO
                          output options are provided for each I/O
                           • Support Mipi interface

     Push button          2 programmable Push buttons

          LED             On board 1 programmable LED

   Number of GPIO         38

深圳矽速科技有限公司                                                                                        2
Sipeed Tang Nano 4K Datasheet v1.0

                                     Software overview

IDE                     Support Gowin IDE(Version>1.9.7) ；Support Gowin Synthesis

Floating License        45.33.107.56:10559

                        Send application email to support@sipeed.com
Off-line License
                        Example of mail title ：【Apply Tang Lic】MAC: xxxxxx

IDE                     http://www.gowinsemi.com.cn/faq.aspx

MCU development
                        http://www.gowinsemi.com.cn/down.aspx?TypeId=317&Id=394
documents
GOAI brief
                        http://www.gowinsemi.com.cn/down.aspx?TypeId=666&Id=757
introduction

GOAI Official project   https://github.com/gowinsemi/GoAI

Sipeed Reference
                        https://github.com/sipeed/TangNano-4K-example
example

                                     Working conditions

Power supply
                        TYPE-C connector：5V±10% 0.5A
demand

Temperature rise        <30K

Operating ambient
                        -10℃ ~ 65℃
temperature range

深圳矽速科技有限公司                                                                          3
Sipeed Tang Nano 4K Datasheet v1.0

                            Appearance drawing

深圳矽速科技有限公司                                       4
Sipeed Tang Nano 4K Datasheet v1.0

                            Functional annotation

深圳矽速科技有限公司                                          5
Sipeed Tang Nano 4K Datasheet v1.0

                           Dimension information

Length                         60.0 mm

Width                          22.86mm

Thickness                      Please check the 3D drawing

深圳矽速科技有限公司                                                   6
Sipeed Tang Nano 4K Datasheet v1.0

                                  Matters needing attention

                                  Please pay attention to avoid static electricity hitting PCBA;
ESD protection                    Please release the static electricity from the handle before contacting
                                  PCBA
                                  The working voltage of each GPIO has been marked in the
                                  schematic . Please do not let the actual working voltage of GPIO
Tolerance voltage
                                  exceed the rated value, otherwise it will cause permanent damage to
                                  PCBA
                                  When connecting FPC flexible cable, please ensure that the cable is
FPC connector
                                  completely inserted into the cable without offset；
                                  Please disconnect the power completely before plugging in and out
Plugging
                                  the camera
                                  Please avoid any liquid or metal touching the pads of components
Avoid short circuit               on PCBA during power on, otherwise it will cause short circuit and
                                  burn PCBA
                                   • JTAG : IOT2A/IOT2B/IOT3A/IOT3B/IOT4B
                                   • MODE : IOT7A
Please avoid using these GPIO.
                                   • DONE : IOT5B
                                  If you must use these GPIO, please read the following documents:
                                  <Ug292-1.0 schematic diagram instruction manual>

                                            Resources

Official website                  www.sipeed.com

Github                            https://github.com/Sipeed

BBS                               http://bbs.sipeed.com

Wiki                              wiki.sipeed.com

Sipeed Model platform             https://maixhub.com/

SDK /HDK Relevant information     https://dl.sipeed.com/

E-mail
(Technical support and business   support@sipeed.com
cooperation)

深圳矽速科技有限公司                                                                                                  7
Sipeed Tang Nano 4K Datasheet v1.0

                          免责声明和版权声明
                          本文档中的信息（包括 URL 地址）如有更改，恕不另行通知。
                          该文档由 Sipeed 提供，不附带任何形式的担保，包括任何适销
                          性担保，以及其他地方提及的任何提案，规范或样本。 本文
                          档不构成责任，包括使用本文档中的信息侵犯任何专利权。
                          Copyrights © 2021 Sipeed Limited. All rights reserved.

深圳矽速科技有限公司                                                                         8
