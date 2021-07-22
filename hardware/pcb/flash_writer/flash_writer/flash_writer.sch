EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date "lun. 30 mars 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Label 8250 2550 0    60   ~ 0
A0
Text Label 8250 2650 0    60   ~ 0
A1
Text Label 8250 2750 0    60   ~ 0
A2
Text Label 8250 2850 0    60   ~ 0
A3
Text Label 8250 2950 0    60   ~ 0
A4(SDA)
Text Label 8250 3050 0    60   ~ 0
A5(SCL)
Text Label 10550 2850 0    60   ~ 0
2
Text Label 10550 2650 0    60   ~ 0
4
Text Label 10550 2350 0    60   ~ 0
7
Text Label 10550 2150 0    60   ~ 0
8
Text Label 10550 1450 0    60   ~ 0
AREF
NoConn ~ 9050 1650
Text Label 10550 1350 0    60   ~ 0
A4(SDA)
Text Label 10550 1250 0    60   ~ 0
A5(SCL)
Text Notes 10500 1050 0    60   ~ 0
Holes
Text Notes 8200 800  0    60   ~ 0
Shield for Arduino that uses\nthe same pin disposition\nlike "Uno" board Rev 3.
$Comp
L Connector_Generic:Conn_01x08 P1
U 1 1 56D70129
P 9250 1950
F 0 "P1" H 9250 2400 50  0000 C CNN
F 1 "Power" V 9350 1950 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" V 9400 1950 20  0000 C CNN
F 3 "" H 9250 1950 50  0000 C CNN
	1    9250 1950
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR02
U 1 1 56D707BB
P 8700 1400
F 0 "#PWR02" H 8700 1250 50  0001 C CNN
F 1 "+5V" V 8700 1600 50  0000 C CNN
F 2 "" H 8700 1400 50  0000 C CNN
F 3 "" H 8700 1400 50  0000 C CNN
	1    8700 1400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 56D70CC2
P 8950 3200
F 0 "#PWR03" H 8950 2950 50  0001 C CNN
F 1 "GND" H 8950 3050 50  0000 C CNN
F 2 "" H 8950 3200 50  0000 C CNN
F 3 "" H 8950 3200 50  0000 C CNN
	1    8950 3200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR04
U 1 1 56D70CFF
P 9950 3200
F 0 "#PWR04" H 9950 2950 50  0001 C CNN
F 1 "GND" H 9950 3050 50  0000 C CNN
F 2 "" H 9950 3200 50  0000 C CNN
F 3 "" H 9950 3200 50  0000 C CNN
	1    9950 3200
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x06 P2
U 1 1 56D70DD8
P 9250 2750
F 0 "P2" H 9250 2350 50  0000 C CNN
F 1 "Analog" V 9350 2750 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical" V 9400 2800 20  0000 C CNN
F 3 "" H 9250 2750 50  0000 C CNN
	1    9250 2750
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P5
U 1 1 56D71177
P 10450 700
F 0 "P5" V 10550 700 50  0000 C CNN
F 1 "CONN_01X01" V 10550 700 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" H 10371 774 20  0000 C CNN
F 3 "" H 10450 700 50  0000 C CNN
	1    10450 700 
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P6
U 1 1 56D71274
P 10550 700
F 0 "P6" V 10650 700 50  0000 C CNN
F 1 "CONN_01X01" V 10650 700 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" H 10550 700 20  0001 C CNN
F 3 "" H 10550 700 50  0000 C CNN
	1    10550 700 
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P7
U 1 1 56D712A8
P 10650 700
F 0 "P7" V 10750 700 50  0000 C CNN
F 1 "CONN_01X01" V 10750 700 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" V 10650 700 20  0001 C CNN
F 3 "" H 10650 700 50  0000 C CNN
	1    10650 700 
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x01 P8
U 1 1 56D712DB
P 10750 700
F 0 "P8" V 10850 700 50  0000 C CNN
F 1 "CONN_01X01" V 10850 700 50  0001 C CNN
F 2 "Socket_Arduino_Uno:Arduino_1pin" H 10674 622 20  0000 C CNN
F 3 "" H 10750 700 50  0000 C CNN
	1    10750 700 
	0    -1   -1   0   
