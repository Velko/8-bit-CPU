EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Counter"
Date "2021-07-23"
Rev "1.0"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Connector:Conn_01x16_Male J5
U 1 1 60FAF446
P 10250 1650
F 0 "J5" H 10222 1624 50  0000 R CNN
F 1 "Address Bus" H 10222 1533 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x16_P2.54mm_Vertical" H 10250 1650 50  0001 C CNN
F 3 "~" H 10250 1650 50  0001 C CNN
	1    10250 1650
	-1   0    0    -1  
$EndComp
Text GLabel 10000 2450 0    50   BiDi ~ 0
ABUS0
Text GLabel 10000 2350 0    50   BiDi ~ 0
ABUS1
Text GLabel 10000 2250 0    50   BiDi ~ 0
ABUS2
Text GLabel 10000 2150 0    50   BiDi ~ 0
ABUS3
Text GLabel 10000 2050 0    50   BiDi ~ 0
ABUS4
Text GLabel 10000 1950 0    50   BiDi ~ 0
ABUS5
Text GLabel 10000 1850 0    50   BiDi ~ 0
ABUS6
Text GLabel 10000 1750 0    50   BiDi ~ 0
ABUS7
Text GLabel 10000 1650 0    50   BiDi ~ 0
ABUS8
Text GLabel 10000 1550 0    50   BiDi ~ 0
ABUS9
Text GLabel 10000 1450 0    50   BiDi ~ 0
ABUS10
Text GLabel 10000 1350 0    50   BiDi ~ 0
ABUS11
Text GLabel 10000 1250 0    50   BiDi ~ 0
ABUS12
Text GLabel 10000 1150 0    50   BiDi ~ 0
ABUS13
Text GLabel 10000 1050 0    50   BiDi ~ 0
ABUS14
Text GLabel 10000 950  0    50   BiDi ~ 0
ABUS15
Wire Wire Line
	10000 950  10050 950 
Wire Wire Line
	10050 1050 10000 1050
Wire Wire Line
	10000 1150 10050 1150
Wire Wire Line
	10050 1250 10000 1250
Wire Wire Line
	10000 1350 10050 1350
Wire Wire Line
	10050 1450 10000 1450
Wire Wire Line
	10000 1550 10050 1550
Wire Wire Line
	10000 1650 10050 1650
Wire Wire Line
	10050 1750 10000 1750
Wire Wire Line
	10000 1850 10050 1850
Wire Wire Line
	10050 1950 10000 1950
Wire Wire Line
	10000 2050 10050 2050
Wire Wire Line
	10050 2150 10000 2150
Wire Wire Line
	10000 2250 10050 2250
Wire Wire Line
	10050 2350 10000 2350
Wire Wire Line
	10000 2450 10050 2450
$Comp
L Connector:Conn_01x02_Male J6
U 1 1 60FB7D2D
P 10250 2800
F 0 "J6" H 10222 2774 50  0000 R CNN
F 1 "Support" H 10222 2683 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 10250 2800 50  0001 C CNN
F 3 "~" H 10250 2800 50  0001 C CNN
	1    10250 2800
	-1   0    0    -1  
$EndComp
NoConn ~ 10050 2800
NoConn ~ 10050 2900
$Comp
L Connector:Conn_01x04_Male J4
U 1 1 60FBA3C7
P 10500 5650
F 0 "J4" H 10472 5532 50  0000 R CNN
F 1 "+ Power -" H 10472 5623 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x02_P2.54mm_Vertical" H 10500 5650 50  0001 C CNN
F 3 "~" H 10500 5650 50  0001 C CNN
	1    10500 5650
	-1   0    0    1   
$EndComp
Wire Wire Line
	10300 5450 10300 5550
Wire Wire Line
	10300 5650 10300 5750
$Comp
L Connector:Conn_01x04_Male J3
U 1 1 60FBCF67
P 10250 4000
F 0 "J3" H 10222 3974 50  0000 R CNN
F 1 "Sync" H 10222 3883 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 10250 4000 50  0001 C CNN
F 3 "~" H 10250 4000 50  0001 C CNN
	1    10250 4000
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J2
U 1 1 60FBE2A8
P 10250 4550
F 0 "J2" H 10222 4524 50  0000 R CNN
F 1 "Control" H 10222 4433 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 10250 4550 50  0001 C CNN
F 3 "~" H 10250 4550 50  0001 C CNN
	1    10250 4550
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2400 1800 2400 2000
Wire Wire Line
	2400 2000 2650 2000
Wire Wire Line
	4000 1800 4000 2000
Wire Wire Line
	4000 2000 4250 2000
Wire Wire Line
	5600 1800 5600 2000
Wire Wire Line
	5600 2000 5850 2000
