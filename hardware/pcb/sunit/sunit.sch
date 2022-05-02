EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Shift Unit (SHR/SWAP)"
Date "2021-09-06"
Rev "1"
Comp "Velko"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 74xx:74HC245 U8
U 1 1 5F208CA5
P 7800 1850
F 0 "U8" H 7600 2500 50  0000 C CNN
F 1 "74HC245" H 8000 2500 50  0000 C CNN
F 2 "Package_SO:SO-20_12.8x7.5mm_P1.27mm" H 7800 1850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 7800 1850 50  0001 C CNN
	1    7800 1850
	1    0    0    -1  
$EndComp
Text GLabel 7250 1350 0    50   Input ~ 0
RES0
Text GLabel 7250 1450 0    50   Input ~ 0
RES1
Text GLabel 7250 1550 0    50   Input ~ 0
RES2
Text GLabel 7250 1650 0    50   Input ~ 0
RES3
Text GLabel 7250 1750 0    50   Input ~ 0
RES4
Text GLabel 7250 1850 0    50   Input ~ 0
RES5
Text GLabel 7250 1950 0    50   Input ~ 0
RES6
Text GLabel 7250 2050 0    50   Input ~ 0
RES7
Wire Wire Line
	7250 1350 7300 1350
Wire Wire Line
	7250 1450 7300 1450
Wire Wire Line
	7250 1550 7300 1550
Wire Wire Line
	7250 1650 7300 1650
Wire Wire Line
	7250 1750 7300 1750
Wire Wire Line
	7250 1850 7300 1850
Wire Wire Line
	7250 1950 7300 1950
Wire Wire Line
	7250 2050 7300 2050
$Comp
L power:VCC #PWR014
U 1 1 5F229A39
P 7800 950
F 0 "#PWR014" H 7800 800 50  0001 C CNN
F 1 "VCC" H 7900 1050 50  0000 C CNN
F 2 "" H 7800 950 50  0001 C CNN
F 3 "" H 7800 950 50  0001 C CNN
	1    7800 950 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR015
U 1 1 5F229A9E
P 7800 2650
F 0 "#PWR015" H 7800 2400 50  0001 C CNN
F 1 "GND" H 7950 2600 50  0000 C CNN
F 2 "" H 7800 2650 50  0001 C CNN
F 3 "" H 7800 2650 50  0001 C CNN
	1    7800 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 950  7800 1000
Wire Wire Line
	7300 2250 6850 2250
Wire Wire Line
	6850 2250 6850 1000
Wire Wire Line
	6850 1000 7800 1000
Connection ~ 7800 1000
Wire Wire Line
	7800 1000 7800 1050
Text GLabel 8400 2050 2    50   Output ~ 0
BUS7
Text GLabel 8400 1950 2    50   Output ~ 0
BUS6
Text GLabel 8400 1850 2    50   Output ~ 0
BUS5
Text GLabel 8400 1750 2    50   Output ~ 0
BUS4
Text GLabel 8400 1650 2    50   Output ~ 0
BUS3
Text GLabel 8400 1550 2    50   Output ~ 0
BUS2
Text GLabel 8400 1450 2    50   Output ~ 0
BUS1
Text GLabel 8400 1350 2    50   Output ~ 0
BUS0
Wire Wire Line
	8300 1350 8400 1350
Wire Wire Line
	8400 1450 8300 1450
Wire Wire Line
	8300 1550 8400 1550
Wire Wire Line
	8400 1650 8300 1650
Wire Wire Line
	8300 1750 8400 1750
Wire Wire Line
	8400 1850 8300 1850
Wire Wire Line
	8300 1950 8400 1950
Wire Wire Line
	8400 2050 8300 2050
Text GLabel 7200 2350 0    50   Input ~ 0
~OUT~
Wire Wire Line
	7200 2350 7300 2350
