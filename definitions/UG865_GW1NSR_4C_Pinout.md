# Version History

| Data | Version | Description |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 10/15/2019 | 1.0E | Initial version published.                                                                                                          |  |  |  |  |  |
| 04/16/2020 | 1.01E | Pin 25 of QN48P and QN48G modified. |  |  |  |  |  |
| 05/29/2020 | 1.02E | The pin description of GCLK updated;<br>VCCO0/VCCO1 range when using FLASH updated. |  |  |  |  |  |

# Pin Definitions

| Pins Name | Direction | Description |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- |
| User I/O Pins |  |  |  |  |  |  |
| IO [End][Row/Column Number][A/B] | I/O | [End] indicates the pin location, including L(left) R(right) B(bottom), and T(top) |  |  |  |  |
|  |  | [Row/Column Number] indicates the pin Row/Column number.<br>If [End] is T(top) or B(bottom), the pin indicates the Column number of the corresponding CFU.<br>If [End] is L(left) or R(right),  the pin indicates the Row number of the corresponding CFU. |  |  |  |  |
|  |  | [A/B] indicaties differential signal pair information. |  |  |  |  |
| Multi-Function Pins |  |  |  |  |  |  |
| IO [End][Row/Column Number][A/B]/MMM |  | /MMM represents one or more of the other functions in addition to being general purpose user I/O.<br>When not used for the specical functions, these pins can be user I/O. |  |  |  |  |
| RECONFIG_N | I,Internal Weak Pull Up | Starat new GowinCONFIG mode when low pulse |  |  |  |  |
| READY | I/O | When high, device can be programmed and configured |  |  |  |  |
|  |  | When low, device cannot be programmed and configured |  |  |  |  |
| DONE | I/O | High indicates successful completion of programming and configuration |  |  |  |  |
|  |  | Low indicates unfinished or failure of programming and configuration  |  |  |  |  |
| FASTRD_N/D3 | I/O | In MSPI mode, FASTRD_N is used as Flash access speed port. <br>Low indicates high-speed Flash access mode; high indicates regular Flash access mode. |  |  |  |  |
|  |  | Data port D3 in CPU mode |  |  |  |  |
| MCLK/D4 | I/O | Clock output MCLK in MSPI mode |  |  |  |  |
|  |  | Data port D4 in CPU mode |  |  |  |  |
| MCS_N/D5 | I/O | Enable signal MCS_N in MSPI mode, active-low |  |  |  |  |
|  |  | Data port D5 in CPU mode |  |  |  |  |
| MO/D6 | I/O | MOSI in MSPI mode:Master data output/Slave data input |  |  |  |  |
|  |  | Data port D6 in CPU mode |  |  |  |  |
| MI/D7 | I/O | MISO in MSPI mode:Master data input/Slave data output |  |  |  |  |
|  |  | Data port D7 in CPU mode |  |  |  |  |
| SSPI_CS_N/D0 | I/O | Enable signal SSPI_CS_N in SSPI mode, active-low |  |  |  |  |
|  |  | Data port D0 in CPU mode |  |  |  |  |
| SO/D1 | I/O | MISO in MSPI mode:Master data input/Slave data output |  |  |  |  |
|  |  | Data port D1 in CPU mode |  |  |  |  |
| SI/D2 | I/O | MOSI in SSPI mode:Master data output/Slave data input |  |  |  |  |
|  |  | Data port D2 in CPU mode |  |  |  |  |
| TMS | I | Serial mode input in JTAG mode |  |  |  |  |
| TCK | I | Serial clock input in JTAG mode |  |  |  |  |
| TDI | I | Serial data input in JTAG mode |  |  |  |  |
| TDO | O | Serial data output in JTAG mode |  |  |  |  |
| JTAGSEL_N | I, Internal Weak Pull Up | JTAG mode selection, active-low |  |  |  |  |
| SCLK | I | Clock input in SSPI, SERIAL, and CPU modes |  |  |  |  |
| DIN | I, Internal Weak Pull Up | Data input in SERIAL mode |  |  |  |  |
| DOUT | O | Data output in SERIAL mode |  |  |  |  |
| CLKHOLD_N | I, Internal Weak Pull Up | High, SCLK will be connected internally in SSPI mode or CPU mode |  |  |  |  |
|  |  | Low, SCLK will be disconnected from SSPI mode or CPU mode |  |  |  |  |
| WE_N | I | Select data input/output of D[7:0] in CPU mode |  |  |  |  |
| GCLKT_[x]   | I | Global clock input pin, T(True), [x]:global clock number. |  |  |  |  |
| GCLKC_[x]  | I | Differential comparsion input pin of GCLKC_[x], C(Comp), [x]: global clock number1. |  |  |  |  |
| LPLL_T_fb/RPLL_T_fb | I | L/R PLL feedback the input pins, T(True)   |  |  |  |  |
| LPLL_C_fb/RPLL_C_fb | I | L/R PLL feedback the input pins, C(Comp) |  |  |  |  |
| LPLL_T_in/RPLL_T_in | I | L/R PLL clock input pins,T(True)  |  |  |  |  |
| LPLL_C_in/RPLL_C_in | I | L/R PLL clock input pins, C(Comp) |  |  |  |  |
| CH[7:0] | I | Eight-channel analog input |  |  |  |  |
| MODE2 | I,Internal Weak Pull Up | GowinCONFIG modes selection pin; if this pin is not bonded, it's internal grounded. |  |  |  |  |
| MODE1 | I,Internal Weak Pull Up | GowinCONFIG modes selection pin; if this pin is not bonded, it's internal grounded. |  |  |  |  |
| MODE0 | I,Internal Weak Pull Up | GowinCONFIG modes selection pin; if this pin is not bonded, it's internal grounded. |  |  |  |  |
| Other Pins |  |  |  |  |  |  |
| NC | NA | Reserved. |  |  |  |  |
| VSS | NA | Ground. |  |  |  |  |
| VCC | NA | Power supply pins for the internal core logic. |  |  |  |  |
| VCCO# | NA | Power supply pins for I/O voltage of I/O BANK#. |  |  |  |  |
| VCCX | NA | Power supply pins for auxiliary voltage. |  |  |  |  |
| VCCP | NA | Power supply pins for FLASH (1.8V). |  |  |  |  |
| VCCPLL | NA | Power supply pins for PLL. |  |  |  |  |
| VDDA | NA | ADC Analog power supply voltage, VDDA=3.3V  |  |  |  |  |
| X16 | NA | I/O supports 16:1. |  |  |  |  |
| VREF | NA | The input pin of ADC external reference voltage. |  |  |  |  |
| Note!<br>[1]For single-ended input, the pin of GLKC_[x] is not a global clock pin. |  |  |  |  |  |  |

