










Gowin PSRAM Memory Interface IP
User Guide




IPUG525-1.3.1E,12/15/2020





Copyright©2020 Guangdong Gowin Semiconductor Corporation. All Rights Reserved.
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



Revision History
Date Version Description
10/17/2018 1.0E Initial version published.
11/23/2018 1.1E
 PSRAM user interface added; PLL that the user
autonomously configured moved to the outside of the
design; Embedded PSRAM working frequency modified;
 GW1NSR-2C/GW1NSR-2 supported.
03/01/2019 1.2E Two-channel PSRAM IP support and description added.
07/26/2019 1.3E The description of HyperRam and GUI options added.
12/15/2020 1.3.1E 3.3 Resource Utilization improved.

 Contents

IPUG525-1.3.1E i

Contents
Contents ................................................................................................................ i
List of Figures ...................................................................................................... ii
List of Tables ...................................................................................................... iii
1 About This Guide ............................................................................................. 1
1.1 Purpose .............................................................................................................................. 1
1.2 Terminology and Abbreviations ........................................................................................... 1
1.3 Support and Feedback ....................................................................................................... 2
2 Overview ........................................................................................................... 3
3 Feature and Performance ............................................................................... 4
3.1 Key Features ...................................................................................................................... 4
3.2 Working Frequency and Bandwidth Efficiency ................................................................... 4
3.3 Resource Utilization ............................................................................................................ 5
4 Functional Description .................................................................................... 6
4.1 Structure ............................................................................................................................. 6
4.2 Memory Controller Logic .................................................................................................... 6
4.3 PHY..................................................................................................................................... 8
4.3.1 Initialization Unit ............................................................................................................... 9
4.3.2 Data Path Unit ................................................................................................................. 9
4.3.3 Control Path Unit ............................................................................................................. 9
4.3.4 I/O Logical Unit ................................................................................................................ 9
4.4 Major Functions .................................................................................................................. 9
4.4.1 Initialization ...................................................................................................................... 9
4.4.2 Send Addresses and Commands .................................................................................. 10
4.4.3 Write data....................................................................................................................... 11
4.4.4 Read data ...................................................................................................................... 13
5 Ports List ........................................................................................................ 15
6 Parameter Configuration ............................................................................... 18
7 Reference Design .......................................................................................... 19
8 Interface Configuration ................................................................................. 21
9 File Delivery ................................................................................................... 27
9.1 Document ......................................................................................................................... 27
9.2 Design Source Code (Encryption) .................................................................................... 27
9.3 Reference Design ............................................................................................................. 27

 List of Figures

IPUG525-1.3.1E ii

List of Figures
Figure 4-1 Gowin PSRAM Memory Interface IP Structure ................................................................. 6
Figure 4-2 Basic Structure of PSRAM Memory Controller Logic ....................................................... 7
Figure 4-3 Basic Structure of PSRAM PHY ....................................................................................... 8
Figure 4-4 Initialization Completion Signal Timing Diagram .............................................................. 10
Figure 4-5 Addressing Scheme in Row-Column Order...................................................................... 10
Figure 4-6 Command, Address, and Enable Signal Timing ............................................................... 11
Figure 4-7 Write Data Interface Timing .............................................................................................. 12
Figure 4-8 Write data timing when the burst length is 32 .................................................................. 12
Figure 4-9 Write data timing when the burst length is 64 .................................................................. 12
Figure 4-10 Write data timing when the burst length is 128 .............................................................. 13
Figure 4-11 Read Data Port Timing ................................................................................................... 13
Figure 4-12 Read data timing when the burst length is 32 ................................................................ 13
Figure 4-13 Read data timing when the burst length is 64 ................................................................ 14
Figure 4-14 Read data timing when the burst length is 128 .............................................................. 14
Figure 7-1 Basic Structure of Reference Design ............................................................................... 19
Figure 7-2 Part of psram_test Interface Signal Simulation Waveform ............................................... 20
Figure 8-1 Open IP Core Generater .................................................................................................. 21
Figure 8-2 Open PSRAM Memeory Interface IP core ....................................................................... 22
Figure 8-3 IP Core Interface .............................................................................................................. 22
Figure 8-4 Help File ........................................................................................................................... 23
Figure 8-5 Basic Information Configuration Interface ........................................................................ 24
Figure 8-6 Type Option ...................................................................................................................... 25
Figure 8-7 Options ............................................................................................................................. 26

 List of Tables

