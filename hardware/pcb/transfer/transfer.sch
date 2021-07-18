EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Transfer Register"
Date ""
Rev "1.0"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:Conn_01x16_Male J5
U 1 1 60EC6FE6
P 10650 2500
F 0 "J5" H 10622 2474 50  0000 R CNN
F 1 "Address Bus" H 10622 2383 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x16_P2.54mm_Vertical" H 10650 2500 50  0001 C CNN
F 3 "~" H 10650 2500 50  0001 C CNN
	1    10650 2500
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x08_Male J6
U 1 1 60EC9535
P 10650 1100
F 0 "J6" H 10622 1074 50  0000 R CNN
F 1 "Main Bus" H 10622 983 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 10650 1100 50  0001 C CNN
F 3 "~" H 10650 1100 50  0001 C CNN
	1    10650 1100
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J2
U 1 1 60ECBE3B
P 9050 3100
F 0 "J2" H 9022 3074 50  0000 R CNN
F 1 "Control" H 9022 2983 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 9050 3100 50  0001 C CNN
F 3 "~" H 9050 3100 50  0001 C CNN
	1    9050 3100
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J3
U 1 1 60ECD9CE
P 9050 3600
F 0 "J3" H 9022 3574 50  0000 R CNN
F 1 "Sync" H 9022 3483 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 9050 3600 50  0001 C CNN
F 3 "~" H 9050 3600 50  0001 C CNN
	1    9050 3600
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J4
U 1 1 60ECF182
P 8500 4950
F 0 "J4" H 8472 4832 50  0000 R CNN
F 1 "+ Power -" H 8472 4923 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x02_P2.54mm_Vertical" H 8500 4950 50  0001 C CNN
F 3 "~" H 8500 4950 50  0001 C CNN
	1    8500 4950
	-1   0    0    1   
$EndComp
$Comp
L 74xx:74LS173 U1
U 1 1 60ED59C3
P 1450 1600
F 0 "U1" H 1200 2350 50  0000 C CNN
F 1 "74HC173" H 1650 2350 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 1450 1600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS173" H 1450 1600 50  0001 C CNN
	1    1450 1600
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS173 U4
U 1 1 60ED8953
P 3200 1600
F 0 "U4" H 2950 2350 50  0000 C CNN
F 1 "74HC173" H 3400 2350 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3200 1600 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS173" H 3200 1600 50  0001 C CNN
	1    3200 1600
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS157 U2
U 1 1 60EDA502
P 1450 3700
F 0 "U2" H 1200 4450 50  0000 C CNN
F 1 "74HC157" H 1650 4450 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 1450 3700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS157" H 1450 3700 50  0001 C CNN
	1    1450 3700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS157 U5
U 1 1 60EDB6D8
P 3200 3700
F 0 "U5" H 2950 4450 50  0000 C CNN
F 1 "74HC157" H 3400 4450 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3200 3700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS157" H 3200 3700 50  0001 C CNN
	1    3200 3700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS245 U3
U 1 1 60EDF332
P 1450 5850
F 0 "U3" H 1200 6500 50  0000 C CNN
F 1 "74HC245" H 1650 6500 50  0000 C CNN
F 2 "Package_SO:SO-20_12.8x7.5mm_P1.27mm" H 1450 5850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 1450 5850 50  0001 C CNN
	1    1450 5850
	1    0    0    -1  
$EndComp
Text GLabel 10050 3300 0    50   BiDi ~ 0
ABUS0
Text GLabel 10400 3200 0    50   BiDi ~ 0
ABUS1
Text GLabel 10400 3100 0    50   BiDi ~ 0
ABUS2
Text GLabel 10400 3000 0    50   BiDi ~ 0
ABUS3
Text GLabel 10400 2900 0    50   BiDi ~ 0
ABUS4
Text GLabel 10400 2800 0    50   BiDi ~ 0
ABUS5
Text GLabel 10400 2700 0    50   BiDi ~ 0
ABUS6
Text GLabel 10400 2600 0    50   BiDi ~ 0
ABUS7
Wire Wire Line
	10400 1800 10450 1800
Wire Wire Line
	10450 1900 10400 1900
Wire Wire Line
	10400 2000 10450 2000
Wire Wire Line
	10450 2100 10400 2100
Wire Wire Line
	10400 2200 10450 2200
Wire Wire Line
	10450 2300 10400 2300
Wire Wire Line
	10400 2400 10450 2400
Wire Wire Line
	10450 2500 10400 2500
Wire Wire Line
	10400 2600 10450 2600
Wire Wire Line
	10450 2700 10400 2700
Wire Wire Line
	10400 2800 10450 2800
Wire Wire Line
	10450 2900 10400 2900
Wire Wire Line
	10400 3000 10450 3000
Wire Wire Line
	10450 3100 10400 3100
Wire Wire Line
	10400 3200 10450 3200
Wire Wire Line
	10450 3300 10400 3300
Text GLabel 10400 1500 0    50   BiDi ~ 0
MBUS0
Text GLabel 10400 1400 0    50   BiDi ~ 0
MBUS1
Text GLabel 10400 1300 0    50   BiDi ~ 0
MBUS2
Text GLabel 10400 1200 0    50   BiDi ~ 0
MBUS3
Text GLabel 10400 1100 0    50   BiDi ~ 0
MBUS4
Text GLabel 10400 1000 0    50   BiDi ~ 0
MBUS5
Text GLabel 10400 900  0    50   BiDi ~ 0
MBUS6
Text GLabel 10400 800  0    50   BiDi ~ 0
MBUS7
Wire Wire Line
	10400 800  10450 800 
Wire Wire Line
	10450 900  10400 900 
Wire Wire Line
	10400 1000 10450 1000
Wire Wire Line
	10450 1100 10400 1100
Wire Wire Line
	10400 1200 10450 1200
Wire Wire Line
	10450 1300 10400 1300
Wire Wire Line
	10400 1400 10450 1400
Wire Wire Line
	10450 1500 10400 1500
