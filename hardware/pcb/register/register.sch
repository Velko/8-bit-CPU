EESchema Schematic File Version 4
LIBS:register-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Register"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 74xx:74HC245 U1
U 1 1 5EEF6738
P 1750 2200
F 0 "U1" H 1550 2850 50  0000 C CNN
F 1 "74HC245" H 1950 2850 50  0000 C CNN
F 2 "Package_SO:SO-20_12.8x7.5mm_P1.27mm" H 1750 2200 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74HC245" H 1750 2200 50  0001 C CNN
	1    1750 2200
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS173 U2
U 1 1 5EEF68FA
P 3750 2300
F 0 "U2" H 3550 3050 50  0000 C CNN
F 1 "74HC173" H 3950 3050 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3750 2300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS173" H 3750 2300 50  0001 C CNN
	1    3750 2300
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS173 U3
U 1 1 5EEF697C
P 5750 2300
F 0 "U3" H 5550 3050 50  0000 C CNN
F 1 "74HC173" H 5950 3050 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 5750 2300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS173" H 5750 2300 50  0001 C CNN
	1    5750 2300
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0101
U 1 1 5EEF785D
P 3750 1050
F 0 "#PWR0101" H 3750 900 50  0001 C CNN
F 1 "VCC" H 3767 1223 50  0000 C CNN
F 2 "" H 3750 1050 50  0001 C CNN
F 3 "" H 3750 1050 50  0001 C CNN
	1    3750 1050
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0102
U 1 1 5EEF7878
P 1750 1050
F 0 "#PWR0102" H 1750 900 50  0001 C CNN
F 1 "VCC" H 1767 1223 50  0000 C CNN
F 2 "" H 1750 1050 50  0001 C CNN
F 3 "" H 1750 1050 50  0001 C CNN
	1    1750 1050
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0103
U 1 1 5EEF7889
P 5750 1050
F 0 "#PWR0103" H 5750 900 50  0001 C CNN
F 1 "VCC" H 5767 1223 50  0000 C CNN
F 2 "" H 5750 1050 50  0001 C CNN
F 3 "" H 5750 1050 50  0001 C CNN
	1    5750 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	5750 1400 5750 1050
Wire Wire Line
	3750 1050 3750 1400
Wire Wire Line
	1750 1050 1750 1250
$Comp
L power:GND #PWR0104
U 1 1 5EEF8A94
P 3750 3250
F 0 "#PWR0104" H 3750 3000 50  0001 C CNN
F 1 "GND" H 3755 3077 50  0000 C CNN
F 2 "" H 3750 3250 50  0001 C CNN
F 3 "" H 3750 3250 50  0001 C CNN
	1    3750 3250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 5EEF8AAC
P 1750 3250
F 0 "#PWR0105" H 1750 3000 50  0001 C CNN
F 1 "GND" H 1755 3077 50  0000 C CNN
F 2 "" H 1750 3250 50  0001 C CNN
F 3 "" H 1750 3250 50  0001 C CNN
	1    1750 3250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 5EEF8ABD
P 5750 3250
F 0 "#PWR0106" H 5750 3000 50  0001 C CNN
F 1 "GND" H 5755 3077 50  0000 C CNN
F 2 "" H 5750 3250 50  0001 C CNN
F 3 "" H 5750 3250 50  0001 C CNN
	1    5750 3250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 5EEF9517
P 3150 2300
F 0 "#PWR0107" H 3150 2050 50  0001 C CNN
F 1 "GND" H 3155 2127 50  0000 C CNN
F 2 "" H 3150 2300 50  0001 C CNN
F 3 "" H 3150 2300 50  0001 C CNN
	1    3150 2300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 5EEF9528
P 5150 2300
F 0 "#PWR0108" H 5150 2050 50  0001 C CNN
F 1 "GND" H 5155 2127 50  0000 C CNN
F 2 "" H 5150 2300 50  0001 C CNN
F 3 "" H 5150 2300 50  0001 C CNN
	1    5150 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5250 2200 5150 2200