# Bank

|  |  | IO Bank0 |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
|  | IO Bank3 | GW1NSR |  |  |  |  |  |  | IO Bank1 |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  |  | IO Bank2 |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |
|  | Note！ |  |  |  |  |  |  |  |  |  |
|  | 1.Each Bank has independent reference volatge (VREF); |  |  |  |  |  |  |  |  |  |
|  | 2.Users can select to use internal VREF of IOB (equals to 0.5*VCCO) or <br>   external VREF input (use any IO pins as external VREF input). |  |  |  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |  |  |  |  |

# Pin List

| Note!
1. In packages of QN48P and QN48, IOT7A and IOT7B share pin 10.
2.HyperRAM is embedded in QN48P; PSRAM is embedded in MG64P; FLASH is embedded in QN48G. |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Pin Name | Function | BANK | Configuration Function | Differential Pair | LVDS | X16 | QN48P | QN48G | MG64P |
| IOB13A | I/O | 3 |  | True_of_IOB13B | NONE | NONE | 18 | 18 |  |
| IOB13B | I/O | 3 |  | Comp_of_IOB13A | NONE | NONE | 19 | 19 |  |
| IOB14A | I/O | 3 |  | True_of_IOB14B | NONE | NONE |  |  |  |
| IOB14B | I/O | 3 |  | Comp_of_IOB14A | NONE | NONE |  |  |  |
| IOB15A | I/O | 3 |  | True_of_IOB15B | NONE | NONE |  |  |  |
| IOB15B | I/O | 3 |  | Comp_of_IOB15A | NONE | NONE |  |  |  |
| IOB16A/GCLKT_5 | I/O | 3 | GCLKT_5 | True_of_IOB16B | NONE | NONE | 20 | 20 |  |
| IOB16B/GCLKC_5 | I/O | 3 | GCLKC_5 | Comp_of_IOB16A | NONE | NONE | 21 | 21 |  |
| IOB22A/GCLKT_4 | I/O | 3 | GCLKT_4 | True_of_IOB22B | NONE | NONE | 22 | 22 |  |
| IOB22B/GCLKC_4 | I/O | 3 | GCLKC_4 | Comp_of_IOB22A | NONE | NONE | 23 | 23 |  |
| IOB23A | I/O | 3 |  | True_of_IOB23B | NONE | NONE |  |  |  |
| IOB23B | I/O | 3 |  | Comp_of_IOB23A | NONE | NONE |  |  |  |
| IOB24A | I/O | 3 |  | True_of_IOB24B | NONE | NONE |  |  |  |
| IOB24B | I/O | 3 |  | Comp_of_IOB24A | NONE | NONE |  |  |  |
| IOB25A | I/O | 3 |  | True_of_IOB25B | NONE | NONE |  |  |  |
| IOB25B | I/O | 3 |  | Comp_of_IOB25A | NONE | NONE |  |  |  |
| IOB29A | I/O | 3 |  | True_of_IOB29B | NONE | NONE |  |  |  |
| IOB29B | I/O | 3 |  | Comp_of_IOB29A | NONE | NONE |  |  |  |
| IOB4A | I/O | 3 |  | True_of_IOB4B | NONE | NONE | 13 | 13 |  |
| IOB4B | I/O | 3 |  | Comp_of_IOB4A | NONE | NONE | 14 | 14 |  |
| IOB5A | I/O | 3 |  | True_of_IOB5B | NONE | NONE | 15 | 15 |  |
| IOB5B | I/O | 3 |  | Comp_of_IOB5A | NONE | NONE |  |  |  |
| IOB6A | I/O | 3 |  | True_of_IOB6B | NONE | NONE | 16 | 16 |  |
| IOB6B | I/O | 3 |  | Comp_of_IOB6A | NONE | NONE | 17 | 17 |  |
| IOB7A | I/O | 3 |  | True_of_IOB7B | NONE | NONE |  |  |  |
| IOB7B | I/O | 3 |  | Comp_of_IOB7A | NONE | NONE |  |  |  |
| IOR11A/GCLKT_3 | I/O | 2 | GCLKT_3 | True_of_IOR11B | True | x16 | 32 | 32 | G5 |
| IOR11B/GCLKC_3 | I/O | 2 | GCLKC_3 | Comp_of_IOR11A | True | NONE | 31 | 31 | H5 |
| IOR12A | I/O | 2 |  | True_of_IOR12B | NONE | NONE |  |  |  |
| IOR12B | I/O | 2 |  | Comp_of_IOR12A | NONE | NONE |  |  |  |
| IOR13A | I/O | 2 |  | True_of_IOR13B | True | x16 |  |  | G6 |
| IOR13B | I/O | 2 |  | Comp_of_IOR13A | True | NONE |  |  | H6 |
| IOR14A | I/O | 2 |  | True_of_IOR14B | NONE | NONE |  |  |  |
| IOR14B | I/O | 2 |  | Comp_of_IOR14A | NONE | NONE |  |  |  |
| IOR15A | I/O | 2 |  | True_of_IOR15B | True | x16 | 30 | 30 | G7 |
| IOR15B | I/O | 2 |  | Comp_of_IOR15A | True | NONE | 29 | 29 | H7 |
| IOR16A | I/O | 2 |  | True_of_IOR16B | NONE | NONE |  |  |  |
| IOR16B | I/O | 2 |  | Comp_of_IOR16A | NONE | NONE |  |  |  |
| IOR17A | I/O | 2 |  | True_of_IOR17B | True | x16 | 28 | 28 | G8 |
| IOR17B | I/O | 2 |  | Comp_of_IOR17A | True | NONE | 27 | 27 | H8 |
| IOR18A | I/O | 2 |  | True_of_IOR18B | NONE | NONE |  |  |  |
| IOR18B | I/O | 2 |  | Comp_of_IOR18A | NONE | NONE |  |  |  |
| IOR2A/RPLL_T_in | I/O | 2 | RPLL_T_in | True_of_IOR2B | True | x16 | 35 | 35 | G1 |
| IOR2B/RPLL_C_in | I/O | 2 | RPLL_C_in | Comp_of_IOR2A | True | NONE | 34 | 34 | H1 |
| IOR3A/RPLL_T_fb | I/O | 2 | RPLL_T_fb | True_of_IOR3B | NONE | NONE |  |  |  |
| IOR3B/RPLL_C_fb | I/O | 2 | RPLL_C_fb | Comp_of_IOR3A | NONE | NONE |  |  |  |
| IOR4A | I/O | 2 |  | True_of_IOR4B | True | x16 |  |  | G2 |
| IOR4B | I/O | 2 |  | Comp_of_IOR4A | True | NONE |  |  | H2 |
| IOR5A | I/O | 2 |  | True_of_IOR5B | NONE | NONE |  |  |  |
| IOR5B | I/O | 2 |  | Comp_of_IOR5A | NONE | NONE |  |  |  |
| IOR6A | I/O | 2 |  | True_of_IOR6B | True | x16 |  |  | G3 |
| IOR6B | I/O | 2 |  | Comp_of_IOR6A | True | NONE |  |  | H3 |
| IOR7A | I/O | 2 |  | True_of_IOR7B | NONE | NONE |  |  |  |
| IOR7B | I/O | 2 |  | Comp_of_IOR7A | NONE | NONE |  |  |  |
| IOR8A | I/O | 2 |  | True_of_IOR8B | True | x16 |  |  | G4 |
| IOR8B | I/O | 2 |  | Comp_of_IOR8A | True | NONE |  |  | H4 |
| IOR9A/GCLKT_2 | I/O | 2 | GCLKT_2 | True_of_IOR9B | NONE | NONE |  |  | F5 |
| IOR9B/GCLKC_2 | I/O | 2 | GCLKC_2 | Comp_of_IOR9A | NONE | NONE | 33 | 33 | F4 |
| IOT10A/MCLK/D4 | I/O | 0 | MCLK/D4 | True_of_IOT10B | NONE | NONE | 1 |  |  |
| IOT10B/MCS_N/D5 | I/O | 0 | MCS_N/D5 | Comp_of_IOT10A | NONE | NONE | 2 |  |  |
| IOT11A/MO/D6 | I/O | 1 | MO/D6 | True_of_IOT11B | NONE | x16 | 48 |  | A1 |
| IOT11B/MI/D7 | I/O | 1 | MI/D7 | Comp_of_IOT11A | NONE | NONE | 47 |  | B1 |
| IOT12A/DIN/CLKHOLD_N | I/O | 1 | DIN/CLKHOLD_N | True_of_IOT12B | NONE | NONE |  | 48 | A2 |
| IOT12B/DOUT/WE_N | I/O | 1 | DOUT/WE_N | Comp_of_IOT12A | NONE | NONE |  | 47 | B2 |
| IOT13A/LPLL_T_in | I/O | 1 | LPLL_T_in | True_of_IOT13B | NONE | x16 | 45 | 45 | B3 |
| IOT13B/LPLL_C_in | I/O | 1 | LPLL_C_in | Comp_of_IOT13A | NONE | NONE | 46 | 46 | A3 |
| IOT15A/LPLL_T_fb | I/O | 1 | LPLL_T_fb | True_of_IOT15B | NONE | x16 |  |  | B4 |
| IOT15B/LPLL_C_fb | I/O | 1 | LPLL_C_fb | Comp_of_IOT15A | NONE | NONE |  |  | A4 |
| IOT17A/GCLKT_0 | I/O | 1 | GCLKT_0 | True_of_IOT17B | NONE | x16 | 43 | 43 | B5 |
| IOT17B/GCLKC_0 | I/O | 1 | GCLKC_0 | Comp_of_IOT17A | NONE | NONE | 44 | 44 | A5 |
| IOT20A/GCLKT_1 | I/O | 1 | GCLKT_1 | True_of_IOT20B | NONE | x16 | 41 | 41 | C5 |
| IOT20B/GCLKC_1 | I/O | 1 | GCLKC_1 | Comp_of_IOT20A | NONE | NONE | 42 | 42 | C4 |
| IOT21A | I/O | 1 |  | True_of_IOT21B | NONE | NONE |  |  | B6 |
| IOT21B | I/O | 1 |  | Comp_of_IOT21A | NONE | NONE |  |  | A6 |
| IOT22A | I/O | 1 |  | True_of_IOT22B | NONE | x16 |  |  | B7 |
| IOT22B | I/O | 1 |  | Comp_of_IOT22A | NONE | NONE |  |  | A7 |
| IOT24A | I/O | 1 |  | True_of_IOT24B | NONE | x16 |  |  | A8 |
| IOT24B | I/O | 1 |  | Comp_of_IOT24A | NONE | NONE |  |  | B8 |
| IOT26A | I/O | 1 |  | True_of_IOT26B | NONE | x16 | 39 | 39 | C7 |
| IOT26B | I/O | 1 |  | Comp_of_IOT26A | NONE | NONE | 40 | 40 | C8 |
| IOT29A | I/O | 1 |  | True_of_IOT29B | NONE | x16 |  |  | E6 |
| IOT29B | I/O | 1 |  | Comp_of_IOT29A | NONE | NONE |  |  | D6 |
| IOT2A/TDI | I/O | 0 | TDI | True_of_IOT2B | NONE | x16 | 3 | 3 | E2 |
| IOT2B/TDO | I/O | 0 | TDO | Comp_of_IOT2A | NONE | NONE | 4 | 4 | E3 |
| IOT30A | I/O | 1 |  | True_of_IOT30B | NONE | NONE |  |  |  |
| IOT30B | I/O | 1 |  | Comp_of_IOT30A | NONE | NONE |  |  |  |
| IOT31A | I/O | 1 |  | True_of_IOT31B | NONE | x16 |  |  | D7 |
| IOT31B | I/O | 1 |  | Comp_of_IOT31A | NONE | NONE |  |  | D8 |
| IOT33A | I/O | 1 |  | True_of_IOT33B | NONE | x16 |  |  | E7 |
| IOT33B | I/O | 1 |  | Comp_of_IOT33A | NONE | NONE |  |  | E8 |
| IOT35A | I/O | 1 |  | True_of_IOT35B | NONE | x16 |  |  | F7 |
| IOT35B | I/O | 1 |  | Comp_of_IOT35A | NONE | NONE |  |  | F8 |
| IOT3A/TMS | I/O | 0 | TMS | True_of_IOT3B | NONE | NONE | 6 | 6 | D2 |
| IOT3B/TCK | I/O | 0 | TCK | Comp_of_IOT3A | NONE | NONE | 7 | 7 | D3 |
| IOT4A/SCLK | I/O | 0 | SCLK | True_of_IOT4B | NONE | x16 |  |  | F1 |
| IOT4B/JTAGSEL_N | I/O | 0 | JTAGSEL_N | Comp_of_IOT4A | NONE | NONE | 8 | 8 | F2 |
| IOT5A/READY | I/O | 0 | READY | True_of_IOT5B | NONE | NONE |  |  | D1 |
| IOT5B/DONE | I/O | 0 | DONE | Comp_of_IOT5A | NONE | NONE | 9 | 9 |  |
| IOT6A/RECONFIG_N | I/O | 0 | RECONFIG_N | True_of_IOT6B | NONE | x16 |  |  | E1 |
| IOT6B/MODE0 | I/O | 0 | MODE0 | Comp_of_IOT6A | NONE | NONE |  |  |  |
| IOT7A/MODE1 | I/O | 0 | MODE1 | True_of_IOT7B | NONE | NONE | 10 | 10 |  |
| IOT7B/MODE2 | I/O | 0 | MODE2 | Comp_of_IOT7A | NONE | NONE | 10 | 10 |  |
| IOT8A/SSPI_CS_N/D0 | I/O | 0 | SSPI_CS_N/D0 | True_of_IOT8B | NONE | x16 |  |  | C1 |
| IOT8B/SO/D1 | I/O | 0 | SO/D1 | Comp_of_IOT8A | NONE | NONE |  |  | C2 |
| IOT9A/SI/D2 | I/O | 0 | SI/D2 | True_of_IOT9B | NONE | NONE |  | 1 |  |
| IOT9B/FASTRD_N/D3 | I/O | 0 | FASTRD_N/D3 | Comp_of_IOT9A | NONE | NONE |  | 2 |  |
| VCC | Power | N/A |  |  |  |  | 11 | 11 | D5 |
| VCC | Power | N/A |  |  |  |  | 37 | 37 |  |
| VCCO0 | Power | N/A |  |  |  |  | 5 | 5 | C3 |
| VCCO1 | Power | N/A |  |  |  |  | 38 | 38 | C6 |
| VCCO2 | Power | N/A |  |  |  |  |  |  | F6 |
| VCCO2 | Power | N/A |  |  |  |  | 36 | 36 |  |
| VCCO3 | Power | N/A |  |  |  |  | 12 | 12 | F3 |
| VCCO3 | Power | N/A |  |  |  |  | 24 | 24 |  |
| VCCX | Power | N/A |  |  |  |  | 25 | 25 | E4 |
| VSS | Ground | N/A |  |  |  |  |  |  | D4 |
| VSS | Ground | N/A |  |  |  |  |  |  | E5 |
| VSS | Ground | N/A |  |  |  |  | 26 | 26 |  |

