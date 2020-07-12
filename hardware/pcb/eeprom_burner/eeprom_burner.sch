EESchema Schematic File Version 4
LIBS:eeprom_burner-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "EEPROM burner"
Date "2020-07-07"
Rev "1"
Comp "Velko"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Label 8200 2550 0    60   ~ 0
A0
Text Label 8200 2650 0    60   ~ 0
A1
Text Label 8200 2750 0    60   ~ 0
A2
Text Label 8200 2850 0    60   ~ 0
A3
Text Label 8200 2950 0    60   ~ 0
A4(SDA)
Text Label 8200 3050 0    60   ~ 0
A5(SCL)
Text Label 10350 3050 0    60   ~ 0
0(Rx)
Text Label 10350 2850 0    60   ~ 0
2
Text Label 10350 2950 0    60   ~ 0
1(Tx)
Text Label 10350 2750 0    60   ~ 0
3(**)
Text Label 10350 2650 0    60   ~ 0
4
Text Label 10350 2550 0    60   ~ 0
5(**)
Text Label 10350 2450 0    60   ~ 0
6(**)
Text Label 10350 2350 0    60   ~ 0
7
Text Label 10400 2150 0    60   ~ 0
8
Text Label 10400 2050 0    60   ~ 0
9(**)
Text Label 10400 1950 0    60   ~ 0
10(**/SS)
Text Label 10400 1850 0    60   ~ 0
11(**/MOSI)
Text Label 10400 1750 0    60   ~ 0
12(MISO)
Text Label 10400 1650 0    60   ~ 0
13(SCK)
Text Label 10350 1450 0    60   ~ 0
AREF
NoConn ~ 8950 1600
Text Label 10350 1350 0    60   ~ 0
A4(SDA)
Text Label 10350 1250 0    60   ~ 0
A5(SCL)
Text Notes 10400 1000 0    60   ~ 0
Holes
Text Notes 8100 750  0    60   ~ 0
Shield for Arduino that uses\nthe same pin disposition\nlike "Uno" board Rev 3.
$Comp
L Connector_Generic:Conn_01x08 P1
U 1 1 56D70129
P 9150 1900
F 0 "P1" H 9150 2350 50  0000 C CNN
F 1 "Power" V 9250 1900 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" V 9300 1900 20  0000 C CNN
F 3 "" H 9150 1900 50  0000 C CNN
	1    9150 1900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR02
U 1 1 56D707BB
P 8600 1350
F 0 "#PWR02" H 8600 1200 50  0001 C CNN
F 1 "+5V" V 8600 1550 50  0000 C CNN
F 2 "" H 8600 1350 50  0000 C CNN
F 3 "" H 8600 1350 50  0000 C CNN
	1    8600 1350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 56D70CC2
P 8850 3150
F 0 "#PWR03" H 8850 2900 50  0001 C CNN
F 1 "GND" H 8850 3000 50  0000 C CNN
F 2 "" H 8850 3150 50  0000 C CNN
F 3 "" H 8850 3150 50  0000 C CNN
	1    8850 3150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR04
U 1 1 56D70CFF
P 9850 3150
F 0 "#PWR04" H 9850 2900 50  0001 C CNN
F 1 "GND" H 9850 3000 50  0000 C CNN
F 2 "" H 9850 3150 50  0000 C CNN
F 3 "" H 9850 3150 50  0000 C CNN
	1    9850 3150
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x06 P2
U 1 1 56D70DD8
P 9150 2700
F 0 "P2" H 9150 2300 50  0000 C CNN
F 1 "Analog" V 9250 2700 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical" V 9300 2750 20  0000 C CNN
F 3 "" H 9150 2700 50  0000 C CNN
	1    9150 2700
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P5
U 1 1 56D71177
P 10350 650
F 0 "P5" V 10450 650 50  0000 C CNN
F 1 "CONN_01X01" V 10450 650 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" H 10271 724 20  0000 C CNN
F 3 "" H 10350 650 50  0000 C CNN
	1    10350 650 
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P6
U 1 1 56D71274
P 10450 650
F 0 "P6" V 10550 650 50  0000 C CNN
F 1 "CONN_01X01" V 10550 650 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" H 10450 650 20  0001 C CNN
F 3 "" H 10450 650 50  0000 C CNN
	1    10450 650 
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P7
U 1 1 56D712A8
P 10550 650
F 0 "P7" V 10650 650 50  0000 C CNN
F 1 "CONN_01X01" V 10650 650 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" V 10550 650 20  0001 C CNN
F 3 "" H 10550 650 50  0000 C CNN
	1    10550 650 
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P8
U 1 1 56D712DB
P 10650 650
F 0 "P8" V 10750 650 50  0000 C CNN
F 1 "CONN_01X01" V 10750 650 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" H 10574 572 20  0000 C CNN
F 3 "" H 10650 650 50  0000 C CNN
	1    10650 650 
	0    -1   -1   0   