$EndComp
NoConn ~ 10450 900 
NoConn ~ 10550 900 
NoConn ~ 10650 900 
NoConn ~ 10750 900 
$Comp
L Connector_Generic:Conn_01x08 P4
U 1 1 56D7164F
P 9650 2650
F 0 "P4" H 9650 2150 50  0000 C CNN
F 1 "Digital" V 9750 2650 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" V 9800 2600 20  0000 C CNN
F 3 "" H 9650 2650 50  0000 C CNN
	1    9650 2650
	-1   0    0    -1  
$EndComp
Wire Notes Line
	8175 875  9575 875 
Wire Notes Line
	9575 875  9575 525 
Wire Wire Line
	9050 2050 8700 2050
Wire Wire Line
	9050 2150 8950 2150
Wire Wire Line
	9050 2250 8950 2250
Connection ~ 8950 2250
Wire Wire Line
	8700 2050 8700 1400
$Comp
L Connector_Generic:Conn_01x10 P3
U 1 1 56D721E0
P 9650 1650
F 0 "P3" H 9650 2200 50  0000 C CNN
F 1 "Digital" V 9750 1650 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x10_P2.54mm_Vertical" V 9800 1650 20  0000 C CNN
F 3 "" H 9650 1650 50  0000 C CNN
	1    9650 1650
	-1   0    0    -1  
$EndComp
Wire Wire Line
	9850 2150 10200 2150
Wire Wire Line
	9850 2050 10200 2050
Wire Wire Line
	9850 1950 10200 1950
Wire Wire Line
	9850 1850 10200 1850
Wire Wire Line
	9850 1750 10200 1750
Wire Wire Line
	9850 1650 10200 1650
Wire Wire Line
	9850 1350 10200 1350
Wire Wire Line
	9850 2850 10200 2850
Wire Wire Line
	9850 2750 10200 2750
Wire Wire Line
	9850 2650 10200 2650
Wire Wire Line
	9850 2550 10200 2550
Wire Wire Line
	9850 2450 10200 2450
Wire Wire Line
	9850 2350 10200 2350
Wire Wire Line
	9850 1550 9950 1550
Wire Wire Line
	9950 1550 9950 3200
Wire Wire Line
	8950 2150 8950 2250
Wire Wire Line
	8950 2250 8950 3200
Wire Notes Line
	8150 550  8150 3500
Wire Notes Line
	8150 3500 10850 3500
Text Notes 9350 1650 0    60   ~ 0
1
Wire Notes Line
	10850 1050 10350 1050
Wire Notes Line
	10350 1050 10350 550 