$Comp
L Device:LED D1
U 1 1 5F384C0D
P 1950 4950
F 0 "D1" H 1850 5000 50  0000 C CNN
F 1 "0" H 1942 4786 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1950 4950 50  0001 C CNN
F 3 "~" H 1950 4950 50  0001 C CNN
	1    1950 4950
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D2
U 1 1 5F384FBD
P 1950 5150
F 0 "D2" H 1850 5200 50  0000 C CNN
F 1 "1" H 1942 4986 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1950 5150 50  0001 C CNN
F 3 "~" H 1950 5150 50  0001 C CNN
	1    1950 5150
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D3
U 1 1 5F384FFF
P 1950 5350
F 0 "D3" H 1850 5400 50  0000 C CNN
F 1 "2" H 1942 5186 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1950 5350 50  0001 C CNN
F 3 "~" H 1950 5350 50  0001 C CNN
	1    1950 5350
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D4
U 1 1 5F385053
P 1950 5550
F 0 "D4" H 1850 5600 50  0000 C CNN
F 1 "Result" H 1942 5386 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1950 5550 50  0001 C CNN
F 3 "~" H 1950 5550 50  0001 C CNN
	1    1950 5550
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D5
U 1 1 5F38509D
P 1950 5750
F 0 "D5" H 1850 5800 50  0000 C CNN
F 1 "4" H 1942 5586 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1950 5750 50  0001 C CNN
F 3 "~" H 1950 5750 50  0001 C CNN
	1    1950 5750
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D6
U 1 1 5F385103
P 1950 5950
F 0 "D6" H 1850 6000 50  0000 C CNN
F 1 "5" H 1942 5786 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1950 5950 50  0001 C CNN
F 3 "~" H 1950 5950 50  0001 C CNN
	1    1950 5950
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D7
U 1 1 5F38514F
P 1950 6150
F 0 "D7" H 1850 6200 50  0000 C CNN
F 1 "6" H 1942 5986 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1950 6150 50  0001 C CNN
F 3 "~" H 1950 6150 50  0001 C CNN
	1    1950 6150
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D8
U 1 1 5F3852D3
P 1950 6350
F 0 "D8" H 1850 6400 50  0000 C CNN
F 1 "N" H 1900 6500 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 1950 6350 50  0001 C CNN
F 3 "~" H 1950 6350 50  0001 C CNN
	1    1950 6350
	-1   0    0    1   
$EndComp
$Comp
L Device:R R1
U 1 1 5F3857AD
P 1550 4950
F 0 "R1" V 1343 4950 50  0001 C CNN
F 1 "330" V 1550 4950 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1480 4950 50  0001 C CNN
F 3 "~" H 1550 4950 50  0001 C CNN
	1    1550 4950
	0    1    1    0   
$EndComp
$Comp
L Device:R R2
U 1 1 5F385967
P 1550 5150
F 0 "R2" V 1343 5150 50  0001 C CNN
F 1 "330" V 1550 5150 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1480 5150 50  0001 C CNN
F 3 "~" H 1550 5150 50  0001 C CNN
	1    1550 5150
	0    1    1    0   
$EndComp
$Comp
L Device:R R3
U 1 1 5F3859AC
P 1550 5350
F 0 "R3" V 1343 5350 50  0001 C CNN
F 1 "330" V 1550 5350 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1480 5350 50  0001 C CNN
F 3 "~" H 1550 5350 50  0001 C CNN
	1    1550 5350
	0    1    1    0   
$EndComp
$Comp
L Device:R R4
U 1 1 5F3859F1
P 1550 5550
F 0 "R4" V 1343 5550 50  0001 C CNN
F 1 "330" V 1550 5550 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1480 5550 50  0001 C CNN
F 3 "~" H 1550 5550 50  0001 C CNN
	1    1550 5550
	0    1    1    0   
$EndComp
$Comp
L Device:R R5
U 1 1 5F385A36
P 1550 5750
F 0 "R5" V 1343 5750 50  0001 C CNN
F 1 "330" V 1550 5750 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1480 5750 50  0001 C CNN
F 3 "~" H 1550 5750 50  0001 C CNN
	1    1550 5750
	0    1    1    0   
$EndComp
$Comp
L Device:R R6
U 1 1 5F385B0C
P 1550 5950
F 0 "R6" V 1343 5950 50  0001 C CNN
F 1 "330" V 1550 5950 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1480 5950 50  0001 C CNN
F 3 "~" H 1550 5950 50  0001 C CNN
	1    1550 5950
	0    1    1    0   
$EndComp
$Comp
L Device:R R7
U 1 1 5F385B51
P 1550 6150
F 0 "R7" V 1343 6150 50  0001 C CNN
F 1 "330" V 1550 6150 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1480 6150 50  0001 C CNN
F 3 "~" H 1550 6150 50  0001 C CNN
	1    1550 6150
	0    1    1    0   
$EndComp
$Comp
L Device:R R8
U 1 1 5F385B96
P 1550 6350
F 0 "R8" V 1343 6350 50  0001 C CNN
F 1 "330" V 1550 6350 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1480 6350 50  0001 C CNN
F 3 "~" H 1550 6350 50  0001 C CNN
	1    1550 6350
	0    1    1    0   
$EndComp
Text GLabel 1300 4950 0    50   Input ~ 0
RES0
Text GLabel 1300 5150 0    50   Input ~ 0
RES1
Text GLabel 1300 5350 0    50   Input ~ 0
RES2
Text GLabel 1300 5550 0    50   Input ~ 0
RES3
Text GLabel 1300 5750 0    50   Input ~ 0
RES4
Text GLabel 1300 5950 0    50   Input ~ 0
RES5
Text GLabel 1300 6150 0    50   Input ~ 0
RES6
Text GLabel 1300 6350 0    50   Input ~ 0
RES7
$Comp
L power:GND #PWR01
U 1 1 5F450848
P 2150 6450
F 0 "#PWR01" H 2150 6200 50  0001 C CNN
F 1 "GND" H 2300 6400 50  0000 C CNN
F 2 "" H 2150 6450 50  0001 C CNN
F 3 "" H 2150 6450 50  0001 C CNN
	1    2150 6450
	1    0    0    -1  