$EndComp
NoConn ~ 10350 850 
NoConn ~ 10450 850 
NoConn ~ 10550 850 
NoConn ~ 10650 850 
$Comp
L Connector_Generic:Conn_01x08 P4
U 1 1 56D7164F
P 9550 2600
F 0 "P4" H 9550 2100 50  0000 C CNN
F 1 "Digital" V 9650 2600 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" V 9700 2550 20  0000 C CNN
F 3 "" H 9550 2600 50  0000 C CNN
	1    9550 2600
	-1   0    0    -1  
$EndComp
Wire Notes Line
	8075 825  9475 825 
Wire Notes Line
	9475 825  9475 475 
Wire Wire Line
	8950 2000 8600 2000
Wire Wire Line
	8950 2100 8850 2100
Wire Wire Line
	8950 2200 8850 2200
Connection ~ 8850 2200
Wire Wire Line
	8600 2000 8600 1350
$Comp
L Connector_Generic:Conn_01x10 P3
U 1 1 56D721E0
P 9550 1600
F 0 "P3" H 9550 2150 50  0000 C CNN
F 1 "Digital" V 9650 1600 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x10_P2.54mm_Vertical" V 9700 1600 20  0000 C CNN
F 3 "" H 9550 1600 50  0000 C CNN
	1    9550 1600
	-1   0    0    -1  
$EndComp
Wire Wire Line
	9750 2100 10100 2100
Wire Wire Line
	9750 2000 10100 2000
Wire Wire Line
	9750 1900 10100 1900
Wire Wire Line
	9750 1800 10100 1800
Wire Wire Line
	9750 1600 10100 1600
Wire Wire Line
	9750 1200 10100 1200
Wire Wire Line
	9750 2800 10100 2800
Wire Wire Line
	9750 2700 10100 2700
Wire Wire Line
	9750 2600 10100 2600
Wire Wire Line
	9750 2500 10100 2500
Wire Wire Line
	9750 2400 10100 2400
Wire Wire Line
	9750 2300 10100 2300
Wire Wire Line
	9750 1500 9850 1500
Wire Wire Line
	9850 1500 9850 3150
Wire Wire Line
	8850 2100 8850 2200
Wire Wire Line
	8850 2200 8850 3150
Wire Notes Line
	8050 500  8050 3450
Wire Notes Line
	8050 3450 10750 3450
Text Notes 9250 1600 0    60   ~ 0
1
Wire Notes Line
	10750 1000 10250 1000
Wire Notes Line
	10250 1000 10250 500 
$Comp
L 74xx:74HC595 U1
U 1 1 5F039E0A
P 3400 2000
F 0 "U1" H 3150 2550 50  0000 C CNN
F 1 "74HC595" H 3600 2550 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 3400 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn74hc595.pdf" H 3400 2000 50  0001 C CNN
	1    3400 2000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC595 U2
U 1 1 5F039ECD
P 1550 2000
F 0 "U2" H 1300 2550 50  0000 C CNN
F 1 "74HC595" H 1750 2550 50  0000 C CNN
F 2 "Package_DIP:DIP-16_W7.62mm" H 1550 2000 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn74hc595.pdf" H 1550 2000 50  0001 C CNN
	1    1550 2000
	1    0    0    -1  
