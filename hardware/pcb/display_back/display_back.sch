EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Timer:TLC555xD U7
U 1 1 60C11A3C
P 1900 1450
F 0 "U7" H 1650 1800 50  0000 C CNN
F 1 "555" H 2100 1800 50  0000 C CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 2750 1050 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/tlc555.pdf" H 2750 1050 50  0001 C CNN
	1    1900 1450
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR01
U 1 1 60C13C9A
P 1900 800
F 0 "#PWR01" H 1900 650 50  0001 C CNN
F 1 "VCC" H 1915 973 50  0000 C CNN
F 2 "" H 1900 800 50  0001 C CNN
F 3 "" H 1900 800 50  0001 C CNN
	1    1900 800 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 60C1466B
P 1900 2300
F 0 "#PWR02" H 1900 2050 50  0001 C CNN
F 1 "GND" H 1905 2127 50  0000 C CNN
F 2 "" H 1900 2300 50  0001 C CNN
F 3 "" H 1900 2300 50  0001 C CNN
	1    1900 2300
	1    0    0    -1  
$EndComp
$Comp
L Device:C C1
U 1 1 60C14C11
P 1050 2100
F 0 "C1" H 1050 2200 50  0000 L CNN
F 1 "10nF" H 1050 2000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 1088 1950 50  0001 C CNN
F 3 "~" H 1050 2100 50  0001 C CNN
	1    1050 2100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 60C156AC
P 1300 2100
F 0 "C2" H 1300 2200 50  0000 L CNN
F 1 "C" H 1300 2000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 1338 1950 50  0001 C CNN
F 3 "~" H 1300 2100 50  0001 C CNN
	1    1300 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1400 1450 1050 1450
Wire Wire Line
	1400 1250 1200 1250
Wire Wire Line
	1050 2250 1300 2250
Wire Wire Line
	1300 2250 1900 2250
Connection ~ 1300 2250
Wire Wire Line
	1900 2250 1900 2300
Connection ~ 1900 2250
Wire Wire Line
	1900 1850 1900 2250
Wire Wire Line
	1050 1450 1050 1950
Wire Wire Line
	1200 1900 1300 1900
Wire Wire Line
	2450 1900 2450 1650
Wire Wire Line
	2450 1650 2400 1650
Wire Wire Line
	1300 1900 1300 1950
Connection ~ 1300 1900
Wire Wire Line
	1300 1900 2450 1900
Wire Wire Line
	1200 1250 1200 1900
$Comp
L Device:R R1
U 1 1 60C17524
P 2550 1000
F 0 "R1" H 2620 1046 50  0000 L CNN
F 1 "1K" H 2620 955 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 2480 1000 50  0001 C CNN
F 3 "~" H 2550 1000 50  0001 C CNN
	1    2550 1000
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 60C1872F
P 2550 1600
F 0 "R2" H 2620 1646 50  0000 L CNN
F 1 "10K" H 2620 1555 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 2480 1600 50  0001 C CNN
F 3 "~" H 2550 1600 50  0001 C CNN
	1    2550 1600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2550 850  1900 850 
Wire Wire Line
	1900 850  1900 800 
Wire Wire Line
	1900 850  1900 1050
Connection ~ 1900 850 
Wire Wire Line
	2400 1450 2550 1450
Wire Wire Line
	2550 1750 2550 1900
Wire Wire Line
	2550 1900 2450 1900
Connection ~ 2450 1900
Wire Wire Line
	1400 1650 1300 1650
Wire Wire Line
	1300 1650 1300 850 
Wire Wire Line
	1300 850  1900 850 
Wire Wire Line
	2550 1150 2550 1450
Connection ~ 2550 1450
$Comp
L 74xx:74LS161 U2
U 1 1 60C1A912
P 3750 1550
F 0 "U2" H 3500 2200 50  0000 C CNN
F 1 "74HC161" H 3950 2200 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3750 1550 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 3750 1550 50  0001 C CNN
	1    3750 1550
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR04
U 1 1 60C1CE67
P 3750 700
F 0 "#PWR04" H 3750 550 50  0001 C CNN
F 1 "VCC" H 3765 873 50  0000 C CNN
F 2 "" H 3750 700 50  0001 C CNN
F 3 "" H 3750 700 50  0001 C CNN
	1    3750 700 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR05
U 1 1 60C1D37A
P 3750 2400
F 0 "#PWR05" H 3750 2150 50  0001 C CNN
F 1 "GND" H 3900 2300 50  0000 C CNN
F 2 "" H 3750 2400 50  0001 C CNN
F 3 "" H 3750 2400 50  0001 C CNN
	1    3750 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 700  3750 750 
Wire Wire Line
	3750 2350 3750 2400
Wire Wire Line
	2400 1250 2650 1250
Wire Wire Line
	2900 1250 2900 1850
Wire Wire Line
	2900 1850 3250 1850
NoConn ~ 4250 1550
NoConn ~ 4250 1350
NoConn ~ 4250 1250
Wire Wire Line
	3250 2050 3100 2050