Text GLabel 1050 1300 0    50   Input ~ 0
ABUS0
Text GLabel 1050 1400 0    50   Input ~ 0
ABUS1
Text GLabel 1050 1500 0    50   Input ~ 0
ABUS2
Text GLabel 1050 1600 0    50   Input ~ 0
ABUS3
Text GLabel 2650 1300 0    50   Input ~ 0
ABUS4
Text GLabel 2650 1400 0    50   Input ~ 0
ABUS5
Text GLabel 2650 1500 0    50   Input ~ 0
ABUS6
Text GLabel 2650 1600 0    50   Input ~ 0
ABUS7
Text GLabel 4250 1300 0    50   Input ~ 0
ABUS8
Text GLabel 4250 1400 0    50   Input ~ 0
ABUS9
Text GLabel 4250 1500 0    50   Input ~ 0
ABUS10
Text GLabel 4250 1600 0    50   Input ~ 0
ABUS11
Text GLabel 5850 1300 0    50   Input ~ 0
ABUS12
Text GLabel 5850 1400 0    50   Input ~ 0
ABUS13
Text GLabel 5850 1500 0    50   Input ~ 0
ABUS14
Text GLabel 5850 1600 0    50   Input ~ 0
ABUS15
Text GLabel 2050 1300 2    50   Output ~ 0
Q0
Text GLabel 2050 1400 2    50   Output ~ 0
Q1
Text GLabel 2050 1500 2    50   Output ~ 0
Q2
Text GLabel 2050 1600 2    50   Output ~ 0
Q3
Text GLabel 3650 1300 2    50   Output ~ 0
Q4
Text GLabel 3650 1400 2    50   Output ~ 0
Q5
Text GLabel 3650 1500 2    50   Output ~ 0
Q6
Text GLabel 3650 1600 2    50   Output ~ 0
Q7
Text GLabel 5250 1300 2    50   Output ~ 0
Q8
Text GLabel 5250 1400 2    50   Output ~ 0
Q9
Text GLabel 5250 1500 2    50   Output ~ 0
Q10
Text GLabel 5250 1600 2    50   Output ~ 0
Q11
Text GLabel 6850 1300 2    50   Output ~ 0
Q12
Text GLabel 6850 1400 2    50   Output ~ 0
Q13
Text GLabel 6850 1500 2    50   Output ~ 0
Q14
Text GLabel 6850 1600 2    50   Output ~ 0
Q15
Wire Wire Line
	2050 1800 2400 1800
Wire Wire Line
	3650 1800 4000 1800
Wire Wire Line
	5250 1800 5600 1800
NoConn ~ 6850 1800
Text GLabel 10000 4100 0    50   Output ~ 0
RST
Wire Wire Line
	10000 4100 10050 4100
Text GLabel 1050 2300 0    50   Input ~ 0
~RST~
Text GLabel 2650 2300 0    50   Input ~ 0
~RST~
Text GLabel 4250 2300 0    50   Input ~ 0
~RST~
Text GLabel 5850 2300 0    50   Input ~ 0
~RST~
Text GLabel 1050 1800 0    50   Input ~ 0
LOAD
$Comp
L power:VCC #PWR0101
U 1 1 60FED03C
P 1550 1000
F 0 "#PWR0101" H 1550 850 50  0001 C CNN
F 1 "VCC" H 1650 1100 50  0000 C CNN
F 2 "" H 1550 1000 50  0001 C CNN
F 3 "" H 1550 1000 50  0001 C CNN
	1    1550 1000
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0102
U 1 1 60FEDBB0
P 3150 1000
F 0 "#PWR0102" H 3150 850 50  0001 C CNN
F 1 "VCC" H 3250 1100 50  0000 C CNN
F 2 "" H 3150 1000 50  0001 C CNN
F 3 "" H 3150 1000 50  0001 C CNN
	1    3150 1000
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0103
U 1 1 60FEE22E
P 4750 1000
F 0 "#PWR0103" H 4750 850 50  0001 C CNN
F 1 "VCC" H 4850 1100 50  0000 C CNN
F 2 "" H 4750 1000 50  0001 C CNN
F 3 "" H 4750 1000 50  0001 C CNN
	1    4750 1000
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0104
U 1 1 60FEE7A3
P 6350 1000
F 0 "#PWR0104" H 6350 850 50  0001 C CNN
F 1 "VCC" H 6450 1100 50  0000 C CNN
F 2 "" H 6350 1000 50  0001 C CNN
F 3 "" H 6350 1000 50  0001 C CNN
	1    6350 1000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 60FEF0CF
P 1550 2600
F 0 "#PWR0105" H 1550 2350 50  0001 C CNN
F 1 "GND" H 1650 2500 50  0000 C CNN
F 2 "" H 1550 2600 50  0001 C CNN
F 3 "" H 1550 2600 50  0001 C CNN
	1    1550 2600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 60FEF97B
P 3150 2600
F 0 "#PWR0106" H 3150 2350 50  0001 C CNN
F 1 "GND" H 3250 2500 50  0000 C CNN
F 2 "" H 3150 2600 50  0001 C CNN
F 3 "" H 3150 2600 50  0001 C CNN
	1    3150 2600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 60FEFCB8
P 4750 2600
F 0 "#PWR0107" H 4750 2350 50  0001 C CNN
F 1 "GND" H 4850 2500 50  0000 C CNN
F 2 "" H 4750 2600 50  0001 C CNN
F 3 "" H 4750 2600 50  0001 C CNN
	1    4750 2600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 60FF0002
P 6350 2600
F 0 "#PWR0108" H 6350 2350 50  0001 C CNN
F 1 "GND" H 6450 2500 50  0000 C CNN
F 2 "" H 6350 2600 50  0001 C CNN
F 3 "" H 6350 2600 50  0001 C CNN
	1    6350 2600
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS173 U2
U 1 1 60FF07E5
P 1550 4000
F 0 "U2" H 1300 4750 50  0000 C CNN
F 1 "74HC173" H 1750 4750 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 1550 4000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 1550 4000 50  0001 C CNN
	1    1550 4000
	1    0    0    -1  