$EndComp
Text GLabel 10100 1600 2    50   Output ~ 0
SCK
Text GLabel 10100 1800 2    50   Output ~ 0
MOSI
Text GLabel 10100 1900 2    50   Output ~ 0
LATCH
Text GLabel 10100 1700 2    50   Input ~ 0
MISO
Text GLabel 2900 1600 0    50   Input ~ 0
MOSI
Wire Wire Line
	2900 1600 3000 1600
Text GLabel 2900 1800 0    50   Input ~ 0
SCK
Wire Wire Line
	2900 1800 3000 1800
Text GLabel 1050 1800 0    50   Input ~ 0
SCK
Wire Wire Line
	1050 1800 1150 1800
Text GLabel 2900 2100 0    50   Input ~ 0
LATCH
Text GLabel 1050 2100 0    50   Input ~ 0
LATCH
Wire Wire Line
	2900 2100 3000 2100
Wire Wire Line
	1050 2100 1150 2100
$Comp
L power:GND #PWR0101
U 1 1 5F04170D
P 1550 2950
F 0 "#PWR0101" H 1550 2700 50  0001 C CNN
F 1 "GND" H 1555 2777 50  0000 C CNN
F 2 "" H 1550 2950 50  0001 C CNN
F 3 "" H 1550 2950 50  0001 C CNN
	1    1550 2950
	1    0    0    -1  
$EndComp
NoConn ~ 1950 2500
Wire Wire Line
	1550 1250 1550 1400
NoConn ~ 9750 2900
NoConn ~ 9750 3000
NoConn ~ 9750 1400
NoConn ~ 8900 1450
NoConn ~ 8950 1700
NoConn ~ 8950 1800
NoConn ~ 8950 1900
NoConn ~ 8950 2300
$Comp
L power:+5V #PWR0103
U 1 1 5F04F8B9
P 3400 1250
F 0 "#PWR0103" H 3400 1100 50  0001 C CNN
F 1 "+5V" V 3350 1350 50  0000 C CNN
F 2 "" H 3400 1250 50  0000 C CNN
F 3 "" H 3400 1250 50  0000 C CNN
	1    3400 1250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0104
U 1 1 5F04F91E
P 1550 1250
F 0 "#PWR0104" H 1550 1100 50  0001 C CNN
F 1 "+5V" V 1500 1350 50  0000 C CNN
F 2 "" H 1550 1250 50  0000 C CNN
F 3 "" H 1550 1250 50  0000 C CNN
	1    1550 1250
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0106
U 1 1 5F0512C1
P 700 1850
F 0 "#PWR0106" H 700 1700 50  0001 C CNN
F 1 "+5V" V 650 1950 50  0000 C CNN
F 2 "" H 700 1850 50  0000 C CNN
F 3 "" H 700 1850 50  0000 C CNN
	1    700  1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	700  1900 700  1850
Wire Wire Line
	700  1900 1150 1900
Wire Wire Line
	3000 2200 2650 2200
Wire Wire Line
	2450 1900 3000 1900
$Comp
L power:+5V #PWR0105
U 1 1 5F04F98D
P 2450 1850
F 0 "#PWR0105" H 2450 1700 50  0001 C CNN
F 1 "+5V" V 2400 1950 50  0000 C CNN
F 2 "" H 2450 1850 50  0000 C CNN
F 3 "" H 2450 1850 50  0000 C CNN
	1    2450 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2450 1900 2450 1850
Connection ~ 2450 1900
$Comp
L power:GND #PWR0102
U 1 1 5F041751
P 3400 2950
F 0 "#PWR0102" H 3400 2700 50  0001 C CNN
F 1 "GND" H 3405 2777 50  0000 C CNN
F 2 "" H 3400 2950 50  0001 C CNN
F 3 "" H 3400 2950 50  0001 C CNN
	1    3400 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2450 2900 3400 2900
Wire Wire Line
	3400 2700 3400 2900
Wire Wire Line
	3400 2900 3400 2950