Text GLabel 900  3100 0    50   Input ~ 0
ABUS0
Text GLabel 900  3400 0    50   Input ~ 0
ABUS1
Text GLabel 900  4000 0    50   Input ~ 0
ABUS2
Text GLabel 900  3700 0    50   Input ~ 0
ABUS3
Text GLabel 2650 3100 0    50   Input ~ 0
ABUS4
Text GLabel 2650 3400 0    50   Input ~ 0
ABUS5
Text GLabel 2650 3700 0    50   Input ~ 0
ABUS6
Text GLabel 2650 4000 0    50   Input ~ 0
ABUS7
Text GLabel 2000 3100 2    50   Output ~ 0
LD0
Text GLabel 2000 3400 2    50   Output ~ 0
LD1
Text GLabel 2000 4000 2    50   Output ~ 0
LD2
Text GLabel 2000 3700 2    50   Output ~ 0
LD3
Text GLabel 3750 3100 2    50   Output ~ 0
LD4
Text GLabel 3750 3400 2    50   Output ~ 0
LD5
Text GLabel 3750 3700 2    50   Output ~ 0
LD6
Text GLabel 3750 4000 2    50   Output ~ 0
LD7
Text GLabel 900  3200 0    50   Input ~ 0
MBUS0
Text GLabel 900  3500 0    50   Input ~ 0
MBUS1
Text GLabel 900  4100 0    50   Input ~ 0
MBUS2
Text GLabel 900  3800 0    50   Input ~ 0
MBUS3
Text GLabel 2650 3200 0    50   Input ~ 0
MBUS4
Text GLabel 2650 3500 0    50   Input ~ 0
MBUS5
Text GLabel 2650 3800 0    50   Input ~ 0
MBUS6
Text GLabel 2650 4100 0    50   Input ~ 0
MBUS7
Text GLabel 900  1300 0    50   Input ~ 0
LD0
Text GLabel 900  1100 0    50   Input ~ 0
LD1
Text GLabel 900  1200 0    50   Input ~ 0
LD2
Text GLabel 900  1000 0    50   Input ~ 0
LD3
Text GLabel 2650 1200 0    50   Input ~ 0
LD4
Text GLabel 2650 1100 0    50   Input ~ 0
LD5
Text GLabel 2650 1000 0    50   Input ~ 0
LD6
Text GLabel 2650 1300 0    50   Input ~ 0
LD7
Text GLabel 2000 1300 2    50   Output ~ 0
OUT0
Text GLabel 2000 1100 2    50   Output ~ 0
OUT1
Text GLabel 2000 1200 2    50   Output ~ 0
OUT2
Text GLabel 2000 1000 2    50   Output ~ 0
OUT3
Text GLabel 3750 1200 2    50   Output ~ 0
OUT4
Text GLabel 3750 1100 2    50   Output ~ 0
OUT5
Text GLabel 3750 1000 2    50   Output ~ 0
OUT6
Text GLabel 3750 1300 2    50   Output ~ 0
OUT7
Text GLabel 900  5350 0    50   Input ~ 0
OUT0
Text GLabel 900  5450 0    50   Input ~ 0
OUT1
Text GLabel 900  5550 0    50   Input ~ 0
OUT2
Text GLabel 900  5650 0    50   Input ~ 0
OUT3
Text GLabel 900  5750 0    50   Input ~ 0
OUT4
Text GLabel 900  5850 0    50   Input ~ 0
OUT5
Text GLabel 900  5950 0    50   Input ~ 0
OUT6
Text GLabel 900  6050 0    50   Input ~ 0
OUT7
Text GLabel 2000 5350 2    50   Output ~ 0
ABUS0
Text GLabel 2000 5450 2    50   Output ~ 0
ABUS1
Text GLabel 2000 5550 2    50   Output ~ 0
ABUS2
Text GLabel 2000 5650 2    50   Output ~ 0
ABUS3
Text GLabel 2000 5750 2    50   Output ~ 0
ABUS4
Text GLabel 2000 5850 2    50   Output ~ 0
ABUS5
Text GLabel 2000 5950 2    50   Output ~ 0
ABUS6
Text GLabel 2000 6050 2    50   Output ~ 0
ABUS7
Wire Wire Line
	900  1000 950  1000
Wire Wire Line
	900  1100 950  1100
Wire Wire Line
	900  1200 950  1200
Wire Wire Line
	900  1300 950  1300
Wire Wire Line
	1950 1000 2000 1000
Wire Wire Line
	1950 1100 2000 1100
Wire Wire Line
	2000 1200 1950 1200
Wire Wire Line
	1950 1300 2000 1300
Wire Wire Line
	2650 1000 2700 1000
Wire Wire Line
	2700 1100 2650 1100
Wire Wire Line
	2650 1200 2700 1200
Wire Wire Line
	2700 1300 2650 1300
Wire Wire Line
	3700 1000 3750 1000
Wire Wire Line
	3750 1100 3700 1100
Wire Wire Line
	3700 1200 3750 1200
Wire Wire Line
	3750 1300 3700 1300
Wire Wire Line
	900  3100 950  3100
Wire Wire Line
	950  3200 900  3200
Wire Wire Line
	1950 3100 2000 3100
Wire Wire Line
	2000 3400 1950 3400
Wire Wire Line
	900  3400 950  3400
Wire Wire Line
	950  3500 900  3500
Wire Wire Line
	900  3700 950  3700
Wire Wire Line
	950  3800 900  3800
Wire Wire Line
	1950 3700 2000 3700
Wire Wire Line
	2000 4000 1950 4000
Wire Wire Line
	900  4000 950  4000
Wire Wire Line
	950  4100 900  4100
Wire Wire Line
	2650 3100 2700 3100
Wire Wire Line
	2700 3200 2650 3200
Wire Wire Line
	2650 3400 2700 3400
Wire Wire Line
	2700 3500 2650 3500
Wire Wire Line
	2650 3700 2700 3700
Wire Wire Line
	2700 3800 2650 3800
Wire Wire Line
	2650 4000 2700 4000
Wire Wire Line
	2700 4100 2650 4100
Wire Wire Line
	3700 3100 3750 3100
Wire Wire Line
	3750 3400 3700 3400
Wire Wire Line
	3700 3700 3750 3700
Wire Wire Line
	3750 4000 3700 4000
Wire Wire Line
	900  5350 950  5350
Wire Wire Line
	950  5450 900  5450
Wire Wire Line
	900  5550 950  5550
Wire Wire Line
	950  5650 900  5650
Wire Wire Line
	900  5750 950  5750
Wire Wire Line
	950  5850 900  5850
Wire Wire Line
	900  5950 950  5950
Wire Wire Line
	950  6050 900  6050
Wire Wire Line
	1950 5350 2000 5350
Wire Wire Line
	2000 5450 1950 5450
Wire Wire Line
	1950 5550 2000 5550
Wire Wire Line
	2000 5650 1950 5650
Wire Wire Line
	1950 5750 2000 5750
Wire Wire Line
	2000 5850 1950 5850
Wire Wire Line
	1950 5950 2000 5950
Wire Wire Line
	2000 6050 1950 6050
Wire Wire Line
	3750 6050 3700 6050
Wire Wire Line
	3700 5950 3750 5950
