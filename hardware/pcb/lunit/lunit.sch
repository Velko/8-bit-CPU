EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Logic Unit (AND/OR)"
Date "2020-07-23"
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 1480 4950 50  0001 C CNN
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 1480 5150 50  0001 C CNN
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 1480 5350 50  0001 C CNN
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 1480 5550 50  0001 C CNN
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 1480 5750 50  0001 C CNN
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 1480 5950 50  0001 C CNN
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 1480 6150 50  0001 C CNN
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 1480 6350 50  0001 C CNN
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
Text GLabel 3100 5050 0    50   Input ~ 0
~OUT~
$Comp
L Device:LED D9
U 1 1 5F516E35
P 3350 5050
F 0 "D9" H 3500 5100 50  0000 C CNN
F 1 "OUT" H 3342 4886 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 3350 5050 50  0001 C CNN
F 3 "~" H 3350 5050 50  0001 C CNN
	1    3350 5050
	1    0    0    1   
$EndComp
$Comp
L Device:R R9
U 1 1 5F516E8D
P 3750 5050
F 0 "R9" V 3543 5050 50  0001 C CNN
F 1 "330" V 3750 5050 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 3680 5050 50  0001 C CNN
F 3 "~" H 3750 5050 50  0001 C CNN
	1    3750 5050
	0    1    1    0   
$EndComp
Wire Wire Line
	3500 5050 3600 5050
$Comp
L power:VCC #PWR02
U 1 1 5F52DFF2
P 3950 4950
F 0 "#PWR02" H 3950 4800 50  0001 C CNN
F 1 "VCC" H 4050 5050 50  0000 C CNN
F 2 "" H 3950 4950 50  0001 C CNN
F 3 "" H 3950 4950 50  0001 C CNN
	1    3950 4950
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 5050 3950 5050
Wire Wire Line
	3950 5050 3950 4950
Text GLabel 3100 5650 0    50   Input ~ 0
AND_OR
$Comp
L Device:LED D10
U 1 1 5F54765E
P 3350 5650
F 0 "D10" H 3200 5700 50  0000 C CNN
F 1 "OR" H 3342 5486 50  0001 C CNN
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 3680 5650 50  0001 C CNN
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
L Connector:Conn_01x08_Male J6
U 1 1 5F6AB90B
P 10900 1650
F 0 "J6" H 10873 1577 50  0000 R CNN
F 1 "Input B" H 10980 1551 50  0001 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 10900 1650 50  0001 C CNN
F 3 "~" H 10900 1650 50  0001 C CNN
	1    10900 1650
	-1   0    0    -1  
$EndComp
Text GLabel 10550 2050 0    50   Output ~ 0
B0
Text GLabel 10550 1950 0    50   Output ~ 0
B1
Text GLabel 10550 1850 0    50   Output ~ 0
B2
Text GLabel 10550 1750 0    50   Output ~ 0
B3
Text GLabel 10550 1650 0    50   Output ~ 0
B4
Text GLabel 10550 1550 0    50   Output ~ 0
B5
Text GLabel 10550 1450 0    50   Output ~ 0
B6
Text GLabel 10550 1350 0    50   Output ~ 0
B7
Wire Wire Line
	10550 1350 10700 1350
Wire Wire Line
	10550 1450 10700 1450
Wire Wire Line
	10700 1550 10550 1550
Wire Wire Line
	10550 1650 10700 1650
Wire Wire Line
	10700 1750 10550 1750
Wire Wire Line
	10550 1850 10700 1850
Wire Wire Line
	10700 1950 10550 1950
Wire Wire Line
	10550 2050 10700 2050
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
U 3 1 5F962C3F
P 2900 5950
F 0 "U5" H 2850 5950 50  0000 C CNN
F 1 "74HC125" H 3050 6100 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2900 5950 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 2900 5950 50  0001 C CNN
	3    2900 5950
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS125 U5
U 5 1 5FAE1E20
P 7800 5500
F 0 "U5" H 7750 5500 50  0000 C CNN
F 1 "74HC125" H 7800 5726 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 7800 5500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 7800 5500 50  0001 C CNN
	5    7800 5500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR011