IPUG525-1.3.1E iii

List of Tables
Table 1-1 Terminology and Abbreviations .......................................................................................... 1
Table 2-1 Gowin PSRAM Memory Interface IP .................................................................................. 3
Table 3-1 Resource Utilization ........................................................................................................... 5
Table 4-1 cmd Command ................................................................................................................... 10
Table 5-1 I/O Ports List of Gowin PSRAM Memory Interface IP ........................................................ 15
Table 5-2 Gowin PSRAM Memory Inteface 2CH IP I/O Port List ...................................................... 16
Table 6-1 Static Parameter Options of Gowin PSRAM Memory Interface ......................................... 18
Table 7-1 Psram_syn_top Module Input Interface List....................................................................... 19
Table 9-1 Document List .................................................................................................................... 27
Table 9-2 Design Source Code List ................................................................................................... 27
Table 9-3 Ref. Design Folder Contents .............................................................................................. 28


1 About This Guide 1.1 Purpose

IPUG525-1.3.1E 1(28)

1 About This Guide
1.1 Purpose
Gowin PSRAM Memory Interface IP user guide includes the structure
and function description, port description, timing specification,
configuration and call, reference design, etc. The guide helps you to quickly
learn the features and usage of Gowin PSRAM Memory Interface IP. Since
the usage of HyperRam is basically the same as that of PSRAM, this
manual takes PSRAM as the main part to introduce the usage, which is
also suitable for HyperRAM if not otherwise specifiedRelated Documents
The latest user guides are available on the GOWINSEMI Website. You
can find the related documents at www.gowinsemi.com/en
:
 DS100, GW1N series of FPGA Products Data Sheet
 DS117, GW1NR series of FPGA Products Data Sheet
 DS821, GW1NS series of FPGA Products Data Sheet
 DS102, GW2A series of FPGA Products Data Sheet
 DS226, GW2AR series of FPGA Products Data Sheet
 DS841, GW1NZ series of FPGA Products Data Sheet
 DS861, GW1NSR series of FPGA Products Data Sheet
 DS871, GW1NSE series of FPGA Products Data Sheet
 DS881, GW1NSER series of Bluetooth FPGA Products Data Sheet
 DS891, GW1NRF series of Bluetooth FPGA Products Data Sheet
 DS961, GW2ANR series of Bluetooth FPGA Products Data Sheet
 SUG100, Gowin Software User Guide
1.2 Terminology and Abbreviations
The terminology and abbreviations used in this manual are as shown in
Table 1-1 below.
Table 1-1 Terminology and Abbreviations
Terminology and Abbreviations Meaning

1 About This Guide 1.3 Support and Feedback

IPUG525-1.3.1E 2(28)

Terminology and Abbreviations Meaning
IP Intellectual Property
RAM Random Access Memory
LUT Look-up Table
GSR Global System Reset

1.3 Support and Feedback
Gowin Semiconductor provides customers with comprehensive
technical support. If you have any questions, comments, or suggestions,
please feel free to contact us directly by the following ways.
Website: http://www.gowinsemi.com/en/
E-mail: support@gowinsemi.com

2 Overview 1.3 Support and Feedback

IPUG525-1.3.1E 3(28)

2 Overview
Gowin PSRAM Memory Interface IP is a common used PSRAM
interface IP, in compliance with PSRAM standard protocol. The IP includes
the PSRAM MCL (Memory Controller Logic) and the corresponding PHY
(Physical Interface) design. Gowin PSRAM Memory Interface IP provides
users a common command interface to connect with the PSRAM chip for
data access and storage.
Table 2-1 Gowin PSRAM Memory Interface IP
Gowin PSRAM Memory Interface IP
Supported Devices All Gowin devices
(except GW1N-1/GW1N-1S/GW1NR-1/GW1NZ-1)
Logic Resource See Table 3-1
Delivered Doc.
Design Files Verilog (encrypted)
Reference Design Verilog
TestBench Verilog
Test and Design Flow
Synthesis Software Synplify Pro
Application Software Gowin Software

3 Feature and Performance 3.1 Key Features

IPUG525-1.3.1E 4(28)

3 Feature and Performance
3.1 Key Features
 Compatiable with the standard PSRAM device interfaces;
 Supports memory data path width of 8 bits, 16 bits, 24 bits, 32 bits, 40