Text GLabel 10200 2850 2    50   BiDi ~ 0
D0
Text GLabel 10200 2750 2    50   BiDi ~ 0
D1
Text GLabel 10200 2650 2    50   BiDi ~ 0
D2
Text GLabel 10200 2550 2    50   BiDi ~ 0
D3
Text GLabel 10200 2450 2    50   BiDi ~ 0
D4
Text GLabel 10200 2350 2    50   BiDi ~ 0
D5
Text GLabel 10200 2150 2    50   BiDi ~ 0
D6
Text GLabel 10200 2050 2    50   BiDi ~ 0
D7
Text GLabel 10200 1650 2    50   Output ~ 0
SCK
Text GLabel 10200 1850 2    50   Output ~ 0
MOSI
Text GLabel 10200 1750 2    50   Input ~ 0
MISO
Text GLabel 10200 1950 2    50   Output ~ 0
LATCH
Text Label 10550 1650 0    60   ~ 0
13(SCK)
Text Label 10550 1750 0    60   ~ 0
12(MISO)
Text Label 10550 1850 0    60   ~ 0
11(**/MOSI)
Text Label 10550 1950 0    60   ~ 0
10(**/SS)
Text Label 10550 2050 0    60   ~ 0
9(**)
Text Label 10550 2450 0    60   ~ 0
6(**)
Text Label 10550 2550 0    60   ~ 0
5(**)
Text Label 10550 2750 0    60   ~ 0
3(**)
Text Label 10550 2950 0    60   ~ 0
1(Tx)
Text Label 10550 3050 0    60   ~ 0
0(Rx)
NoConn ~ 9850 2950
NoConn ~ 9850 3050
NoConn ~ 9050 1950
NoConn ~ 9050 1850
NoConn ~ 9050 1750
NoConn ~ 9050 2350
$Comp
L 74xx:74HC595 U1
U 1 1 60FB34CF
P 1700 1800
F 0 "U1" H 1450 2350 50  0000 C CNN
F 1 "74HC595" H 1900 2350 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 1700 1800 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn74hc595.pdf" H 1700 1800 50  0001 C CNN
	1    1700 1800
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC595 U2
U 1 1 60FB450A
P 3350 1800
F 0 "U2" H 3100 2350 50  0000 C CNN
F 1 "74HC595" H 3550 2350 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3350 1800 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn74hc595.pdf" H 3350 1800 50  0001 C CNN
	1    3350 1800
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC595 U4
U 1 1 60FB53E1
P 5000 1800
F 0 "U4" H 4750 2350 50  0000 C CNN
F 1 "74HC595" H 5200 2350 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 5000 1800 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/sn74hc595.pdf" H 5000 1800 50  0001 C CNN
	1    5000 1800
	1    0    0    -1  
$EndComp
Text GLabel 2150 1400 2    50   Output ~ 0
A0
Text GLabel 2150 1500 2    50   Output ~ 0
A1
Text GLabel 2150 1600 2    50   Output ~ 0
A2
Text GLabel 2150 1700 2    50   Output ~ 0
A3
Text GLabel 2150 1800 2    50   Output ~ 0
A4
Text GLabel 2150 1900 2    50   Output ~ 0
A5
Text GLabel 2150 2000 2    50   Output ~ 0
A6
Text GLabel 2150 2100 2    50   Output ~ 0
A7
Text GLabel 3800 1400 2    50   Output ~ 0
A8
Text GLabel 3800 1500 2    50   Output ~ 0
A9
Text GLabel 3800 1600 2    50   Output ~ 0
A10
Text GLabel 3800 1700 2    50   Output ~ 0
A11
Text GLabel 3800 1800 2    50   Output ~ 0
A12
Text GLabel 3800 1900 2    50   Output ~ 0
A13
Text GLabel 3800 2000 2    50   Output ~ 0
A14
Text GLabel 3800 2100 2    50   Output ~ 0
A15
Text GLabel 5450 1400 2    50   Output ~ 0
A16
Text GLabel 5450 1500 2    50   Output ~ 0
A17
Text GLabel 5450 1600 2    50   Output ~ 0
A18
Wire Wire Line
	2100 1400 2150 1400
Wire Wire Line
	2100 1500 2150 1500
Wire Wire Line
	2150 1600 2100 1600
Wire Wire Line
	2100 1700 2150 1700
Wire Wire Line
	2150 1800 2100 1800
Wire Wire Line
	2100 1900 2150 1900
Wire Wire Line
	2150 2000 2100 2000
Wire Wire Line
	2100 2100 2150 2100
Wire Wire Line
	3750 1400 3800 1400
Wire Wire Line
	3800 1500 3750 1500
Wire Wire Line
	3750 1600 3800 1600
Wire Wire Line
	3800 1700 3750 1700
Wire Wire Line
	3750 1800 3800 1800
Wire Wire Line
	3800 1900 3750 1900
Wire Wire Line
	3750 2000 3800 2000
Wire Wire Line
	3800 2100 3750 2100
Wire Wire Line
	5400 1400 5450 1400
Wire Wire Line
	5450 1500 5400 1500