Wire Wire Line
	3750 5850 3700 5850
Wire Wire Line
	3700 5750 3750 5750
Wire Wire Line
	3750 5650 3700 5650
Wire Wire Line
	3700 5550 3750 5550
Wire Wire Line
	3750 5450 3700 5450
Wire Wire Line
	3700 5350 3750 5350
Wire Wire Line
	2700 6050 2650 6050
Wire Wire Line
	2650 5950 2700 5950
Wire Wire Line
	2700 5850 2650 5850
Wire Wire Line
	2650 5750 2700 5750
Wire Wire Line
	2700 5650 2650 5650
Wire Wire Line
	2650 5550 2700 5550
Wire Wire Line
	2700 5450 2650 5450
Wire Wire Line
	2650 5350 2700 5350
Text GLabel 2650 5750 0    50   Input ~ 0
OUT4
Text GLabel 2650 5650 0    50   Input ~ 0
OUT3
Text GLabel 2650 5550 0    50   Input ~ 0
OUT2
Text GLabel 2650 5450 0    50   Input ~ 0
OUT1
Text GLabel 2650 5350 0    50   Input ~ 0
OUT0
$Comp
L 74xx:74LS245 U9
U 1 1 60EE2A19
P 3200 5850
F 0 "U9" H 2950 6500 50  0000 C CNN
F 1 "74HC245" H 3400 6500 50  0000 C CNN
F 2 "Package_SO:SO-20_12.8x7.5mm_P1.27mm" H 3200 5850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS245" H 3200 5850 50  0001 C CNN
	1    3200 5850
	-1   0    0    -1  
$EndComp
Text GLabel 10400 2500 0    50   BiDi ~ 0
ABUS0
Text GLabel 10400 2400 0    50   BiDi ~ 0
ABUS1
Text GLabel 10400 2300 0    50   BiDi ~ 0
ABUS2
Text GLabel 10400 2200 0    50   BiDi ~ 0
ABUS3
Text GLabel 10400 2100 0    50   BiDi ~ 0
ABUS4
Text GLabel 10400 2000 0    50   BiDi ~ 0
ABUS5
Text GLabel 10400 1900 0    50   BiDi ~ 0
ABUS6
Text GLabel 10400 1800 0    50   BiDi ~ 0
ABUS7
Text GLabel 3750 5350 2    50   Output ~ 0
MBUS0
Text GLabel 3750 5450 2    50   Output ~ 0
MBUS1
Text GLabel 3750 5550 2    50   Output ~ 0
MBUS2
Text GLabel 3750 5650 2    50   Output ~ 0
MBUS3
Text GLabel 3750 5750 2    50   Output ~ 0
MBUS4
Text GLabel 2650 5850 0    50   Input ~ 0
OUT5
Text GLabel 2650 5950 0    50   Input ~ 0
OUT6
Text GLabel 2650 6050 0    50   Input ~ 0
OUT7
Text GLabel 3750 6050 2    50   Output ~ 0
MBUS7
Text GLabel 3750 5950 2    50   Output ~ 0
MBUS6
Text GLabel 3750 5850 2    50   Output ~ 0
MBUS5
$Comp
L Device:LED D1
U 1 1 60FEB162
P 5600 2150
F 0 "D1" H 5700 2100 50  0000 C CNN
F 1 "LED" H 5593 1986 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5600 2150 50  0001 C CNN
F 3 "~" H 5600 2150 50  0001 C CNN
	1    5600 2150
	-1   0    0    1   
$EndComp
$Comp
L Device:R R1
U 1 1 60FEC252
P 5950 2150
F 0 "R1" V 5850 2150 50  0000 C CNN
F 1 "330" V 5950 2150 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5880 2150 50  0001 C CNN
F 3 "~" H 5950 2150 50  0001 C CNN
	1    5950 2150
	0    1    1    0   
$EndComp
Text GLabel 5400 2950 0    50   Input ~ 0
OUT4
Text GLabel 5400 2750 0    50   Input ~ 0
OUT3
Text GLabel 5400 2550 0    50   Input ~ 0
OUT2
Text GLabel 5400 2350 0    50   Input ~ 0
OUT1
Text GLabel 5400 2150 0    50   Input ~ 0
OUT0
Text GLabel 5400 3150 0    50   Input ~ 0
OUT5
Text GLabel 5400 3350 0    50   Input ~ 0
OUT6
Text GLabel 5400 3550 0    50   Input ~ 0
OUT7
$Comp
L Device:LED D2
U 1 1 60FF916C
P 5600 2350
F 0 "D2" H 5700 2300 50  0000 C CNN
F 1 "LED" H 5593 2186 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5600 2350 50  0001 C CNN
F 3 "~" H 5600 2350 50  0001 C CNN
	1    5600 2350
	-1   0    0    1   
$EndComp
$Comp
L Device:R R2
U 1 1 60FF9172
P 5950 2350
F 0 "R2" V 5850 2350 50  0000 C CNN
F 1 "330" V 5950 2350 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5880 2350 50  0001 C CNN
F 3 "~" H 5950 2350 50  0001 C CNN
	1    5950 2350
	0    1    1    0   
$EndComp
$Comp
L Device:LED D3
U 1 1 6101EC65
P 5600 2550
F 0 "D3" H 5700 2500 50  0000 C CNN
F 1 "LED" H 5593 2386 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5600 2550 50  0001 C CNN
F 3 "~" H 5600 2550 50  0001 C CNN
	1    5600 2550
	-1   0    0    1   
$EndComp
$Comp
L Device:R R3
U 1 1 6101EC6B
P 5950 2550
F 0 "R3" V 5850 2550 50  0000 C CNN
F 1 "330" V 5950 2550 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5880 2550 50  0001 C CNN
F 3 "~" H 5950 2550 50  0001 C CNN
	1    5950 2550
	0    1    1    0   
$EndComp
$Comp
L Device:LED D4
U 1 1 610243D5
P 5600 2750
F 0 "D4" H 5700 2700 50  0000 C CNN
F 1 "LED" H 5593 2586 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5600 2750 50  0001 C CNN
F 3 "~" H 5600 2750 50  0001 C CNN
	1    5600 2750
	-1   0    0    1   
$EndComp
$Comp
L Device:R R4
U 1 1 610243DB
P 5950 2750
F 0 "R4" V 5850 2750 50  0000 C CNN
F 1 "330" V 5950 2750 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5880 2750 50  0001 C CNN
F 3 "~" H 5950 2750 50  0001 C CNN
	1    5950 2750
	0    1    1    0   