# True LVDS

| Pin Name | Function | BANK | Configuration Function | Differential Pair | LVDS | X16 | QN48P | QN48G | MG64P |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BANK2 True LVDS Pair |  |  |  |  |  |  |  |  |  |
| IOR11A/GCLKT_3 | I/O | 2 | GCLKT_3 | True_of_IOR11B | True | x16 | 32 | 32 | G5 |
| IOR11B/GCLKC_3 | I/O | 2 | GCLKC_3 | Comp_of_IOR11A | True | NONE | 31 | 31 | H5 |
| IOR13A | I/O | 2 |  | True_of_IOR13B | True | x16 |  |  | G6 |
| IOR13B | I/O | 2 |  | Comp_of_IOR13A | True | NONE |  |  | H6 |
| IOR15A | I/O | 2 |  | True_of_IOR15B | True | x16 | 30 | 30 | G7 |
| IOR15B | I/O | 2 |  | Comp_of_IOR15A | True | NONE | 29 | 29 | H7 |
| IOR17A | I/O | 2 |  | True_of_IOR17B | True | x16 | 28 | 28 | G8 |
| IOR17B | I/O | 2 |  | Comp_of_IOR17A | True | NONE | 27 | 27 | H8 |
| IOR2A/RPLL_T_in | I/O | 2 | RPLL_T_in | True_of_IOR2B | True | x16 | 35 | 35 | G1 |
| IOR2B/RPLL_C_in | I/O | 2 | RPLL_C_in | Comp_of_IOR2A | True | NONE | 34 | 34 | H1 |
| IOR4A | I/O | 2 |  | True_of_IOR4B | True | x16 |  |  | G2 |
| IOR4B | I/O | 2 |  | Comp_of_IOR4A | True | NONE |  |  | H2 |
| IOR6A | I/O | 2 |  | True_of_IOR6B | True | x16 |  |  | G3 |
| IOR6B | I/O | 2 |  | Comp_of_IOR6A | True | NONE |  |  | H3 |
| IOR8A | I/O | 2 |  | True_of_IOR8B | True | x16 |  |  | G4 |
| IOR8B | I/O | 2 |  | Comp_of_IOR8A | True | NONE |  |  | H4 |