$EndComp
Text GLabel 1050 3700 0    50   Input ~ 0
Q0
Text GLabel 1050 3600 0    50   Input ~ 0
Q1
Text GLabel 1050 3500 0    50   Input ~ 0
Q2
Text GLabel 1050 3400 0    50   Input ~ 0
Q3
Text GLabel 2650 3700 0    50   Input ~ 0
Q4
Text GLabel 2650 3600 0    50   Input ~ 0
Q5
Text GLabel 2650 3500 0    50   Input ~ 0
Q6
Text GLabel 2650 3400 0    50   Input ~ 0
Q7
Text GLabel 4250 3700 0    50   Input ~ 0
Q8
Text GLabel 4250 3600 0    50   Input ~ 0
Q9
Text GLabel 4250 3500 0    50   Input ~ 0
Q10
Text GLabel 4250 3400 0    50   Input ~ 0
Q11
Text GLabel 5850 3700 0    50   Input ~ 0
Q12
Text GLabel 5850 3600 0    50   Input ~ 0
Q13
Text GLabel 5850 3500 0    50   Input ~ 0
Q14
Text GLabel 5850 3400 0    50   Input ~ 0
Q15
$Comp
L 74xx:74LS173 U6
U 1 1 60FFA676
P 3150 4000
F 0 "U6" H 2900 4750 50  0000 C CNN
F 1 "74HC173" H 3350 4750 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3150 4000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 3150 4000 50  0001 C CNN
	1    3150 4000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS173 U8
U 1 1 60FFB494
P 4750 4000
F 0 "U8" H 4500 4750 50  0000 C CNN
F 1 "74HC173" H 4950 4750 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 4750 4000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 4750 4000 50  0001 C CNN
	1    4750 4000
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS173 U10
U 1 1 60FFC4C4
P 6350 4000
F 0 "U10" H 6100 4750 50  0000 C CNN
F 1 "74HC173" H 6550 4750 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 6350 4000 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS32" H 6350 4000 50  0001 C CNN
	1    6350 4000
	1    0    0    -1  
$EndComp
Text GLabel 2050 3700 2    50   Output ~ 0
ABUS0
Text GLabel 2050 3600 2    50   Output ~ 0
ABUS1
Text GLabel 2050 3500 2    50   Output ~ 0
ABUS2
Text GLabel 2050 3400 2    50   Output ~ 0
ABUS3
Text GLabel 3650 3700 2    50   Output ~ 0
ABUS4
Text GLabel 3650 3600 2    50   Output ~ 0
ABUS5
Text GLabel 3650 3500 2    50   Output ~ 0
ABUS6
Text GLabel 3650 3400 2    50   Output ~ 0
ABUS7
Text GLabel 5250 3700 2    50   Output ~ 0
ABUS8
Text GLabel 5250 3600 2    50   Output ~ 0
ABUS9
Text GLabel 5250 3500 2    50   Output ~ 0
ABUS10
Text GLabel 5250 3400 2    50   Output ~ 0
ABUS11
Text GLabel 6850 3700 2    50   Output ~ 0
ABUS12
Text GLabel 6850 3600 2    50   Output ~ 0
ABUS13
Text GLabel 6850 3500 2    50   Output ~ 0
ABUS14
Text GLabel 6850 3400 2    50   Output ~ 0
ABUS15
Text GLabel 10000 4450 0    50   Output ~ 0
AOUT
Wire Wire Line
	10000 4450 10050 4450
Text GLabel 1000 3900 0    50   Input ~ 0
AOUT
Wire Wire Line
	1000 3900 1050 3900
Wire Wire Line
	1050 4000 1050 3900
Connection ~ 1050 3900
Text GLabel 2600 3900 0    50   Input ~ 0
AOUT
Wire Wire Line
	2600 3900 2650 3900
Wire Wire Line
	2650 3900 2650 4000
Connection ~ 2650 3900
Text GLabel 4200 3900 0    50   Input ~ 0
AOUT
Wire Wire Line
	4200 3900 4250 3900
Wire Wire Line
	4250 3900 4250 4000
Connection ~ 4250 3900
Text GLabel 5800 3900 0    50   Input ~ 0
AOUT
Wire Wire Line
	5800 3900 5850 3900
Wire Wire Line
	5850 3900 5850 4000
Connection ~ 5850 3900
$Comp
L power:VCC #PWR0109
U 1 1 6101B748
P 1550 3100
F 0 "#PWR0109" H 1550 2950 50  0001 C CNN
F 1 "VCC" H 1650 3200 50  0000 C CNN
F 2 "" H 1550 3100 50  0001 C CNN
F 3 "" H 1550 3100 50  0001 C CNN
	1    1550 3100
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0110
U 1 1 6101C143
P 3150 3100
F 0 "#PWR0110" H 3150 2950 50  0001 C CNN
F 1 "VCC" H 3250 3200 50  0000 C CNN
F 2 "" H 3150 3100 50  0001 C CNN
F 3 "" H 3150 3100 50  0001 C CNN
	1    3150 3100
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0111
U 1 1 6101C88D
P 4750 3100
F 0 "#PWR0111" H 4750 2950 50  0001 C CNN
F 1 "VCC" H 4850 3200 50  0000 C CNN
F 2 "" H 4750 3100 50  0001 C CNN
F 3 "" H 4750 3100 50  0001 C CNN
	1    4750 3100
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0112
U 1 1 6101D02B
P 6350 3100
F 0 "#PWR0112" H 6350 2950 50  0001 C CNN
F 1 "VCC" H 6450 3200 50  0000 C CNN
F 2 "" H 6350 3100 50  0001 C CNN
F 3 "" H 6350 3100 50  0001 C CNN
	1    6350 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0113
U 1 1 6101D527
P 1550 4900
F 0 "#PWR0113" H 1550 4650 50  0001 C CNN
F 1 "GND" H 1650 4800 50  0000 C CNN
F 2 "" H 1550 4900 50  0001 C CNN
F 3 "" H 1550 4900 50  0001 C CNN
	1    1550 4900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 6101DD79