bits, 48 bits, 56 bits, and 64 bits.
 Supports x8 data width memory chip;
 Programs 16, 32, 64 or 128 burst lengths;
 The clock rate is 1:2
 The initial latency is six clock cycles;
 Supports the fixed latency mode;
 Supports the power off option;
 Configurable drive strength;
 Configurable self-refresh area;
 Configurable refresh rate.
 Single-channel or double-channel operation mode IP to be chosen.
Note!
The single HyperRam capacity is two times as much as that of PSRAM, so the address bit
is 1 bit more than PSRAM. HyperRam configuration registers are also different from those
of PSRAM. Please refer to the GUI interface and GUI help document for details. The read
and write timing is exactly the same at the user side interface.
3.2 Working Frequency and Bandwidth Efficiency
Gowin PSRAM Memory Interface IP supports:
 The max. data rate of 333Mbps
 Burst length 128 and bandwidth efficiency 74%
 Burst length 64 and bandwidth efficiency 59%
 Burst length 32 and bandwidth efficiency 42%
 Burst length 16 and bandwidth efficiency 26%

3 Feature and Performance 3.3 Resource Utilization

IPUG525-1.3.1E 5(28)

3.3 Resource Utilization
The Gowin PSRAM Memory Interface IP employs the Verilog
language, which is used in the GW1N4 and GW1NR-4 FPGA devices.
Table 3-1 presents an overview of the resource utilization. For the
applications on the other GOWINSEMI FPGA devices, please see the
associated post-release information.
Table 3-1 Resource Utilization
DQ_WIDTH LOGICs REGs I/O fMAX Throughput Device Series Speed Level
8(x8) 615 541 16
333Mbps
fMAX x DQ x
work
efficiency
GW1N-4
GW1NR-4

C6/I5
C5/I4

16(x8) 947 898 29

                 Note!
In the Table 3-1, the user address width of the Gowin PSRAM Memory Interface IP is 21
bits, the PSRAM WITDH is x8, and the burst length is 32. The increased burst length will
increase the resource utilization, and the double-channel PSRAM IP will also increase the
resource utilization.

4 Functional Description 4.1 Structure

IPUG525-1.3.1E 6(28)

4 Functional Description
4.1 Structure
As shown in Figure 4-1, the Gowin PSRAM Memory Interface IP
mainly includes Memory Controller Logic, Physical Interface, etc. The User
Design module is the module connected to the external PSRAM SDRAM
chip in FPGA.
Figure 4-1 Gowin PSRAM Memory Interface IP Structure
Memory
Controller
Logic
Physical
Interface
MC/PHY
Interface
FPGA
User
Design PSRAM
rst_n
clk
addr
cmd
   cmd_en
wr_data
data_mask
rd_data
rd_data_valid
O_psram_ck
O_psram_ck_n
O_psram_cas_n
O_psram_reset_n
IO_psram_dq
IO_psram_rwds
clk_out
Init_calib

4.2 Memory Controller Logic
Memory Controller Logic is the main logic module of Gowin PSRAM
Interface IP , which locates between User Design and PHY . The Memory
Controller Logic receives the command, address, and data from the user
interface and stores them in logical order.
The write, read and other commands sent by the user are sorted and
reorganized in Memory Controller Logic to combine a data format that
complies with the PSRAM protocol. Meanwhile, when the Memory
Controller Logic writes data, the data will be reorganized and cached to
meet the initial delay value between the command and the data. When the
Memory Controller Logic reads the data, the data will be sampled and
reorganized to be the correct one.
The PSRAM Memory Controller includes the CMD unit, the WR_Data
unit, the RD_Data unit, etc. The main structure is shown in Figure 4-2.

4 Functional Description 4.2 Memory Controller Logic

IPUG525-1.3.1E 7(28)

Figure 4-2 Basic Structure of PSRAM Memory Controller Logic
RD_Data
WR_Data
CMD
Write Data Path
Initialization
Address
Command Path
Read Data Path
PHY
User
Design


4 Functional Description 4.3 PHY

IPUG525-1.3.1E 8(28)