U 1 1 5FAF467C
P 6000 6100
F 0 "#PWR011" H 6000 5850 50  0001 C CNN
F 1 "GND" H 6150 6050 50  0000 C CNN
F 2 "" H 6000 6100 50  0001 C CNN
F 3 "" H 6000 6100 50  0001 C CNN
	1    6000 6100
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR010
U 1 1 5FAF48A3
P 6000 4900
F 0 "#PWR010" H 6000 4750 50  0001 C CNN
F 1 "VCC" H 6100 5000 50  0000 C CNN
F 2 "" H 6000 4900 50  0001 C CNN
F 3 "" H 6000 4900 50  0001 C CNN
	1    6000 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 4900 6000 5000
Wire Wire Line
	6000 6100 6000 6000
NoConn ~ 8000 3800
$Comp
L Device:R R12
U 1 1 5F36ADD1
P 7750 3400
F 0 "R12" V 7543 3400 50  0001 C CNN
F 1 "10K" V 7750 3400 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 7680 3400 50  0001 C CNN
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 7680 3850 50  0001 C CNN
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
P 8250 5500
F 0 "C2" H 8250 5600 50  0000 L CNN
F 1 "100nF" H 8250 5400 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8288 5350 50  0001 C CNN
F 3 "~" H 8250 5500 50  0001 C CNN
	1    8250 5500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 5F2705F6
P 8500 5500
F 0 "C3" H 8500 5600 50  0000 L CNN
F 1 "100nF" H 8500 5400 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8538 5350 50  0001 C CNN
F 3 "~" H 8500 5500 50  0001 C CNN
	1    8500 5500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 5F270678
P 8750 5500
F 0 "C4" H 8750 5600 50  0000 L CNN
F 1 "100nF" H 8750 5400 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8788 5350 50  0001 C CNN
F 3 "~" H 8750 5500 50  0001 C CNN
	1    8750 5500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 5F270A50
P 9000 5500
F 0 "C5" H 9000 5600 50  0000 L CNN
F 1 "100nF" H 9000 5400 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9038 5350 50  0001 C CNN
F 3 "~" H 9000 5500 50  0001 C CNN
	1    9000 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7800 5000 8250 5000
Wire Wire Line
	8250 5000 8250 5350
Connection ~ 7800 5000
Wire Wire Line
	8750 5350 8750 5000
Wire Wire Line
	8750 5000 8500 5000
Connection ~ 8250 5000
Connection ~ 8750 5000
Wire Wire Line
	7800 6000 8250 6000
Wire Wire Line
	8250 6000 8250 5650
Connection ~ 7800 6000
Wire Wire Line
	8250 6000 8500 6000
Wire Wire Line
	8750 6000 8750 5650
Connection ~ 8250 6000
Wire Wire Line
	8750 6000 9000 6000
Connection ~ 8750 6000
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
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 3680 5950 50  0001 C CNN
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
	3100 5050 3200 5050
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
P 9250 5500
F 0 "C6" H 9250 5600 50  0000 L CNN
F 1 "100nF" H 9250 5400 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9288 5350 50  0001 C CNN
F 3 "~" H 9250 5500 50  0001 C CNN
	1    9250 5500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C7
U 1 1 605E17EA
P 9500 5500
F 0 "C7" H 9500 5600 50  0000 L CNN
F 1 "100nF" H 9500 5400 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9538 5350 50  0001 C CNN
F 3 "~" H 9500 5500 50  0001 C CNN
	1    9500 5500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 605E38ED
P 9750 5500
F 0 "C8" H 9750 5600 50  0000 L CNN
F 1 "100nF" H 9750 5400 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9788 5350 50  0001 C CNN
F 3 "~" H 9750 5500 50  0001 C CNN
	1    9750 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	8500 5350 8500 5000
Connection ~ 8500 5000
Wire Wire Line
	8500 5000 8250 5000
Wire Wire Line
	8500 5650 8500 6000
Connection ~ 8500 6000
Wire Wire Line
	8500 6000 8750 6000
Wire Wire Line
	9000 5350 9000 5000
Connection ~ 9000 5000
Wire Wire Line
	9000 5000 8750 5000
Wire Wire Line
	9000 5650 9000 6000
Connection ~ 9000 6000
Wire Wire Line
	9250 5350 9250 5000