$EndComp
$Comp
L Device:LED D5
U 1 1 61029C0F
P 5600 2950
F 0 "D5" H 5700 2900 50  0000 C CNN
F 1 "LED" H 5593 2786 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5600 2950 50  0001 C CNN
F 3 "~" H 5600 2950 50  0001 C CNN
	1    5600 2950
	-1   0    0    1   
$EndComp
$Comp
L Device:R R5
U 1 1 61029C15
P 5950 2950
F 0 "R5" V 5850 2950 50  0000 C CNN
F 1 "330" V 5950 2950 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5880 2950 50  0001 C CNN
F 3 "~" H 5950 2950 50  0001 C CNN
	1    5950 2950
	0    1    1    0   
$EndComp
$Comp
L Device:LED D6
U 1 1 6102FC27
P 5600 3150
F 0 "D6" H 5700 3100 50  0000 C CNN
F 1 "LED" H 5593 2986 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5600 3150 50  0001 C CNN
F 3 "~" H 5600 3150 50  0001 C CNN
	1    5600 3150
	-1   0    0    1   
$EndComp
$Comp
L Device:R R6
U 1 1 6102FC2D
P 5950 3150
F 0 "R6" V 5850 3150 50  0000 C CNN
F 1 "330" V 5950 3150 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5880 3150 50  0001 C CNN
F 3 "~" H 5950 3150 50  0001 C CNN
	1    5950 3150
	0    1    1    0   
$EndComp
$Comp
L Device:LED D7
U 1 1 610355F7
P 5600 3350
F 0 "D7" H 5700 3300 50  0000 C CNN
F 1 "LED" H 5593 3186 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5600 3350 50  0001 C CNN
F 3 "~" H 5600 3350 50  0001 C CNN
	1    5600 3350
	-1   0    0    1   
$EndComp
$Comp
L Device:R R7
U 1 1 610355FD
P 5950 3350
F 0 "R7" V 5850 3350 50  0000 C CNN
F 1 "330" V 5950 3350 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5880 3350 50  0001 C CNN
F 3 "~" H 5950 3350 50  0001 C CNN
	1    5950 3350
	0    1    1    0   
$EndComp
$Comp
L Device:LED D8
U 1 1 6103AF53
P 5600 3550
F 0 "D8" H 5700 3500 50  0000 C CNN
F 1 "LED" H 5593 3386 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5600 3550 50  0001 C CNN
F 3 "~" H 5600 3550 50  0001 C CNN
	1    5600 3550
	-1   0    0    1   
$EndComp
$Comp
L Device:R R8
U 1 1 6103AF59
P 5950 3550
F 0 "R8" V 5850 3550 50  0000 C CNN
F 1 "330" V 5950 3550 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5880 3550 50  0001 C CNN
F 3 "~" H 5950 3550 50  0001 C CNN
	1    5950 3550
	0    1    1    0   
$EndComp
Wire Wire Line
	5400 2150 5450 2150
Wire Wire Line
	5400 2350 5450 2350
Wire Wire Line
	5400 2550 5450 2550
Wire Wire Line
	5400 2750 5450 2750
Wire Wire Line
	5450 2950 5400 2950
Wire Wire Line
	5400 3150 5450 3150
Wire Wire Line
	5450 3350 5400 3350
Wire Wire Line
	5400 3550 5450 3550
Wire Wire Line
	5750 2150 5800 2150
Wire Wire Line
	5800 2350 5750 2350
Wire Wire Line
	5750 2550 5800 2550
Wire Wire Line
	5800 2750 5750 2750
Wire Wire Line
	5750 2950 5800 2950
Wire Wire Line
	5800 3150 5750 3150
Wire Wire Line
	5750 3350 5800 3350
Wire Wire Line
	5800 3550 5750 3550
$Comp
L power:GND #PWR01
U 1 1 610A4D72
P 6150 3600
F 0 "#PWR01" H 6150 3350 50  0001 C CNN
F 1 "GND" H 6155 3427 50  0000 C CNN
F 2 "" H 6150 3600 50  0001 C CNN
F 3 "" H 6150 3600 50  0001 C CNN
	1    6150 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 2150 6150 2150
Wire Wire Line
	6150 2150 6150 2350
Wire Wire Line
	6100 3550 6150 3550
Connection ~ 6150 3550
Wire Wire Line
	6150 3550 6150 3600
Wire Wire Line
	6100 3350 6150 3350
Connection ~ 6150 3350
Wire Wire Line
	6150 3350 6150 3550
Wire Wire Line
	6100 3150 6150 3150
Connection ~ 6150 3150
Wire Wire Line
	6150 3150 6150 3350
Wire Wire Line
	6100 2950 6150 2950
Connection ~ 6150 2950
Wire Wire Line
	6150 2950 6150 3150
Wire Wire Line
	6100 2750 6150 2750
Connection ~ 6150 2750
Wire Wire Line
	6150 2750 6150 2950
Wire Wire Line
	6100 2550 6150 2550
Connection ~ 6150 2550
Wire Wire Line
	6150 2550 6150 2750
Wire Wire Line
	6100 2350 6150 2350
Connection ~ 6150 2350
Wire Wire Line
	6150 2350 6150 2550
$Comp
L Device:C C1
U 1 1 6112482B
P 6150 4900
F 0 "C1" H 6150 5000 50  0000 L CNN
F 1 "100nF" H 6150 4800 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 6188 4750 50  0001 C CNN
F 3 "~" H 6150 4900 50  0001 C CNN
	1    6150 4900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 611251CF
P 6400 4900
F 0 "C2" H 6400 5000 50  0000 L CNN
F 1 "100nF" H 6400 4800 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 6438 4750 50  0001 C CNN
F 3 "~" H 6400 4900 50  0001 C CNN
	1    6400 4900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 61125759
P 6650 4900
F 0 "C3" H 6650 5000 50  0000 L CNN
F 1 "100nF" H 6650 4800 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 6688 4750 50  0001 C CNN
F 3 "~" H 6650 4900 50  0001 C CNN
	1    6650 4900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 61125AE3
P 6900 4900
F 0 "C4" H 6900 5000 50  0000 L CNN
F 1 "100nF" H 6900 4800 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 6938 4750 50  0001 C CNN
F 3 "~" H 6900 4900 50  0001 C CNN
	1    6900 4900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 61125E8A
P 7150 4900
F 0 "C5" H 7150 5000 50  0000 L CNN
F 1 "100nF" H 7150 4800 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 7188 4750 50  0001 C CNN
F 3 "~" H 7150 4900 50  0001 C CNN
	1    7150 4900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 611260EB