Wire Wire Line
	5150 2200 5150 2300
Wire Wire Line
	5250 2300 5150 2300
Connection ~ 5150 2300
Wire Wire Line
	3250 2200 3150 2200
Wire Wire Line
	3150 2200 3150 2300
Wire Wire Line
	3250 2300 3150 2300
Connection ~ 3150 2300
Connection ~ 1750 1250
Wire Wire Line
	1750 1250 1750 1400
Text GLabel 2350 2400 2    50   Output ~ 0
BUS0
Text GLabel 2350 2300 2    50   Output ~ 0
BUS1
Text GLabel 2350 2200 2    50   Output ~ 0
BUS2
Text GLabel 2350 2100 2    50   Output ~ 0
BUS3
Text GLabel 2350 2000 2    50   Output ~ 0
BUS4
Text GLabel 2350 1900 2    50   Output ~ 0
BUS5
Text GLabel 2350 1800 2    50   Output ~ 0
BUS6
Text GLabel 2350 1700 2    50   Output ~ 0
BUS7
Text GLabel 1150 2400 0    50   Input ~ 0
TAP0
Text GLabel 1150 2300 0    50   Input ~ 0
TAP1
Text GLabel 1150 2200 0    50   Input ~ 0
TAP2
Text GLabel 1150 2100 0    50   Input ~ 0
TAP3
Text GLabel 1150 2000 0    50   Input ~ 0
TAP4
Text GLabel 1150 1900 0    50   Input ~ 0
TAP5
Text GLabel 1150 1800 0    50   Input ~ 0
TAP6
Text GLabel 1150 1700 0    50   Input ~ 0
TAP7
Wire Wire Line
	1250 2600 850  2600
Wire Wire Line
	850  2600 850  1250
Wire Wire Line
	850  1250 1750 1250
Text GLabel 3150 1700 0    50   Input ~ 0
BUS0
Text GLabel 3150 1800 0    50   Input ~ 0
BUS1
Text GLabel 3150 1900 0    50   Input ~ 0
BUS2
Text GLabel 3150 2000 0    50   Input ~ 0
BUS3
Wire Wire Line
	3150 1700 3250 1700
Wire Wire Line
	3150 1800 3250 1800
Wire Wire Line
	3150 1900 3250 1900
Wire Wire Line
	3150 2000 3250 2000
Text GLabel 4350 1700 2    50   Output ~ 0
TAP0
Text GLabel 4350 1800 2    50   Output ~ 0
TAP1
Text GLabel 4350 1900 2    50   Output ~ 0
TAP2
Text GLabel 4350 2000 2    50   Output ~ 0
TAP3
Wire Wire Line
	4250 1700 4350 1700
Wire Wire Line
	4250 1800 4350 1800
Wire Wire Line
	4250 1900 4350 1900
Wire Wire Line
	4250 2000 4350 2000
Text GLabel 5200 1700 0    50   Input ~ 0
BUS4
Text GLabel 5200 1800 0    50   Input ~ 0
BUS5
Text GLabel 5200 1900 0    50   Input ~ 0
BUS6
Text GLabel 5200 2000 0    50   Input ~ 0
BUS7
Wire Wire Line
	5200 1700 5250 1700
Wire Wire Line
	5200 1800 5250 1800
Wire Wire Line
	5200 1900 5250 1900
Wire Wire Line
	5200 2000 5250 2000
Text GLabel 6350 1700 2    50   Output ~ 0
TAP4
Text GLabel 6350 1800 2    50   Output ~ 0
TAP5
Text GLabel 6350 1900 2    50   Output ~ 0
TAP6
Text GLabel 6350 2000 2    50   Output ~ 0
TAP7
Wire Wire Line
	6250 1700 6350 1700
Wire Wire Line
	6250 1800 6350 1800
Wire Wire Line
	6250 1900 6350 1900
Wire Wire Line
	6250 2000 6350 2000