4.3 PHY
The PHY provides the physical layer definition and interface between
Memory Controller Logic and the external PSRAM. It receives the
commands and data from the Memory Controller Logic and provides the
PSRAM interface with signals that meet the timing and sequence
requirements.
The basic structure of the PHY includes four modules: initialization
module, data path, command/address control path and I/O logic module, as
shown in Figure 4-3.
Figure 4-3 Basic Structure of PSRAM PHY
I/O Logic Unit
Delay Adjustment
PSRAMMemory
Controller
Logic
Data Path
In it ia liza tion
Command/Address
Control Path
PHY
Read Calibration


4 Functional Description 4.4 Major Functions

IPUG525-1.3.1E 9(28)

4.3.1 Initialization Unit
The initialization module is mainly used for the initialization and
read-calibration after power on. After all initialization and read-calibration
are finished, the signal "init_calib" will be high to indicate the completion of
the initialization.
Power-on Initialization
According to the PSRAM protocol standard, it needs to initialize the
PSRAM after power on. This includes the reset, mode register
configuration, and read calibration.
4.3.2 Data Path Unit
Data path includes write data and read data.
4.3.3 Control Path Unit
The command/address control path is a single pass that receives the
command and address signal sent by the Memory Controller Logic and
cooperates with the data path to process the write and read data delay
parameters and send the commands to the I/O logic module.
4.3.4 I/O Logical Unit
The Logic I/O module is mainly used to convert the clock domain of the
data, command, and address signals received from the data path and
command/address path.
4.4 Major Functions
  The f unctions of the PSRAM Memory Interface IP are as follows:
 Initializes the PSRAM;
 Sends the addresses and commands;
 Writes data;
 Reads data.
4.4.1 Initialization
PSRAM must be read calibrated to perform normal write and read
operations. Therefore, after power on, PHY performs initialization read
calibration operation on PSRAM and returns to init_calib after initialization
completion. Single-channel PSRAM IP initializes two PSRAM particles at
the same time, while double-channel IP initializes two PSRAM particles
respectively and sends two initialization completion signals to the user
respectively.
The completion signal is returned to the user after the initialization is
completed, as shown in Figure 4-4.

4 Functional Description 4.4 Major Functions

IPUG525-1.3.1E 10(28)

Figure 4-4 Initialization Completion Signal Timing Diagram

4.4.2 Send Addresses and Commands
The user can send operation commands and addresses through the
addr, cmd, and cmd_en interfaces.
 Addr is the address data interface;
 Continuous address write operation, two adjacent operations address
plus burst length / 2, continuous address read operation is the same;
 CMD is the command data interface;
 Cmd_en is the enable signal of the address and command, active high.
 The operation mode of two-channel PSRAM IP and single-channel
PSRAM IP is the same, but the command and address of the
two-channel PSRAM IP are independent, and control signals need to
be given respectively.
In the application, a mapping relationship exists between the address
bus of user interface and the physical memory ROW, Upper Column, and
Lower Column. In this design, it is in ROW-Upper Column-Lower Column
order. The addressing scheme is as shown Figure 4-5. In the application,
the user only needs to give the address as needed, and the mapping
relationship is excluded.
Figure 4-5 Addressing Scheme in Row-Column Order
A
0
A
1
A
2
A
3
A
4
A
5
A
n
Row Addr Upper Column Lower Column
User
PSRAM
…… ……


The commands sent by users through the CMD interface are as shown
in Table 4-1.
Table 4-1 cmd Command
Command cmd
Read 1’b0
Write 1’b1

At the user interface, the timing between the command, address, and
enable signals is as shown in Figure 4-6.
When the cmd_en is high, the cmd and the addr are valid at this time.

4 Functional Description 4.4 Major Functions

IPUG525-1.3.1E 11(28)

Figure 4-6 Command, Address, and Enable Signal Timing


When the user uses PSRAM, the read/write command interval needs
to be calculated according to the tRWR value. Take the 166M clock, and
the "W955D8MBY" as examples, the tRWR minimum value is 36ns, i.e.,
the read/write command interval needs to be greater than 6 clock cycles. In
the actual read-write conversion, it is recommended that the user performs
the read operation after all the write data is written, and then perform the
write operation after all the read data is read;
When the PSRAM is in actual use, the two commands
(write-read/read-write/write-write/read-read) interval must satisfy the
minimum interval cycle(Tcmd cycles in Figure 4-6), i.e., when the burst
length is 16, the command interval is at least 15 clock cycles; when the
burst length is 32, the command interval is at least 19 clock cycles; when
the burst length is 64, the command interval is at least 27 clock cycles;
when the burst length is 128, the command interval is at least 43 clock
cycles.
4.4.3 Write data
You can send the data to the Gowin PSRAM Memory Interface IP
through the user Interface of wr_data and data_mask, etc. The write data
will be sent to the PSRAM after being processed.
 The wr_data is a write data port;
 Data_mask a write mask port;
 There are many timing cases between the data channel and the