Wire Wire Line
	3100 750  3750 750 
Wire Wire Line
	3100 750  3100 1050
Connection ~ 3750 750 
Wire Wire Line
	3250 1750 3100 1750
Connection ~ 3100 1750
Wire Wire Line
	3100 1750 3100 2050
Wire Wire Line
	3250 1650 3100 1650
Connection ~ 3100 1650
Wire Wire Line
	3100 1650 3100 1750
Wire Wire Line
	3250 1550 3100 1550
Connection ~ 3100 1550
Wire Wire Line
	3100 1550 3100 1650
Wire Wire Line
	3250 1350 3100 1350
Connection ~ 3100 1350
Wire Wire Line
	3100 1350 3100 1550
Wire Wire Line
	3250 1250 3100 1250
Connection ~ 3100 1250
Wire Wire Line
	3100 1250 3100 1350
Wire Wire Line
	3250 1150 3100 1150
Connection ~ 3100 1150
Wire Wire Line
	3100 1150 3100 1250
Wire Wire Line
	3250 1050 3100 1050
Connection ~ 3100 1050
Wire Wire Line
	3100 1050 3100 1150
$Comp
L 74xx:74LS138 U5
U 1 1 60C23349
P 5200 1350
F 0 "U5" H 4950 1800 50  0000 C CNN
F 1 "74HC138" H 5400 1800 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 5200 1350 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS138" H 5200 1350 50  0001 C CNN
	1    5200 1350
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR011
U 1 1 60C24EA5
P 5200 700
F 0 "#PWR011" H 5200 550 50  0001 C CNN
F 1 "VCC" H 5215 873 50  0000 C CNN
F 2 "" H 5200 700 50  0001 C CNN
F 3 "" H 5200 700 50  0001 C CNN
	1    5200 700 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 60C25351
P 5200 2100
F 0 "#PWR012" H 5200 1850 50  0001 C CNN
F 1 "GND" H 5205 1927 50  0000 C CNN
F 2 "" H 5200 2100 50  0001 C CNN
F 3 "" H 5200 2100 50  0001 C CNN
	1    5200 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5200 700  5200 750 
Wire Wire Line
	5200 2050 5200 2100
Wire Wire Line
	4700 1650 4650 1650
Wire Wire Line
	4650 1650 4650 1750
Wire Wire Line
	4650 1750 4700 1750
Wire Wire Line
	4650 1750 4650 2050
Wire Wire Line
	4650 2050 5200 2050
Connection ~ 4650 1750
Connection ~ 5200 2050
Wire Wire Line
	4700 1250 4650 1250
Wire Wire Line
	4650 1250 4650 1650
Connection ~ 4650 1650
Wire Wire Line
	4700 1550 4600 1550
Wire Wire Line
	4600 750  5200 750 
Wire Wire Line
	4600 750  4600 1550
Connection ~ 5200 750 
Wire Wire Line
	4250 1050 4550 1050
Wire Wire Line
	4250 1150 4500 1150
NoConn ~ 5700 1750
NoConn ~ 5700 1650
NoConn ~ 5700 1550
NoConn ~ 5700 1450
$Comp
L Custom:AT28C256J U1
U 1 1 60C2F5DA
P 6100 3900
F 0 "U1" H 5850 4950 50  0000 C CNN
F 1 "AT28C64" H 6350 4950 50  0000 C CNN
F 2 "Custom:PLCC-32_SMD-Socket" H 6100 3900 50  0001 C CNN
F 3 "http://www.kingbrightusa.com/images/catalog/SPEC/sc56-11ywa.pdf" H 6100 3900 50  0001 C CNN
	1    6100 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4550 3000 4550 1050
Connection ~ 4550 1050
Wire Wire Line
	4550 1050 4700 1050
Wire Wire Line
	4500 1150 4500 3100
Connection ~ 4500 1150
Wire Wire Line
	4500 1150 4700 1150
$Comp
L power:VCC #PWR017
U 1 1 60C351E9
P 6100 2700
F 0 "#PWR017" H 6100 2550 50  0001 C CNN
F 1 "VCC" H 6115 2873 50  0000 C CNN
F 2 "" H 6100 2700 50  0001 C CNN
F 3 "" H 6100 2700 50  0001 C CNN
	1    6100 2700
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR018
U 1 1 60C356DF
P 6100 5050
F 0 "#PWR018" H 6100 4800 50  0001 C CNN
F 1 "GND" H 6105 4877 50  0000 C CNN
F 2 "" H 6100 5050 50  0001 C CNN
F 3 "" H 6100 5050 50  0001 C CNN
	1    6100 5050
	1    0    0    -1  
$EndComp
Wire Wire Line
	6100 2700 6100 2800
Wire Wire Line
	6100 5000 6100 5050
Wire Wire Line
	5700 4700 5650 4700
Wire Wire Line
	5650 4700 5650 4800
Wire Wire Line
	5650 5000 6100 5000
Connection ~ 6100 5000
Wire Wire Line
	5700 4800 5650 4800