P 7400 4900
F 0 "C6" H 7400 5000 50  0000 L CNN
F 1 "100nF" H 7400 4800 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 7438 4750 50  0001 C CNN
F 3 "~" H 7400 4900 50  0001 C CNN
	1    7400 4900
	1    0    0    -1  
$EndComp
$Comp
L Device:C C7
U 1 1 611262E3
P 7650 4900
F 0 "C7" H 7650 5000 50  0000 L CNN
F 1 "10uF" H 7650 4800 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 7688 4750 50  0001 C CNN
F 3 "~" H 7650 4900 50  0001 C CNN
	1    7650 4900
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR02
U 1 1 61126E80
P 7650 4650
F 0 "#PWR02" H 7650 4500 50  0001 C CNN
F 1 "VCC" H 7665 4823 50  0000 C CNN
F 2 "" H 7650 4650 50  0001 C CNN
F 3 "" H 7650 4650 50  0001 C CNN
	1    7650 4650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 61127E3F
P 7650 5150
F 0 "#PWR03" H 7650 4900 50  0001 C CNN
F 1 "GND" H 7655 4977 50  0000 C CNN
F 2 "" H 7650 5150 50  0001 C CNN
F 3 "" H 7650 5150 50  0001 C CNN
	1    7650 5150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 4650 7650 4700
Wire Wire Line
	7650 5150 7650 5100
Wire Wire Line
	7650 5100 7400 5100
Wire Wire Line
	6150 5100 6150 5050
Connection ~ 7650 5100
Wire Wire Line
	7650 5100 7650 5050
Wire Wire Line
	6150 4750 6150 4700
Wire Wire Line
	6150 4700 6400 4700
Connection ~ 7650 4700
Wire Wire Line
	7650 4700 7650 4750
Wire Wire Line
	7400 4700 7400 4750
Connection ~ 7400 4700
Wire Wire Line
	7400 4700 7650 4700
Wire Wire Line
	7150 4700 7150 4750
Connection ~ 7150 4700
Wire Wire Line
	7150 4700 7400 4700
Wire Wire Line
	6900 4700 6900 4750
Connection ~ 6900 4700
Wire Wire Line
	6900 4700 7150 4700
Wire Wire Line
	6650 4700 6650 4750
Connection ~ 6650 4700
Wire Wire Line
	6650 4700 6900 4700
Wire Wire Line
	6400 4700 6400 4750
Connection ~ 6400 4700
Wire Wire Line
	6400 4700 6650 4700
Wire Wire Line
	6400 5050 6400 5100
Connection ~ 6400 5100
Wire Wire Line
	6400 5100 6150 5100
Wire Wire Line
	6650 5050 6650 5100
Connection ~ 6650 5100
Wire Wire Line
	6650 5100 6400 5100
Wire Wire Line
	6900 5050 6900 5100
Connection ~ 6900 5100
Wire Wire Line
	6900 5100 6650 5100
Wire Wire Line
	7150 5050 7150 5100
Connection ~ 7150 5100
Wire Wire Line
	7150 5100 6900 5100
Wire Wire Line
	7400 5050 7400 5100
Connection ~ 7400 5100
Wire Wire Line
	7400 5100 7150 5100
$Comp
L power:VCC #PWR0101
U 1 1 611A5CF4
P 3200 5050
F 0 "#PWR0101" H 3200 4900 50  0001 C CNN
F 1 "VCC" H 3300 5150 50  0000 C CNN
F 2 "" H 3200 5050 50  0001 C CNN
F 3 "" H 3200 5050 50  0001 C CNN
	1    3200 5050
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0102
U 1 1 611A648F
P 1450 5050
F 0 "#PWR0102" H 1450 4900 50  0001 C CNN
F 1 "VCC" H 1550 5150 50  0000 C CNN
F 2 "" H 1450 5050 50  0001 C CNN
F 3 "" H 1450 5050 50  0001 C CNN
	1    1450 5050
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0103
U 1 1 611A681A
P 1450 2800
F 0 "#PWR0103" H 1450 2650 50  0001 C CNN
F 1 "VCC" H 1550 2900 50  0000 C CNN
F 2 "" H 1450 2800 50  0001 C CNN
F 3 "" H 1450 2800 50  0001 C CNN
	1    1450 2800
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0104
U 1 1 611A70E3
P 3200 2800
F 0 "#PWR0104" H 3200 2650 50  0001 C CNN
F 1 "VCC" H 3300 2900 50  0000 C CNN
F 2 "" H 3200 2800 50  0001 C CNN
F 3 "" H 3200 2800 50  0001 C CNN
	1    3200 2800
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0105
U 1 1 611A753F
P 1450 700
F 0 "#PWR0105" H 1450 550 50  0001 C CNN
F 1 "VCC" H 1550 800 50  0000 C CNN
F 2 "" H 1450 700 50  0001 C CNN
F 3 "" H 1450 700 50  0001 C CNN
	1    1450 700 
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0106
U 1 1 611A7ABB
P 3200 700
F 0 "#PWR0106" H 3200 550 50  0001 C CNN
F 1 "VCC" H 3300 800 50  0000 C CNN
F 2 "" H 3200 700 50  0001 C CNN
F 3 "" H 3200 700 50  0001 C CNN
	1    3200 700 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 611A84B7
P 1450 2500
F 0 "#PWR0107" H 1450 2250 50  0001 C CNN
F 1 "GND" H 1550 2500 50  0000 C CNN
F 2 "" H 1450 2500 50  0001 C CNN
F 3 "" H 1450 2500 50  0001 C CNN
	1    1450 2500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 611A8F31
P 3200 2500
F 0 "#PWR0108" H 3200 2250 50  0001 C CNN
F 1 "GND" H 3300 2500 50  0000 C CNN
F 2 "" H 3200 2500 50  0001 C CNN
F 3 "" H 3200 2500 50  0001 C CNN
	1    3200 2500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0109
U 1 1 611A93B6
P 1450 4700
F 0 "#PWR0109" H 1450 4450 50  0001 C CNN
F 1 "GND" H 1550 4700 50  0000 C CNN
F 2 "" H 1450 4700 50  0001 C CNN
F 3 "" H 1450 4700 50  0001 C CNN
	1    1450 4700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0110
U 1 1 611A99B4
P 3200 4700
F 0 "#PWR0110" H 3200 4450 50  0001 C CNN
F 1 "GND" H 3300 4700 50  0000 C CNN
F 2 "" H 3200 4700 50  0001 C CNN
F 3 "" H 3200 4700 50  0001 C CNN
	1    3200 4700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0111