command channel. Take the 16 burst length as an example;
 The write operation mode of double-channel PSRAM IP and
single-channel PSRAM IP is the same, but the command and address
of the double-channel PSRAM IP are independent, and write data need
to be given respectively.

4 Functional Description 4.4 Major Functions

IPUG525-1.3.1E 12(28)

Figure 4-7 Write Data Interface Timing


 The write data occupy 32 CLK cycles if the burst length is 128, as
shown in Figure 4-8.
 If the mask function is not used, the data_mask can be 0.
Figure 4-8 Write data timing when the burst length is 32


 The write data occupy 16 clk cycles if the user configures 64 burst
lengths, as shown in Figure 4-9.
 If the mask function is not used, the data_mask can be 0.
Figure 4-9 Write data timing when the burst length is 64


 The write data occupies 32 CLK cycles if the burst length is 128, as
shown in Figure 4-10.
 If the mask function is not used, the data_mask can be 0.

4 Functional Description 4.4 Major Functions

IPUG525-1.3.1E 13(28)

Figure 4-10 Write data timing when the burst length is 128


4.4.4 Read data
You can read the data from the PSRAM using the user interfaces
rd_data and rd_data_valid.
 The rd_data interface is the returned read data interface;
 The rd_data_valid interface signal is the valid read data interface.
When it is high, the returned rd_data is valid at this time.
 There are many timing cases between the read data channel and the
command channel. Take the 16 burst length as an example;
 The read operation mode of two-channel PSRAM IP and
single-channel PSRAM IP is the same, but the command and address
of the two-channel PSRAM IP are independent, and The rd_data_valid
signal and rd_data data need to be received respectively.
Figure 4-11 Read Data Port Timing


 The read data occupies 8 CLK cycles if the burst length is 32, as shown
in Figure 4-12.
Figure 4-12 Read data timing when the burst length is 32



4 Functional Description 4.4 Major Functions

IPUG525-1.3.1E 14(28)

 The read data occupies 16 CLK cycles if the burst length is 64, as
shown in Figure 4-13.
Figure 4-13 Read data timing when the burst length is 64


 The read data occupies 32 CLK cycles if the burst length is 128, as
shown in Figure 4-14.
Figure 4-14 Read data timing when the burst length is 128


5 Ports List

IPUG525-1.3.1E 15

5 Ports List
The I/O ports of the Gowin PSRAM Memory Interface IP are shown in
Table 5-1.
Table 5-1 I/O Ports List of Gowin PSRAM Memory Interface IP
Signal Data Width I/O Description
User Interface
addr ADDR_WIDTH Input Address input
cmd 1 Input Command path
cmd_en 1 Input
Command and address enable
signals:
0: invalid
1: valid
rd_data 4*DQ_WIDTH Output Read data path
rd_data_valid 1 Output
rd_data valid signal:
0: invalid
1: valid
wr_data 4*DQ_WIDTH Input Write data path
data_mask MASK_WIDTH Input Provide the masking signals
for wr_data
clk 1 Input
Reference input clock, it is
usually on-board crystal
oscillator clock
init_calib 1 Output Complete initialization signal
clk_out 1 Output The user-design clock, with a
frequency of 1/2 Memory Clk
rst_n 1 Input
Input reset signal:
0: valid
1: invalid
memory_clk 1 Input
The user can input chip
working clock, which is
generally a high clock of PLL
frequency doubling, or not use
PLL
pll_lock 1 Input If memory_clk is PLL
frequency doubling input, this

5 Ports List

IPUG525-1.3.1E 16(28)