Connection ~ 9250 5000
Wire Wire Line
	9250 5650 9250 6000
Connection ~ 9250 6000
Wire Wire Line
	9250 6000 9500 6000
Wire Wire Line
	9500 5650 9500 6000
Wire Wire Line
	9500 5350 9500 5000
Wire Wire Line
	9500 5000 9250 5000
Wire Wire Line
	9000 5000 9250 5000
Wire Wire Line
	9000 6000 9250 6000
$Comp
L Device:C C9
U 1 1 606B6FD9
P 10000 5500
F 0 "C9" H 10000 5600 50  0000 L CNN
F 1 "100nF" H 10000 5400 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 10038 5350 50  0001 C CNN
F 3 "~" H 10000 5500 50  0001 C CNN
	1    10000 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	9500 5000 9750 5000
Wire Wire Line
	9750 5000 9750 5350
Connection ~ 9500 5000
Wire Wire Line
	9750 5000 10000 5000
Wire Wire Line
	10000 5000 10000 5350
Connection ~ 9750 5000
Wire Wire Line
	9500 6000 9750 6000
Wire Wire Line
	9750 6000 9750 5650
Connection ~ 9500 6000
Wire Wire Line
	9750 6000 10000 6000
Wire Wire Line
	10000 6000 10000 5650
Connection ~ 9750 6000
Wire Notes Line
	10300 6450 10300 4300
Wire Notes Line
	4400 6450 10300 6450
Text GLabel 1000 1950 0    50   Input ~ 0
A7
Text GLabel 1000 1600 0    50   Input ~ 0
A6
Text GLabel 1000 1250 0    50   Input ~ 0
A5
Text GLabel 1000 900  0    50   Input ~ 0
A4
Text GLabel 1000 3650 0    50   Input ~ 0
A3
Text GLabel 1000 2600 0    50   Input ~ 0
A2
Text GLabel 1000 3300 0    50   Input ~ 0
A1
Text GLabel 1000 2950 0    50   Input ~ 0
A0
Text GLabel 2400 1950 0    50   Input ~ 0
A7
Text GLabel 2400 1600 0    50   Input ~ 0
A6
Text GLabel 2400 1250 0    50   Input ~ 0
A5
Text GLabel 2400 900  0    50   Input ~ 0
A4
Text GLabel 2400 3650 0    50   Input ~ 0
A3
Text GLabel 2400 2600 0    50   Input ~ 0
A2
Text GLabel 2400 3300 0    50   Input ~ 0
A1
Text GLabel 2400 2950 0    50   Input ~ 0
A0
Wire Wire Line
	1000 2600 1100 2600
Wire Wire Line
	1000 2950 1100 2950
Wire Wire Line
	1000 3300 1100 3300
Wire Wire Line
	1000 3650 1100 3650
Wire Wire Line
	2400 3650 2500 3650
Wire Wire Line
	2500 3300 2400 3300
Wire Wire Line
	2500 2950 2400 2950
Wire Wire Line
	2500 2600 2400 2600
Wire Wire Line
	2400 1950 2500 1950
Wire Wire Line
	1000 1950 1100 1950
Wire Wire Line
	1000 1600 1100 1600
Wire Wire Line
	2400 1600 2500 1600
Wire Wire Line
	1000 1250 1100 1250
Wire Wire Line
	2400 1250 2500 1250
Wire Wire Line
	2500 900  2400 900 
Wire Wire Line
	1000 900  1100 900 
Text GLabel 1000 3150 0    50   Input ~ 0
B0
Text GLabel 1000 3500 0    50   Input ~ 0
B1
Text GLabel 1000 2800 0    50   Input ~ 0
B2
Text GLabel 1000 3850 0    50   Input ~ 0
B3
Text GLabel 1000 1100 0    50   Input ~ 0
B4
Text GLabel 1000 1450 0    50   Input ~ 0
B5
Text GLabel 1000 1800 0    50   Input ~ 0
B6
Text GLabel 1000 2150 0    50   Input ~ 0
B7
Wire Wire Line
	1000 1100 1100 1100
Wire Wire Line
	1000 1450 1100 1450
Wire Wire Line
	1000 1800 1100 1800
Wire Wire Line
	1000 2150 1100 2150
Wire Wire Line
	1000 2800 1100 2800