$EndComp
Text GLabel 3100 4850 0    50   Input ~ 0
~OUT~
$Comp
L Device:LED D9
U 1 1 5F516E35
P 3350 4850
F 0 "D9" H 3500 4900 50  0000 C CNN
F 1 "OUT" H 3342 4686 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 3350 4850 50  0001 C CNN
F 3 "~" H 3350 4850 50  0001 C CNN
	1    3350 4850
	1    0    0    1   
$EndComp
$Comp
L Device:R R9
U 1 1 5F516E8D
P 3750 4850
F 0 "R9" V 3543 4850 50  0001 C CNN
F 1 "330" V 3750 4850 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 3680 4850 50  0001 C CNN
F 3 "~" H 3750 4850 50  0001 C CNN
	1    3750 4850
	0    1    1    0   
$EndComp
Wire Wire Line
	3500 4850 3600 4850
$Comp
L power:VCC #PWR02
U 1 1 5F52DFF2
P 3950 4750
F 0 "#PWR02" H 3950 4600 50  0001 C CNN
F 1 "VCC" H 4050 4850 50  0000 C CNN
F 2 "" H 3950 4750 50  0001 C CNN
F 3 "" H 3950 4750 50  0001 C CNN
	1    3950 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 4850 3950 4850
Wire Wire Line
	3950 4850 3950 4750
Text GLabel 3100 5650 0    50   Input ~ 0
SH_SWP
$Comp
L Device:LED D10
U 1 1 5F54765E
P 3350 5650
F 0 "D10" H 3200 5700 50  0000 C CNN
F 1 "SWAP" H 3342 5486 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 3350 5650 50  0001 C CNN
F 3 "~" H 3350 5650 50  0001 C CNN
	1    3350 5650
	-1   0    0    1   
$EndComp
$Comp
L Device:R R10
U 1 1 5F5476B6
P 3750 5650
F 0 "R10" V 3543 5650 50  0001 C CNN
F 1 "330" V 3750 5650 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 3680 5650 50  0001 C CNN
F 3 "~" H 3750 5650 50  0001 C CNN
	1    3750 5650
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_01x08_Male J3
U 1 1 5F5AD288
P 9450 1650
F 0 "J3" H 9423 1577 50  0000 R CNN
F 1 "BUS" H 9530 1551 50  0001 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 9450 1650 50  0001 C CNN
F 3 "~" H 9450 1650 50  0001 C CNN
	1    9450 1650
	-1   0    0    -1  
$EndComp
Text GLabel 9150 1350 0    50   Input ~ 0
BUS7
Text GLabel 9150 1450 0    50   Input ~ 0
BUS6
Text GLabel 9150 1550 0    50   Input ~ 0
BUS5
Text GLabel 9150 1650 0    50   Input ~ 0
BUS4
Text GLabel 9150 1750 0    50   Input ~ 0
BUS3
Text GLabel 9150 1850 0    50   Input ~ 0
BUS2
Text GLabel 9150 1950 0    50   Input ~ 0
BUS1
Text GLabel 9150 2050 0    50   Input ~ 0
BUS0
Wire Wire Line
	9150 1350 9250 1350
Wire Wire Line
	9150 1450 9250 1450
Wire Wire Line
	9150 1550 9250 1550
Wire Wire Line
	9150 1650 9250 1650
Wire Wire Line
	9150 1750 9250 1750
Wire Wire Line
	9150 1850 9250 1850
Wire Wire Line
	9150 1950 9250 1950
Wire Wire Line
	9150 2050 9250 2050
$Comp
L Connector:Conn_01x08_Male J4
U 1 1 5F62EA78
P 10150 1650
F 0 "J4" H 10123 1577 50  0000 R CNN
F 1 "Input A" H 10230 1551 50  0001 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 10150 1650 50  0001 C CNN
F 3 "~" H 10150 1650 50  0001 C CNN
	1    10150 1650
	-1   0    0    -1  
$EndComp
Text GLabel 9850 1350 0    50   Output ~ 0
A7
Text GLabel 9850 1450 0    50   Output ~ 0
A6
Text GLabel 9850 1550 0    50   Output ~ 0
A5
Text GLabel 9850 1650 0    50   Output ~ 0
A4
Wire Wire Line
	9950 1350 9850 1350