Connection ~ 3400 2900
Wire Wire Line
	4450 2500 4450 800 
Wire Wire Line
	4450 800  1100 800 
Wire Wire Line
	1100 800  1100 1600
Wire Wire Line
	1100 1600 1150 1600
Wire Wire Line
	3800 2500 4450 2500
Wire Wire Line
	2250 2750 1100 2750
Wire Wire Line
	1100 2750 1100 2200
Wire Wire Line
	1100 2200 1150 2200
Wire Wire Line
	9750 1700 10100 1700
Wire Wire Line
	3400 1400 3400 1250
Text GLabel 7500 1050 2    50   Input ~ 0
MISO
$Comp
L power:GND #PWR0107
U 1 1 5F05FC6B
P 7350 1450
F 0 "#PWR0107" H 7350 1200 50  0001 C CNN
F 1 "GND" H 7355 1277 50  0000 C CNN
F 2 "" H 7350 1450 50  0001 C CNN
F 3 "" H 7350 1450 50  0001 C CNN
	1    7350 1450
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5F05FD4C
P 7350 1250
F 0 "R1" H 7420 1250 50  0000 L CNN
F 1 "10K" H 7420 1205 50  0001 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 7280 1250 50  0001 C CNN
F 3 "~" H 7350 1250 50  0001 C CNN
	1    7350 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 1050 7350 1050
Wire Wire Line
	7350 1050 7350 1100
Wire Wire Line
	7350 1450 7350 1400
Wire Wire Line
	1550 2700 1550 2950
Text GLabel 3950 1600 2    50   Output ~ 0
A0
Text GLabel 3950 1700 2    50   Output ~ 0
A1
Text GLabel 3950 1800 2    50   Output ~ 0
A2
Text GLabel 3950 1900 2    50   Output ~ 0
A3
Text GLabel 3950 2000 2    50   Output ~ 0
A4
Text GLabel 3950 2100 2    50   Output ~ 0
A5
Text GLabel 3950 2200 2    50   Output ~ 0
A6
Text GLabel 3950 2300 2    50   Output ~ 0
A7
Wire Wire Line
	3800 1600 3950 1600
Wire Wire Line
	3800 1700 3950 1700
Wire Wire Line
	3800 1800 3950 1800
Wire Wire Line
	3800 1900 3950 1900
Wire Wire Line
	3800 2000 3950 2000
Wire Wire Line
	3800 2100 3950 2100
Wire Wire Line
	3800 2200 3950 2200
Wire Wire Line
	3800 2300 3950 2300
Text GLabel 2050 1600 2    50   Output ~ 0
A8
Text GLabel 2050 1700 2    50   Output ~ 0
A9
Text GLabel 2050 1800 2    50   Output ~ 0
A10
Text GLabel 2050 1900 2    50   Output ~ 0
A11
Text GLabel 2050 2000 2    50   Output ~ 0
A12
Text GLabel 2050 2100 2    50   Output ~ 0
A13
Text GLabel 2050 2200 2    50   Output ~ 0
A14
Text GLabel 2050 2300 2    50   Output ~ 0
A15
Wire Wire Line
	1950 1600 2050 1600
Wire Wire Line
	1950 1700 2050 1700
Wire Wire Line
	1950 1800 2050 1800
Wire Wire Line
	1950 1900 2050 1900
Wire Wire Line
	1950 2000 2050 2000
Wire Wire Line
	1950 2100 2050 2100
Wire Wire Line
	1950 2200 2050 2200
Wire Wire Line
	1950 2300 2050 2300
Text GLabel 10100 2000 2    50   BiDi ~ 0
D0
Text GLabel 10100 2100 2    50   BiDi ~ 0
D1
Text GLabel 10100 2300 2    50   BiDi ~ 0
D2
Text GLabel 10100 2400 2    50   BiDi ~ 0
D3
Text GLabel 10100 2500 2    50   BiDi ~ 0
D4
Text GLabel 10100 2600 2    50   BiDi ~ 0
D5
Text GLabel 10100 2700 2    50   BiDi ~ 0
D6
Text GLabel 10100 2800 2    50   BiDi ~ 0
D7
$Comp
L Memory_EEPROM:28C256 U3
U 1 1 5F081F6E
P 1750 5300
F 0 "U3" H 1550 6350 50  0000 C CNN
F 1 "28C256" H 1900 6350 50  0000 C CNN
F 2 "Package_DIP:DIP-28_W15.24mm" H 1750 5300 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf" H 1750 5300 50  0001 C CNN
	1    1750 5300
	1    0    0    -1  