# Power

| Note!
It is recommended to connect  VCCX with the VCCO with the maximum voltage. |  |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Recommended Operating Conditions for GW1NSR-4C QN48P Packages |  |  |  |  |  |  |  |  |  |
| Name | Description |  |  |  | Min. | Max. |  |  |  |
| VCC | Core volatge |  |  |  | 1.14V | 1.26V |  |  |  |
| VCCO0, VCCO1, <br>VCCO2, VCCO3 | I/O Bank volatge |  |  |  | 1.14V | 3.465V |  |  |  |
|  | When HyperRAM is employed, VCCO3 provides power to HyperRAM. |  |  |  | 1.71V | 1.89V |  |  |  |
|  | When MIPI input of BANK0 and BANK1 is employed, VCCO0 and VCCO1 needs to be supplied with 1.2V. |  |  |  | 1.14V | 1.26V |  |  |  |
|  | VCCO2 needs to be supplied with 1.2V when BANK2 MIPI output is employed. |  |  |  | 1.14V | 1.26V |  |  |  |
| VCCX | Auxiliary voltage |  |  |  | 1.71V | 3.465V |  |  |  |
| Recommended Operating Conditions for GW1NSR-4C QN48G |  |  |  |  |  |  |  |  |  |
| Name | Description |  |  |  | Min. | Max. |  |  |  |
| VCC | Core volatge |  |  |  | 1.14V | 1.26V |  |  |  |
| VCCO0, VCCO1, <br>VCCO2, VCCO3 | I/O Bank volatge |  |  |  | 1.14V | 3.465V |  |  |  |
|  | When FLASH is employed, VCCO0 and VCCO1 provide power to FLASH. |  |  |  | 2.565V | 3.465V |  |  |  |
|  | When MIPI input of BANK0 and BANK1 is employed, VCCO0 and VCCO1 needs to be supplied with 1.2V. |  |  |  | 1.14V | 1.26V |  |  |  |
|  | VCCO2 needs to be supplied with 1.2V when BANK2 MIPI output is employed. |  |  |  | 1.14V | 1.26V |  |  |  |
| VCCX | Auxiliary voltage |  |  |  | 1.71V | 3.465V |  |  |  |
| Recommended Operating Conditions for GW1NSR-4C MG64P |  |  |  |  |  |  |  |  |  |
| Name | Description |  |  |  | Min. | Max. |  |  |  |
| VCC | Core volatge |  |  |  | 1.14V | 1.26V |  |  |  |
| VCCO0, VCCO1, <br>VCCO2, VCCO3 | I/O Bank volatge |  |  |  | 1.14V | 3.465V |  |  |  |
|  | When PSRAM is employed, VCCO3 provides power to PSRAM. |  |  |  | 1.71V | 1.89V |  |  |  |
|  | When MIPI input of BANK0 and BANK1 is employed, VCCO0 and VCCO1 needs to be supplied with 1.2V. |  |  |  | 1.14V | 1.26V |  |  |  |
|  | VCCO2 needs to be supplied with 1.2V when BANK2 MIPI output is employed. |  |  |  | 1.14V | 1.26V |  |  |  |
| VCCX | Auxiliary voltage |  |  |  | 1.71V | 3.465V |  |  |  |