U 1 1 611A9CE6
P 1450 6650
F 0 "#PWR0111" H 1450 6400 50  0001 C CNN
F 1 "GND" H 1550 6650 50  0000 C CNN
F 2 "" H 1450 6650 50  0001 C CNN
F 3 "" H 1450 6650 50  0001 C CNN
	1    1450 6650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0112
U 1 1 611AA10E
P 3200 6650
F 0 "#PWR0112" H 3200 6400 50  0001 C CNN
F 1 "GND" H 3300 6650 50  0000 C CNN
F 2 "" H 3200 6650 50  0001 C CNN
F 3 "" H 3200 6650 50  0001 C CNN
	1    3200 6650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 611AA5CF
P 900 1650
F 0 "#PWR0113" H 900 1400 50  0001 C CNN
F 1 "GND" H 1000 1650 50  0000 C CNN
F 2 "" H 900 1650 50  0001 C CNN
F 3 "" H 900 1650 50  0001 C CNN
	1    900  1650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 611AA96B
P 2650 1650
F 0 "#PWR0114" H 2650 1400 50  0001 C CNN
F 1 "GND" H 2750 1650 50  0000 C CNN
F 2 "" H 2650 1650 50  0001 C CNN
F 3 "" H 2650 1650 50  0001 C CNN
	1    2650 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	950  1500 900  1500
Wire Wire Line
	900  1500 900  1600
Wire Wire Line
	950  1600 900  1600
Connection ~ 900  1600
Wire Wire Line
	900  1600 900  1650
Wire Wire Line
	2700 1500 2650 1500
Wire Wire Line
	2650 1500 2650 1600
Wire Wire Line
	2700 1600 2650 1600
Connection ~ 2650 1600
Wire Wire Line
	2650 1600 2650 1650
$Comp
L power:GND #PWR0115
U 1 1 611D2C87
P 900 4450
F 0 "#PWR0115" H 900 4200 50  0001 C CNN
F 1 "GND" H 1000 4450 50  0000 C CNN
F 2 "" H 900 4450 50  0001 C CNN
F 3 "" H 900 4450 50  0001 C CNN
	1    900  4450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0116
U 1 1 611D3A09
P 2650 4450
F 0 "#PWR0116" H 2650 4200 50  0001 C CNN
F 1 "GND" H 2750 4450 50  0000 C CNN
F 2 "" H 2650 4450 50  0001 C CNN
F 3 "" H 2650 4450 50  0001 C CNN
	1    2650 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	950  4400 900  4400
Wire Wire Line
	900  4400 900  4450
Wire Wire Line
	2700 4400 2650 4400
Wire Wire Line
	2650 4400 2650 4450
$Comp
L power:GND #PWR0117
U 1 1 611E91ED
P 3850 6150
F 0 "#PWR0117" H 3850 5900 50  0001 C CNN
F 1 "GND" H 3950 6150 50  0000 C CNN
F 2 "" H 3850 6150 50  0001 C CNN
F 3 "" H 3850 6150 50  0001 C CNN
	1    3850 6150
	1    0    0    -1  
$EndComp
Wire Wire Line
	3700 6250 3700 6150
Wire Wire Line
	3700 6150 3850 6150
$Comp
L power:VCC #PWR0118
U 1 1 611F4A28
P 900 6200
F 0 "#PWR0118" H 900 6050 50  0001 C CNN
F 1 "VCC" H 1000 6300 50  0000 C CNN
F 2 "" H 900 6200 50  0001 C CNN
F 3 "" H 900 6200 50  0001 C CNN
	1    900  6200
	1    0    0    -1  
$EndComp
Wire Wire Line
	950  6250 900  6250
Wire Wire Line
	900  6250 900  6200
Wire Wire Line
	7650 4700 8050 4700
Wire Wire Line
	8050 4700 8050 4750
Wire Wire Line
	8050 4750 8300 4750
Wire Wire Line
	7650 5100 8050 5100
Wire Wire Line
	8050 5100 8050 5050
Wire Wire Line
	8050 5050 8300 5050
Wire Wire Line
	8300 4950 8300 5050
Connection ~ 8300 5050
Wire Wire Line
	8300 4750 8300 4850
Connection ~ 8300 4750
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 6129A829
P 8050 4700
F 0 "#FLG0101" H 8050 4775 50  0001 C CNN
F 1 "PWR_FLAG" H 8050 4873 50  0000 C CNN
F 2 "" H 8050 4700 50  0001 C CNN
F 3 "~" H 8050 4700 50  0001 C CNN
	1    8050 4700
	1    0    0    -1  
$EndComp
Connection ~ 8050 4700
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 6129ADAD
P 8050 5100
F 0 "#FLG0102" H 8050 5175 50  0001 C CNN
F 1 "PWR_FLAG" H 8050 5273 50  0000 C CNN
F 2 "" H 8050 5100 50  0001 C CNN
F 3 "~" H 8050 5100 50  0001 C CNN
	1    8050 5100
	-1   0    0    1   
$EndComp
Connection ~ 8050 5100
Text GLabel 8800 3500 0    50   Output ~ 0
CLK
Text GLabel 8800 3700 0    50   Output ~ 0
RST
Wire Wire Line
	8800 3500 8850 3500
Wire Wire Line
	8800 3700 8850 3700
NoConn ~ 8850 3600
NoConn ~ 8850 3800
Text GLabel 900  2200 0    50   Input ~ 0
RST
Text GLabel 2650 2200 0    50   Input ~ 0
RST
Wire Wire Line
	900  2200 950  2200
Wire Wire Line
	2650 2200 2700 2200
Text GLabel 900  2000 0    50   Input ~ 0
CLK
Wire Wire Line
	900  2000 950  2000
Text GLabel 2650 2000 0    50   Input ~ 0
CLK
Wire Wire Line
	2650 2000 2700 2000
Text GLabel 8800 3000 0    50   Output ~ 0
AOUT
Text GLabel 8800 3100 0    50   Output ~ 0
ALOAD
Text GLabel 8800 3200 0    50   Output ~ 0
MOUT
Text GLabel 8800 3300 0    50   Output ~ 0
MLOAD
Wire Wire Line
	8800 3000 8850 3000
Wire Wire Line
	8850 3100 8800 3100
Wire Wire Line
	8800 3200 8850 3200
Wire Wire Line
	8850 3300 8800 3300
Text GLabel 900  6350 0    50   Input ~ 0
AOUT
Text GLabel 2200 7400 0    50   Input ~ 0
ALOAD
Text GLabel 3750 6350 2    50   Input ~ 0
MOUT
Text GLabel 2200 7200 0    50   Input ~ 0
MLOAD
Wire Wire Line
	3700 6350 3750 6350