Connection ~ 5650 4800
Wire Wire Line
	5650 4800 5650 5000
$Comp
L power:VCC #PWR015
U 1 1 60C3BBC2
P 5500 4550
F 0 "#PWR015" H 5500 4400 50  0001 C CNN
F 1 "VCC" H 5600 4550 50  0000 C CNN
F 2 "" H 5500 4550 50  0001 C CNN
F 3 "" H 5500 4550 50  0001 C CNN
	1    5500 4550
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS161 U3
U 1 1 60C3EF5A
P 3750 3700
F 0 "U3" H 3500 4350 50  0000 C CNN
F 1 "74HC161" H 3950 4350 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3750 3700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 3750 3700 50  0001 C CNN
	1    3750 3700
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS161 U4
U 1 1 60C48B1B
P 3750 5700
F 0 "U4" H 3500 6350 50  0000 C CNN
F 1 "74HC161" H 3950 6350 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 3750 5700 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS161" H 3750 5700 50  0001 C CNN
	1    3750 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 3700 4300 3700
NoConn ~ 4250 5700
Wire Wire Line
	4300 3700 4300 4700
$Comp
L power:VCC #PWR06
U 1 1 60C6730E
P 3750 2850
F 0 "#PWR06" H 3750 2700 50  0001 C CNN
F 1 "VCC" H 3900 2950 50  0000 C CNN
F 2 "" H 3750 2850 50  0001 C CNN
F 3 "" H 3750 2850 50  0001 C CNN
	1    3750 2850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR07
U 1 1 60C67FCD
P 3750 4550
F 0 "#PWR07" H 3750 4300 50  0001 C CNN
F 1 "GND" H 3900 4450 50  0000 C CNN
F 2 "" H 3750 4550 50  0001 C CNN
F 3 "" H 3750 4550 50  0001 C CNN
	1    3750 4550
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR08
U 1 1 60C6840A
P 3750 4850
F 0 "#PWR08" H 3750 4700 50  0001 C CNN
F 1 "VCC" H 3900 4950 50  0000 C CNN
F 2 "" H 3750 4850 50  0001 C CNN
F 3 "" H 3750 4850 50  0001 C CNN
	1    3750 4850
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 5500 4500 5500
Wire Wire Line
	4500 3900 4500 5500
Wire Wire Line
	4250 5400 4450 5400
Wire Wire Line
	4450 3800 4450 5400
Wire Wire Line
	4250 5300 4400 5300
Wire Wire Line
	4400 3700 4400 5300
Wire Wire Line
	4250 5200 4350 5200
Wire Wire Line
	4350 3600 4350 5200
Wire Wire Line
	3250 6200 3200 6200
Wire Wire Line
	3200 6200 3200 4200
Wire Wire Line
	3200 4200 3250 4200
Wire Wire Line
	3250 6000 3150 6000
Wire Wire Line
	3150 4000 3250 4000
Wire Wire Line
	3150 4000 3150 6000
Wire Wire Line
	3250 5900 3100 5900
Wire Wire Line
	3100 5900 3100 4700
Wire Wire Line
	3100 4700 4300 4700
Wire Wire Line
	3250 5800 3050 5800
Wire Wire Line
	3050 5800 3050 3850
Wire Wire Line
	3050 3800 3250 3800
Wire Wire Line
	3250 5700 3000 5700
Wire Wire Line
	3000 5700 3000 3700
Wire Wire Line
	3000 3700 3250 3700
$Comp
L power:GND #PWR09
U 1 1 60C870AF
P 3750 6550
F 0 "#PWR09" H 3750 6300 50  0001 C CNN
F 1 "GND" H 3900 6450 50  0000 C CNN
F 2 "" H 3750 6550 50  0001 C CNN
F 3 "" H 3750 6550 50  0001 C CNN
	1    3750 6550
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 6500 3750 6550
Wire Wire Line
	3750 4850 3750 4900
Wire Wire Line
	3750 4500 3750 4550
Wire Wire Line
	3750 2850 3750 2900
$Comp
L Connector:Conn_01x08_Male J1
U 1 1 60C95259
P 1800 3350
F 0 "J1" H 1772 3278 50  0000 R CNN
F 1 "Conn_01x08_Male" H 1772 3233 50  0001 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 1800 3350 50  0001 C CNN
F 3 "~" H 1800 3350 50  0001 C CNN
	1    1800 3350
	-1   0    0    -1  