$EndComp
Text GLabel 2250 4400 2    50   BiDi ~ 0
D0
Text GLabel 2250 4500 2    50   BiDi ~ 0
D1
Text GLabel 2250 4600 2    50   BiDi ~ 0
D2
Text GLabel 2250 4700 2    50   BiDi ~ 0
D3
Text GLabel 2250 4800 2    50   BiDi ~ 0
D4
Text GLabel 2250 4900 2    50   BiDi ~ 0
D5
Text GLabel 2250 5000 2    50   BiDi ~ 0
D6
Text GLabel 2250 5100 2    50   BiDi ~ 0
D7
Wire Wire Line
	2150 4400 2250 4400
Wire Wire Line
	2250 4500 2150 4500
Wire Wire Line
	2150 4600 2250 4600
Wire Wire Line
	2250 4700 2150 4700
Wire Wire Line
	2150 4800 2250 4800
Wire Wire Line
	2250 4900 2150 4900
Wire Wire Line
	2150 5000 2250 5000
Wire Wire Line
	2250 5100 2150 5100
Text GLabel 1250 4400 0    50   Input ~ 0
A0
Text GLabel 1250 4500 0    50   Input ~ 0
A1
Text GLabel 1250 4600 0    50   Input ~ 0
A2
Text GLabel 1250 4700 0    50   Input ~ 0
A3
Text GLabel 1250 4800 0    50   Input ~ 0
A4
Text GLabel 1250 4900 0    50   Input ~ 0
A5
Text GLabel 1250 5000 0    50   Input ~ 0
A6
Text GLabel 1250 5100 0    50   Input ~ 0
A7
Text GLabel 1250 5200 0    50   Input ~ 0
A8
Text GLabel 1250 5300 0    50   Input ~ 0
A9
Text GLabel 1250 5400 0    50   Input ~ 0
A10
Text GLabel 1250 5500 0    50   Input ~ 0
A11
Text GLabel 1250 5600 0    50   Input ~ 0
A12
Text GLabel 1250 5700 0    50   Input ~ 0
A13
Text GLabel 1250 5800 0    50   Input ~ 0
A14
Text GLabel 1250 6100 0    50   Input ~ 0
A15
Wire Wire Line
	1250 4400 1350 4400
Wire Wire Line
	1350 4500 1250 4500
Wire Wire Line
	1250 4600 1350 4600
Wire Wire Line
	1350 4700 1250 4700
Wire Wire Line
	1250 4800 1350 4800
Wire Wire Line
	1350 4900 1250 4900
Wire Wire Line
	1250 5000 1350 5000
Wire Wire Line
	1350 5100 1250 5100
Wire Wire Line
	1250 5200 1350 5200
Wire Wire Line
	1350 5300 1250 5300
Wire Wire Line
	1250 5400 1350 5400
Wire Wire Line
	1350 5500 1250 5500
Wire Wire Line
	1250 5600 1350 5600
Wire Wire Line
	1350 5700 1250 5700
Wire Wire Line
	1250 5800 1350 5800
Wire Wire Line
	1350 6100 1250 6100
$Comp
L power:GND #PWR0108
U 1 1 5F0D83F6
P 1750 6500
F 0 "#PWR0108" H 1750 6250 50  0001 C CNN
F 1 "GND" H 1755 6327 50  0000 C CNN
F 2 "" H 1750 6500 50  0001 C CNN
F 3 "" H 1750 6500 50  0001 C CNN
	1    1750 6500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0109