Wire Wire Line
	9950 1450 9850 1450
Wire Wire Line
	9950 1550 9850 1550
Wire Wire Line
	9950 1650 9850 1650
Text GLabel 9850 1750 0    50   Output ~ 0
A3
Text GLabel 9850 1850 0    50   Output ~ 0
A2
Text GLabel 9850 1950 0    50   Output ~ 0
A1
Text GLabel 9850 2050 0    50   Output ~ 0
A0
Wire Wire Line
	9850 1750 9950 1750
Wire Wire Line
	9850 1850 9950 1850
Wire Wire Line
	9850 1950 9950 1950
Wire Wire Line
	9850 2050 9950 2050
$Comp
L Connector:Conn_01x02_Male J6
U 1 1 5F6AB90B
P 10900 1650
F 0 "J6" H 10873 1577 50  0000 R CNN
F 1 "Input B" H 10980 1551 50  0001 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 10900 1650 50  0001 C CNN
F 3 "~" H 10900 1650 50  0001 C CNN
	1    10900 1650
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J2
U 1 1 5F731807
P 8200 3700
F 0 "J2" H 8173 3627 50  0000 R CNN
F 1 "Control" H 8280 3601 50  0001 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 8200 3700 50  0001 C CNN
F 3 "~" H 8200 3700 50  0001 C CNN
	1    8200 3700
	-1   0    0    -1  
$EndComp
Text GLabel 7650 3550 0    50   Output ~ 0
~OUT~
Wire Wire Line
	7950 3550 7950 3600
Wire Wire Line
	7950 3600 8000 3600
$Comp
L Connector:Conn_01x04_Male J5
U 1 1 5F79C5A0
P 10150 2350
F 0 "J5" H 10123 2277 50  0000 R CNN
F 1 "Flags" H 10230 2251 50  0001 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 10150 2350 50  0001 C CNN
F 3 "~" H 10150 2350 50  0001 C CNN
	1    10150 2350
	-1   0    0    -1  
$EndComp
NoConn ~ 8000 3900
$Comp
L power:GND #PWR07
U 1 1 5F885C28
P 4750 5650
F 0 "#PWR07" H 4750 5400 50  0001 C CNN
F 1 "GND" H 4900 5600 50  0000 C CNN
F 2 "" H 4750 5650 50  0001 C CNN
F 3 "" H 4750 5650 50  0001 C CNN
	1    4750 5650
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR06
U 1 1 5F885C81
P 4750 5350
F 0 "#PWR06" H 4750 5200 50  0001 C CNN
F 1 "VCC" H 4850 5450 50  0000 C CNN
F 2 "" H 4750 5350 50  0001 C CNN
F 3 "" H 4750 5350 50  0001 C CNN
	1    4750 5350
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG01
U 1 1 5F885D50
P 4600 5350
F 0 "#FLG01" H 4600 5425 50  0001 C CNN
F 1 "PWR_FLAG" H 4600 5524 50  0001 C CNN
F 2 "" H 4600 5350 50  0001 C CNN
F 3 "~" H 4600 5350 50  0001 C CNN
	1    4600 5350
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG02
U 1 1 5F885DB0
P 4600 5650
F 0 "#FLG02" H 4600 5725 50  0001 C CNN
F 1 "PWR_FLAG" H 4600 5823 50  0001 C CNN
F 2 "" H 4600 5650 50  0001 C CNN
F 3 "~" H 4600 5650 50  0001 C CNN
	1    4600 5650
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74LS125 U5
U 4 1 5F962C3F
P 2900 5950
F 0 "U5" H 2850 5950 50  0000 C CNN
F 1 "74HC125" H 3050 6100 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2900 5950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 2900 5950 50  0001 C CNN
	4    2900 5950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS125 U5
U 5 1 5FAE1E20
P 6800 5400
F 0 "U5" H 6750 5400 50  0000 C CNN
F 1 "74HC125" H 6800 5626 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 6800 5400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 6800 5400 50  0001 C CNN
	5    6800 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR011
U 1 1 5FAF467C
P 6800 6000
F 0 "#PWR011" H 6800 5750 50  0001 C CNN
F 1 "GND" H 6950 5950 50  0000 C CNN
F 2 "" H 6800 6000 50  0001 C CNN
F 3 "" H 6800 6000 50  0001 C CNN
	1    6800 6000
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR010
U 1 1 5FAF48A3
P 6800 4800
F 0 "#PWR010" H 6800 4650 50  0001 C CNN
F 1 "VCC" H 6900 4900 50  0000 C CNN
F 2 "" H 6800 4800 50  0001 C CNN
F 3 "" H 6800 4800 50  0001 C CNN
	1    6800 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	6800 4800 6800 4900
Wire Wire Line
	6800 6000 6800 5900