Wire Wire Line
	1100 3150 1000 3150
Wire Wire Line
	1000 3500 1100 3500
Wire Wire Line
	1000 3850 1100 3850
Text GLabel 2400 3150 0    50   Input ~ 0
B0
Text GLabel 2400 3500 0    50   Input ~ 0
B1
Text GLabel 2400 2800 0    50   Input ~ 0
B2
Text GLabel 2400 3850 0    50   Input ~ 0
B3
Wire Wire Line
	2400 2800 2500 2800
Wire Wire Line
	2400 3150 2500 3150
Wire Wire Line
	2400 3500 2500 3500
Wire Wire Line
	2400 3850 2500 3850
Text GLabel 2400 1100 0    50   Input ~ 0
B4
Text GLabel 2400 1450 0    50   Input ~ 0
B5
Text GLabel 2400 1800 0    50   Input ~ 0
B6
Text GLabel 2400 2150 0    50   Input ~ 0
B7
Wire Wire Line
	2400 1100 2500 1100
Wire Wire Line
	2400 1450 2500 1450
Wire Wire Line
	2400 1800 2500 1800
Wire Wire Line
	2400 2150 2500 2150
Text GLabel 1750 2050 2    50   Output ~ 0
AND7
Text GLabel 1750 1700 2    50   Output ~ 0
AND6
Text GLabel 1750 1350 2    50   Output ~ 0
AND5
Text GLabel 1750 1000 2    50   Output ~ 0
AND4
Text GLabel 1750 3750 2    50   Output ~ 0
AND3
Text GLabel 1750 2700 2    50   Output ~ 0
AND2
Text GLabel 1750 3400 2    50   Output ~ 0
AND1
Text GLabel 1750 3050 2    50   Output ~ 0
AND0
Text GLabel 3150 2050 2    50   Output ~ 0
OR7
Text GLabel 3150 1700 2    50   Output ~ 0
OR6
Text GLabel 3150 1350 2    50   Output ~ 0
OR5
Text GLabel 3150 1000 2    50   Output ~ 0
OR4
Text GLabel 3150 3750 2    50   Output ~ 0
OR3
Text GLabel 3150 2700 2    50   Output ~ 0
OR2
Text GLabel 3150 3400 2    50   Output ~ 0
OR1
Text GLabel 3150 3050 2    50   Output ~ 0
OR0
Wire Wire Line
	1700 1000 1750 1000
Wire Wire Line
	3100 1000 3150 1000
Wire Wire Line
	3150 1350 3100 1350
Wire Wire Line
	1700 1350 1750 1350
Wire Wire Line
	1750 1700 1700 1700
Wire Wire Line
	1700 2050 1750 2050
Wire Wire Line
	3100 1700 3150 1700
Wire Wire Line
	3150 2050 3100 2050
Wire Wire Line
	1700 2700 1750 2700
Wire Wire Line
	1700 3050 1750 3050
Wire Wire Line
	1750 3400 1700 3400
Wire Wire Line
	1700 3750 1750 3750
Wire Wire Line
	3100 3750 3150 3750
Wire Wire Line
	3150 3400 3100 3400
Wire Wire Line
	3100 3050 3150 3050
Wire Wire Line
	3100 2700 3150 2700
Text GLabel 3950 2000 0    50   Input ~ 0
AND7
Text GLabel 3950 2100 0    50   Input ~ 0
OR7
Text GLabel 3950 1700 0    50   Input ~ 0
AND6
Text GLabel 3950 1800 0    50   Input ~ 0
OR6
Text GLabel 3950 1400 0    50   Input ~ 0
AND5
Text GLabel 3950 1500 0    50   Input ~ 0
OR5
Text GLabel 3950 1100 0    50   Input ~ 0
AND4
Text GLabel 3950 1200 0    50   Input ~ 0
OR4
Wire Wire Line
	3950 1100 4000 1100
Wire Wire Line
	4000 1200 3950 1200
Wire Wire Line
	3950 1400 4000 1400
Wire Wire Line
	4000 1500 3950 1500
Wire Wire Line
	3950 1700 4000 1700
Wire Wire Line
	4000 1800 3950 1800
Wire Wire Line
	3950 2000 4000 2000
Wire Wire Line
	4000 2100 3950 2100