U 1 1 5F0D85CF
P 1750 4100
F 0 "#PWR0109" H 1750 3950 50  0001 C CNN
F 1 "+5V" V 1700 4200 50  0000 C CNN
F 2 "" H 1750 4100 50  0000 C CNN
F 3 "" H 1750 4100 50  0000 C CNN
	1    1750 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 4100 1750 4200
Wire Wire Line
	1750 6500 1750 6450
Wire Wire Line
	1350 6200 1300 6200
Wire Wire Line
	1300 6200 1300 6450
Wire Wire Line
	1300 6450 1750 6450
Connection ~ 1750 6450
Wire Wire Line
	1750 6450 1750 6400
Text GLabel 10100 1200 2    50   Output ~ 0
~WE~
Text GLabel 1250 5950 0    50   Input ~ 0
~WE~
Wire Wire Line
	1250 5950 1300 5950
Wire Wire Line
	1300 5950 1300 6000
Wire Wire Line
	1300 6000 1350 6000
NoConn ~ 9750 1300
$Comp
L Memory_EEPROM:28C256 U4
U 1 1 5F109E2E
P 3750 5300
F 0 "U4" H 3550 6350 50  0000 C CNN
F 1 "28C256" H 3900 6350 50  0000 C CNN
F 2 "Package_LCC:PLCC-28_SMD-Socket" H 3750 5300 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf" H 3750 5300 50  0001 C CNN
	1    3750 5300
	1    0    0    -1  
$EndComp
Text GLabel 4250 4400 2    50   BiDi ~ 0
D0
Text GLabel 4250 4500 2    50   BiDi ~ 0
D1
Text GLabel 4250 4600 2    50   BiDi ~ 0
D2
Text GLabel 4250 4700 2    50   BiDi ~ 0
D3
Text GLabel 4250 4800 2    50   BiDi ~ 0
D4
Text GLabel 4250 4900 2    50   BiDi ~ 0
D5
Text GLabel 4250 5000 2    50   BiDi ~ 0
D6
Text GLabel 4250 5100 2    50   BiDi ~ 0
D7
Wire Wire Line
	4150 4400 4250 4400
Wire Wire Line
	4250 4500 4150 4500
Wire Wire Line
	4150 4600 4250 4600
Wire Wire Line
	4250 4700 4150 4700
Wire Wire Line
	4150 4800 4250 4800
Wire Wire Line
	4250 4900 4150 4900
Wire Wire Line
	4150 5000 4250 5000
Wire Wire Line
	4250 5100 4150 5100
Text GLabel 3250 4400 0    50   Input ~ 0
A0
Text GLabel 3250 4500 0    50   Input ~ 0
A1
Text GLabel 3250 4600 0    50   Input ~ 0
A2
Text GLabel 3250 4700 0    50   Input ~ 0
A3
Text GLabel 3250 4800 0    50   Input ~ 0
A4
Text GLabel 3250 4900 0    50   Input ~ 0
A5
Text GLabel 3250 5000 0    50   Input ~ 0
A6
Text GLabel 3250 5100 0    50   Input ~ 0
A7
Text GLabel 3250 5200 0    50   Input ~ 0
A8
Text GLabel 3250 5300 0    50   Input ~ 0
A9
Text GLabel 3250 5400 0    50   Input ~ 0
A10
Text GLabel 3250 5500 0    50   Input ~ 0
A11
Text GLabel 3250 5600 0    50   Input ~ 0
A12
Text GLabel 3250 5700 0    50   Input ~ 0
A13
Text GLabel 3250 5800 0    50   Input ~ 0
A14
Text GLabel 3250 6100 0    50   Input ~ 0
A15
Wire Wire Line
	3250 4400 3350 4400
Wire Wire Line
	3350 4500 3250 4500
Wire Wire Line
	3250 4600 3350 4600
Wire Wire Line
	3350 4700 3250 4700
Wire Wire Line
	3250 4800 3350 4800
Wire Wire Line
	3350 4900 3250 4900
Wire Wire Line
	3250 5000 3350 5000
Wire Wire Line
	3350 5100 3250 5100
Wire Wire Line
	3250 5200 3350 5200