$Comp
L Device:LED D1
U 1 1 5EF627FB
P 7650 1250
F 0 "D1" H 7750 1150 50  0000 C CNN
F 1 "LED" H 7500 1300 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7650 1250 50  0001 C CNN
F 3 "~" H 7650 1250 50  0001 C CNN
	1    7650 1250
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D2
U 1 1 5EF687E6
P 7650 1450
F 0 "D2" H 7750 1350 50  0000 C CNN
F 1 "LED" H 7500 1500 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7650 1450 50  0001 C CNN
F 3 "~" H 7650 1450 50  0001 C CNN
	1    7650 1450
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D3
U 1 1 5EF6880C
P 7650 1650
F 0 "D3" H 7750 1550 50  0000 C CNN
F 1 "LED" H 7500 1700 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7650 1650 50  0001 C CNN
F 3 "~" H 7650 1650 50  0001 C CNN
	1    7650 1650
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D4
U 1 1 5EF68874
P 7650 1850
F 0 "D4" H 7750 1750 50  0000 C CNN
F 1 "LED" H 7500 1900 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7650 1850 50  0001 C CNN
F 3 "~" H 7650 1850 50  0001 C CNN
	1    7650 1850
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D5
U 1 1 5EF688A2
P 7650 2050
F 0 "D5" H 7750 1950 50  0000 C CNN
F 1 "LED" H 7500 2100 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7650 2050 50  0001 C CNN
F 3 "~" H 7650 2050 50  0001 C CNN
	1    7650 2050
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D6
U 1 1 5EF688C6
P 7650 2250
F 0 "D6" H 7750 2150 50  0000 C CNN
F 1 "LED" H 7500 2300 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7650 2250 50  0001 C CNN
F 3 "~" H 7650 2250 50  0001 C CNN
	1    7650 2250
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D7
U 1 1 5EF688F4
P 7650 2450
F 0 "D7" H 7750 2350 50  0000 C CNN
F 1 "LED" H 7500 2500 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7650 2450 50  0001 C CNN
F 3 "~" H 7650 2450 50  0001 C CNN
	1    7650 2450
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D8
U 1 1 5EF68A4A
P 7650 2650
F 0 "D8" H 7750 2550 50  0000 C CNN
F 1 "LED" H 7500 2700 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 7650 2650 50  0001 C CNN
F 3 "~" H 7650 2650 50  0001 C CNN
	1    7650 2650
	-1   0    0    1   
$EndComp
$Comp
L Device:R R1
U 1 1 5EF68B05
P 8100 1250
F 0 "R1" V 8000 1250 50  0000 C CNN
F 1 "330" V 8100 1250 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 8030 1250 50  0001 C CNN
F 3 "~" H 8100 1250 50  0001 C CNN
	1    8100 1250
	0    1    1    0   
$EndComp
$Comp
L Device:R R2
U 1 1 5EF698B1
P 8100 1450
F 0 "R2" V 8000 1450 50  0000 C CNN
F 1 "330" V 8100 1450 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 8030 1450 50  0001 C CNN
F 3 "~" H 8100 1450 50  0001 C CNN
	1    8100 1450
	0    1    1    0   
$EndComp
$Comp
L Device:R R3
U 1 1 5EF698F9
P 8100 1650
F 0 "R3" V 8000 1650 50  0000 C CNN
F 1 "330" V 8100 1650 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 8030 1650 50  0001 C CNN
F 3 "~" H 8100 1650 50  0001 C CNN
	1    8100 1650
	0    1    1    0   
$EndComp
$Comp
L Device:R R4
U 1 1 5EF69935
P 8100 1850
F 0 "R4" V 8000 1850 50  0000 C CNN
F 1 "330" V 8100 1850 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 8030 1850 50  0001 C CNN
F 3 "~" H 8100 1850 50  0001 C CNN
	1    8100 1850
	0    1    1    0   