NoConn ~ 8000 3800
$Comp
L Device:R R12
U 1 1 5F36ADD1
P 7750 3400
F 0 "R12" V 7543 3400 50  0001 C CNN
F 1 "10K" V 7750 3400 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 7680 3400 50  0001 C CNN
F 3 "~" H 7750 3400 50  0001 C CNN
	1    7750 3400
	-1   0    0    1   
$EndComp
$Comp
L Device:R R13
U 1 1 5F36AE38
P 7750 3850
F 0 "R13" V 7543 3850 50  0001 C CNN
F 1 "10K" V 7750 3850 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 7680 3850 50  0001 C CNN
F 3 "~" H 7750 3850 50  0001 C CNN
	1    7750 3850
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR013
U 1 1 5F36BE69
P 7750 4000
F 0 "#PWR013" H 7750 3750 50  0001 C CNN
F 1 "GND" H 7900 3950 50  0000 C CNN
F 2 "" H 7750 4000 50  0001 C CNN
F 3 "" H 7750 4000 50  0001 C CNN
	1    7750 4000
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR012
U 1 1 5F36BED0
P 7750 3250
F 0 "#PWR012" H 7750 3100 50  0001 C CNN
F 1 "VCC" H 7850 3350 50  0000 C CNN
F 2 "" H 7750 3250 50  0001 C CNN
F 3 "" H 7750 3250 50  0001 C CNN
	1    7750 3250
	1    0    0    -1  
$EndComp
Wire Notes Line
	6700 600  6700 4300
Wire Wire Line
	7650 3550 7750 3550
Connection ~ 7750 3550
Wire Wire Line
	7750 3550 7950 3550
Wire Wire Line
	7650 3700 7750 3700
Wire Wire Line
	7750 3700 8000 3700
Connection ~ 7750 3700
Text Notes 8350 750  0    50   ~ 0
Output
Wire Notes Line
	8750 600  8750 4300
Text Notes 8300 3200 0    50   ~ 0
Control\nsignals
Wire Notes Line
	600  600  11150 600 
Text Notes 10400 750  0    50   ~ 0
Data connections
Wire Notes Line
	600  7000 4400 7000
Wire Notes Line
	600  600  600  7000
Text Notes 3600 4550 0    50   ~ 0
Data and status\n    indicators
Wire Notes Line
	600  4300 11150 4300
Wire Notes Line
	11150 600  11150 4300
Text Notes 10500 3150 0    50   ~ 0
Unused gates
$Comp
L Device:C C1
U 1 1 5F1E2F39
P 4750 5500
F 0 "C1" H 4865 5546 50  0000 L CNN
F 1 "10μF" H 4865 5455 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 4788 5350 50  0001 C CNN
F 3 "~" H 4750 5500 50  0001 C CNN
	1    4750 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4600 5350 4750 5350
Connection ~ 4750 5350
Wire Wire Line
	4600 5650 4750 5650
Connection ~ 4750 5650
$Comp
L Connector:Conn_01x04_Male J1
U 1 1 5F86597C
P 5350 5550
F 0 "J1" H 5323 5476 50  0000 R CNN
F 1 "Power" H 5430 5451 50  0001 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x02_P2.54mm_Vertical" H 5350 5550 50  0001 C CNN
F 3 "~" H 5350 5550 50  0001 C CNN
	1    5350 5550
	-1   0    0    1   
$EndComp
Wire Wire Line
	5150 5450 5150 5350
Wire Wire Line
	5150 5350 4750 5350
Wire Wire Line
	5150 5550 5150 5650
Wire Wire Line
	5150 5650 4750 5650
$Comp
L Device:C C2
U 1 1 5F2703B2
P 7250 5400
F 0 "C2" H 7250 5500 50  0000 L CNN
F 1 "100nF" H 7250 5300 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7288 5250 50  0001 C CNN
F 3 "~" H 7250 5400 50  0001 C CNN
	1    7250 5400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 5F2705F6
P 7500 5400
F 0 "C3" H 7500 5500 50  0000 L CNN
F 1 "100nF" H 7500 5300 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7538 5250 50  0001 C CNN
F 3 "~" H 7500 5400 50  0001 C CNN
	1    7500 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	6800 4900 7250 4900
Wire Wire Line
	7250 4900 7250 5250
Connection ~ 6800 4900
Connection ~ 7250 4900
Wire Wire Line
	6800 5900 7250 5900
Wire Wire Line
	7250 5900 7250 5550
Connection ~ 6800 5900
Wire Wire Line
	7250 5900 7500 5900
Connection ~ 7250 5900
Text Notes 9350 4500 0    50   ~ 0
Power
Connection ~ 5150 5350
Connection ~ 5150 5650
Text GLabel 9850 2550 0    50   Output ~ 0
ZIN
Wire Wire Line
	9950 2550 9850 2550