Text GLabel 6250 2850 2    50   Output ~ 0
RES0
Text GLabel 6250 3150 2    50   Output ~ 0
RES1
Text GLabel 6250 2550 2    50   Output ~ 0
RES2
Text GLabel 6250 3450 2    50   Output ~ 0
RES3
Text GLabel 5050 1100 2    50   Output ~ 0
RES4
Text GLabel 5050 1400 2    50   Output ~ 0
RES5
Text GLabel 5050 1700 2    50   Output ~ 0
RES6
Text GLabel 5050 2000 2    50   Output ~ 0
RES7
Wire Wire Line
	5050 1100 5000 1100
Wire Wire Line
	5000 1400 5050 1400
Wire Wire Line
	5050 1700 5000 1700
Wire Wire Line
	5000 2000 5050 2000
Text GLabel 5150 3450 0    50   Input ~ 0
AND3
Text GLabel 5150 2550 0    50   Input ~ 0
AND2
Text GLabel 5150 3150 0    50   Input ~ 0
AND1
Text GLabel 5150 2850 0    50   Input ~ 0
AND0
Text GLabel 5150 3550 0    50   Input ~ 0
OR3
Text GLabel 5150 2650 0    50   Input ~ 0
OR2
Text GLabel 5150 3250 0    50   Input ~ 0
OR1
Text GLabel 5150 2950 0    50   Input ~ 0
OR0
Wire Wire Line
	5150 2550 5200 2550
Wire Wire Line
	5150 2650 5200 2650
Wire Wire Line
	5150 2850 5200 2850
Wire Wire Line
	5150 2950 5200 2950
Wire Wire Line
	5150 3150 5200 3150
Wire Wire Line
	5200 3250 5150 3250
Wire Wire Line
	5200 3450 5150 3450
Wire Wire Line
	5200 3550 5150 3550
Wire Wire Line
	6250 2550 6200 2550
Wire Wire Line
	6200 2850 6250 2850
Wire Wire Line
	6200 3150 6250 3150
Wire Wire Line
	6200 3450 6250 3450
$Comp
L power:VCC #PWR04
U 1 1 60FAC4E3
P 4500 800
F 0 "#PWR04" H 4500 650 50  0001 C CNN
F 1 "VCC" H 4600 900 50  0000 C CNN
F 2 "" H 4500 800 50  0001 C CNN
F 3 "" H 4500 800 50  0001 C CNN
	1    4500 800 
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR08
U 1 1 60FAC7E7
P 5700 2250
F 0 "#PWR08" H 5700 2100 50  0001 C CNN
F 1 "VCC" H 5800 2350 50  0000 C CNN
F 2 "" H 5700 2250 50  0001 C CNN
F 3 "" H 5700 2250 50  0001 C CNN
	1    5700 2250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR05
U 1 1 60FACAA8
P 4500 2700
F 0 "#PWR05" H 4500 2450 50  0001 C CNN
F 1 "GND" H 4650 2650 50  0000 C CNN
F 2 "" H 4500 2700 50  0001 C CNN
F 3 "" H 4500 2700 50  0001 C CNN
	1    4500 2700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 60FACC82
P 5700 4150
F 0 "#PWR09" H 5700 3900 50  0001 C CNN
F 1 "GND" H 5850 4100 50  0000 C CNN
F 2 "" H 5700 4150 50  0001 C CNN
F 3 "" H 5700 4150 50  0001 C CNN
	1    5700 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 2400 4000 2700
Wire Wire Line
	4000 2700 4500 2700
Connection ~ 4500 2700
Wire Wire Line
	5700 4150 5200 4150
Wire Wire Line
	5200 4150 5200 3850
Connection ~ 5700 4150
Text GLabel 5150 3750 0    50   Input ~ 0
AND_OR
Text GLabel 3950 2300 0    50   Input ~ 0
AND_OR
Wire Wire Line
	3950 2300 4000 2300
Wire Wire Line
	5150 3750 5200 3750
Text GLabel 7650 3700 0    50   Output ~ 0
AND_OR
$Comp
L 74xx:74LS08 U1
U 5 1 6100624E
P 6000 5500
F 0 "U1" H 6000 5500 50  0000 C CNN
F 1 "74HC08" H 6000 5734 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 6000 5500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 6000 5500 50  0001 C CNN
	5    6000 5500
	1    0    0    -1  