Signal Data Width I/O Description
interface is connected to PLL's
pll_lock pin
If the user does not use PLL,
this interface is connected to
1'b1
PSRAM Interface
O_psram_cs_n CS_WIDTH Output Chip selects, low valid
O_psram_ck CS_WIDTH Output A clock signal provided for
PSRAM
O_psram_ck_n CS_WIDTH Output Compose the difference signal
with the O_psram_ck
O_psram_reset
_n CS_WIDTH Output PSRAM reset signal
IO_psram_dq DQ_WIDTH Bidirectio
n PSRAM data
IO_rwds RWDS_WIDTH Bidirectio
n
The PSRAM data strobe signal
and mask signal

The I/O port of the Gowin PSRAM Memory Interface 2CH IP is shown
in Table 5-2.
Table 5-2 Gowin PSRAM Memory Inteface 2CH IP I/O Port List
Signal Data Width I/O Description
User Interface
addr0 ADDR_WIDTH Input Path 0 address input
addr1 ADDR_WIDTH Input Path 1 address input
cmd0 1 Input Path 0 command path
cmd1 1 Input Path 1 command path
cmd_en0 1 Input
Path 0 command and address
enable signal:
0: invalid
1: valid
cmd_en1 1 Input
Path 1 command and address
enable signal:
0: invalid
1: valid
rd_data0 [31:0] Output Read data path 0
rd_data1 [31:0] Output Read data path 1
rd_data_valid0 1 Output
Path 0rd_data valid signal:
0: invalid
1: valid
rd_data_valid1 1 Output
Path 1rd_data valid signal:
0: invalid
1: valid
wr_data0 [31:0] Input Write data path 0
wr_data1 [31:0] Input Write data path 1

5 Ports List

IPUG525-1.3.1E 17(28)

Signal Data Width I/O Description
data_mask0 [3:0] Input Provide the masking signals
for path 0wr_data
data_mask1 [3:0] Input Provide the masking signals
for path 1wr_data
init_calib0 1 Output Path 0 initialization completed
signal
init_calib1 1 Output Path 1 initialization completed
signal
clk 1 Input
Reference input clock, it is
usually on-board crystal
oscillator clock
clk_out 1 Output The user-design clock, with a
frequency of 1/2 Memory Clk
rst_n 1 Input
Input reset signal:
0: valid
1: invalid
PSRAM Interface
O_psram_cs_n [1:0] Output Chip selects, low valid
O_psram_ck [1:0] Output A clock signal provided for
PSRAM
O_psram_ck_n [1:0] Output Compose the difference
signal with the O_psram_ck
O_psram_reset
_n [1:0] Output PSRAM reset signal
IO_psram_dq [15:0] Bidirection PSRAM data
IO_rwds [1:0] Bidirection The PSRAM data selection
signal and mask signal

6 Parameter Configuration

IPUG525-1.3.1E 18(28)

6 Parameter Configuration
The Gowin PSRAM Memory Interface IP supports PSRAM devices.
You need to configure various static parameters and timing parameters of
the Gowin PSRAM Memory Interface according to the design requirements.
The specific parameters are as shown in Table 6-1.
Table 6-1 Static Parameter Options of Gowin PSRAM Memory Interface
Name Description Options
Memory TYPE PSRAM Model W955D8MBYA, Custom;
CLk Ratio
The CLK ratio of the PSRAM
PHY to internal logic clock,
cannot be operated by users
1:2;
Memory Clock The operating frequency that
user expected 10Mhz~166Mhz；
Psram Width DQ Width of PSRAM 8;
Dq Width The user required data bit width 8,16,24,32,40,48,56,64;
Addr Width Address width, filled by users
according to the specific chip 21;
Data Width User data bit width 4*Dq Width;
CS Width Chip selection width Dq Width/Psram Width;
Mask Width Mask Width Data Width/Psram Width;
Burst Mode Data burst length 16, 32, 64, 128;
Burst Num Burst data number Burst Mode/4;
Fixed Latency
Enable Fixed Latency Enable “Fixed”;
Initial Latency Initial Latency 6;
Drive Strength Drive strength; 35, 50, 100,200;
Deep Power Down Deep Power Down “OFF”, “ON”;
Hybrid Sleep Mode Sleep Mode “OFF”, “ON”;
Refresh Rate Refresh Rate “normal”, “faster”
PASR Self Refresh Area
full,bottom_1/2,bottom_1/4,
bottom_1/8, top_1/2,
top_1/4, top_1/8.

7 Reference Design

IPUG525-1.3.1E 19(28)