$EndComp
Text GLabel 1550 3750 0    50   Output ~ 0
BUS0
Text GLabel 1550 3650 0    50   Output ~ 0
BUS1
Text GLabel 1550 3550 0    50   Output ~ 0
BUS2
Text GLabel 1550 3450 0    50   Output ~ 0
BUS3
Text GLabel 1550 3350 0    50   Output ~ 0
BUS4
Text GLabel 1550 3250 0    50   Output ~ 0
BUS5
Text GLabel 1550 3150 0    50   Output ~ 0
BUS6
Text GLabel 1550 3050 0    50   Output ~ 0
BUS7
Text GLabel 3150 3200 0    50   Input ~ 0
BUS0
Text GLabel 3150 3300 0    50   Input ~ 0
BUS1
Text GLabel 3150 3400 0    50   Input ~ 0
BUS2
Text GLabel 3150 3500 0    50   Input ~ 0
BUS3
Text GLabel 2950 5200 0    50   Input ~ 0
BUS4
Text GLabel 2950 5300 0    50   Input ~ 0
BUS5
Text GLabel 2950 5400 0    50   Input ~ 0
BUS6
Text GLabel 2950 5500 0    50   Input ~ 0
BUS7
Wire Wire Line
	1550 3050 1600 3050
Wire Wire Line
	1600 3150 1550 3150
Wire Wire Line
	1550 3250 1600 3250
Wire Wire Line
	1600 3350 1550 3350
Wire Wire Line
	1550 3450 1600 3450
Wire Wire Line
	1600 3550 1550 3550
Wire Wire Line
	1550 3650 1600 3650
Wire Wire Line
	1600 3750 1550 3750
Wire Wire Line
	3150 3200 3250 3200
Wire Wire Line
	3250 3300 3150 3300
Wire Wire Line
	3150 3400 3250 3400
Wire Wire Line
	3250 3500 3150 3500
Wire Wire Line
	2950 5200 3250 5200
Wire Wire Line
	3250 5300 2950 5300
Wire Wire Line
	2950 5400 3250 5400
Wire Wire Line
	3250 5500 2950 5500
$Comp
L Connector:Conn_01x04_Male J2
U 1 1 60CF8352
P 1800 4100
F 0 "J2" H 1772 4028 50  0000 R CNN
F 1 "Conn_01x04_Male" H 1772 3983 50  0001 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 1800 4100 50  0001 C CNN
F 3 "~" H 1800 4100 50  0001 C CNN
	1    1800 4100
	-1   0    0    -1  
$EndComp
NoConn ~ 1600 4000
Text GLabel 1500 4050 0    50   Output ~ 0
~LOAD~
Text GLabel 1500 4200 0    50   Output ~ 0
COUNT
Text GLabel 1500 4350 0    50   Output ~ 0
~LOAD_M~
Wire Wire Line
	1500 4050 1550 4050
Wire Wire Line
	1550 4050 1550 4100
Wire Wire Line
	1550 4100 1600 4100
Wire Wire Line
	1500 4200 1600 4200
Wire Wire Line
	1500 4350 1550 4350
Wire Wire Line
	1550 4350 1550 4300
Wire Wire Line
	1550 4300 1600 4300
Text GLabel 2950 3700 0    50   Input ~ 0
~LOAD~
Wire Wire Line
	2950 3700 3000 3700
Connection ~ 3000 3700
Text GLabel 2950 3850 0    50   Input ~ 0
COUNT
Wire Wire Line
	2950 3850 3050 3850
Connection ~ 3050 3850
Wire Wire Line
	3050 3850 3050 3800
$Comp
L power:VCC #PWR03
U 1 1 60D168E5
P 3200 3650
F 0 "#PWR03" H 3200 3500 50  0001 C CNN
F 1 "VCC" H 3100 3700 50  0000 C CNN
F 2 "" H 3200 3650 50  0001 C CNN
F 3 "" H 3200 3650 50  0001 C CNN
	1    3200 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 3900 3200 3900
Wire Wire Line
	3200 3900 3200 3650
$Comp
L power:GND #PWR016
U 1 1 60D1CFEE
P 5600 4400
F 0 "#PWR016" H 5600 4150 50  0001 C CNN
F 1 "GND" H 5500 4400 50  0000 C CNN
F 2 "" H 5600 4400 50  0001 C CNN
F 3 "" H 5600 4400 50  0001 C CNN
	1    5600 4400
	1    0    0    -1  
$EndComp
Wire Wire Line
	5500 4600 5500 4550
Wire Wire Line
	5500 4600 5700 4600
$Comp
L 74xx:74LS173 U6
U 1 1 60D2EFB0
P 5250 6450
F 0 "U6" H 5000 7200 50  0000 C CNN
F 1 "74HC173" H 5450 7200 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 5250 6450 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS173" H 5250 6450 50  0001 C CNN
	1    5250 6450
	1    0    0    -1  
$EndComp
Text GLabel 4700 5850 0    50   Input ~ 0
BUS0
Text GLabel 4700 5950 0    50   Input ~ 0
BUS1
Text GLabel 4700 6050 0    50   Input ~ 0
BUS2
Wire Wire Line
	4700 5850 4750 5850
Wire Wire Line
	4700 5950 4750 5950
Wire Wire Line
	4700 6050 4750 6050