$EndComp
$Comp
L Device:R R5
U 1 1 5EF6996B
P 8100 2050
F 0 "R5" V 8000 2050 50  0000 C CNN
F 1 "330" V 8100 2050 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 8030 2050 50  0001 C CNN
F 3 "~" H 8100 2050 50  0001 C CNN
	1    8100 2050
	0    1    1    0   
$EndComp
$Comp
L Device:R R6
U 1 1 5EF699BF
P 8100 2250
F 0 "R6" V 8000 2250 50  0000 C CNN
F 1 "330" V 8100 2250 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 8030 2250 50  0001 C CNN
F 3 "~" H 8100 2250 50  0001 C CNN
	1    8100 2250
	0    1    1    0   
$EndComp
$Comp
L Device:R R7
U 1 1 5EF699F9
P 8100 2450
F 0 "R7" V 8000 2450 50  0000 C CNN
F 1 "330" V 8100 2450 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 8030 2450 50  0001 C CNN
F 3 "~" H 8100 2450 50  0001 C CNN
	1    8100 2450
	0    1    1    0   
$EndComp
$Comp
L Device:R R8
U 1 1 5EF69A3D
P 8100 2650
F 0 "R8" V 8000 2650 50  0000 C CNN
F 1 "330" V 8100 2650 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 8030 2650 50  0001 C CNN
F 3 "~" H 8100 2650 50  0001 C CNN
	1    8100 2650
	0    1    1    0   
$EndComp
Text GLabel 7300 1250 0    50   Input ~ 0
TAP0
Text GLabel 7300 1450 0    50   Input ~ 0
TAP1
Text GLabel 7300 1650 0    50   Input ~ 0
TAP2
Text GLabel 7300 1850 0    50   Input ~ 0
TAP3
Text GLabel 7300 2050 0    50   Input ~ 0
TAP4
Text GLabel 7300 2250 0    50   Input ~ 0
TAP5
Text GLabel 7300 2450 0    50   Input ~ 0
TAP6
Text GLabel 7300 2650 0    50   Input ~ 0
TAP7
Wire Wire Line
	7300 1250 7500 1250
Wire Wire Line
	7300 1450 7500 1450
Wire Wire Line
	7300 1650 7500 1650
Wire Wire Line
	7300 1850 7500 1850
Wire Wire Line
	7300 2050 7500 2050
Wire Wire Line
	7300 2250 7500 2250
Wire Wire Line
	7300 2450 7500 2450
Wire Wire Line
	7300 2650 7500 2650
Wire Wire Line
	7800 1250 7950 1250
Wire Wire Line
	7800 1450 7950 1450
Wire Wire Line
	7800 1650 7950 1650
Wire Wire Line
	7800 1850 7950 1850
Wire Wire Line
	7800 2050 7950 2050
Wire Wire Line
	7800 2250 7950 2250
Wire Wire Line
	7800 2450 7950 2450
Wire Wire Line
	7800 2650 7950 2650
$Comp
L power:GND #PWR0109
U 1 1 5EF79DB2
P 8350 2900
F 0 "#PWR0109" H 8350 2650 50  0001 C CNN
F 1 "GND" H 8355 2727 50  0000 C CNN
F 2 "" H 8350 2900 50  0001 C CNN
F 3 "" H 8350 2900 50  0001 C CNN
	1    8350 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	8250 1250 8350 1250
Wire Wire Line
	8350 1250 8350 1450
Wire Wire Line
	8250 1450 8350 1450
Connection ~ 8350 1450
Wire Wire Line
	8350 1450 8350 1650
Wire Wire Line
	8250 1650 8350 1650
Connection ~ 8350 1650
Wire Wire Line
	8350 1650 8350 1850
Wire Wire Line
	8250 1850 8350 1850
Connection ~ 8350 1850
Wire Wire Line
	8350 1850 8350 2050
Wire Wire Line
	8250 2050 8350 2050
Connection ~ 8350 2050
Wire Wire Line
	8350 2050 8350 2250
Wire Wire Line
	8250 2250 8350 2250