P 3150 4900
F 0 "#PWR0114" H 3150 4650 50  0001 C CNN
F 1 "GND" H 3250 4800 50  0000 C CNN
F 2 "" H 3150 4900 50  0001 C CNN
F 3 "" H 3150 4900 50  0001 C CNN
	1    3150 4900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0115
U 1 1 6101E194
P 4750 4900
F 0 "#PWR0115" H 4750 4650 50  0001 C CNN
F 1 "GND" H 4850 4800 50  0000 C CNN
F 2 "" H 4750 4900 50  0001 C CNN
F 3 "" H 4750 4900 50  0001 C CNN
	1    4750 4900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0116
U 1 1 6101E933
P 6350 4900
F 0 "#PWR0116" H 6350 4650 50  0001 C CNN
F 1 "GND" H 6450 4800 50  0000 C CNN
F 2 "" H 6350 4900 50  0001 C CNN
F 3 "" H 6350 4900 50  0001 C CNN
	1    6350 4900
	1    0    0    -1  
$EndComp
Text GLabel 1050 4600 0    50   Input ~ 0
RST
Text GLabel 2650 4600 0    50   Input ~ 0
RST
Text GLabel 4250 4600 0    50   Input ~ 0
RST
Text GLabel 5850 4600 0    50   Input ~ 0
RST
Text GLabel 10000 3900 0    50   Output ~ 0
CLK
Text GLabel 10000 4000 0    50   Output ~ 0
ICLK
Wire Wire Line
	10000 3900 10050 3900
Wire Wire Line
	10000 4000 10050 4000
$Comp
L power:GND #PWR0117
U 1 1 610223F8
P 950 4200
F 0 "#PWR0117" H 950 3950 50  0001 C CNN
F 1 "GND" H 850 4100 50  0000 C CNN
F 2 "" H 950 4200 50  0001 C CNN
F 3 "" H 950 4200 50  0001 C CNN
	1    950  4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	950  4200 1050 4200
Wire Wire Line
	1050 4200 1050 4300
Connection ~ 1050 4200
$Comp
L power:GND #PWR0118
U 1 1 61025547
P 2550 4200
F 0 "#PWR0118" H 2550 3950 50  0001 C CNN
F 1 "GND" H 2450 4100 50  0000 C CNN
F 2 "" H 2550 4200 50  0001 C CNN
F 3 "" H 2550 4200 50  0001 C CNN
	1    2550 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 4200 2650 4200
Wire Wire Line
	2650 4300 2650 4200
Connection ~ 2650 4200
$Comp
L power:GND #PWR0119
U 1 1 61027E64
P 4150 4200
F 0 "#PWR0119" H 4150 3950 50  0001 C CNN
F 1 "GND" H 4050 4100 50  0000 C CNN
F 2 "" H 4150 4200 50  0001 C CNN
F 3 "" H 4150 4200 50  0001 C CNN
	1    4150 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	4150 4200 4250 4200
Wire Wire Line
	4250 4200 4250 4300
Connection ~ 4250 4200
$Comp
L power:GND #PWR0120
U 1 1 6102A9B7
P 5750 4200
F 0 "#PWR0120" H 5750 3950 50  0001 C CNN
F 1 "GND" H 5650 4100 50  0000 C CNN
F 2 "" H 5750 4200 50  0001 C CNN
F 3 "" H 5750 4200 50  0001 C CNN
	1    5750 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5750 4200 5850 4200
Wire Wire Line
	5850 4300 5850 4200
Connection ~ 5850 4200
Text GLabel 10000 4550 0    50   Output ~ 0
LOAD
Text GLabel 10000 4650 0    50   Output ~ 0
UP
Wire Wire Line
	10000 4550 10050 4550
Wire Wire Line
	10000 4650 10050 4650