$EndComp
Connection ~ 6000 5000
Connection ~ 6000 6000
$Comp
L 74xx:74LS08 U1
U 3 1 60A5AD92
P 1400 1000
F 0 "U1" H 1400 1000 50  0000 C CNN
F 1 "74HC08" H 1400 1234 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 1400 1000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1400 1000 50  0001 C CNN
	3    1400 1000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U1
U 4 1 60A5D4C5
P 1400 1350
F 0 "U1" H 1400 1350 50  0000 C CNN
F 1 "74HC08" H 1400 1584 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 1400 1350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1400 1350 50  0001 C CNN
	4    1400 1350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U1
U 1 1 60A69F5B
P 1400 1700
F 0 "U1" H 1400 1700 50  0000 C CNN
F 1 "74HC08" H 1400 1934 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 1400 1700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1400 1700 50  0001 C CNN
	1    1400 1700
	1    0    0    1   
$EndComp
$Comp
L 74xx:74LS08 U1
U 2 1 60A6AE83
P 1400 2050
F 0 "U1" H 1400 2050 50  0000 C CNN
F 1 "74HC08" H 1400 2284 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 1400 2050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1400 2050 50  0001 C CNN
	2    1400 2050
	1    0    0    1   
$EndComp
$Comp
L 74xx:74LS08 U2
U 1 1 60A6BCBF
P 1400 2700
F 0 "U2" H 1400 2700 50  0000 C CNN
F 1 "74HC08" H 1400 2500 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 1400 2700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1400 2700 50  0001 C CNN
	1    1400 2700
	1    0    0    1   
$EndComp
$Comp
L 74xx:74LS08 U2
U 2 1 60A6C8A6
P 1400 3050
F 0 "U2" H 1400 3050 50  0000 C CNN
F 1 "74HC08" H 1400 3284 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 1400 3050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1400 3050 50  0001 C CNN
	2    1400 3050
	1    0    0    1   
$EndComp
$Comp
L 74xx:74LS08 U2
U 3 1 60A6DF2D
P 1400 3400
F 0 "U2" H 1400 3400 50  0000 C CNN
F 1 "74HC08" H 1400 3634 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 1400 3400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1400 3400 50  0001 C CNN
	3    1400 3400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U2
U 4 1 60A6EA62
P 1400 3750
F 0 "U2" H 1400 3750 50  0000 C CNN
F 1 "74HC08" H 1400 3984 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 1400 3750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1400 3750 50  0001 C CNN
	4    1400 3750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U3
U 3 1 60A8A99F
P 2800 1000
F 0 "U3" H 2800 1000 50  0000 C CNN
F 1 "74HC32" H 2800 1234 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2800 1000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 1000 50  0001 C CNN
	3    2800 1000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U3
U 4 1 60A8FFC8
P 2800 1350
F 0 "U3" H 2800 1350 50  0000 C CNN
F 1 "74HC32" H 2800 1584 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2800 1350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 1350 50  0001 C CNN
	4    2800 1350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U3
U 1 1 60A918B1
P 2800 1700
F 0 "U3" H 2800 1700 50  0000 C CNN
F 1 "74HC32" H 2800 1934 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2800 1700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 1700 50  0001 C CNN
	1    2800 1700
	1    0    0    1   
$EndComp
$Comp
L 74xx:74LS32 U3
U 2 1 60A924E1
P 2800 2050
F 0 "U3" H 2800 2050 50  0000 C CNN
F 1 "74HC32" H 2800 2284 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2800 2050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 2050 50  0001 C CNN
	2    2800 2050
	1    0    0    1   
$EndComp
$Comp
L 74xx:74LS32 U4
U 1 1 60A9A9B6
P 2800 2700
F 0 "U4" H 2800 2700 50  0000 C CNN
F 1 "74HC32" H 2800 2934 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2800 2700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 2700 50  0001 C CNN
	1    2800 2700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U4