$Comp
L Device:LED D11
U 1 1 5F2A17AF
P 3400 5950
F 0 "D11" H 3300 6050 50  0000 C CNN
F 1 "Z" H 3392 5786 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 3400 5950 50  0001 C CNN
F 3 "~" H 3400 5950 50  0001 C CNN
	1    3400 5950
	-1   0    0    1   
$EndComp
$Comp
L Device:R R11
U 1 1 5F2A1859
P 3750 5950
F 0 "R11" V 3543 5950 50  0001 C CNN
F 1 "330" V 3750 5950 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 3680 5950 50  0001 C CNN
F 3 "~" H 3750 5950 50  0001 C CNN
	1    3750 5950
	0    1    1    0   
$EndComp
Text GLabel 2650 6250 0    50   Input ~ 0
~OUT~
Text GLabel 2600 5950 0    50   Input ~ 0
ZIN
Wire Wire Line
	2900 6250 2900 6200
$Comp
L power:GND #PWR03
U 1 1 5F2DC5C9
P 3950 6000
F 0 "#PWR03" H 3950 5750 50  0001 C CNN
F 1 "GND" H 4100 5950 50  0000 C CNN
F 2 "" H 3950 6000 50  0001 C CNN
F 3 "" H 3950 6000 50  0001 C CNN
	1    3950 6000
	1    0    0    -1  
$EndComp
Wire Wire Line
	3100 4850 3200 4850
Wire Wire Line
	2650 6250 2900 6250
Wire Wire Line
	2150 4950 2150 5150
Wire Wire Line
	1300 4950 1400 4950
Wire Wire Line
	1300 5150 1400 5150
Wire Wire Line
	1300 5350 1400 5350
Wire Wire Line
	1300 5550 1400 5550
Wire Wire Line
	1300 5750 1400 5750
Wire Wire Line
	1300 5950 1400 5950
Wire Wire Line
	1300 6150 1400 6150
Wire Wire Line
	1300 6350 1400 6350
Wire Wire Line
	1700 4950 1800 4950
Wire Wire Line
	1700 5150 1800 5150
Wire Wire Line
	1700 5350 1800 5350
Wire Wire Line
	1700 5550 1800 5550
Wire Wire Line
	1700 5750 1800 5750
Wire Wire Line
	1700 5950 1800 5950
Wire Wire Line
	1700 6150 1800 6150
Wire Wire Line
	1700 6350 1800 6350
Wire Wire Line
	2100 4950 2150 4950
Wire Wire Line
	2100 5150 2150 5150
Connection ~ 2150 5150
Wire Wire Line
	2150 5150 2150 5350
Wire Wire Line
	2100 5350 2150 5350
Connection ~ 2150 5350
Wire Wire Line
	2150 5350 2150 5550
Wire Wire Line
	2100 5550 2150 5550
Connection ~ 2150 5550
Wire Wire Line
	2150 5550 2150 5750
Wire Wire Line
	2100 5750 2150 5750
Connection ~ 2150 5750
Wire Wire Line
	2150 5750 2150 5950
Wire Wire Line
	2100 5950 2150 5950
Connection ~ 2150 5950
Wire Wire Line
	2150 5950 2150 6150
Wire Wire Line
	2100 6150 2150 6150
Connection ~ 2150 6150
Wire Wire Line
	2150 6150 2150 6350
Wire Wire Line
	2100 6350 2150 6350
Connection ~ 2150 6350
Wire Wire Line
	2150 6350 2150 6450
Wire Wire Line
	3100 5650 3200 5650
Wire Wire Line
	3500 5650 3600 5650
Wire Wire Line
	3900 5650 3950 5650
Wire Wire Line
	3950 5650 3950 5950
Wire Wire Line
	3900 5950 3950 5950
Connection ~ 3950 5950
Wire Wire Line
	3950 5950 3950 6000
Wire Wire Line
	3550 5950 3600 5950
Wire Wire Line
	3200 5950 3250 5950
$Comp
L Device:C C6
U 1 1 605E047D
P 7750 5400
F 0 "C6" H 7750 5500 50  0000 L CNN
F 1 "100nF" H 7750 5300 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7788 5250 50  0001 C CNN
F 3 "~" H 7750 5400 50  0001 C CNN
	1    7750 5400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 605E38ED
P 8000 5400
F 0 "C8" H 8000 5500 50  0000 L CNN
F 1 "100nF" H 8000 5300 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8038 5250 50  0001 C CNN
F 3 "~" H 8000 5400 50  0001 C CNN
	1    8000 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 5250 7500 4900
Connection ~ 7500 4900
Wire Wire Line
	7500 4900 7250 4900
Wire Wire Line
	7500 5550 7500 5900
Connection ~ 7500 5900
Wire Wire Line
	7750 5250 7750 4900