Connection ~ 8350 2250
Wire Wire Line
	8350 2250 8350 2450
Wire Wire Line
	8250 2450 8350 2450
Connection ~ 8350 2450
Wire Wire Line
	8350 2450 8350 2650
Wire Wire Line
	8250 2650 8350 2650
Connection ~ 8350 2650
Wire Wire Line
	8350 2650 8350 2900
Wire Wire Line
	3250 2500 3250 2600
Wire Wire Line
	5250 2500 5250 2600
Wire Wire Line
	3250 2900 3150 2900
Wire Wire Line
	3750 3200 3750 3250
Wire Wire Line
	5750 3200 5750 3250
Text GLabel 3150 2600 0    50   Input ~ 0
LOAD
Text GLabel 3150 2700 0    50   Input ~ 0
CLK
Text GLabel 3150 2900 0    50   Input ~ 0
RESET
Wire Wire Line
	3150 2600 3250 2600
Connection ~ 3250 2600
Wire Wire Line
	3150 2700 3250 2700
Wire Wire Line
	1750 3000 1750 3250
Text GLabel 5200 2900 0    50   Input ~ 0
RESET
Text GLabel 5200 2700 0    50   Input ~ 0
CLK
Text GLabel 5200 2600 0    50   Input ~ 0
LOAD
Wire Wire Line
	5200 2700 5250 2700
Wire Wire Line
	5200 2600 5250 2600
Connection ~ 5250 2600
Wire Wire Line
	5200 2900 5250 2900
Text GLabel 1150 2700 0    50   Input ~ 0
~OUT~
Wire Wire Line
	1150 2700 1250 2700
$Comp
L Device:LED D9
U 1 1 5EFAF776
P 9250 1750
F 0 "D9" H 9350 1650 50  0000 C CNN
F 1 "LED" H 9100 1800 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9250 1750 50  0001 C CNN
F 3 "~" H 9250 1750 50  0001 C CNN
	1    9250 1750
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D10
U 1 1 5EFAF7F0
P 9300 1300
F 0 "D10" H 9400 1200 50  0000 C CNN
F 1 "LED" H 9150 1350 50  0000 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9300 1300 50  0001 C CNN
F 3 "~" H 9300 1300 50  0001 C CNN
	1    9300 1300
	1    0    0    -1  
$EndComp
Text GLabel 9000 1750 0    50   Input ~ 0
LOAD
Text GLabel 9000 1300 0    50   Input ~ 0
~OUT~
Wire Wire Line
	9000 1750 9050 1750
$Comp
L Device:R R12
U 1 1 5EFB22A4
P 9650 1750
F 0 "R12" V 9550 1750 50  0000 C CNN
F 1 "330" V 9650 1750 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 9580 1750 50  0001 C CNN
F 3 "~" H 9650 1750 50  0001 C CNN
	1    9650 1750
	0    1    1    0   
$EndComp
$Comp
L Device:R R10
U 1 1 5EFB2318
P 9650 1300
F 0 "R10" V 9550 1300 50  0000 C CNN
F 1 "330" V 9650 1300 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 9580 1300 50  0001 C CNN
F 3 "~" H 9650 1300 50  0001 C CNN
	1    9650 1300
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR0110
U 1 1 5EFC04D0
P 9900 1050
F 0 "#PWR0110" H 9900 900 50  0001 C CNN
F 1 "VCC" H 9917 1223 50  0000 C CNN
F 2 "" H 9900 1050 50  0001 C CNN
F 3 "" H 9900 1050 50  0001 C CNN
	1    9900 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	9000 1300 9050 1300
Wire Wire Line
	9450 1300 9500 1300
Wire Wire Line
	9800 1300 9900 1300
Wire Wire Line
	9400 1750 9500 1750
$Comp
L power:GND #PWR0111
U 1 1 5EFCA25D
P 9900 2100
F 0 "#PWR0111" H 9900 1850 50  0001 C CNN
F 1 "GND" H 9905 1927 50  0000 C CNN
F 2 "" H 9900 2100 50  0001 C CNN
F 3 "" H 9900 2100 50  0001 C CNN
	1    9900 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	9800 1750 9900 1750