U 2 1 60A9A9BC
P 2800 3050
F 0 "U4" H 2800 3050 50  0000 C CNN
F 1 "74HC32" H 2800 3284 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2800 3050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 3050 50  0001 C CNN
	2    2800 3050
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U4
U 3 1 60A9A9C2
P 2800 3400
F 0 "U4" H 2800 3400 50  0000 C CNN
F 1 "74HC32" H 2800 3634 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2800 3400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 3400 50  0001 C CNN
	3    2800 3400
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS32 U4
U 4 1 60A9A9C8
P 2800 3750
F 0 "U4" H 2800 3750 50  0000 C CNN
F 1 "74HC32" H 2800 3984 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2800 3750 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 2800 3750 50  0001 C CNN
	4    2800 3750
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS157 U6
U 1 1 60C509D9
P 4500 1700
F 0 "U6" H 4300 2450 50  0000 C CNN
F 1 "74HC157" H 4700 2450 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 4500 1700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 4500 1700 50  0001 C CNN
	1    4500 1700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS157 U7
U 1 1 60C52581
P 5700 3150
F 0 "U7" H 5500 3900 50  0000 C CNN
F 1 "74HC157" H 5900 3900 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 5700 3150 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 5700 3150 50  0001 C CNN
	1    5700 3150
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS08 U2
U 5 1 6100709E
P 6450 5500
F 0 "U2" H 6450 5500 50  0000 C CNN
F 1 "74HC08" H 6450 5734 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 6450 5500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 6450 5500 50  0001 C CNN
	5    6450 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6000 5000 6450 5000
Connection ~ 6450 5000
Wire Wire Line
	6000 6000 6450 6000
Connection ~ 6450 6000
$Comp
L 74xx:74LS32 U4
U 5 1 61004FF9
P 7350 5500
F 0 "U4" H 7350 5500 50  0000 C CNN
F 1 "74HC32" H 7350 5734 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 7350 5500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 7350 5500 50  0001 C CNN
	5    7350 5500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 5000 7800 5000
Connection ~ 7350 5000
Wire Wire Line
	7350 6000 7800 6000
Connection ~ 7350 6000
$Comp
L 74xx:74LS32 U3
U 5 1 610034B6
P 6900 5500
F 0 "U3" H 6900 5500 50  0000 C CNN
F 1 "74HC32" H 6900 5734 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 6900 5500 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 6900 5500 50  0001 C CNN
	5    6900 5500
	1    0    0    -1  
$EndComp
Connection ~ 6900 5000
Connection ~ 6900 6000
Wire Wire Line
	6450 5000 6900 5000
Wire Wire Line
	6900 5000 7350 5000
Wire Wire Line
	6900 6000 7350 6000
Wire Wire Line
	6450 6000 6900 6000
NoConn ~ 9950 2250
NoConn ~ 9950 2350
NoConn ~ 9950 2450
$Comp
L 74xx:74LS125 U5
U 1 1 60C265D9
P 9300 3100
F 0 "U5" H 9250 3100 50  0000 C CNN
F 1 "74HC125" H 9450 3250 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 9300 3100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 9300 3100 50  0001 C CNN
	1    9300 3100
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS125 U5
U 2 1 60C2929F
P 9300 3600
F 0 "U5" H 9250 3600 50  0000 C CNN
F 1 "74HC125" H 9450 3750 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 9300 3600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 9300 3600 50  0001 C CNN
	2    9300 3600
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS125 U5
U 4 1 60C2A1C3
P 9950 3100
F 0 "U5" H 9900 3100 50  0000 C CNN
F 1 "74HC125" H 10100 3250 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 9950 3100 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS126" H 9950 3100 50  0001 C CNN
	4    9950 3100
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
	9300 3350 9650 3350
Wire Wire Line
	9950 3350 10300 3350
Connection ~ 9950 3350
Wire Wire Line
	9300 3850 9950 3850
Wire Wire Line
	9950 3850 9950 3350
NoConn ~ 10250 3100
NoConn ~ 9600 3100
NoConn ~ 9600 3600
Wire Wire Line
	9650 3100 9650 3350
Connection ~ 9650 3350
Wire Wire Line
	9650 3350 9950 3350
Wire Wire Line
	9000 3100 9000 3350
Wire Wire Line
	9000 3350 9300 3350
Connection ~ 9300 3350
Wire Wire Line
	9000 3350 9000 3600
Connection ~ 9000 3350
$EndSCHEMATC