$Comp
L power:GND #PWR014
U 1 1 60D4E5EE
P 5250 7400
F 0 "#PWR014" H 5250 7150 50  0001 C CNN
F 1 "GND" H 5400 7300 50  0000 C CNN
F 2 "" H 5250 7400 50  0001 C CNN
F 3 "" H 5250 7400 50  0001 C CNN
	1    5250 7400
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR013
U 1 1 60D4EAC6
P 5250 5550
F 0 "#PWR013" H 5250 5400 50  0001 C CNN
F 1 "VCC" H 5400 5650 50  0000 C CNN
F 2 "" H 5250 5550 50  0001 C CNN
F 3 "" H 5250 5550 50  0001 C CNN
	1    5250 5550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR010
U 1 1 60D5B978
P 4650 6450
F 0 "#PWR010" H 4650 6200 50  0001 C CNN
F 1 "GND" H 4550 6450 50  0000 C CNN
F 2 "" H 4650 6450 50  0001 C CNN
F 3 "" H 4650 6450 50  0001 C CNN
	1    4650 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4750 6450 4650 6450
Wire Wire Line
	4750 6350 4650 6350
Wire Wire Line
	4650 6350 4650 6450
Connection ~ 4650 6450
Wire Wire Line
	5250 7350 5250 7400
Wire Wire Line
	4550 3000 5700 3000
Wire Wire Line
	4500 3100 5700 3100
Wire Wire Line
	4250 3200 5700 3200
Wire Wire Line
	4250 3300 5700 3300
Wire Wire Line
	4250 3400 5700 3400
Wire Wire Line
	4250 3500 5700 3500
Wire Wire Line
	4350 3600 5700 3600
Wire Wire Line
	4400 3700 5700 3700
Wire Wire Line
	4450 3800 5700 3800
Wire Wire Line
	4500 3900 5700 3900
Wire Wire Line
	5750 5850 5750 5250
Wire Wire Line
	5750 5250 5350 5250
Wire Wire Line
	5350 5250 5350 4000
Wire Wire Line
	5350 4000 5700 4000
Wire Wire Line
	5750 5950 5850 5950
Wire Wire Line
	5850 5950 5850 5300
Wire Wire Line
	5850 5300 5300 5300
Wire Wire Line
	5300 5300 5300 4100
Wire Wire Line
	5300 4100 5700 4100
Wire Wire Line
	5700 4200 5250 4200
Wire Wire Line
	5250 4200 5250 5350
Wire Wire Line
	5250 5350 5950 5350
Wire Wire Line
	5950 5350 5950 6050
Wire Wire Line
	5950 6050 5750 6050
Text GLabel 4650 6650 0    50   Input ~ 0
~LOAD_M~
Wire Wire Line
	4650 6650 4750 6650
Wire Wire Line
	4750 6750 4750 6650
Connection ~ 4750 6650
$Comp
L Connector:Conn_01x04_Male J3
U 1 1 60E67F45
P 1750 4900
F 0 "J3" H 1722 4828 50  0000 R CNN
F 1 "Conn_01x04_Male" H 1722 4783 50  0001 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 1750 4900 50  0001 C CNN
F 3 "~" H 1750 4900 50  0001 C CNN
	1    1750 4900
	-1   0    0    -1  
$EndComp
Text GLabel 1500 4800 0    50   Output ~ 0
CLK
Text GLabel 1500 5000 0    50   Output ~ 0
RESET
Text GLabel 1500 5150 0    50   Output ~ 0
~RESET~
Wire Wire Line
	1500 4800 1550 4800
Wire Wire Line
	1500 5000 1550 5000
Wire Wire Line
	1550 5100 1550 5150
Wire Wire Line
	1550 5150 1500 5150
Text GLabel 2950 4000 0    50   Input ~ 0
CLK
Wire Wire Line
	2950 4000 3150 4000
Connection ~ 3150 4000
Text GLabel 4650 6850 0    50   Input ~ 0
CLK
Wire Wire Line
	4650 6850 4750 6850
Text GLabel 4650 7050 0    50   Input ~ 0
RESET
Wire Wire Line
	4650 7050 4750 7050
Text GLabel 2950 4200 0    50   Input ~ 0
~RESET~
Wire Wire Line
	2950 4200 3200 4200
Connection ~ 3200 4200
$Comp
L Connector:Conn_01x04_Male J4
U 1 1 60EA8A11
P 10400 1150
F 0 "J4" H 10300 1100 50  0000 C CNN
F 1 "Conn_01x04_Male" H 10508 1340 50  0001 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x02_P2.54mm_Vertical" H 10400 1150 50  0001 C CNN
F 3 "~" H 10400 1150 50  0001 C CNN
	1    10400 1150
	-1   0    0    1   
$EndComp
Wire Wire Line
	10200 1050 10150 1050
Wire Wire Line
	10150 1050 10150 950 
Wire Wire Line
	10150 950  10200 950 
Wire Wire Line
	10200 1150 10150 1150
Wire Wire Line
	10150 1150 10150 1250
Wire Wire Line
	10150 1250 10200 1250
$Comp
L Connector:Conn_01x08_Female J5
U 1 1 60C6C15C
P 6700 3400
F 0 "J5" H 6800 3300 50  0000 C CNN
F 1 "DISP_ANODES" H 7000 3400 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 6700 3400 50  0001 C CNN
F 3 "~" H 6700 3400 50  0001 C CNN
	1    6700 3400
	1    0    0    1   