$Comp
L power:VCC #PWR0112
U 1 1 5EFCD43E
P 9350 2700
F 0 "#PWR0112" H 9350 2550 50  0001 C CNN
F 1 "VCC" H 9367 2873 50  0000 C CNN
F 2 "" H 9350 2700 50  0001 C CNN
F 3 "" H 9350 2700 50  0001 C CNN
	1    9350 2700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 5EFCD477
P 9350 3100
F 0 "#PWR0113" H 9350 2850 50  0001 C CNN
F 1 "GND" H 9355 2927 50  0000 C CNN
F 2 "" H 9350 3100 50  0001 C CNN
F 3 "" H 9350 3100 50  0001 C CNN
	1    9350 3100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 5EFCD531
P 9350 2900
F 0 "C1" H 9465 2946 50  0000 L CNN
F 1 "100nF" H 9465 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9388 2750 50  0001 C CNN
F 3 "~" H 9350 2900 50  0001 C CNN
	1    9350 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	9350 2700 9350 2750
Wire Wire Line
	9350 3050 9350 3100
$Comp
L Device:C C2
U 1 1 5EFD2D57
P 9850 2900
F 0 "C2" H 9965 2946 50  0000 L CNN
F 1 "100nF" H 9965 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 9888 2750 50  0001 C CNN
F 3 "~" H 9850 2900 50  0001 C CNN
	1    9850 2900
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5EFD88DB
P 9850 2700
F 0 "#FLG0101" H 9850 2775 50  0001 C CNN
F 1 "PWR_FLAG" H 9850 2874 50  0000 C CNN
F 2 "" H 9850 2700 50  0001 C CNN
F 3 "~" H 9850 2700 50  0001 C CNN
	1    9850 2700
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5EFD891F
P 9850 3100
F 0 "#FLG0102" H 9850 3175 50  0001 C CNN
F 1 "PWR_FLAG" H 9850 3273 50  0000 C CNN
F 2 "" H 9850 3100 50  0001 C CNN
F 3 "~" H 9850 3100 50  0001 C CNN
	1    9850 3100
	-1   0    0    1   
$EndComp
Wire Wire Line
	9850 2700 9850 2750
Connection ~ 9850 2750
Wire Wire Line
	9850 3100 9850 3050
Connection ~ 9850 3050
$Comp
L Connector_Generic:Conn_02x08_Odd_Even J1
U 1 1 5EFE5B16
P 1850 4950
F 0 "J1" H 1900 5467 50  0000 C CNN
F 1 "IDC_02x08" H 1900 5376 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x08_P2.54mm_Horizontal" H 1850 4950 50  0001 C CNN
F 3 "~" H 1850 4950 50  0001 C CNN
	1    1850 4950
	1    0    0    -1  
$EndComp
Text GLabel 9150 2750 0    50   Input ~ 0
VCC
Text GLabel 9150 3050 0    50   Input ~ 0
GND
Wire Wire Line
	9150 2750 9350 2750
Connection ~ 9350 2750
Wire Wire Line
	9150 3050 9350 3050
Connection ~ 9350 3050
Wire Wire Line
	9350 2750 9850 2750
Wire Wire Line
	9350 3050 9850 3050
Text GLabel 1550 4650 0    50   Output ~ 0
VCC
Text GLabel 2250 4650 2    50   Output ~ 0
GND
Text GLabel 1600 4750 0    50   BiDi ~ 0
BUS7
Text GLabel 2200 4750 2    50   BiDi ~ 0
BUS6
Wire Wire Line
	1600 4750 1650 4750
Wire Wire Line
	2150 4750 2200 4750
Wire Wire Line
	1550 4650 1650 4650
Wire Wire Line
	2150 4650 2250 4650