Wire Wire Line
	3350 5300 3250 5300
Wire Wire Line
	3250 5400 3350 5400
Wire Wire Line
	3350 5500 3250 5500
Wire Wire Line
	3250 5600 3350 5600
Wire Wire Line
	3350 5700 3250 5700
Wire Wire Line
	3250 5800 3350 5800
Wire Wire Line
	3350 6100 3250 6100
$Comp
L power:GND #PWR0110
U 1 1 5F109E65
P 3750 6500
F 0 "#PWR0110" H 3750 6250 50  0001 C CNN
F 1 "GND" H 3755 6327 50  0000 C CNN
F 2 "" H 3750 6500 50  0001 C CNN
F 3 "" H 3750 6500 50  0001 C CNN
	1    3750 6500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0111
U 1 1 5F109E6B
P 3750 4100
F 0 "#PWR0111" H 3750 3950 50  0001 C CNN
F 1 "+5V" V 3700 4200 50  0000 C CNN
F 2 "" H 3750 4100 50  0000 C CNN
F 3 "" H 3750 4100 50  0000 C CNN
	1    3750 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 4100 3750 4200
Wire Wire Line
	3750 6500 3750 6450
Wire Wire Line
	3350 6200 3300 6200
Wire Wire Line
	3300 6200 3300 6450
Wire Wire Line
	3300 6450 3750 6450
Connection ~ 3750 6450
Wire Wire Line
	3750 6450 3750 6400
Text GLabel 3250 5950 0    50   Input ~ 0
~WE~
Wire Wire Line
	3250 5950 3300 5950
Wire Wire Line
	3300 5950 3300 6000
Wire Wire Line
	3300 6000 3350 6000
Wire Wire Line
	2650 2200 2650 2750
Wire Wire Line
	2650 2750 2250 2750
Connection ~ 2250 2750
$Comp
L Jumper:SolderJumper_3_Open JP1
U 1 1 5F0A6B6F
P 2450 2400
F 0 "JP1" V 2450 2467 50  0000 L CNN
F 1 "SolderJumper_3_Open" V 2495 2468 50  0001 L CNN
F 2 "Jumper:SolderJumper-3_P1.3mm_Open_RoundedPad1.0x1.5mm" H 2450 2400 50  0001 C CNN
F 3 "~" H 2450 2400 50  0001 C CNN
	1    2450 2400
	0    1    1    0   
$EndComp
Wire Wire Line
	2450 1900 2450 2200
Wire Wire Line
	2450 2600 2450 2900
Wire Wire Line
	2250 2400 2300 2400
Wire Wire Line
	2250 2400 2250 2750
Text GLabel 5550 4350 0    50   Input ~ 0
A0
Text GLabel 5550 4450 0    50   Input ~ 0
A1
Text GLabel 5550 4550 0    50   Input ~ 0
A2
Text GLabel 5550 4650 0    50   Input ~ 0
A3
Text GLabel 5550 4750 0    50   Input ~ 0
A4
Text GLabel 5550 4850 0    50   Input ~ 0
A5
Text GLabel 5550 4950 0    50   Input ~ 0
A6
Text GLabel 5550 5050 0    50   Input ~ 0
A7
Text GLabel 6450 4350 2    50   Input ~ 0
A8
Text GLabel 6450 4450 2    50   Input ~ 0
A9
Text GLabel 6450 4550 2    50   Input ~ 0
A10
Text GLabel 6450 4650 2    50   Input ~ 0
A11
Text GLabel 6450 4750 2    50   Input ~ 0
A12
Text GLabel 6450 4850 2    50   Input ~ 0
A13
Text GLabel 6450 4950 2    50   Input ~ 0
A14
Text GLabel 6450 5050 2    50   Input ~ 0
A15
Wire Wire Line
	5550 4350 5650 4350
Wire Wire Line
	6350 4350 6450 4350
Wire Wire Line
	6450 4450 6350 4450
Wire Wire Line
	5550 4450 5650 4450
Wire Wire Line
	5550 4550 5650 4550
Wire Wire Line
	6350 4550 6450 4550