7Reference Design
To be familiar with Gowin PSRAM Memory Interface IP quickly, a
simple reference design is provided for users. The basic structure of
reference is shown in Figure 7-1.
Figure 7-1 Basic Structure of Reference Design
Memory
Controller
Logic
Physical
Layer
MC/PHY
Interface
psram
test
Gowin PSRAM Interface IP
psram_syn_top
Key
debounce
PSRAM
Ref. Design

In the reference design, the psram_syn_top module is the top-level
module unit, and its interfaces are connected to the input reference clocks,
external reset signals, etc, as shown in Table 7-1. The psram_test is used
to generate the address, data, and read/write commands required by the
Gowin PSRAM Interface IP, and the module can be synthesized. The
Key_debounce module is a jitter elimination module that is used to
eliminate the signal jitter generated by the key or dial switch when it
controls the external excitation.
Table 7-1 Psram_syn_top Module Input Interface List
Name Description
clk Input reference clock, 50MHz by default
rst_n Input reset signal

The PSRAM_test generates one write command and one read
command to write and read from the same address once. You can modify

7 Reference Design

IPUG525-1.3.1E 20(28)

the written address and data, etc., analyze and verify the read data
received from the PSRAM Memory Interface IP. In this reference design,
the memory model is W955D8MBYA, the Burst Mode is configured as BC4,
and the DQ width is 16 bits.
The simulation waveforms of some signals between the psram_test
and the PSRAM Memory Interface IP interfaces are shown in Figure 7-2.
Figure 7-2 Part of psram_test Interface Signal Simulation Waveform


8 Interface Configuration

IPUG525-1.3.1E 21(28)

8Interface Configuration
You can call and configure the Gowin PSRAM Memory Interface IP
using the IP Core Generater tool in the IDE. In this chapter, take the
“W955D8MBYA” PSRAM memory as an example, introduce the main
configuration interface, configuration flow and the meaning of each
configuration option.
1. Open the IP Core Generater
After creating the project, you can click the “Tools” tab in the upper left,
select and open the IP Core Generater via the drop-down list, as shown in
Figure 8-1.
Figure 8-1 Open IP Core Generater


2. Open the PSRAM Memeory Interface IP core
Click "PSRAM", and then double-click "PSRAM Memory Interface".
The "PSRAM Memory Interface" page opens, as shown in Figure 8-2.

8 Interface Configuration 4.4 Major Functions

IPUG525-1.3.1E 22(28)

Figure 8-2 Open PSRAM Memeory Interface IP core


3. PSRAM Memeory Interface IP Core Port Interface
The Interface of PSRAM Memeory Interface IP core is on the left, as
shown in Figure 8-3.
The right side of the interface view is the interfaces between the
PSRAM Memory Controller and the user port. You can send/receive the
commands and data through connecting your design to the PSRAM
Memeory Interface IP. The left side of the interface is the interface between
the physical interface (PHY) and the memory. You can access the data
through connecting the PSRAM Memeory Interface IP core to your
required memory. With different configuration information, the signal
bit-width and the signal number will change accordingly.
Figure 8-3 IP Core Interface


4. Open the Help file
You can click the Help button in the lower left of Figure 8-3 to check
the English brief introduction of each option. The introduction order in the
Help file and the order shown on the
“IP Customization” are consistent, as

8 Interface Configuration 4.4 Major Functions

IPUG525-1.3.1E 23(28)

shown in Figure 8-4.
Figure 8-4 Help File


5. Configure the Basic Information
See the basic information in the upper part of the configuration
interface. Take the GW1N-4 chip as an example, and select the “LQFP144”
package. The “Module Name” option is the top-level file name of the
generated project, and the default value is
"psram_memory_interface_top".It can be modified. The "File Name" option
is the folder used for saving the files required by the PSRAM Memeory
Interface IP core, and the default value is "PSRAM Memory_Interface" . It
can be modified. The
“Creat IN” option is the the IP core files path, and the
default value is "/ project path/SRC/PSRAM_Memory_Interface". It can be
modified. The "Add to Current Project" option in the lower right is used to
ask whether added the generated IP to your project directly. It’s checked by
default, as shown in Figure 8-5.

8 Interface Configuration 4.4 Major Functions

IPUG525-1.3.1E 24(28)

Figure 8-5 Basic Information Configuration Interface


6. Type Tab
In the Type tab, you need to configure the basic information for
PSRAM chip.
 Select Memory
 Data Bus
 Memory Address