Text GLabel 1600 4850 0    50   BiDi ~ 0
BUS5
Text GLabel 2200 4850 2    50   BiDi ~ 0
BUS4
Wire Wire Line
	1600 4850 1650 4850
Wire Wire Line
	2150 4850 2200 4850
Text GLabel 1550 5150 0    50   Output ~ 0
VCC
Text GLabel 2250 5150 2    50   Output ~ 0
GND
Text GLabel 1600 5250 0    50   BiDi ~ 0
BUS3
Text GLabel 2200 5250 2    50   BiDi ~ 0
BUS2
Text GLabel 1600 5350 0    50   BiDi ~ 0
BUS1
Text GLabel 2200 5350 2    50   BiDi ~ 0
BUS0
Wire Wire Line
	1550 5150 1650 5150
Wire Wire Line
	2150 5150 2250 5150
Wire Wire Line
	2150 5250 2200 5250
Wire Wire Line
	1600 5250 1650 5250
Wire Wire Line
	1600 5350 1650 5350
Wire Wire Line
	2150 5350 2200 5350
Text GLabel 1550 5050 0    50   Output ~ 0
CLK
Text GLabel 2550 5050 2    50   Output ~ 0
~CLK~
Wire Wire Line
	1550 5050 1650 5050
Text GLabel 1600 4950 0    50   Output ~ 0
RESET
Wire Wire Line
	1600 4950 1650 4950
Text GLabel 2550 4900 2    50   Output ~ 0
~RESET~
Wire Wire Line
	2500 4950 2500 4900
Wire Wire Line
	2500 4900 2550 4900
Wire Wire Line
	2150 4950 2500 4950
Wire Wire Line
	2150 5050 2550 5050
Text GLabel 2000 5600 0    50   Input ~ 0
~RESET~
Text GLabel 2000 5750 0    50   Input ~ 0
~CLK~
NoConn ~ 2000 5600
NoConn ~ 2000 5750
$Comp
L Connector_Generic:Conn_02x08_Odd_Even J2
U 1 1 5F05EB32
P 3900 4950
F 0 "J2" H 3950 5467 50  0000 C CNN
F 1 "IDC_02x08" H 3950 5376 50  0000 C CNN
F 2 "Connector_IDC:IDC-Header_2x08_P2.54mm_Vertical" H 3900 4950 50  0001 C CNN
F 3 "~" H 3900 4950 50  0001 C CNN
	1    3900 4950
	1    0    0    -1  
$EndComp
Text GLabel 4300 4650 2    50   BiDi ~ 0
GND
Text GLabel 4300 5150 2    50   BiDi ~ 0
GND
Wire Wire Line
	4200 4650 4300 4650
Wire Wire Line
	4200 5150 4300 5150
Text GLabel 4300 5350 2    50   Input ~ 0
TAP0
Text GLabel 3550 5350 0    50   Input ~ 0
TAP1
Text GLabel 4300 5250 2    50   Input ~ 0
TAP2
Text GLabel 3550 5250 0    50   Input ~ 0
TAP3
Text GLabel 3550 4750 0    50   Input ~ 0
TAP7
Text GLabel 4300 4750 2    50   Input ~ 0
TAP6
Text GLabel 3550 4850 0    50   Input ~ 0
TAP5
Text GLabel 4300 4850 2    50   Input ~ 0
TAP4
Wire Wire Line
	3550 4750 3700 4750
Wire Wire Line
	3550 4850 3700 4850
Wire Wire Line
	4200 4750 4300 4750
Wire Wire Line
	4200 4850 4300 4850
Wire Wire Line
	3550 5250 3700 5250
Wire Wire Line
	4200 5250 4300 5250
Wire Wire Line
	3550 5350 3700 5350
Wire Wire Line
	4200 5350 4300 5350