$EndComp
$Comp
L Connector:Conn_01x04_Female J6
U 1 1 60C6D3E3
P 5900 1150
F 0 "J6" H 6000 1100 50  0000 C CNN
F 1 "DISP_CATHODES" H 6300 1200 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 5900 1150 50  0001 C CNN
F 3 "~" H 5900 1150 50  0001 C CNN
	1    5900 1150
	1    0    0    -1  
$EndComp
Text GLabel 4700 6150 0    50   Input ~ 0
BUS3
Wire Wire Line
	4700 6150 4750 6150
Wire Wire Line
	5600 4400 5700 4400
Wire Wire Line
	5200 4300 5200 5400
Wire Wire Line
	5200 5400 6050 5400
Wire Wire Line
	6050 5400 6050 6150
Wire Wire Line
	6050 6150 5750 6150
Wire Wire Line
	5200 4300 5700 4300
$Comp
L power:VCC #PWR0101
U 1 1 60CA8508
P 10050 950
F 0 "#PWR0101" H 10050 800 50  0001 C CNN
F 1 "VCC" H 10065 1123 50  0000 C CNN
F 2 "" H 10050 950 50  0001 C CNN
F 3 "" H 10050 950 50  0001 C CNN
	1    10050 950 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 60CA90F2
P 10050 1250
F 0 "#PWR0102" H 10050 1000 50  0001 C CNN
F 1 "GND" H 10055 1077 50  0000 C CNN
F 2 "" H 10050 1250 50  0001 C CNN
F 3 "" H 10050 1250 50  0001 C CNN
	1    10050 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	10050 950  10150 950 
Connection ~ 10150 950 
Wire Wire Line
	10150 1250 10050 1250
Connection ~ 10150 1250
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 60CBC161
P 9950 950
F 0 "#FLG0101" H 9950 1025 50  0001 C CNN
F 1 "PWR_FLAG" H 9950 1123 50  0001 C CNN
F 2 "" H 9950 950 50  0001 C CNN
F 3 "~" H 9950 950 50  0001 C CNN
	1    9950 950 
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 60CBCC26
P 9950 1250
F 0 "#FLG0102" H 9950 1325 50  0001 C CNN
F 1 "PWR_FLAG" H 9950 1423 50  0001 C CNN
F 2 "" H 9950 1250 50  0001 C CNN
F 3 "~" H 9950 1250 50  0001 C CNN
	1    9950 1250
	-1   0    0    1   
$EndComp
Wire Wire Line
	9950 950  10050 950 
Connection ~ 10050 950 
Wire Wire Line
	10050 1250 9950 1250
Connection ~ 10050 1250
Text GLabel 1500 4900 0    50   Input ~ 0
CLK_O
Wire Wire Line
	1500 4900 1550 4900
Text GLabel 2700 1150 2    50   Output ~ 0
CLK_O
Wire Wire Line
	2700 1150 2650 1150
Wire Wire Line
	2650 1150 2650 1250
Connection ~ 2650 1250
Wire Wire Line
	2650 1250 2900 1250
$Comp
L Device:C C10
U 1 1 60CEDF51
P 9800 1100
F 0 "C10" H 9800 1200 50  0000 L CNN
F 1 "10uF" H 9700 1000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9838 950 50  0001 C CNN
F 3 "~" H 9800 1100 50  0001 C CNN
	1    9800 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C9
U 1 1 60CEF9C9
P 9550 1100
F 0 "C9" H 9550 1200 50  0000 L CNN
F 1 "100nF" H 9450 1000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9588 950 50  0001 C CNN
F 3 "~" H 9550 1100 50  0001 C CNN
	1    9550 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 60CEFCEA
P 9300 1100
F 0 "C8" H 9300 1200 50  0000 L CNN
F 1 "100nF" H 9200 1000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9338 950 50  0001 C CNN
F 3 "~" H 9300 1100 50  0001 C CNN
	1    9300 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C7
U 1 1 60CEFF9B
P 9050 1100
F 0 "C7" H 9050 1200 50  0000 L CNN
F 1 "100nF" H 8950 1000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 9088 950 50  0001 C CNN
F 3 "~" H 9050 1100 50  0001 C CNN
	1    9050 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C6
U 1 1 60CF0200
P 8800 1100
F 0 "C6" H 8800 1200 50  0000 L CNN
F 1 "100nF" H 8700 1000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 8838 950 50  0001 C CNN
F 3 "~" H 8800 1100 50  0001 C CNN
	1    8800 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 60CF055E
P 8550 1100
F 0 "C5" H 8550 1200 50  0000 L CNN
F 1 "100nF" H 8450 1000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 8588 950 50  0001 C CNN
F 3 "~" H 8550 1100 50  0001 C CNN
	1    8550 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 60CF087B