Wire Wire Line
	7750 5550 7750 5900
Wire Wire Line
	8000 4900 8000 5250
Wire Wire Line
	8000 5900 8000 5550
Wire Notes Line
	10300 6450 10300 4300
Wire Notes Line
	4400 6450 10300 6450
Wire Wire Line
	3250 1350 3300 1350
Wire Wire Line
	3300 1450 3250 1450
Wire Wire Line
	3250 1650 3300 1650
Wire Wire Line
	3300 1750 3250 1750
Wire Wire Line
	3250 1950 3300 1950
Wire Wire Line
	3300 2050 3250 2050
Wire Wire Line
	3250 2250 3300 2250
Wire Wire Line
	3300 2350 3250 2350
Text GLabel 2650 1350 2    50   Output ~ 0
RES0
Text GLabel 2650 1650 2    50   Output ~ 0
RES1
Text GLabel 2650 1950 2    50   Output ~ 0
RES2
Text GLabel 2650 2250 2    50   Output ~ 0
RES3
Text GLabel 4350 1350 2    50   Output ~ 0
RES4
Text GLabel 4350 1650 2    50   Output ~ 0
RES5
Text GLabel 4350 1950 2    50   Output ~ 0
RES6
Text GLabel 4350 2250 2    50   Output ~ 0
RES7
Wire Wire Line
	4350 1350 4300 1350
Wire Wire Line
	4300 1650 4350 1650
Wire Wire Line
	4350 1950 4300 1950
Wire Wire Line
	4300 2250 4350 2250
Wire Wire Line
	1550 1350 1600 1350
Wire Wire Line
	1550 1450 1600 1450
Wire Wire Line
	1550 1650 1600 1650
Wire Wire Line
	1550 1750 1600 1750
Wire Wire Line
	1550 1950 1600 1950
Wire Wire Line
	1600 2050 1550 2050
Wire Wire Line
	1600 2250 1550 2250
Wire Wire Line
	1600 2350 1550 2350
Wire Wire Line
	2650 1350 2600 1350
Wire Wire Line
	2600 1650 2650 1650
Wire Wire Line
	2600 1950 2650 1950
Wire Wire Line
	2600 2250 2650 2250
$Comp
L power:VCC #PWR04
U 1 1 60FAC4E3
P 3800 1050
F 0 "#PWR04" H 3800 900 50  0001 C CNN
F 1 "VCC" H 3900 1150 50  0000 C CNN
F 2 "" H 3800 1050 50  0001 C CNN
F 3 "" H 3800 1050 50  0001 C CNN
	1    3800 1050
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR08
U 1 1 60FAC7E7
P 2100 1050
F 0 "#PWR08" H 2100 900 50  0001 C CNN
F 1 "VCC" H 2200 1150 50  0000 C CNN
F 2 "" H 2100 1050 50  0001 C CNN
F 3 "" H 2100 1050 50  0001 C CNN
	1    2100 1050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR05
U 1 1 60FACAA8
P 3800 2950
F 0 "#PWR05" H 3800 2700 50  0001 C CNN
F 1 "GND" H 3950 2900 50  0000 C CNN
F 2 "" H 3800 2950 50  0001 C CNN
F 3 "" H 3800 2950 50  0001 C CNN
	1    3800 2950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 60FACC82
P 2100 2950
F 0 "#PWR09" H 2100 2700 50  0001 C CNN
F 1 "GND" H 2250 2900 50  0000 C CNN
F 2 "" H 2100 2950 50  0001 C CNN
F 3 "" H 2100 2950 50  0001 C CNN
	1    2100 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	3300 2650 3300 2950
Wire Wire Line
	3300 2950 3800 2950
Connection ~ 3800 2950
Wire Wire Line
	2100 2950 1600 2950
Wire Wire Line
	1600 2950 1600 2650
Connection ~ 2100 2950
Text GLabel 1550 2550 0    50   Input ~ 0
SH_SWP
Text GLabel 3250 2550 0    50   Input ~ 0
SH_SWP
Wire Wire Line
	3250 2550 3300 2550
Wire Wire Line
	1550 2550 1600 2550
Text GLabel 7650 3700 0    50   Output ~ 0
SH_SWP
$Comp
L 74xx:74LS157 U6
U 1 1 60C509D9
P 3800 1950
F 0 "U6" H 3600 2700 50  0000 C CNN
F 1 "74HC157" H 4000 2700 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3800 1950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 3800 1950 50  0001 C CNN
	1    3800 1950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS157 U7
U 1 1 60C52581
P 2100 1950
F 0 "U7" H 1900 2700 50  0000 C CNN
F 1 "74HC157" H 2300 2700 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 2100 1950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2100 1950 50  0001 C CNN
	1    2100 1950
	1    0    0    -1  