Wire Wire Line
	900  6350 950  6350
$Comp
L 74xx:74LS08 U6
U 1 1 613A8F35
P 2550 7300
F 0 "U6" H 2550 7625 50  0000 C CNN
F 1 "74HC08" H 2550 7534 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2550 7300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 2550 7300 50  0001 C CNN
	1    2550 7300
	1    0    0    -1  
$EndComp
Wire Wire Line
	2200 7200 2250 7200
Wire Wire Line
	2200 7400 2250 7400
Text GLabel 2900 7300 2    50   Output ~ 0
LOAD
Wire Wire Line
	2850 7300 2900 7300
Text GLabel 900  1900 0    50   Input ~ 0
LOAD
Wire Wire Line
	900  1900 950  1900
Wire Wire Line
	950  1800 950  1900
Connection ~ 950  1900
Text GLabel 2650 1900 0    50   Input ~ 0
LOAD
Wire Wire Line
	2650 1900 2700 1900
Wire Wire Line
	2700 1900 2700 1800
Connection ~ 2700 1900
Text GLabel 900  4300 0    50   Input ~ 0
MLOAD
Wire Wire Line
	900  4300 950  4300
Text GLabel 2650 4300 0    50   Input ~ 0
MLOAD
Wire Wire Line
	2650 4300 2700 4300
$Comp
L Device:C C8
U 1 1 61469FAB
P 5900 4900
F 0 "C8" H 5900 5000 50  0000 L CNN
F 1 "100nF" H 5900 4800 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 5938 4750 50  0001 C CNN
F 3 "~" H 5900 4900 50  0001 C CNN
	1    5900 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	5900 4750 5900 4700
Wire Wire Line
	5900 4700 6150 4700
Connection ~ 6150 4700
Wire Wire Line
	6150 5100 5900 5100
Wire Wire Line
	5900 5100 5900 5050
Connection ~ 6150 5100
$Comp
L 74xx:74LS08 U6
U 2 1 6149013E
P 4050 7300
F 0 "U6" H 4050 7625 50  0000 C CNN
F 1 "74HC08" H 4050 7534 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 4050 7300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 4050 7300 50  0001 C CNN
	2    4050 7300
	1    0    0    1   
$EndComp
$Comp
L 74xx:74LS08 U6
U 5 1 6149205B
P 5750 5900
F 0 "U6" H 5980 5946 50  0000 L CNN
F 1 "74HC08" H 5980 5855 50  0000 L CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 5750 5900 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 5750 5900 50  0001 C CNN
	5    5750 5900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0119
U 1 1 61492A20
P 5750 6400
F 0 "#PWR0119" H 5750 6150 50  0001 C CNN
F 1 "GND" H 5850 6400 50  0000 C CNN
F 2 "" H 5750 6400 50  0001 C CNN
F 3 "" H 5750 6400 50  0001 C CNN
	1    5750 6400
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0120
U 1 1 614930BB
P 5750 5400
F 0 "#PWR0120" H 5750 5250 50  0001 C CNN
F 1 "VCC" H 5850 5500 50  0000 C CNN
F 2 "" H 5750 5400 50  0001 C CNN
F 3 "" H 5750 5400 50  0001 C CNN
	1    5750 5400
	1    0    0    -1  
$EndComp
NoConn ~ 8500 1250
$Comp
L power:GND #PWR0123
U 1 1 61557231
P 7850 1400
F 0 "#PWR0123" H 7850 1150 50  0001 C CNN
F 1 "GND" H 7855 1227 50  0000 C CNN
F 2 "" H 7850 1400 50  0001 C CNN
F 3 "" H 7850 1400 50  0001 C CNN
	1    7850 1400
	1    0    0    -1  
$EndComp
Wire Wire Line
	7900 1150 7850 1150
Wire Wire Line
	7850 1150 7850 1350
Wire Wire Line
	7900 1350 7850 1350
Connection ~ 7850 1350
Wire Wire Line
	7850 1350 7850 1400
$Comp
L 74xx:74LS08 U6
U 4 1 6149162A
P 8200 1250
F 0 "U6" H 8200 1575 50  0000 C CNN
F 1 "74HC08" H 8200 1484 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 8200 1250 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 8200 1250 50  0001 C CNN
	4    8200 1250
	1    0    0    -1  
$EndComp
Text GLabel 7400 3650 0    50   Output ~ 0
RST
Text GLabel 7400 2850 0    50   BiDi ~ 0
AOUT
Text GLabel 7400 3050 0    50   BiDi ~ 0
ALOAD
Text GLabel 7400 3250 0    50   BiDi ~ 0
MOUT
Text GLabel 7400 3450 0    50   BiDi ~ 0
MLOAD
$Comp
L Device:R R16
U 1 1 60F790FF
P 7600 3650
F 0 "R16" V 7500 3650 50  0000 C CNN
F 1 "100K" V 7600 3650 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 7530 3650 50  0001 C CNN
F 3 "~" H 7600 3650 50  0001 C CNN
	1    7600 3650
	0    1    1    0   
$EndComp
$Comp
L Device:R R12
U 1 1 60F798C6
P 7600 2850
F 0 "R12" V 7500 2850 50  0000 C CNN
F 1 "10K" V 7600 2850 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 7530 2850 50  0001 C CNN
F 3 "~" H 7600 2850 50  0001 C CNN
	1    7600 2850
	0    1    1    0   
$EndComp
$Comp
L Device:R R13
U 1 1 60F8B811
P 7600 3050
F 0 "R13" V 7500 3050 50  0000 C CNN
F 1 "10K" V 7600 3050 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 7530 3050 50  0001 C CNN
F 3 "~" H 7600 3050 50  0001 C CNN
	1    7600 3050
	0    1    1    0   
$EndComp
$Comp
L Device:R R14
U 1 1 60FAF16E
P 7600 3250
F 0 "R14" V 7500 3250 50  0000 C CNN
F 1 "10K" V 7600 3250 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 7530 3250 50  0001 C CNN
F 3 "~" H 7600 3250 50  0001 C CNN
	1    7600 3250
	0    1    1    0   
$EndComp
$Comp
L Device:R R15
U 1 1 60FAF41C
P 7600 3450
F 0 "R15" V 7500 3450 50  0000 C CNN
F 1 "10K" V 7600 3450 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 7530 3450 50  0001 C CNN
F 3 "~" H 7600 3450 50  0001 C CNN
	1    7600 3450
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR0121
U 1 1 60FAF779
P 7800 2800
F 0 "#PWR0121" H 7800 2650 50  0001 C CNN
F 1 "VCC" H 7900 2900 50  0000 C CNN
F 2 "" H 7800 2800 50  0001 C CNN
F 3 "" H 7800 2800 50  0001 C CNN
	1    7800 2800
	1    0    0    -1  