In “Memory Address”, you can fill in the address information of PSRAM.
You need to know the address width of the used PSRAM, and the data
equals to the ROW + Upper Column + Lower Column of your selected
PSRAM. After choosing the PSRAM Memory type, the software will be fill in
the data automatically; if you choose
”Custom”, you need to fill in the data
according to your selected PSRAM.
 Accelerate Simulation
This option is used to speed up simulation, which can be checked
during user simulation, but please uncheck and regenerate IP during board
level testing.
 Non-operational

8 Interface Configuration 4.4 Major Functions

IPUG525-1.3.1E 25(28)

Figure 8-6 Type Option


7. Options Tab
 Memory options
 Generation Config
 Adjust Sampling
Adjust sampling is used to adjust the parameter when the user's IP
generates error code. If the IP works normally, the default value can be
used.
In the IP generated after being checked, IBUF, OBUF and the other
primitives are not inserted, and the logic is directly connected using the port,
the default is checked.
“Options” is shown in Figure 8-7, and take winbond W955D8MBYA
PSRAM memory as an example.

8 Interface Configuration 4.4 Major Functions

IPUG525-1.3.1E 26(28)

Figure 8-7 Options



8. PSRAM 2CH IP Special Instructions
 Dq Width Psram Width cannot be modified. It has been configured
according to one chip bit Width. The top-level file will instantiate
two channels to form a two-channel transmission.
 If the top-level file is unencrypted, users can modify it according to
their own needs. The top-level file includes a DLL, a PLL, a
synchronization module and two psram controller modules. Users
need to configure the clock frequency output by PLL according to
the actual speed (default configuration: 160M). The others do not
need to be modified. The top-level file path is Gowin installation
directory /1.9/IDE/ipcore/PSRAM_2CH/data/ psram_top.v.
After the user has configured the PLL according to the required
frequency, the IP can be generated by using the software IPcore
Generate;


9 File Delivery 9.1 Document

IPUG525-1.3.1E 27(28)

9File Delivery
The delivery files for the Gowin PSRAM Memory Interface IP include
the documents, the design source code, and the reference design.
9.1 Document
The document folder mainly contains PDF files for the user guide.
Table 9-1 Document List
Name Description
IPUG525, Gowin PSRAM
Memory Interface IP User Guide Gowin PSRAM Memory Interface IP User Manual
RN525, Gowin PSRAM Memory
Interface IP Release Note –

9.2 Design Source Code (Encryption)
The Encryption Code Folder contains the RTL encryption code of
Gowin PSRAM Memory Interface IP used for the GUI, to generate the IP
cores as needed.
Table 9-2 Design Source Code List
Name Description
PSRAM_TOP.v The top-level file of the IP core, which provides users
with interface information, unencrypted.
GOWIN PSRAM Memeory Interface code
psram_code.v GOWIN PSRAM Memory Interface IP Design RTL
Source File, encrypted
psram_pll_config.v
GOWIN PSRAM Memory Controller PLL Configuration
File, which is generated by the user via GUI
configuration, unencrypted
psram_define.v
Gowin PSRAM memory controller parameter definition
module, which is generated by the user via the GUI,
unencrypted.
psram_local_define.v Gowin PSRAM memory controller parameter definition
processing module, encrypted.
psram_param.v Gowin PSRAM memory controller parameter
configuration module, which is generated by the user

9 File Delivery 9.3 Reference Design

IPUG525-1.3.1E 28(28)

Name Description
via the GUI, unencrypted.
psram_local_param.v
Gowin PSRAM memory controller parameter
processing module, which disposes the parameters
passed from the GUI, encrypted.

9.3 Reference Design
The Ref. Design folder contains the netlist file for Gowin PSRAM
Memory Interface IP, the user reference design, the constraint file, the jitter
elimination module, the top file, the project file folder, etc.
Table 9-3 Ref. Design Folder Contents
Name Description
psram_syn_top.v The top module of reference design
key_debounce.v Key jitter elimination module
psram_test.v Test stimulus generation module
PSRAM_Memory_Interface.vo Gowin PSRAM Memory Interface IP netlist file
psram.cst PSRAM Physical Constraints File
psram.sdc PSRAM Timing Constraint File
psram.gao Capture PSRAM chip data
PSRAM_Memory_Interface PSRAM IP project folder