Text GLabel 7900 1150 0    50   Input ~ 0
Q0
Text GLabel 7900 1300 0    50   Input ~ 0
Q1
Text GLabel 7900 1450 0    50   Input ~ 0
Q2
Text GLabel 7900 1600 0    50   Input ~ 0
Q3
Text GLabel 7900 1750 0    50   Input ~ 0
Q4
Text GLabel 7900 1900 0    50   Input ~ 0
Q5
Text GLabel 7900 2050 0    50   Input ~ 0
Q6
Text GLabel 7900 2200 0    50   Input ~ 0
Q7
Text GLabel 7900 2350 0    50   Input ~ 0
Q8
Text GLabel 7900 2500 0    50   Input ~ 0
Q9
Text GLabel 7900 2650 0    50   Input ~ 0
Q10
Text GLabel 7900 2800 0    50   Input ~ 0
Q11
Text GLabel 7900 2950 0    50   Input ~ 0
Q12
Text GLabel 7900 3100 0    50   Input ~ 0
Q13
Text GLabel 7900 3250 0    50   Input ~ 0
Q14
Text GLabel 7900 3400 0    50   Input ~ 0
Q15
$Comp
L Device:LED D1
U 1 1 6108384B
P 8100 1150
F 0 "D1" H 8200 1100 50  0000 C CNN
F 1 "LED" H 8093 986 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 1150 50  0001 C CNN
F 3 "~" H 8100 1150 50  0001 C CNN
	1    8100 1150
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D2
U 1 1 61084364
P 8100 1300
F 0 "D2" H 8200 1250 50  0000 C CNN
F 1 "LED" H 8093 1136 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 1300 50  0001 C CNN
F 3 "~" H 8100 1300 50  0001 C CNN
	1    8100 1300
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D3
U 1 1 61084796
P 8100 1450
F 0 "D3" H 8200 1400 50  0000 C CNN
F 1 "LED" H 8093 1286 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 1450 50  0001 C CNN
F 3 "~" H 8100 1450 50  0001 C CNN
	1    8100 1450
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D4
U 1 1 6109A628
P 8100 1600
F 0 "D4" H 8200 1550 50  0000 C CNN
F 1 "LED" H 8093 1436 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 1600 50  0001 C CNN
F 3 "~" H 8100 1600 50  0001 C CNN
	1    8100 1600
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D5
U 1 1 6109AA7C
P 8100 1750
F 0 "D5" H 8200 1700 50  0000 C CNN
F 1 "LED" H 8093 1586 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 1750 50  0001 C CNN
F 3 "~" H 8100 1750 50  0001 C CNN
	1    8100 1750
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D6
U 1 1 6109ADD9
P 8100 1900
F 0 "D6" H 8200 1850 50  0000 C CNN
F 1 "LED" H 8093 1736 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 1900 50  0001 C CNN
F 3 "~" H 8100 1900 50  0001 C CNN
	1    8100 1900
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D7
U 1 1 6109B065
P 8100 2050
F 0 "D7" H 8200 2000 50  0000 C CNN
F 1 "LED" H 8093 1886 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 2050 50  0001 C CNN
F 3 "~" H 8100 2050 50  0001 C CNN
	1    8100 2050
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D8
U 1 1 6109B357
P 8100 2200
F 0 "D8" H 8200 2150 50  0000 C CNN
F 1 "LED" H 8093 2036 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 2200 50  0001 C CNN
F 3 "~" H 8100 2200 50  0001 C CNN
	1    8100 2200
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D9
U 1 1 6109B4FA
P 8100 2350
F 0 "D9" H 8200 2300 50  0000 C CNN
F 1 "LED" H 8093 2186 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 2350 50  0001 C CNN
F 3 "~" H 8100 2350 50  0001 C CNN
	1    8100 2350
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D10
U 1 1 6109B6C9
P 8100 2500
F 0 "D10" H 8200 2450 50  0000 C CNN
F 1 "LED" H 8093 2336 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 2500 50  0001 C CNN
F 3 "~" H 8100 2500 50  0001 C CNN
	1    8100 2500
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D11
U 1 1 6109B8CD
P 8100 2650
F 0 "D11" H 8200 2600 50  0000 C CNN
F 1 "LED" H 8093 2486 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 2650 50  0001 C CNN
F 3 "~" H 8100 2650 50  0001 C CNN
	1    8100 2650
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D12
U 1 1 6109BA9C
P 8100 2800
F 0 "D12" H 8200 2750 50  0000 C CNN
F 1 "LED" H 8093 2636 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 2800 50  0001 C CNN
F 3 "~" H 8100 2800 50  0001 C CNN
	1    8100 2800
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D13
U 1 1 6109BCA5
P 8100 2950
F 0 "D13" H 8200 2900 50  0000 C CNN
F 1 "LED" H 8093 2786 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 2950 50  0001 C CNN
F 3 "~" H 8100 2950 50  0001 C CNN
	1    8100 2950
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D14
U 1 1 6109BF70
P 8100 3100
F 0 "D14" H 8200 3050 50  0000 C CNN
F 1 "LED" H 8093 2936 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 3100 50  0001 C CNN
F 3 "~" H 8100 3100 50  0001 C CNN
	1    8100 3100
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D15
U 1 1 6109C1DA
P 8100 3250
F 0 "D15" H 8200 3200 50  0000 C CNN
F 1 "LED" H 8093 3086 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 3250 50  0001 C CNN
F 3 "~" H 8100 3250 50  0001 C CNN
	1    8100 3250
	-1   0    0    1   
$EndComp
$Comp
L Device:LED D16
U 1 1 6109C3E3
P 8100 3400
F 0 "D16" H 8200 3350 50  0000 C CNN
F 1 "LED" H 8093 3236 50  0001 C CNN
F 2 "LED_SMD:LED_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 8100 3400 50  0001 C CNN
F 3 "~" H 8100 3400 50  0001 C CNN
	1    8100 3400
	-1   0    0    1   
$EndComp
$Comp
L Device:R R1
U 1 1 6109C6E6
P 8450 1150
F 0 "R1" V 8400 1300 50  0000 C CNN
F 1 "330" V 8450 1150 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 1150 50  0001 C CNN
F 3 "~" H 8450 1150 50  0001 C CNN
	1    8450 1150
	0    1    1    0   
$EndComp
$Comp
L Device:R R2
U 1 1 6109D8DF
P 8450 1300
F 0 "R2" V 8400 1450 50  0000 C CNN
F 1 "330" V 8450 1300 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 1300 50  0001 C CNN
F 3 "~" H 8450 1300 50  0001 C CNN
	1    8450 1300
	0    1    1    0   
$EndComp
$Comp
L Device:R R3
U 1 1 6109E686
P 8450 1450
F 0 "R3" V 8400 1600 50  0000 C CNN
F 1 "330" V 8450 1450 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 1450 50  0001 C CNN
F 3 "~" H 8450 1450 50  0001 C CNN
	1    8450 1450
	0    1    1    0   
$EndComp
$Comp
L Device:R R4
U 1 1 6109E68C
P 8450 1600
F 0 "R4" V 8400 1750 50  0000 C CNN
F 1 "330" V 8450 1600 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 1600 50  0001 C CNN
F 3 "~" H 8450 1600 50  0001 C CNN
	1    8450 1600
	0    1    1    0   
$EndComp
$Comp
L Device:R R5
U 1 1 610A0BDA
P 8450 1750
F 0 "R5" V 8400 1900 50  0000 C CNN
F 1 "330" V 8450 1750 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 1750 50  0001 C CNN
F 3 "~" H 8450 1750 50  0001 C CNN
	1    8450 1750
	0    1    1    0   