$EndComp
Wire Wire Line
	7400 2850 7450 2850
Wire Wire Line
	7400 3050 7450 3050
Wire Wire Line
	7400 3250 7450 3250
Wire Wire Line
	7400 3450 7450 3450
Wire Wire Line
	7750 2850 7800 2850
Wire Wire Line
	7800 2850 7800 2800
Wire Wire Line
	7750 3050 7800 3050
Wire Wire Line
	7800 3050 7800 2850
Connection ~ 7800 2850
Wire Wire Line
	7750 3250 7800 3250
Wire Wire Line
	7800 3250 7800 3050
Connection ~ 7800 3050
Wire Wire Line
	7750 3450 7800 3450
Wire Wire Line
	7800 3450 7800 3250
Connection ~ 7800 3250
Wire Wire Line
	7400 3650 7450 3650
$Comp
L power:GND #PWR0122
U 1 1 61064DB3
P 7800 3700
F 0 "#PWR0122" H 7800 3450 50  0001 C CNN
F 1 "GND" H 7805 3527 50  0000 C CNN
F 2 "" H 7800 3700 50  0001 C CNN
F 3 "" H 7800 3700 50  0001 C CNN
	1    7800 3700
	1    0    0    -1  
$EndComp
Wire Wire Line
	7750 3650 7800 3650
Wire Wire Line
	7800 3650 7800 3700
Text GLabel 4400 7300 2    50   Output ~ 0
OUT
Wire Wire Line
	4350 7300 4400 7300
Wire Wire Line
	3700 7200 3750 7200
Wire Wire Line
	3700 7400 3750 7400
Text GLabel 5350 1000 0    50   Input ~ 0
LOAD
Text GLabel 5350 1200 0    50   Input ~ 0
OUT
$Comp
L Device:LED D9
U 1 1 6113BE53
P 5550 1000
F 0 "D9" H 5650 1050 50  0000 C CNN
F 1 "LOAD" H 5700 950 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5550 1000 50  0001 C CNN
F 3 "~" H 5550 1000 50  0001 C CNN
	1    5550 1000
	1    0    0    -1  
$EndComp
$Comp
L Device:R R9
U 1 1 6113C48E
P 5900 1000
F 0 "R9" V 5800 1000 50  0000 C CNN
F 1 "330" V 5900 1000 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5830 1000 50  0001 C CNN
F 3 "~" H 5900 1000 50  0001 C CNN
	1    5900 1000
	0    1    1    0   
$EndComp
$Comp
L Device:LED D10
U 1 1 6113C894
P 5550 1200
F 0 "D10" H 5650 1250 50  0000 C CNN
F 1 "OUT" H 5700 1150 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5550 1200 50  0001 C CNN
F 3 "~" H 5550 1200 50  0001 C CNN
	1    5550 1200
	1    0    0    -1  
$EndComp
$Comp
L Device:R R10
U 1 1 6113F698
P 5900 1200
F 0 "R10" V 5800 1200 50  0000 C CNN
F 1 "330" V 5900 1200 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5830 1200 50  0001 C CNN
F 3 "~" H 5900 1200 50  0001 C CNN
	1    5900 1200
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR0124
U 1 1 6118A855
P 6100 950
F 0 "#PWR0124" H 6100 800 50  0001 C CNN
F 1 "VCC" H 6200 1050 50  0000 C CNN
F 2 "" H 6100 950 50  0001 C CNN
F 3 "" H 6100 950 50  0001 C CNN
	1    6100 950 
	1    0    0    -1  
$EndComp
Wire Wire Line
	5350 1000 5400 1000
Wire Wire Line
	5700 1000 5750 1000
Wire Wire Line
	6050 1000 6100 1000
Wire Wire Line
	6100 1000 6100 950 
Wire Wire Line
	5350 1200 5400 1200
Wire Wire Line
	5700 1200 5750 1200
Wire Wire Line
	6050 1200 6100 1200
Wire Wire Line
	6100 1200 6100 1000
Connection ~ 6100 1000
$Comp
L 74xx:74LS08 U6
U 3 1 61490C79
P 5050 1700
F 0 "U6" H 5050 2025 50  0000 C CNN
F 1 "74HC08" H 5050 1934 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 5050 1700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS08" H 5050 1700 50  0001 C CNN
	3    5050 1700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 1600 4700 1600
$Comp
L Device:LED D11
U 1 1 61294FA8
P 5550 1700
F 0 "D11" H 5650 1750 50  0000 C CNN
F 1 "ADDR" H 5700 1650 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 5550 1700 50  0001 C CNN
F 3 "~" H 5550 1700 50  0001 C CNN
	1    5550 1700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R11
U 1 1 6129558B
P 5900 1700
F 0 "R11" V 5800 1700 50  0000 C CNN
F 1 "330" V 5900 1700 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5830 1700 50  0001 C CNN
F 3 "~" H 5900 1700 50  0001 C CNN
	1    5900 1700
	0    1    1    0   
$EndComp
Wire Wire Line
	5350 1700 5400 1700
Wire Wire Line
	5700 1700 5750 1700
$Comp
L power:VCC #PWR0125
U 1 1 612E73F1
P 6100 1650
F 0 "#PWR0125" H 6100 1500 50  0001 C CNN
F 1 "VCC" H 6200 1750 50  0000 C CNN
F 2 "" H 6100 1650 50  0001 C CNN
F 3 "" H 6100 1650 50  0001 C CNN
	1    6100 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	6050 1700 6100 1700
Wire Wire Line
	6100 1700 6100 1650
Text GLabel 3700 7200 0    50   Input ~ 0
AOUT
Text GLabel 3700 7400 0    50   Input ~ 0
MOUT
Wire Wire Line
	4700 1800 4750 1800
Text GLabel 4700 1600 0    50   Input ~ 0
AOUT
Text GLabel 4700 1800 0    50   Input ~ 0
ALOAD
$Comp
L Jumper:SolderJumper_2_Open JP1
U 1 1 613AB4FF
P 10250 3300
F 0 "JP1" H 10150 3350 50  0000 C CNN
F 1 "L" H 10250 3400 50  0001 C CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Open_RoundedPad1.0x1.5mm" H 10250 3300 50  0001 C CNN
F 3 "~" H 10250 3300 50  0001 C CNN
	1    10250 3300
	1    0    0    -1  
$EndComp
Wire Wire Line
	10050 3300 10100 3300
$EndSCHEMATC