NoConn ~ 3700 4950
NoConn ~ 3700 5050
NoConn ~ 4200 4950
NoConn ~ 4200 5050
NoConn ~ 3700 4650
NoConn ~ 3700 5150
Text GLabel 9000 2050 0    50   Input ~ 0
RESET
$Comp
L Device:R R9
U 1 1 5F0E847A
P 9650 1100
F 0 "R9" V 9550 1100 50  0000 C CNN
F 1 "10K" V 9650 1100 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 9580 1100 50  0001 C CNN
F 3 "~" H 9650 1100 50  0001 C CNN
	1    9650 1100
	0    1    1    0   
$EndComp
Wire Wire Line
	9050 1300 9050 1100
Wire Wire Line
	9050 1100 9500 1100
Connection ~ 9050 1300
Wire Wire Line
	9050 1300 9150 1300
Wire Wire Line
	9900 1050 9900 1100
Wire Wire Line
	9800 1100 9900 1100
Connection ~ 9900 1100
Wire Wire Line
	9900 1100 9900 1300
$Comp
L Device:R R11
U 1 1 5F0FB349
P 9650 1550
F 0 "R11" V 9550 1550 50  0000 C CNN
F 1 "10K" V 9650 1550 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 9580 1550 50  0001 C CNN
F 3 "~" H 9650 1550 50  0001 C CNN
	1    9650 1550
	0    1    1    0   
$EndComp
Wire Wire Line
	9050 1750 9050 1550
Wire Wire Line
	9050 1550 9500 1550
Connection ~ 9050 1750
Wire Wire Line
	9050 1750 9100 1750
Wire Wire Line
	9800 1550 9900 1550
Wire Wire Line
	9900 1550 9900 1750
Connection ~ 9900 1750
$Comp
L Device:R R13
U 1 1 5F10F3D4
P 9650 2050
F 0 "R13" V 9550 2050 50  0000 C CNN
F 1 "100K" V 9650 2050 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.15x1.40mm_HandSolder" V 9580 2050 50  0001 C CNN
F 3 "~" H 9650 2050 50  0001 C CNN
	1    9650 2050
	0    1    1    0   
$EndComp
Wire Wire Line
	9000 2050 9500 2050
Wire Wire Line
	9800 2050 9900 2050
Wire Wire Line
	9900 2050 9900 2100
Wire Wire Line
	9900 1750 9900 2050
Connection ~ 9900 2050
$Comp
L Connector:Conn_01x04_Female J3
U 1 1 5F12CDD2
P 5400 4850
F 0 "J3" H 5294 4425 50  0000 C CNN
F 1 "01x04_F" H 5294 4516 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Horizontal" H 5400 4850 50  0001 C CNN
F 3 "~" H 5400 4850 50  0001 C CNN
	1    5400 4850
	-1   0    0    1   
$EndComp
Text GLabel 5750 4950 2    50   Output ~ 0
~OUT~
Text GLabel 5750 4800 2    50   Output ~ 0
LOAD
Wire Wire Line
	5600 4950 5750 4950
Wire Wire Line
	5600 4850 5700 4850
Wire Wire Line
	5700 4850 5700 4800
Wire Wire Line
	5700 4800 5750 4800
NoConn ~ 5600 4750
NoConn ~ 5600 4650
NoConn ~ 22650 1900
Wire Wire Line
	1150 1700 1250 1700
Wire Wire Line
	1250 1800 1150 1800
Wire Wire Line
	1250 1900 1150 1900
Wire Wire Line
	1250 2000 1150 2000
Wire Wire Line
	1250 2100 1150 2100
Wire Wire Line
	1250 2200 1150 2200
Wire Wire Line
	1250 2300 1150 2300
Wire Wire Line
	1250 2400 1150 2400
Wire Wire Line
	2250 1700 2350 1700
Wire Wire Line
	2250 1800 2350 1800
Wire Wire Line
	2250 1900 2350 1900
Wire Wire Line
	2250 2000 2350 2000
Wire Wire Line
	2250 2100 2350 2100
Wire Wire Line
	2250 2200 2350 2200
Wire Wire Line
	2250 2300 2350 2300
Wire Wire Line
	2250 2400 2350 2400
$EndSCHEMATC