Wire Wire Line
	5400 1600 5450 1600
Text GLabel 1250 1400 0    50   Input ~ 0
MOSI
Wire Wire Line
	1250 1400 1300 1400
Text GLabel 1250 1600 0    50   Input ~ 0
SCK
Wire Wire Line
	1250 1600 1300 1600
Text GLabel 2900 1600 0    50   Input ~ 0
SCK
Wire Wire Line
	2900 1600 2950 1600
Text GLabel 4550 1600 0    50   Input ~ 0
SCK
Wire Wire Line
	4550 1600 4600 1600
Text GLabel 1250 1900 0    50   Input ~ 0
LATCH
Text GLabel 2900 1900 0    50   Input ~ 0
LATCH
Text GLabel 4550 1900 0    50   Input ~ 0
LATCH
Wire Wire Line
	1250 1900 1300 1900
Wire Wire Line
	2900 1900 2950 1900
Wire Wire Line
	4550 1900 4600 1900
$Comp
L power:GND #PWR0101
U 1 1 60FE8201
P 1250 2050
F 0 "#PWR0101" H 1250 1800 50  0001 C CNN
F 1 "GND" H 1150 1950 50  0000 C CNN
F 2 "" H 1250 2050 50  0001 C CNN
F 3 "" H 1250 2050 50  0001 C CNN
	1    1250 2050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 60FE8D9F
P 2900 2050
F 0 "#PWR0102" H 2900 1800 50  0001 C CNN
F 1 "GND" H 2800 1950 50  0000 C CNN
F 2 "" H 2900 2050 50  0001 C CNN
F 3 "" H 2900 2050 50  0001 C CNN
	1    2900 2050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 60FE90E3
P 4550 2050
F 0 "#PWR0103" H 4550 1800 50  0001 C CNN
F 1 "GND" H 4450 1950 50  0000 C CNN
F 2 "" H 4550 2050 50  0001 C CNN
F 3 "" H 4550 2050 50  0001 C CNN
	1    4550 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1300 2000 1250 2000
Wire Wire Line
	1250 2000 1250 2050
Wire Wire Line
	2950 2000 2900 2000
Wire Wire Line
	2900 2000 2900 2050
Wire Wire Line
	4600 2000 4550 2000
Wire Wire Line
	4550 2000 4550 2050
$Comp
L power:+5V #PWR0104
U 1 1 60FF007C
P 1000 1650
F 0 "#PWR0104" H 1000 1500 50  0001 C CNN
F 1 "+5V" H 950 1800 50  0000 C CNN
F 2 "" H 1000 1650 50  0000 C CNN
F 3 "" H 1000 1650 50  0000 C CNN
	1    1000 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 1700 1300 1700
Wire Wire Line
	1000 1650 1000 1700
$Comp
L power:+5V #PWR0105
U 1 1 60FF6195
P 2650 1650
F 0 "#PWR0105" H 2650 1500 50  0001 C CNN
F 1 "+5V" H 2600 1800 50  0000 C CNN
F 2 "" H 2650 1650 50  0000 C CNN
F 3 "" H 2650 1650 50  0000 C CNN
	1    2650 1650
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0106
U 1 1 60FF6C84
P 4300 1650
F 0 "#PWR0106" H 4300 1500 50  0001 C CNN
F 1 "+5V" H 4250 1800 50  0000 C CNN
F 2 "" H 4300 1650 50  0000 C CNN
F 3 "" H 4300 1650 50  0000 C CNN
	1    4300 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 1650 2650 1700
Wire Wire Line
	2650 1700 2950 1700
Wire Wire Line
	4300 1650 4300 1700
Wire Wire Line
	4300 1700 4600 1700
Wire Wire Line
	2100 2300 2500 2300
Wire Wire Line
	2500 2300 2500 1400
Wire Wire Line
	2500 1400 2950 1400
Wire Wire Line
	3750 2300 4150 2300
Wire Wire Line
	4150 2300 4150 1400