P 8300 1100
F 0 "C4" H 8300 1200 50  0000 L CNN
F 1 "100nF" H 8200 1000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 8338 950 50  0001 C CNN
F 3 "~" H 8300 1100 50  0001 C CNN
	1    8300 1100
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 60CF0CC8
P 8050 1100
F 0 "C3" H 8050 1200 50  0000 L CNN
F 1 "100nF" H 7950 1000 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 8088 950 50  0001 C CNN
F 3 "~" H 8050 1100 50  0001 C CNN
	1    8050 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	9950 950  9800 950 
Connection ~ 9950 950 
Wire Wire Line
	9800 950  9550 950 
Connection ~ 9800 950 
Wire Wire Line
	9300 950  9550 950 
Connection ~ 9550 950 
Wire Wire Line
	9050 950  9300 950 
Connection ~ 9300 950 
Wire Wire Line
	8800 950  9050 950 
Connection ~ 9050 950 
Wire Wire Line
	8550 950  8800 950 
Connection ~ 8800 950 
Wire Wire Line
	8300 950  8550 950 
Connection ~ 8550 950 
Wire Wire Line
	8050 950  8300 950 
Connection ~ 8300 950 
Wire Wire Line
	8050 1250 8300 1250
Wire Wire Line
	8300 1250 8550 1250
Wire Wire Line
	8550 1250 8800 1250
Connection ~ 8300 1250
Connection ~ 8550 1250
Wire Wire Line
	8800 1250 9050 1250
Connection ~ 8800 1250
Connection ~ 9050 1250
Wire Wire Line
	9050 1250 9300 1250
Connection ~ 9300 1250
Wire Wire Line
	9300 1250 9550 1250
Connection ~ 9550 1250
Wire Wire Line
	9550 1250 9800 1250
Wire Wire Line
	9800 1250 9950 1250
Connection ~ 9800 1250
Connection ~ 9950 1250
Text Label 4800 3000 0    50   ~ 0
MP_A0
Text Label 4800 3100 0    50   ~ 0
MP_A1
Text Label 4800 3200 0    50   ~ 0
V_A0
Text Label 4800 3300 0    50   ~ 0
V_A1
Text Label 4800 3400 0    50   ~ 0
V_A2
Text Label 4800 3500 0    50   ~ 0
V_A3
Text Label 4800 3600 0    50   ~ 0
V_A4
Text Label 4800 3700 0    50   ~ 0
V_A5
Text Label 4800 3800 0    50   ~ 0
V_A6
Text Label 4800 3900 0    50   ~ 0
V_A7
Text Label 5400 4000 0    50   ~ 0
M0
Text Label 5400 4100 0    50   ~ 0
M1
Text Label 5400 4200 0    50   ~ 0
M2
Text Label 5400 4300 0    50   ~ 0
M3
$Comp
L Connector:Conn_01x02_Male J7
U 1 1 60E40293
P 10400 1950
F 0 "J7" H 10300 1900 50  0000 C CNN
F 1 "AUX_VCC" H 10550 1800 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 10400 1950 50  0001 C CNN
F 3 "~" H 10400 1950 50  0001 C CNN
	1    10400 1950
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Male J8
U 1 1 60E406F8
P 10400 2400
F 0 "J8" H 10300 2350 50  0000 C CNN
F 1 "AUX_GND" H 10550 2500 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 10400 2400 50  0001 C CNN
F 3 "~" H 10400 2400 50  0001 C CNN
	1    10400 2400
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR019
U 1 1 60E40C2F
P 10700 1800
F 0 "#PWR019" H 10700 1650 50  0001 C CNN
F 1 "VCC" H 10715 1973 50  0000 C CNN
F 2 "" H 10700 1800 50  0001 C CNN
F 3 "" H 10700 1800 50  0001 C CNN
	1    10700 1800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR020
U 1 1 60E414DE
P 10700 2550
F 0 "#PWR020" H 10700 2300 50  0001 C CNN
F 1 "GND" H 10705 2377 50  0000 C CNN
F 2 "" H 10700 2550 50  0001 C CNN
F 3 "" H 10700 2550 50  0001 C CNN
	1    10700 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	10600 2050 10700 2050
Wire Wire Line
	10700 2050 10700 1950
Wire Wire Line
	10600 1950 10700 1950
Connection ~ 10700 1950
Wire Wire Line
	10700 1950 10700 1800
Wire Wire Line
	10600 2400 10700 2400
Wire Wire Line
	10700 2400 10700 2500
Wire Wire Line
	10600 2500 10700 2500
Connection ~ 10700 2500
Wire Wire Line
	10700 2500 10700 2550