$EndComp
NoConn ~ 9950 2350
$Comp
L 74xx:74LS125 U5
U 1 1 60C265D9
P 2900 5200
F 0 "U5" H 2850 5200 50  0000 C CNN
F 1 "74HC125" H 3050 5350 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2900 5200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 2900 5200 50  0001 C CNN
	1    2900 5200
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS125 U5
U 2 1 60C2929F
P 5550 1350
F 0 "U5" H 5500 1350 50  0000 C CNN
F 1 "74HC125" H 5700 1500 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 5550 1350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 5550 1350 50  0001 C CNN
	2    5550 1350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS125 U5
U 3 1 60C2A1C3
P 9950 3100
F 0 "U5" H 9900 3100 50  0000 C CNN
F 1 "74HC125" H 10100 3250 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 9950 3100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 9950 3100 50  0001 C CNN
	3    9950 3100
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0101
U 1 1 60C2B707
P 10300 3350
F 0 "#PWR0101" H 10300 3200 50  0001 C CNN
F 1 "VCC" H 10400 3450 50  0000 C CNN
F 2 "" H 10300 3350 50  0001 C CNN
F 3 "" H 10300 3350 50  0001 C CNN
	1    10300 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	9950 3350 10300 3350
Connection ~ 9950 3350
NoConn ~ 10250 3100
Wire Wire Line
	9650 3100 9650 3350
Wire Wire Line
	9650 3350 9950 3350
Text GLabel 5200 1350 0    50   Input ~ 0
A0
Text GLabel 1550 1350 0    50   Input ~ 0
A1
Text GLabel 1550 1650 0    50   Input ~ 0
A2
Text GLabel 1550 1950 0    50   Input ~ 0
A3
Text GLabel 1550 2250 0    50   Input ~ 0
A4
Text GLabel 3250 1350 0    50   Input ~ 0
A5
Text GLabel 3250 1650 0    50   Input ~ 0
A6
Text GLabel 3250 1950 0    50   Input ~ 0
A7
Text GLabel 3250 1450 0    50   Input ~ 0
A0
Text GLabel 3250 1750 0    50   Input ~ 0
A1
Text GLabel 3250 2050 0    50   Input ~ 0
A2
Text GLabel 3250 2350 0    50   Input ~ 0
A3
Text GLabel 1550 1450 0    50   Input ~ 0
A4
Text GLabel 1550 1750 0    50   Input ~ 0
A5
Text GLabel 1550 2050 0    50   Input ~ 0
A6
Text GLabel 1550 2350 0    50   Input ~ 0
A7
Text GLabel 9850 2250 0    50   Output ~ 0
CIN
Text GLabel 9850 2450 0    50   Input ~ 0
COUT
Wire Wire Line
	9850 2450 9950 2450
Wire Wire Line
	9950 2250 9850 2250
Text GLabel 5900 1350 2    50   Output ~ 0
COUT
Wire Wire Line
	5200 1350 5250 1350
Wire Wire Line
	5850 1350 5900 1350
Text GLabel 5450 1700 0    50   Input ~ 0
~OUT~
Wire Wire Line
	5450 1700 5550 1700
Wire Wire Line
	5550 1700 5550 1600
Text GLabel 3250 2250 0    50   Input ~ 0
CIN
$Comp
L Device:LED D12
U 1 1 617276DD
P 3350 5200
F 0 "D12" H 3200 5250 50  0000 C CNN
F 1 "C" H 3342 5036 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 3350 5200 50  0001 C CNN
F 3 "~" H 3350 5200 50  0001 C CNN
	1    3350 5200
	-1   0    0    1   
$EndComp
$Comp
L Device:R R14
U 1 1 617276E3
P 3750 5200
F 0 "R14" V 3543 5200 50  0001 C CNN
F 1 "330" V 3750 5200 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 3680 5200 50  0001 C CNN
F 3 "~" H 3750 5200 50  0001 C CNN
	1    3750 5200
	0    1    1    0   
$EndComp
Wire Wire Line
	3500 5200 3600 5200
Wire Wire Line
	3900 5200 3950 5200
Wire Wire Line
	3950 5200 3950 5450
Connection ~ 3950 5650
Text GLabel 2600 5200 0    50   Input ~ 0
A0
Wire Wire Line
	2900 5450 3950 5450
Connection ~ 3950 5450
Wire Wire Line
	3950 5450 3950 5650
NoConn ~ 10700 1650
NoConn ~ 10700 1750
Wire Wire Line
	7500 4900 7750 4900
Wire Wire Line
	7500 5900 7750 5900
Connection ~ 7750 4900
Connection ~ 7750 5900
Wire Wire Line
	7750 4900 8000 4900
Wire Wire Line
	7750 5900 8000 5900
$EndSCHEMATC