$EndComp
$Comp
L Device:R R6
U 1 1 610A0BE0
P 8450 1900
F 0 "R6" V 8400 2050 50  0000 C CNN
F 1 "330" V 8450 1900 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 1900 50  0001 C CNN
F 3 "~" H 8450 1900 50  0001 C CNN
	1    8450 1900
	0    1    1    0   
$EndComp
$Comp
L Device:R R7
U 1 1 610A0BE6
P 8450 2050
F 0 "R7" V 8400 2200 50  0000 C CNN
F 1 "330" V 8450 2050 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 2050 50  0001 C CNN
F 3 "~" H 8450 2050 50  0001 C CNN
	1    8450 2050
	0    1    1    0   
$EndComp
$Comp
L Device:R R8
U 1 1 610A0BEC
P 8450 2200
F 0 "R8" V 8400 2350 50  0000 C CNN
F 1 "330" V 8450 2200 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 2200 50  0001 C CNN
F 3 "~" H 8450 2200 50  0001 C CNN
	1    8450 2200
	0    1    1    0   
$EndComp
$Comp
L Device:R R9
U 1 1 610A44BC
P 8450 2350
F 0 "R9" V 8400 2500 50  0000 C CNN
F 1 "330" V 8450 2350 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 2350 50  0001 C CNN
F 3 "~" H 8450 2350 50  0001 C CNN
	1    8450 2350
	0    1    1    0   
$EndComp
$Comp
L Device:R R10
U 1 1 610A44C2
P 8450 2500
F 0 "R10" V 8400 2650 50  0000 C CNN
F 1 "330" V 8450 2500 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 2500 50  0001 C CNN
F 3 "~" H 8450 2500 50  0001 C CNN
	1    8450 2500
	0    1    1    0   
$EndComp
$Comp
L Device:R R11
U 1 1 610A44C8
P 8450 2650
F 0 "R11" V 8400 2800 50  0000 C CNN
F 1 "330" V 8450 2650 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 2650 50  0001 C CNN
F 3 "~" H 8450 2650 50  0001 C CNN
	1    8450 2650
	0    1    1    0   
$EndComp
$Comp
L Device:R R12
U 1 1 610A44CE
P 8450 2800
F 0 "R12" V 8400 2950 50  0000 C CNN
F 1 "330" V 8450 2800 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 2800 50  0001 C CNN
F 3 "~" H 8450 2800 50  0001 C CNN
	1    8450 2800
	0    1    1    0   
$EndComp
$Comp
L Device:R R13
U 1 1 610A44D4
P 8450 2950
F 0 "R13" V 8400 3100 50  0000 C CNN
F 1 "330" V 8450 2950 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 2950 50  0001 C CNN
F 3 "~" H 8450 2950 50  0001 C CNN
	1    8450 2950
	0    1    1    0   
$EndComp
$Comp
L Device:R R14
U 1 1 610A44DA
P 8450 3100
F 0 "R14" V 8400 3250 50  0000 C CNN
F 1 "330" V 8450 3100 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 3100 50  0001 C CNN
F 3 "~" H 8450 3100 50  0001 C CNN
	1    8450 3100
	0    1    1    0   
$EndComp
$Comp
L Device:R R15
U 1 1 610A44E0
P 8450 3250
F 0 "R15" V 8400 3400 50  0000 C CNN
F 1 "330" V 8450 3250 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 3250 50  0001 C CNN
F 3 "~" H 8450 3250 50  0001 C CNN
	1    8450 3250
	0    1    1    0   
$EndComp
$Comp
L Device:R R16
U 1 1 610A44E6
P 8450 3400
F 0 "R16" V 8400 3550 50  0000 C CNN
F 1 "330" V 8450 3400 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8380 3400 50  0001 C CNN
F 3 "~" H 8450 3400 50  0001 C CNN
	1    8450 3400
	0    1    1    0   
$EndComp
Wire Wire Line
	7900 1150 7950 1150
Wire Wire Line
	7950 1300 7900 1300
Wire Wire Line
	7900 1450 7950 1450
Wire Wire Line
	8250 1150 8300 1150
Wire Wire Line
	8300 1300 8250 1300
Wire Wire Line
	8250 1450 8300 1450
Wire Wire Line
	8300 1600 8250 1600
Wire Wire Line
	7950 1600 7900 1600
Wire Wire Line
	7900 1750 7950 1750
Wire Wire Line
	8250 1750 8300 1750
Wire Wire Line
	8300 1900 8250 1900
Wire Wire Line
	7950 1900 7900 1900
Wire Wire Line
	7900 2050 7950 2050
Wire Wire Line
	8250 2050 8300 2050
Wire Wire Line
	8300 2200 8250 2200
Wire Wire Line
	7950 2200 7900 2200
Wire Wire Line
	7900 2350 7950 2350
Wire Wire Line
	8250 2350 8300 2350
Wire Wire Line
	8300 2500 8250 2500
Wire Wire Line
	7900 2500 7950 2500
Wire Wire Line
	7900 2650 7950 2650
Wire Wire Line
	8250 2650 8300 2650
Wire Wire Line
	8300 2800 8250 2800
Wire Wire Line
	7900 2800 7950 2800
Wire Wire Line
	7900 2950 7950 2950
Wire Wire Line
	8250 2950 8300 2950
Wire Wire Line
	8300 3100 8250 3100
Wire Wire Line
	7950 3100 7900 3100
Wire Wire Line
	7900 3250 7950 3250
Wire Wire Line
	8250 3250 8300 3250
Wire Wire Line
	8300 3400 8250 3400
Wire Wire Line
	7950 3400 7900 3400