Wire Wire Line
	4150 1400 4600 1400
$Comp
L power:+5V #PWR0107
U 1 1 61005839
P 1700 1150
F 0 "#PWR0107" H 1700 1000 50  0001 C CNN
F 1 "+5V" H 1650 1300 50  0000 C CNN
F 2 "" H 1700 1150 50  0000 C CNN
F 3 "" H 1700 1150 50  0000 C CNN
	1    1700 1150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0108
U 1 1 61005D65
P 3350 1150
F 0 "#PWR0108" H 3350 1000 50  0001 C CNN
F 1 "+5V" H 3300 1300 50  0000 C CNN
F 2 "" H 3350 1150 50  0000 C CNN
F 3 "" H 3350 1150 50  0000 C CNN
	1    3350 1150
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0109
U 1 1 61006167
P 5000 1150
F 0 "#PWR0109" H 5000 1000 50  0001 C CNN
F 1 "+5V" H 4950 1300 50  0000 C CNN
F 2 "" H 5000 1150 50  0000 C CNN
F 3 "" H 5000 1150 50  0000 C CNN
	1    5000 1150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0110
U 1 1 6100665A
P 1700 2550
F 0 "#PWR0110" H 1700 2300 50  0001 C CNN
F 1 "GND" H 1600 2450 50  0000 C CNN
F 2 "" H 1700 2550 50  0001 C CNN
F 3 "" H 1700 2550 50  0001 C CNN
	1    1700 2550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0111
U 1 1 61006B27
P 3350 2550
F 0 "#PWR0111" H 3350 2300 50  0001 C CNN
F 1 "GND" H 3250 2450 50  0000 C CNN
F 2 "" H 3350 2550 50  0001 C CNN
F 3 "" H 3350 2550 50  0001 C CNN
	1    3350 2550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0112
U 1 1 61006FBA
P 5000 2550
F 0 "#PWR0112" H 5000 2300 50  0001 C CNN
F 1 "GND" H 4900 2450 50  0000 C CNN
F 2 "" H 5000 2550 50  0001 C CNN
F 3 "" H 5000 2550 50  0001 C CNN
	1    5000 2550
	1    0    0    -1  
$EndComp
NoConn ~ 5400 2300
$Comp
L Device:C C1
U 1 1 61014126
P 8850 4650
F 0 "C1" H 8900 4750 50  0000 L CNN
F 1 "100nF" H 8900 4550 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 8888 4500 50  0001 C CNN
F 3 "~" H 8850 4650 50  0001 C CNN
	1    8850 4650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 61017010
P 9200 4650
F 0 "C2" H 9250 4750 50  0000 L CNN
F 1 "100nF" H 9250 4550 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9238 4500 50  0001 C CNN
F 3 "~" H 9200 4650 50  0001 C CNN
	1    9200 4650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 6101A583
P 9550 4650
F 0 "C3" H 9600 4750 50  0000 L CNN
F 1 "100nF" H 9600 4550 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9588 4500 50  0001 C CNN
F 3 "~" H 9550 4650 50  0001 C CNN
	1    9550 4650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 6101B38E
P 9900 4650
F 0 "C4" H 9950 4750 50  0000 L CNN
F 1 "100nF" H 9950 4550 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9938 4500 50  0001 C CNN
F 3 "~" H 9900 4650 50  0001 C CNN
	1    9900 4650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 6101B801
P 10250 4650
F 0 "C5" H 10300 4750 50  0000 L CNN
F 1 "10uF" H 10300 4550 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 10288 4500 50  0001 C CNN
F 3 "~" H 10250 4650 50  0001 C CNN
	1    10250 4650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 6101BCB0