Wire Wire Line
	5550 4650 5650 4650
Wire Wire Line
	6350 4650 6450 4650
Wire Wire Line
	6450 4750 6350 4750
Wire Wire Line
	5550 4750 5650 4750
Wire Wire Line
	6350 4850 6450 4850
Wire Wire Line
	5550 4850 5650 4850
Wire Wire Line
	6350 4950 6450 4950
Wire Wire Line
	6450 5050 6350 5050
Wire Wire Line
	5550 4950 5650 4950
Wire Wire Line
	5650 5050 5550 5050
Text GLabel 8750 2500 0    50   BiDi ~ 0
E0
Wire Wire Line
	8750 2500 8950 2500
Text GLabel 8750 2600 0    50   BiDi ~ 0
E1
Text GLabel 8750 2700 0    50   BiDi ~ 0
E2
Text GLabel 8750 2800 0    50   BiDi ~ 0
E3
Text GLabel 8750 2900 0    50   BiDi ~ 0
E4
Text GLabel 8750 3000 0    50   BiDi ~ 0
E5
Wire Wire Line
	8750 2600 8950 2600
Wire Wire Line
	8750 2700 8950 2700
Wire Wire Line
	8750 2800 8950 2800
Wire Wire Line
	8950 2900 8750 2900
Wire Wire Line
	8750 3000 8950 3000
Text GLabel 5550 5600 0    50   BiDi ~ 0
E0
Text GLabel 5550 5700 0    50   BiDi ~ 0
E1
Text GLabel 5550 5800 0    50   BiDi ~ 0
E2
Text GLabel 5550 5900 0    50   BiDi ~ 0
E3
Text GLabel 5550 6000 0    50   BiDi ~ 0
E4
Text GLabel 5550 6100 0    50   BiDi ~ 0
E5
$Comp
L power:+5V #PWR0112
U 1 1 5F1C55A4
P 5250 5400
F 0 "#PWR0112" H 5250 5250 50  0001 C CNN
F 1 "+5V" V 5200 5500 50  0000 C CNN
F 2 "" H 5250 5400 50  0000 C CNN
F 3 "" H 5250 5400 50  0000 C CNN
	1    5250 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 5F1C568C
P 5250 5500
F 0 "#PWR0113" H 5250 5250 50  0001 C CNN
F 1 "GND" H 5255 5327 50  0000 C CNN
F 2 "" H 5250 5500 50  0001 C CNN
F 3 "" H 5250 5500 50  0001 C CNN
	1    5250 5500
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x08 J1
U 1 1 5F1D9B5D
P 5850 4650
F 0 "J1" H 5850 5050 50  0000 L CNN
F 1 "Conn_01x08" H 5930 4551 50  0001 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 5850 4650 50  0001 C CNN
F 3 "~" H 5850 4650 50  0001 C CNN
	1    5850 4650
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x08 J2
U 1 1 5F1E3D16
P 6150 4750
F 0 "J2" H 6100 4250 50  0000 C CNN
F 1 "Conn_01x08" H 6230 4651 50  0001 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 6150 4750 50  0001 C CNN
F 3 "~" H 6150 4750 50  0001 C CNN
	1    6150 4750
	-1   0    0    1   
$EndComp
$Comp
L Connector_Generic:Conn_01x08 J4
U 1 1 5F20C709
P 5850 5700
F 0 "J4" H 5929 5646 50  0000 L CNN
F 1 "Conn_01x06" H 5930 5601 50  0001 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 5850 5700 50  0001 C CNN
F 3 "~" H 5850 5700 50  0001 C CNN
	1    5850 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 5400 5250 5400
Wire Wire Line
	5650 5500 5250 5500
Wire Wire Line
	5550 5600 5650 5600
Wire Wire Line
	5650 5700 5550 5700
Wire Wire Line
	5550 5800 5650 5800
Wire Wire Line
	5650 5900 5550 5900
Wire Wire Line
	5550 6000 5650 6000
Wire Wire Line
	5650 6100 5550 6100
$EndSCHEMATC
