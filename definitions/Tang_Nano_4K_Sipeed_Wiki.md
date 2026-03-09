               Next-Gen 4K AI Camera MaixCAM2 is now crowdfunding! 10X faster than K230 in yolo task!   x

                                Tang Nano 4K

 2025-02-11                                                                   Edit this page

  Edit on 2022.08.16

1. Introduction
Tang Nano 4K is a development board designed based on Gowin little-bee GW1NSR-LV4C

FPGA chip. The board is equipped with camera interface and HDMI interface. There is also an

onboard USG-JTAG debugger, which make it convenient for users to use. Its Cortex-M3
hardcore can help users study mcu.

2. Specs
    The sheet below shows difference with previous product

 FPGA chip               GW1N-1-LV                GW1NSR-LV4C

 logic units             1152                     4608

 Register                864                      3456

 Hard processor          none                     ARM Cortex M3

 Block SRAM(bits)        72K                      180K

 User flash(bits)        96K                      256K

 Number of PLL           1                        2

 Number of I/O Bank      4                        4

 Number of users I/O     41                       44
 Screen interface        40P RGB LCD interface    HDMI interface

 camera interface        None                     DVP interface

 Size                    58.4mm*21.3mm            60mm*22.86mm

2.1. Pinmap

3. Development software
Visit install ide to setup your programming environment.

4. Burn firmware
Tang Nano 4K uses the onboard BL702 for jtag, with which to burn bitstream.

Run the Programmer in Gowin IDE to download firmware into FPGA.

5. Informations
     Datasheet

     Schematic

     Bit number map

     Dimensional drawing

     3D File
   hip Manual

   Examples

6. Addition
 1. If you have trouble with this board, you can join our telegram (t.me/sipeed) or contact us
   on twitter ( https://twitter.com/SipeedIO ). Leaving message below is also OK.

 2. Visit Tang questions first if you have any trouble.

 3. Debugging Cortex-M3, we suggest to use serial-port debug way. If you are excellent
   enough you can try other ways to debug it.

 4. THe HDMI ports are multiplexed as IO and routed to the pin headers. The actual results

   of the IO which are multiplexed with HDMI pins on the pin headers may not be consistent
   with what you want because of the external pull up.