P 10250 4900
F 0 "#PWR0113" H 10250 4650 50  0001 C CNN
F 1 "GND" H 10150 4800 50  0000 C CNN
F 2 "" H 10250 4900 50  0001 C CNN
F 3 "" H 10250 4900 50  0001 C CNN
	1    10250 4900
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0114
U 1 1 6101C98C
P 10250 4400
F 0 "#PWR0114" H 10250 4250 50  0001 C CNN
F 1 "+5V" H 10200 4550 50  0000 C CNN
F 2 "" H 10250 4400 50  0000 C CNN
F 3 "" H 10250 4400 50  0000 C CNN
	1    10250 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 1150 5000 1200
Wire Wire Line
	3350 1150 3350 1200
Wire Wire Line
	1700 1150 1700 1200
Wire Wire Line
	1700 2500 1700 2550
Wire Wire Line
	3350 2500 3350 2550
Wire Wire Line
	5000 2500 5000 2550
Wire Wire Line
	10250 4400 10250 4450
Wire Wire Line
	10250 4800 10250 4850
Wire Wire Line
	8850 4500 8850 4450
Wire Wire Line
	8850 4450 9200 4450
Connection ~ 10250 4450
Wire Wire Line
	10250 4450 10250 4500
Wire Wire Line
	8850 4800 8850 4850
Wire Wire Line
	8850 4850 9200 4850
Connection ~ 10250 4850
Wire Wire Line
	10250 4850 10250 4900
Wire Wire Line
	9900 4500 9900 4450
Connection ~ 9900 4450
Wire Wire Line
	9900 4450 10250 4450
Wire Wire Line
	9900 4800 9900 4850
Connection ~ 9900 4850
Wire Wire Line
	9900 4850 10250 4850
Wire Wire Line
	9550 4500 9550 4450
Connection ~ 9550 4450
Wire Wire Line
	9550 4450 9900 4450
Wire Wire Line
	9550 4800 9550 4850
Connection ~ 9550 4850
Wire Wire Line
	9550 4850 9900 4850
Wire Wire Line
	9200 4500 9200 4450
Connection ~ 9200 4450
Wire Wire Line
	9200 4450 9550 4450
Wire Wire Line
	9200 4800 9200 4850
Connection ~ 9200 4850
Wire Wire Line
	9200 4850 9550 4850
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 61057603
P 8850 4400
F 0 "#FLG0101" H 8850 4475 50  0001 C CNN
F 1 "PWR_FLAG" H 8850 4573 50  0000 C CNN
F 2 "" H 8850 4400 50  0001 C CNN
F 3 "~" H 8850 4400 50  0001 C CNN
	1    8850 4400
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 610576E5
P 8850 4900
F 0 "#FLG0102" H 8850 4975 50  0001 C CNN
F 1 "PWR_FLAG" H 8850 5073 50  0000 C CNN
F 2 "" H 8850 4900 50  0001 C CNN
F 3 "~" H 8850 4900 50  0001 C CNN
	1    8850 4900
	-1   0    0    1   
$EndComp
Wire Wire Line
	8850 4400 8850 4450
Connection ~ 8850 4450
Wire Wire Line
	8850 4850 8850 4900
Connection ~ 8850 4850
$Comp
L power:GND #PWR0115
U 1 1 6106090D
P 10000 6000
F 0 "#PWR0115" H 10000 5750 50  0001 C CNN
F 1 "GND" H 9900 5900 50  0000 C CNN
F 2 "" H 10000 6000 50  0001 C CNN
F 3 "" H 10000 6000 50  0001 C CNN
	1    10000 6000
	1    0    0    -1  
$EndComp
Text GLabel 10050 5600 2    50   Output ~ 0
MISO
Wire Wire Line
	10000 5650 10000 5600
Wire Wire Line
	10000 5600 10050 5600
$Comp
L Memory_Flash:SST39SF040 U3
U 1 1 6106DFAC
P 3400 5300
F 0 "U3" H 3050 6600 50  0000 C CNN
F 1 "SST39SF040" H 3650 6600 50  0000 C CNN
F 2 "Custom:PLCC-32_SMD-Socket" H 3400 5600 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/25022B.pdf" H 3400 5600 50  0001 C CNN
	1    3400 5300
	1    0    0    -1  