$Comp
L power:GND #PWR01
U 1 1 6110252C
P 8700 3450
F 0 "#PWR01" H 8700 3200 50  0001 C CNN
F 1 "GND" H 8800 3350 50  0000 C CNN
F 2 "" H 8700 3450 50  0001 C CNN
F 3 "" H 8700 3450 50  0001 C CNN
	1    8700 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	8700 3450 8700 3400
Wire Wire Line
	8700 1150 8600 1150
Wire Wire Line
	8600 1300 8700 1300
Connection ~ 8700 1300
Wire Wire Line
	8700 1300 8700 1150
Wire Wire Line
	8600 1450 8700 1450
Connection ~ 8700 1450
Wire Wire Line
	8700 1450 8700 1300
Wire Wire Line
	8600 1600 8700 1600
Connection ~ 8700 1600
Wire Wire Line
	8700 1600 8700 1450
Wire Wire Line
	8600 1750 8700 1750
Connection ~ 8700 1750
Wire Wire Line
	8700 1750 8700 1600
Wire Wire Line
	8600 1900 8700 1900
Connection ~ 8700 1900
Wire Wire Line
	8700 1900 8700 1750
Wire Wire Line
	8600 2050 8700 2050
Connection ~ 8700 2050
Wire Wire Line
	8700 2050 8700 1900
Wire Wire Line
	8600 2200 8700 2200
Connection ~ 8700 2200
Wire Wire Line
	8700 2200 8700 2050
Wire Wire Line
	8600 2350 8700 2350
Connection ~ 8700 2350
Wire Wire Line
	8700 2350 8700 2200
Wire Wire Line
	8600 2500 8700 2500
Connection ~ 8700 2500
Wire Wire Line
	8700 2500 8700 2350
Wire Wire Line
	8600 2650 8700 2650
Connection ~ 8700 2650
Wire Wire Line
	8700 2650 8700 2500
Wire Wire Line
	8600 2800 8700 2800
Connection ~ 8700 2800
Wire Wire Line
	8700 2800 8700 2650
Wire Wire Line
	8600 2950 8700 2950
Connection ~ 8700 2950
Wire Wire Line
	8700 2950 8700 2800
Wire Wire Line
	8600 3100 8700 3100
Connection ~ 8700 3100
Wire Wire Line
	8700 3100 8700 2950
Wire Wire Line
	8600 3250 8700 3250
Connection ~ 8700 3250
Wire Wire Line
	8700 3250 8700 3100
Wire Wire Line
	8600 3400 8700 3400
Connection ~ 8700 3400
Wire Wire Line
	8700 3400 8700 3250
$Comp
L 74xx:74LS161 U1
U 1 1 60FB839A
P 1550 1800
F 0 "U1" H 1300 2450 50  0000 C CNN
F 1 "74HC161" H 1750 2450 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 1550 1800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 1550 1800 50  0001 C CNN
	1    1550 1800
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS161 U5
U 1 1 60FC5744
P 3150 1800
F 0 "U5" H 2900 2450 50  0000 C CNN
F 1 "74HC161" H 3350 2450 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3150 1800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 3150 1800 50  0001 C CNN
	1    3150 1800
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS161 U7
U 1 1 60FC6760
P 4750 1800
F 0 "U7" H 4500 2450 50  0000 C CNN
F 1 "74HC161" H 4950 2450 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 4750 1800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 4750 1800 50  0001 C CNN
	1    4750 1800
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS161 U9
U 1 1 60FC77C6
P 6350 1800
F 0 "U9" H 6100 2450 50  0000 C CNN
F 1 "74HC161" H 6550 2450 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 6350 1800 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 6350 1800 50  0001 C CNN
	1    6350 1800
	1    0    0    -1  
$EndComp
Text GLabel 5850 4400 0    50   Input ~ 0
ICLK
Text GLabel 4250 4400 0    50   Input ~ 0
ICLK
Text GLabel 2650 4400 0    50   Input ~ 0
ICLK
Text GLabel 1050 4400 0    50   Input ~ 0
ICLK
Text GLabel 1050 2100 0    50   Input ~ 0
CLK
Text GLabel 2650 2100 0    50   Input ~ 0
CLK
Text GLabel 4250 2100 0    50   Input ~ 0
CLK
Text GLabel 5850 2100 0    50   Input ~ 0
CLK
Text GLabel 1050 1900 0    50   Input ~ 0
UP
Text GLabel 2650 1900 0    50   Input ~ 0
UP
Text GLabel 4250 1900 0    50   Input ~ 0
UP
Text GLabel 5850 1900 0    50   Input ~ 0
UP
$Comp
L Device:C C1
U 1 1 6103965E
P 7750 5600
F 0 "C1" H 7750 5700 50  0000 L CNN
F 1 "100nF" H 7750 5500 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 7788 5450 50  0001 C CNN
F 3 "~" H 7750 5600 50  0001 C CNN
	1    7750 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 6103A25F
P 8000 5600
F 0 "C2" H 8000 5700 50  0000 L CNN
F 1 "100nF" H 8000 5500 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 8038 5450 50  0001 C CNN
F 3 "~" H 8000 5600 50  0001 C CNN
	1    8000 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 6103A7EC
P 8250 5600
F 0 "C3" H 8250 5700 50  0000 L CNN
F 1 "100nF" H 8250 5500 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 8288 5450 50  0001 C CNN
F 3 "~" H 8250 5600 50  0001 C CNN
	1    8250 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 6103AB12
P 8500 5600
F 0 "C4" H 8500 5700 50  0000 L CNN
F 1 "100nF" H 8500 5500 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 8538 5450 50  0001 C CNN
F 3 "~" H 8500 5600 50  0001 C CNN
	1    8500 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 6103CB73