$Comp
L Connector:Conn_01x02_Female J9
U 1 1 60EA0DCE
P 9850 1950
F 0 "J9" H 9878 1926 50  0000 L CNN
F 1 "VCC_OUT" H 9600 1800 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x02_P2.54mm_Vertical" H 9850 1950 50  0001 C CNN
F 3 "~" H 9850 1950 50  0001 C CNN
	1    9850 1950
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x02_Female J10
U 1 1 60EA1C35
P 9850 2400
F 0 "J10" H 9878 2376 50  0000 L CNN
F 1 "GND_OUT" H 9600 2500 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x02_P2.54mm_Vertical" H 9850 2400 50  0001 C CNN
F 3 "~" H 9850 2400 50  0001 C CNN
	1    9850 2400
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR021
U 1 1 60EA1F9C
P 9600 1850
F 0 "#PWR021" H 9600 1700 50  0001 C CNN
F 1 "VCC" H 9615 2023 50  0000 C CNN
F 2 "" H 9600 1850 50  0001 C CNN
F 3 "" H 9600 1850 50  0001 C CNN
	1    9600 1850
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR022
U 1 1 60EA2684
P 9600 2550
F 0 "#PWR022" H 9600 2300 50  0001 C CNN
F 1 "GND" H 9605 2377 50  0000 C CNN
F 2 "" H 9600 2550 50  0001 C CNN
F 3 "" H 9600 2550 50  0001 C CNN
	1    9600 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	9600 1850 9600 1950
Wire Wire Line
	9600 1950 9650 1950
Wire Wire Line
	9600 1950 9600 2050
Wire Wire Line
	9600 2050 9650 2050
Connection ~ 9600 1950
Wire Wire Line
	9650 2400 9600 2400
Wire Wire Line
	9600 2400 9600 2500
Wire Wire Line
	9650 2500 9600 2500
Connection ~ 9600 2500
Wire Wire Line
	9600 2500 9600 2550
Text GLabel 1400 6100 0    50   Output ~ 0
~LOAD~
Text GLabel 1400 6550 0    50   Output ~ 0
COUNT
Text GLabel 1400 6250 0    50   Output ~ 0
~LOAD_M~
Text GLabel 1400 6700 0    50   Output ~ 0
RESET
Text GLabel 1400 6400 0    50   Output ~ 0
~RESET~
$Comp
L Device:R R3
U 1 1 60FE8E4A
P 1600 6100
F 0 "R3" V 1600 5750 50  0000 L CNN
F 1 "10K" V 1600 6050 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1530 6100 50  0001 C CNN
F 3 "~" H 1600 6100 50  0001 C CNN
	1    1600 6100
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R4
U 1 1 610367D1
P 1600 6250
F 0 "R4" V 1600 5900 50  0000 L CNN
F 1 "10K" V 1600 6200 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1530 6250 50  0001 C CNN
F 3 "~" H 1600 6250 50  0001 C CNN
	1    1600 6250
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R5
U 1 1 61036974
P 1600 6400
F 0 "R5" V 1600 6050 50  0000 L CNN
F 1 "100K" V 1600 6300 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1530 6400 50  0001 C CNN
F 3 "~" H 1600 6400 50  0001 C CNN
	1    1600 6400
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R6
U 1 1 61036BB3
P 1600 6550
F 0 "R6" V 1600 6200 50  0000 L CNN
F 1 "10K" V 1600 6500 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1530 6550 50  0001 C CNN
F 3 "~" H 1600 6550 50  0001 C CNN
	1    1600 6550
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R7
U 1 1 61036E99
P 1600 6700
F 0 "R7" V 1600 6350 50  0000 L CNN
F 1 "100K" V 1600 6600 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 1530 6700 50  0001 C CNN
F 3 "~" H 1600 6700 50  0001 C CNN
	1    1600 6700
	0    -1   -1   0   
$EndComp
$Comp
L power:VCC #PWR023
U 1 1 6103758C
P 1800 6050
F 0 "#PWR023" H 1800 5900 50  0001 C CNN
F 1 "VCC" H 1950 6150 50  0000 C CNN
F 2 "" H 1800 6050 50  0001 C CNN
F 3 "" H 1800 6050 50  0001 C CNN
	1    1800 6050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR024
U 1 1 61037D47
P 1800 6750
F 0 "#PWR024" H 1800 6500 50  0001 C CNN
F 1 "GND" H 1950 6650 50  0000 C CNN
F 2 "" H 1800 6750 50  0001 C CNN
F 3 "" H 1800 6750 50  0001 C CNN
	1    1800 6750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 6400 1800 6400
Wire Wire Line
	1800 6400 1800 6250
Wire Wire Line
	1750 6250 1800 6250
Connection ~ 1800 6250
Wire Wire Line
	1800 6250 1800 6100
Wire Wire Line
	1750 6100 1800 6100
Connection ~ 1800 6100
Wire Wire Line
	1800 6100 1800 6050
Wire Wire Line
	1750 6550 1800 6550
Wire Wire Line
	1800 6550 1800 6700
Wire Wire Line
	1750 6700 1800 6700
Connection ~ 1800 6700
Wire Wire Line
	1800 6700 1800 6750
Wire Wire Line
	1400 6100 1450 6100
Wire Wire Line
	1450 6250 1400 6250
Wire Wire Line
	1400 6400 1450 6400
Wire Wire Line
	1450 6550 1400 6550
Wire Wire Line
	1400 6700 1450 6700
$EndSCHEMATC