$EndComp
Text GLabel 2750 4100 0    50   Input ~ 0
A0
Text GLabel 2750 4200 0    50   Input ~ 0
A1
Text GLabel 2750 4300 0    50   Input ~ 0
A2
Text GLabel 2750 4400 0    50   Input ~ 0
A3
Text GLabel 2750 4500 0    50   Input ~ 0
A4
Text GLabel 2750 4600 0    50   Input ~ 0
A5
Text GLabel 2750 4700 0    50   Input ~ 0
A6
Text GLabel 2750 4800 0    50   Input ~ 0
A7
Text GLabel 2750 4900 0    50   Input ~ 0
A8
Text GLabel 2750 5000 0    50   Input ~ 0
A9
Text GLabel 2750 5100 0    50   Input ~ 0
A10
Text GLabel 2750 5200 0    50   Input ~ 0
A11
Text GLabel 2750 5300 0    50   Input ~ 0
A12
Text GLabel 2750 5400 0    50   Input ~ 0
A13
Text GLabel 2750 5500 0    50   Input ~ 0
A14
Text GLabel 2750 5600 0    50   Input ~ 0
A15
Text GLabel 2750 5700 0    50   Input ~ 0
A16
Text GLabel 2750 5800 0    50   Input ~ 0
A17
Text GLabel 2750 5900 0    50   Input ~ 0
A18
Wire Wire Line
	2750 4100 2800 4100
Wire Wire Line
	2800 4200 2750 4200
Wire Wire Line
	2750 4300 2800 4300
Wire Wire Line
	2800 4400 2750 4400
Wire Wire Line
	2750 4500 2800 4500
Wire Wire Line
	2800 4600 2750 4600
Wire Wire Line
	2750 4700 2800 4700
Wire Wire Line
	2800 4800 2750 4800
Wire Wire Line
	2750 4900 2800 4900
Wire Wire Line
	2800 5000 2750 5000
Wire Wire Line
	2750 5100 2800 5100
Wire Wire Line
	2800 5200 2750 5200
Wire Wire Line
	2750 5300 2800 5300
Wire Wire Line
	2800 5400 2750 5400
Wire Wire Line
	2750 5500 2800 5500
Wire Wire Line
	2800 5600 2750 5600
Wire Wire Line
	2750 5700 2800 5700
Wire Wire Line
	2800 5800 2750 5800
Wire Wire Line
	2750 5900 2800 5900
Text GLabel 4050 4100 2    50   BiDi ~ 0
D0
Text GLabel 4050 4200 2    50   BiDi ~ 0
D1
Text GLabel 4050 4300 2    50   BiDi ~ 0
D2
Text GLabel 4050 4400 2    50   BiDi ~ 0
D3
Text GLabel 4050 4500 2    50   BiDi ~ 0
D4
Text GLabel 4050 4600 2    50   BiDi ~ 0
D5
Text GLabel 4050 4700 2    50   BiDi ~ 0
D6
Text GLabel 4050 4800 2    50   BiDi ~ 0
D7
Wire Wire Line
	4000 4100 4050 4100
Wire Wire Line
	4050 4200 4000 4200
Wire Wire Line
	4000 4300 4050 4300
Wire Wire Line
	4050 4400 4000 4400
Wire Wire Line
	4000 4500 4050 4500
Wire Wire Line
	4050 4600 4000 4600
Wire Wire Line
	4000 4700 4050 4700
Wire Wire Line
	4050 4800 4000 4800
NoConn ~ 9850 1450
Text GLabel 10200 1200 2    50   Output ~ 0
~WE~
Text GLabel 10200 1350 2    50   Output ~ 0
~OE~
Wire Wire Line
	9850 1250 10050 1250
Wire Wire Line
	10050 1250 10050 1200
Wire Wire Line
	10050 1200 10200 1200
Text GLabel 2750 6100 0    50   Input ~ 0
~WE~
Wire Wire Line
	2750 6100 2800 6100