P 8750 5600
F 0 "C5" H 8750 5700 50  0000 L CNN
F 1 "100nF" H 8750 5500 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 8788 5450 50  0001 C CNN
F 3 "~" H 8750 5600 50  0001 C CNN
	1    8750 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 6103CB79
P 9000 5600
F 0 "C6" H 9000 5700 50  0000 L CNN
F 1 "100nF" H 9000 5500 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9038 5450 50  0001 C CNN
F 3 "~" H 9000 5600 50  0001 C CNN
	1    9000 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C7
U 1 1 6103CB7F
P 9250 5600
F 0 "C7" H 9250 5700 50  0000 L CNN
F 1 "100nF" H 9250 5500 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9288 5450 50  0001 C CNN
F 3 "~" H 9250 5600 50  0001 C CNN
	1    9250 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 6103CB85
P 9500 5600
F 0 "C8" H 9500 5700 50  0000 L CNN
F 1 "100nF" H 9500 5500 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9538 5450 50  0001 C CNN
F 3 "~" H 9500 5600 50  0001 C CNN
	1    9500 5600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C9
U 1 1 61045FCB
P 9850 5600
F 0 "C9" H 9850 5700 50  0000 L CNN
F 1 "10uF" H 9850 5500 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9888 5450 50  0001 C CNN
F 3 "~" H 9850 5600 50  0001 C CNN
	1    9850 5600
	1    0    0    -1  
$EndComp
Wire Wire Line
	10300 5450 10100 5450
Connection ~ 10300 5450
Wire Wire Line
	9500 5450 9850 5450
Connection ~ 9850 5450
Wire Wire Line
	9500 5450 9250 5450
Connection ~ 9500 5450
Wire Wire Line
	9250 5450 9000 5450
Connection ~ 9250 5450
Wire Wire Line
	9000 5450 8750 5450
Connection ~ 9000 5450
Wire Wire Line
	8750 5450 8500 5450
Connection ~ 8750 5450
Wire Wire Line
	8500 5450 8250 5450
Connection ~ 8500 5450
Wire Wire Line
	8250 5450 8000 5450
Connection ~ 8250 5450
Wire Wire Line
	7750 5450 8000 5450
Connection ~ 8000 5450
Wire Wire Line
	7750 5750 8000 5750
Wire Wire Line
	8250 5750 8000 5750
Connection ~ 8000 5750
Wire Wire Line
	8250 5750 8500 5750
Connection ~ 8250 5750
Wire Wire Line
	8500 5750 8750 5750
Connection ~ 8500 5750
Wire Wire Line
	8750 5750 9000 5750
Connection ~ 8750 5750
Wire Wire Line
	9000 5750 9250 5750
Connection ~ 9000 5750
Wire Wire Line
	9250 5750 9500 5750
Connection ~ 9250 5750
Wire Wire Line
	9500 5750 9850 5750
Connection ~ 9500 5750
Wire Wire Line
	9850 5750 10100 5750
Connection ~ 9850 5750
Connection ~ 10300 5750
$Comp
L power:GND #PWR0121
U 1 1 610AD728
P 10100 5750
F 0 "#PWR0121" H 10100 5500 50  0001 C CNN
F 1 "GND" H 10200 5650 50  0000 C CNN
F 2 "" H 10100 5750 50  0001 C CNN
F 3 "" H 10100 5750 50  0001 C CNN
	1    10100 5750
	1    0    0    -1  
$EndComp
Connection ~ 10100 5750
Wire Wire Line
	10100 5750 10300 5750
$Comp
L power:VCC #PWR0122
U 1 1 610ADFED
P 10100 5450
F 0 "#PWR0122" H 10100 5300 50  0001 C CNN
F 1 "VCC" H 10200 5550 50  0000 C CNN
F 2 "" H 10100 5450 50  0001 C CNN
F 3 "" H 10100 5450 50  0001 C CNN
	1    10100 5450
	1    0    0    -1  
$EndComp
Connection ~ 10100 5450
Wire Wire Line
	10100 5450 9850 5450
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 610AF1A8
P 9850 5450
F 0 "#FLG0101" H 9850 5525 50  0001 C CNN
F 1 "PWR_FLAG" H 9850 5623 50  0000 C CNN
F 2 "" H 9850 5450 50  0001 C CNN
F 3 "~" H 9850 5450 50  0001 C CNN
	1    9850 5450
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 610AF928
P 9850 5750
F 0 "#FLG0102" H 9850 5825 50  0001 C CNN
F 1 "PWR_FLAG" H 9850 5923 50  0000 C CNN
F 2 "" H 9850 5750 50  0001 C CNN
F 3 "~" H 9850 5750 50  0001 C CNN
	1    9850 5750
	-1   0    0    1   
$EndComp
Text GLabel 2650 1800 0    50   Input ~ 0
LOAD
Text GLabel 4250 1800 0    50   Input ~ 0
LOAD
Text GLabel 5850 1800 0    50   Input ~ 0
LOAD
$Comp
L power:VCC #PWR0123
U 1 1 610B2F34
P 800 2000
F 0 "#PWR0123" H 800 1850 50  0001 C CNN
F 1 "VCC" H 700 2100 50  0000 C CNN
F 2 "" H 800 2000 50  0001 C CNN
F 3 "" H 800 2000 50  0001 C CNN
	1    800  2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	1050 2000 800  2000
NoConn ~ 10050 4750
Text GLabel 10000 4250 0    50   Output ~ 0
~RST~
Wire Wire Line
	10000 4250 10050 4250
Wire Wire Line
	10050 4250 10050 4200
$EndSCHEMATC