Text GLabel 2750 6400 0    50   Input ~ 0
~OE~
Wire Wire Line
	2750 6400 2800 6400
$Comp
L power:GND #PWR06
U 1 1 61196483
P 3400 6550
F 0 "#PWR06" H 3400 6300 50  0001 C CNN
F 1 "GND" H 3300 6450 50  0000 C CNN
F 2 "" H 3400 6550 50  0001 C CNN
F 3 "" H 3400 6550 50  0001 C CNN
	1    3400 6550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3400 6500 3400 6550
$Comp
L power:+5V #PWR05
U 1 1 6119E159
P 3400 3950
F 0 "#PWR05" H 3400 3800 50  0001 C CNN
F 1 "+5V" H 3350 4100 50  0000 C CNN
F 2 "" H 3400 3950 50  0000 C CNN
F 3 "" H 3400 3950 50  0000 C CNN
	1    3400 3950
	1    0    0    -1  
$EndComp
Wire Wire Line
	3400 3950 3400 4000
$Comp
L power:GND #PWR01
U 1 1 611A5A01
P 2500 6350
F 0 "#PWR01" H 2500 6100 50  0001 C CNN
F 1 "GND" H 2400 6250 50  0000 C CNN
F 2 "" H 2500 6350 50  0001 C CNN
F 3 "" H 2500 6350 50  0001 C CNN
	1    2500 6350
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 6300 2500 6300
Wire Wire Line
	2500 6300 2500 6350
Text GLabel 9600 5900 2    50   Output ~ 0
~WE~
Text GLabel 9200 5900 2    50   Output ~ 0
~OE~
Wire Wire Line
	10000 5950 10000 6000
$Comp
L Device:R R3
U 1 1 610600ED
P 10000 5800
F 0 "R3" H 10070 5846 50  0000 L CNN
F 1 "10K" H 10070 5755 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 9930 5800 50  0001 C CNN
F 3 "~" H 10000 5800 50  0001 C CNN
	1    10000 5800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 611BC6F2
P 9550 5700
F 0 "R2" H 9620 5746 50  0000 L CNN
F 1 "10K" H 9620 5655 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 9480 5700 50  0001 C CNN
F 3 "~" H 9550 5700 50  0001 C CNN
	1    9550 5700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 611BCA19
P 9150 5700
F 0 "R1" H 9220 5746 50  0000 L CNN
F 1 "10K" H 9220 5655 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 9080 5700 50  0001 C CNN
F 3 "~" H 9150 5700 50  0001 C CNN
	1    9150 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	9550 5850 9550 5900
Wire Wire Line
	9550 5900 9600 5900
Wire Wire Line
	9150 5850 9150 5900
Wire Wire Line
	9150 5900 9200 5900
$Comp
L power:+5V #PWR08
U 1 1 611D4AFD
P 9550 5500
F 0 "#PWR08" H 9550 5350 50  0001 C CNN
F 1 "+5V" H 9500 5650 50  0000 C CNN
F 2 "" H 9550 5500 50  0000 C CNN
F 3 "" H 9550 5500 50  0000 C CNN
	1    9550 5500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR07
U 1 1 611D50B1
P 9150 5500
F 0 "#PWR07" H 9150 5350 50  0001 C CNN
F 1 "+5V" H 9100 5650 50  0000 C CNN
F 2 "" H 9150 5500 50  0000 C CNN
F 3 "" H 9150 5500 50  0000 C CNN
	1    9150 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	9550 5500 9550 5550
Wire Wire Line
	9150 5500 9150 5550
NoConn ~ 9050 2550
NoConn ~ 9050 2650
NoConn ~ 9050 2750
NoConn ~ 9050 2850
NoConn ~ 9050 2950
NoConn ~ 9050 3050
NoConn ~ 5400 1700
NoConn ~ 5400 1800
NoConn ~ 5400 1900
NoConn ~ 5400 2000
NoConn ~ 5400 2100
$EndSCHEMATC
