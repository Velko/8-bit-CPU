EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 1 1
Title "ALU backplane"
Date "2021-07-04"
Rev "1.1"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Entry Wire Line
	3200 1300 3300 1200
Entry Wire Line
	3300 1300 3400 1200
Entry Wire Line
	3400 1300 3500 1200
Entry Wire Line
	3500 1300 3600 1200
Entry Wire Line
	3600 1300 3700 1200
Entry Wire Line
	3700 1300 3800 1200
Entry Wire Line
	3800 1300 3900 1200
Entry Wire Line
	3900 1300 4000 1200
Entry Wire Line
	4100 1400 4200 1300
Entry Wire Line
	4200 1400 4300 1300
Entry Wire Line
	4300 1400 4400 1300
Entry Wire Line
	4400 1400 4500 1300
Entry Wire Line
	4500 1400 4600 1300
Entry Wire Line
	4600 1400 4700 1300
Entry Wire Line
	4700 1400 4800 1300
Entry Wire Line
	4800 1400 4900 1300
Entry Wire Line
	4100 2650 4200 2750
Entry Wire Line
	4200 2650 4300 2750
Entry Wire Line
	4300 2650 4400 2750
Entry Wire Line
	4400 2650 4500 2750
Entry Wire Line
	4500 2650 4600 2750
Entry Wire Line
	4600 2650 4700 2750
Entry Wire Line
	4700 2650 4800 2750
Entry Wire Line
	4800 2650 4900 2750
$Comp
L power:VCC #PWR09
U 1 1 60752E2C
P 2800 1500
F 0 "#PWR09" H 2800 1350 50  0001 C CNN
F 1 "VCC" H 2750 1650 50  0000 C CNN
F 2 "" H 2800 1500 50  0001 C CNN
F 3 "" H 2800 1500 50  0001 C CNN
	1    2800 1500
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR02
U 1 1 60753BAA
P 2600 1950
F 0 "#PWR02" H 2600 1800 50  0001 C CNN
F 1 "VCC" V 2615 2077 50  0000 L CNN
F 2 "" H 2600 1950 50  0001 C CNN
F 3 "" H 2600 1950 50  0001 C CNN
	1    2600 1950
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR013
U 1 1 607546B6
P 2900 1500
F 0 "#PWR013" H 2900 1250 50  0001 C CNN
F 1 "GND" H 2800 1500 50  0000 C CNN
F 2 "" H 2900 1500 50  0001 C CNN
F 3 "" H 2900 1500 50  0001 C CNN
	1    2900 1500
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR01
U 1 1 607553B4
P 2600 1850
F 0 "#PWR01" H 2600 1600 50  0001 C CNN
F 1 "GND" V 2600 1650 50  0000 C CNN
F 2 "" H 2600 1850 50  0001 C CNN
F 3 "" H 2600 1850 50  0001 C CNN
	1    2600 1850
	0    1    1    0   
$EndComp
Text GLabel 3300 2600 3    50   Input ~ 0
CLK
Text GLabel 3450 2600 3    50   Input ~ 0
~CLK~
Text GLabel 3600 2600 3    50   Input ~ 0
RESET
Wire Wire Line
	3450 2550 3450 2600
Wire Wire Line
	3550 2550 3600 2550
Wire Wire Line
	3600 2550 3600 2600
Wire Wire Line
	3350 2550 3300 2550
Wire Wire Line
	3300 2550 3300 2600
Text GLabel 12050 1500 2    50   Output ~ 0
CLK
Text GLabel 12050 1650 2    50   Output ~ 0
~CLK~
Text GLabel 12050 1800 2    50   Output ~ 0
RESET
$Comp
L Connector:Conn_01x04_Female J1
U 1 1 608088C3
P 11750 1700
F 0 "J1" H 11642 1275 50  0000 C CNN
F 1 "SYNC" H 11642 1366 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 11750 1700 50  0001 C CNN
F 3 "~" H 11750 1700 50  0001 C CNN
	1    11750 1700
	-1   0    0    1   
$EndComp
Wire Wire Line
	11950 1500 12050 1500
Wire Wire Line
	11950 1600 12000 1600
Wire Wire Line
	12000 1600 12000 1650
Wire Wire Line
	12000 1650 12050 1650
Wire Wire Line
	11950 1700 12000 1700
Wire Wire Line
	12000 1700 12000 1800
Wire Wire Line
	12000 1800 12050 1800
Wire Wire Line
	3800 1300 3800 1500
Wire Wire Line
	3700 1300 3700 1500
Wire Wire Line
	3600 1300 3600 1500
Wire Wire Line
	3500 1300 3500 1500
Wire Wire Line
	3400 1300 3400 1500
Wire Wire Line
	3300 1300 3300 1500
Wire Wire Line
	3200 1300 3200 1500
Text Label 3900 1500 1    50   ~ 0
BUS0
Text Label 3800 1500 1    50   ~ 0
BUS1
Text Label 3700 1500 1    50   ~ 0
BUS2
Text Label 3600 1500 1    50   ~ 0
BUS3
Text Label 3500 1500 1    50   ~ 0
BUS4
Text Label 3400 1500 1    50   ~ 0
BUS5
Text Label 3300 1500 1    50   ~ 0
BUS6
Text Label 3200 1500 1    50   ~ 0
BUS7
Text Label 4800 1500 1    50   ~ 0
L0
Text Label 4700 1500 1    50   ~ 0
L1
Text Label 4600 1500 1    50   ~ 0
L2
Text Label 4500 1500 1    50   ~ 0
L3
Text Label 4400 1500 1    50   ~ 0
L4
Text Label 4300 1500 1    50   ~ 0
L5
Text Label 4200 1500 1    50   ~ 0
L6
Text Label 4100 1500 1    50   ~ 0
L7
Text Label 4800 2650 1    50   ~ 0
R0
Text Label 4700 2650 1    50   ~ 0
R1
Text Label 4600 2650 1    50   ~ 0
R2
Text Label 4500 2650 1    50   ~ 0
R3
Text Label 4400 2650 1    50   ~ 0
R4
Text Label 4300 2650 1    50   ~ 0
R5
Text Label 4200 2650 1    50   ~ 0
R6
Text Label 4100 2650 1    50   ~ 0
R7
Wire Wire Line
	4800 2550 4800 2650
Wire Wire Line
	4700 2550 4700 2650
Wire Wire Line
	4600 2550 4600 2650
Wire Wire Line
	4500 2550 4500 2650
Wire Wire Line
	4400 2550 4400 2650
Wire Wire Line
	4300 2550 4300 2650
Wire Wire Line
	4200 2550 4200 2650
Wire Wire Line
	4100 2550 4100 2650
Wire Wire Line
	4800 1400 4800 1500
Wire Wire Line
	4700 1400 4700 1500
Wire Wire Line
	4600 1400 4600 1500
Wire Wire Line
	4500 1400 4500 1500
Wire Wire Line
	4400 1400 4400 1500
Wire Wire Line
	4300 1400 4300 1500
Wire Wire Line
	4200 1400 4200 1500
Wire Wire Line
	4100 1400 4100 1500
Wire Wire Line
	3900 1300 3900 1500
$Comp
L CPU_Modules:Register U2
U 1 1 608758D7
P 3800 3750
F 0 "U2" H 3350 3750 50  0000 L CNN
F 1 "Register B" H 4150 3750 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 2350 5100 50  0001 C CNN
F 3 "" H 2350 5100 50  0001 C CNN
	1    3800 3750
	1    0    0    -1  
$EndComp
Entry Wire Line
	3200 3050 3300 2950
Entry Wire Line
	3300 3050 3400 2950
Entry Wire Line
	3400 3050 3500 2950
Entry Wire Line
	3500 3050 3600 2950
Entry Wire Line
	3600 3050 3700 2950
Entry Wire Line
	3700 3050 3800 2950
Entry Wire Line
	3800 3050 3900 2950
Entry Wire Line
	3900 3050 4000 2950
Entry Wire Line
	4100 3150 4200 3050
Entry Wire Line
	4200 3150 4300 3050
Entry Wire Line
	4300 3150 4400 3050
Entry Wire Line
	4400 3150 4500 3050
Entry Wire Line
	4500 3150 4600 3050
Entry Wire Line
	4600 3150 4700 3050
Entry Wire Line
	4700 3150 4800 3050
Entry Wire Line
	4800 3150 4900 3050
Entry Wire Line
	4100 4400 4200 4500
Entry Wire Line
	4200 4400 4300 4500
Entry Wire Line
	4300 4400 4400 4500
Entry Wire Line
	4400 4400 4500 4500
Entry Wire Line
	4500 4400 4600 4500
Entry Wire Line
	4600 4400 4700 4500
Entry Wire Line
	4700 4400 4800 4500
Entry Wire Line
	4800 4400 4900 4500
$Comp
L power:VCC #PWR0101
U 1 1 608758F5
P 2800 3250
F 0 "#PWR0101" H 2800 3100 50  0001 C CNN
F 1 "VCC" H 2750 3400 50  0000 C CNN
F 2 "" H 2800 3250 50  0001 C CNN
F 3 "" H 2800 3250 50  0001 C CNN
	1    2800 3250
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0102
U 1 1 608758FB
P 2600 3700
F 0 "#PWR0102" H 2600 3550 50  0001 C CNN
F 1 "VCC" V 2615 3827 50  0000 L CNN
F 2 "" H 2600 3700 50  0001 C CNN
F 3 "" H 2600 3700 50  0001 C CNN
	1    2600 3700
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 60875901
P 2900 3250
F 0 "#PWR0103" H 2900 3000 50  0001 C CNN
F 1 "GND" H 2800 3250 50  0000 C CNN
F 2 "" H 2900 3250 50  0001 C CNN
F 3 "" H 2900 3250 50  0001 C CNN
	1    2900 3250
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 60875907
P 2600 3600
F 0 "#PWR0104" H 2600 3350 50  0001 C CNN
F 1 "GND" V 2600 3400 50  0000 C CNN
F 2 "" H 2600 3600 50  0001 C CNN
F 3 "" H 2600 3600 50  0001 C CNN
	1    2600 3600
	0    1    1    0   
$EndComp
Text GLabel 3300 4350 3    50   Input ~ 0
CLK
Text GLabel 3450 4350 3    50   Input ~ 0
~CLK~
Text GLabel 3600 4350 3    50   Input ~ 0
RESET
Wire Wire Line
	3450 4300 3450 4350
Wire Wire Line
	3550 4300 3600 4300
Wire Wire Line
	3600 4300 3600 4350
Wire Wire Line
	3350 4300 3300 4300
Wire Wire Line
	3300 4300 3300 4350
Wire Wire Line
	3800 3050 3800 3250
Wire Wire Line
	3700 3050 3700 3250
Wire Wire Line
	3600 3050 3600 3250
Wire Wire Line
	3500 3050 3500 3250
Wire Wire Line
	3400 3050 3400 3250
Wire Wire Line
	3300 3050 3300 3250
Wire Wire Line
	3200 3050 3200 3250
Text Label 3900 3250 1    50   ~ 0
BUS0
Text Label 3800 3250 1    50   ~ 0
BUS1
Text Label 3700 3250 1    50   ~ 0
BUS2
Text Label 3600 3250 1    50   ~ 0
BUS3
Text Label 3500 3250 1    50   ~ 0
BUS4
Text Label 3400 3250 1    50   ~ 0
BUS5
Text Label 3300 3250 1    50   ~ 0
BUS6
Text Label 3200 3250 1    50   ~ 0
BUS7
Text Label 4800 3250 1    50   ~ 0
L0
Text Label 4700 3250 1    50   ~ 0
L1
Text Label 4600 3250 1    50   ~ 0
L2
Text Label 4500 3250 1    50   ~ 0
L3
Text Label 4400 3250 1    50   ~ 0
L4
Text Label 4300 3250 1    50   ~ 0
L5
Text Label 4200 3250 1    50   ~ 0
L6
Text Label 4100 3250 1    50   ~ 0
L7
Text Label 4800 4400 1    50   ~ 0
R0
Text Label 4700 4400 1    50   ~ 0
R1
Text Label 4600 4400 1    50   ~ 0
R2
Text Label 4500 4400 1    50   ~ 0
R3
Text Label 4400 4400 1    50   ~ 0
R4
Text Label 4300 4400 1    50   ~ 0
R5
Text Label 4200 4400 1    50   ~ 0
R6
Text Label 4100 4400 1    50   ~ 0
R7
Wire Wire Line
	4800 4300 4800 4400
Wire Wire Line
	4700 4300 4700 4400
Wire Wire Line
	4600 4300 4600 4400
Wire Wire Line
	4500 4300 4500 4400
Wire Wire Line
	4400 4300 4400 4400
Wire Wire Line
	4300 4300 4300 4400
Wire Wire Line
	4200 4300 4200 4400
Wire Wire Line
	4100 4300 4100 4400
Wire Wire Line
	4800 3150 4800 3250
Wire Wire Line
	4700 3150 4700 3250
Wire Wire Line
	4600 3150 4600 3250
Wire Wire Line
	4500 3150 4500 3250
Wire Wire Line
	4400 3150 4400 3250
Wire Wire Line
	4300 3150 4300 3250
Wire Wire Line
	4200 3150 4200 3250
Wire Wire Line
	4100 3150 4100 3250
Wire Wire Line
	3900 3050 3900 3250
$Comp
L CPU_Modules:Register U3
U 1 1 6087FC4D
P 3800 5500
F 0 "U3" H 3350 5500 50  0000 L CNN
F 1 "Register C" H 4150 5500 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 2350 6850 50  0001 C CNN
F 3 "" H 2350 6850 50  0001 C CNN
	1    3800 5500
	1    0    0    -1  
$EndComp
Entry Wire Line
	3200 4800 3300 4700
Entry Wire Line
	3300 4800 3400 4700
Entry Wire Line
	3400 4800 3500 4700
Entry Wire Line
	3500 4800 3600 4700
Entry Wire Line
	3600 4800 3700 4700
Entry Wire Line
	3700 4800 3800 4700
Entry Wire Line
	3800 4800 3900 4700
Entry Wire Line
	3900 4800 4000 4700
Entry Wire Line
	4100 4900 4200 4800
Entry Wire Line
	4200 4900 4300 4800
Entry Wire Line
	4300 4900 4400 4800
Entry Wire Line
	4400 4900 4500 4800
Entry Wire Line
	4500 4900 4600 4800
Entry Wire Line
	4600 4900 4700 4800
Entry Wire Line
	4700 4900 4800 4800
Entry Wire Line
	4800 4900 4900 4800
Entry Wire Line
	4100 6150 4200 6250
Entry Wire Line
	4200 6150 4300 6250
Entry Wire Line
	4300 6150 4400 6250
Entry Wire Line
	4400 6150 4500 6250
Entry Wire Line
	4500 6150 4600 6250
Entry Wire Line
	4600 6150 4700 6250
Entry Wire Line
	4700 6150 4800 6250
Entry Wire Line
	4800 6150 4900 6250
$Comp
L power:VCC #PWR0105
U 1 1 6087FC6B
P 2800 5000
F 0 "#PWR0105" H 2800 4850 50  0001 C CNN
F 1 "VCC" H 2750 5150 50  0000 C CNN
F 2 "" H 2800 5000 50  0001 C CNN
F 3 "" H 2800 5000 50  0001 C CNN
	1    2800 5000
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0106
U 1 1 6087FC71
P 2600 5450
F 0 "#PWR0106" H 2600 5300 50  0001 C CNN
F 1 "VCC" V 2615 5577 50  0000 L CNN
F 2 "" H 2600 5450 50  0001 C CNN
F 3 "" H 2600 5450 50  0001 C CNN
	1    2600 5450
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 6087FC77
P 2900 5000
F 0 "#PWR0107" H 2900 4750 50  0001 C CNN
F 1 "GND" H 2800 5000 50  0000 C CNN
F 2 "" H 2900 5000 50  0001 C CNN
F 3 "" H 2900 5000 50  0001 C CNN
	1    2900 5000
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 6087FC7D
P 2600 5350
F 0 "#PWR0108" H 2600 5100 50  0001 C CNN
F 1 "GND" V 2600 5150 50  0000 C CNN
F 2 "" H 2600 5350 50  0001 C CNN
F 3 "" H 2600 5350 50  0001 C CNN
	1    2600 5350
	0    1    1    0   
$EndComp
Text GLabel 3300 6100 3    50   Input ~ 0
CLK
Text GLabel 3450 6100 3    50   Input ~ 0
~CLK~
Text GLabel 3600 6100 3    50   Input ~ 0
RESET
Wire Wire Line
	3450 6050 3450 6100
Wire Wire Line
	3550 6050 3600 6050
Wire Wire Line
	3600 6050 3600 6100
Wire Wire Line
	3350 6050 3300 6050
Wire Wire Line
	3300 6050 3300 6100
Wire Wire Line
	3800 4800 3800 5000
Wire Wire Line
	3700 4800 3700 5000
Wire Wire Line
	3600 4800 3600 5000
Wire Wire Line
	3500 4800 3500 5000
Wire Wire Line
	3400 4800 3400 5000
Wire Wire Line
	3300 4800 3300 5000
Wire Wire Line
	3200 4800 3200 5000
Text Label 3900 5000 1    50   ~ 0
BUS0
Text Label 3800 5000 1    50   ~ 0
BUS1
Text Label 3700 5000 1    50   ~ 0
BUS2
Text Label 3600 5000 1    50   ~ 0
BUS3
Text Label 3500 5000 1    50   ~ 0
BUS4
Text Label 3400 5000 1    50   ~ 0
BUS5
Text Label 3300 5000 1    50   ~ 0
BUS6
Text Label 3200 5000 1    50   ~ 0
BUS7
Text Label 4800 5000 1    50   ~ 0
L0
Text Label 4700 5000 1    50   ~ 0
L1
Text Label 4600 5000 1    50   ~ 0
L2
Text Label 4500 5000 1    50   ~ 0
L3
Text Label 4400 5000 1    50   ~ 0
L4
Text Label 4300 5000 1    50   ~ 0
L5
Text Label 4200 5000 1    50   ~ 0
L6
Text Label 4100 5000 1    50   ~ 0
L7
Text Label 4800 6150 1    50   ~ 0
R0
Text Label 4700 6150 1    50   ~ 0
R1
Text Label 4600 6150 1    50   ~ 0
R2
Text Label 4500 6150 1    50   ~ 0
R3
Text Label 4400 6150 1    50   ~ 0
R4
Text Label 4300 6150 1    50   ~ 0
R5
Text Label 4200 6150 1    50   ~ 0
R6
Text Label 4100 6150 1    50   ~ 0
R7
Wire Wire Line
	4800 6050 4800 6150
Wire Wire Line
	4700 6050 4700 6150
Wire Wire Line
	4600 6050 4600 6150
Wire Wire Line
	4500 6050 4500 6150
Wire Wire Line
	4400 6050 4400 6150
Wire Wire Line
	4300 6050 4300 6150
Wire Wire Line
	4200 6050 4200 6150
Wire Wire Line
	4100 6050 4100 6150
Wire Wire Line
	4800 4900 4800 5000
Wire Wire Line
	4700 4900 4700 5000
Wire Wire Line
	4600 4900 4600 5000
Wire Wire Line
	4500 4900 4500 5000
Wire Wire Line
	4400 4900 4400 5000
Wire Wire Line
	4300 4900 4300 5000
Wire Wire Line
	4200 4900 4200 5000
Wire Wire Line
	4100 4900 4100 5000
Wire Wire Line
	3900 4800 3900 5000
$Comp
L CPU_Modules:Register U4
U 1 1 6088974D
P 3800 7250
F 0 "U4" H 3350 7250 50  0000 L CNN
F 1 "Register D" H 4150 7250 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 2350 8600 50  0001 C CNN
F 3 "" H 2350 8600 50  0001 C CNN
	1    3800 7250
	1    0    0    -1  
$EndComp
Entry Wire Line
	3200 6550 3300 6450
Entry Wire Line
	3300 6550 3400 6450
Entry Wire Line
	3400 6550 3500 6450
Entry Wire Line
	3500 6550 3600 6450
Entry Wire Line
	3600 6550 3700 6450
Entry Wire Line
	3700 6550 3800 6450
Entry Wire Line
	3800 6550 3900 6450
Entry Wire Line
	3900 6550 4000 6450
Entry Wire Line
	4100 6650 4200 6550
Entry Wire Line
	4200 6650 4300 6550
Entry Wire Line
	4300 6650 4400 6550
Entry Wire Line
	4400 6650 4500 6550
Entry Wire Line
	4500 6650 4600 6550
Entry Wire Line
	4600 6650 4700 6550
Entry Wire Line
	4700 6650 4800 6550
Entry Wire Line
	4800 6650 4900 6550
Entry Wire Line
	4100 7900 4200 8000
Entry Wire Line
	4200 7900 4300 8000
Entry Wire Line
	4300 7900 4400 8000
Entry Wire Line
	4400 7900 4500 8000
Entry Wire Line
	4500 7900 4600 8000
Entry Wire Line
	4600 7900 4700 8000
Entry Wire Line
	4700 7900 4800 8000
Entry Wire Line
	4800 7900 4900 8000
$Comp
L power:VCC #PWR0109
U 1 1 6088976B
P 2800 6750
F 0 "#PWR0109" H 2800 6600 50  0001 C CNN
F 1 "VCC" H 2750 6900 50  0000 C CNN
F 2 "" H 2800 6750 50  0001 C CNN
F 3 "" H 2800 6750 50  0001 C CNN
	1    2800 6750
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0110
U 1 1 60889771
P 2600 7200
F 0 "#PWR0110" H 2600 7050 50  0001 C CNN
F 1 "VCC" V 2615 7327 50  0000 L CNN
F 2 "" H 2600 7200 50  0001 C CNN
F 3 "" H 2600 7200 50  0001 C CNN
	1    2600 7200
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0111
U 1 1 60889777
P 2900 6750
F 0 "#PWR0111" H 2900 6500 50  0001 C CNN
F 1 "GND" H 2800 6750 50  0000 C CNN
F 2 "" H 2900 6750 50  0001 C CNN
F 3 "" H 2900 6750 50  0001 C CNN
	1    2900 6750
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0112
U 1 1 6088977D
P 2600 7100
F 0 "#PWR0112" H 2600 6850 50  0001 C CNN
F 1 "GND" V 2600 6900 50  0000 C CNN
F 2 "" H 2600 7100 50  0001 C CNN
F 3 "" H 2600 7100 50  0001 C CNN
	1    2600 7100
	0    1    1    0   
$EndComp
Text GLabel 3300 7850 3    50   Input ~ 0
CLK
Text GLabel 3450 7850 3    50   Input ~ 0
~CLK~
Text GLabel 3600 7850 3    50   Input ~ 0
RESET
Wire Wire Line
	3450 7800 3450 7850
Wire Wire Line
	3550 7800 3600 7800
Wire Wire Line
	3600 7800 3600 7850
Wire Wire Line
	3350 7800 3300 7800
Wire Wire Line
	3300 7800 3300 7850
Wire Wire Line
	3800 6550 3800 6750
Wire Wire Line
	3700 6550 3700 6750
Wire Wire Line
	3600 6550 3600 6750
Wire Wire Line
	3500 6550 3500 6750
Wire Wire Line
	3400 6550 3400 6750
Wire Wire Line
	3300 6550 3300 6750
Wire Wire Line
	3200 6550 3200 6750
Text Label 3900 6750 1    50   ~ 0
BUS0
Text Label 3800 6750 1    50   ~ 0
BUS1
Text Label 3700 6750 1    50   ~ 0
BUS2
Text Label 3600 6750 1    50   ~ 0
BUS3
Text Label 3500 6750 1    50   ~ 0
BUS4
Text Label 3400 6750 1    50   ~ 0
BUS5
Text Label 3300 6750 1    50   ~ 0
BUS6
Text Label 3200 6750 1    50   ~ 0
BUS7
Text Label 4800 6750 1    50   ~ 0
L0
Text Label 4700 6750 1    50   ~ 0
L1
Text Label 4600 6750 1    50   ~ 0
L2
Text Label 4500 6750 1    50   ~ 0
L3
Text Label 4400 6750 1    50   ~ 0
L4
Text Label 4300 6750 1    50   ~ 0
L5
Text Label 4200 6750 1    50   ~ 0
L6
Text Label 4100 6750 1    50   ~ 0
L7
Text Label 4800 7900 1    50   ~ 0
R0
Text Label 4700 7900 1    50   ~ 0
R1
Text Label 4600 7900 1    50   ~ 0
R2
Text Label 4500 7900 1    50   ~ 0
R3
Text Label 4400 7900 1    50   ~ 0
R4
Text Label 4300 7900 1    50   ~ 0
R5
Text Label 4200 7900 1    50   ~ 0
R6
Text Label 4100 7900 1    50   ~ 0
R7
Wire Wire Line
	4800 7800 4800 7900
Wire Wire Line
	4700 7800 4700 7900
Wire Wire Line
	4600 7800 4600 7900
Wire Wire Line
	4500 7800 4500 7900
Wire Wire Line
	4400 7800 4400 7900
Wire Wire Line
	4300 7800 4300 7900
Wire Wire Line
	4200 7800 4200 7900
Wire Wire Line
	4100 7800 4100 7900
Wire Wire Line
	4800 6650 4800 6750
Wire Wire Line
	4700 6650 4700 6750
Wire Wire Line
	4600 6650 4600 6750
Wire Wire Line
	4500 6650 4500 6750
Wire Wire Line
	4400 6650 4400 6750
Wire Wire Line
	4300 6650 4300 6750
Wire Wire Line
	4200 6650 4200 6750
Wire Wire Line
	4100 6650 4100 6750
Wire Wire Line
	3900 6550 3900 6750
Wire Bus Line
	5150 1300 5150 3050
Wire Bus Line
	5150 3050 5150 3200
Connection ~ 5150 3050
Wire Bus Line
	5150 4800 5150 5250
Connection ~ 5150 4800
Wire Bus Line
	5300 2750 5300 3050
Connection ~ 5300 4500
Wire Bus Line
	5300 4500 5300 5150
Connection ~ 5300 6250
Wire Bus Line
	5450 6450 5450 5350
Wire Bus Line
	5450 4700 5450 3300
Connection ~ 5450 4700
Wire Bus Line
	5450 2950 5450 1200
Connection ~ 5450 2950
Text GLabel 3750 2600 3    50   Input ~ 0
~RESET~
$Comp
L CPU_Modules:Register U1
U 1 1 60734785
P 3800 2000
F 0 "U1" H 3350 2000 50  0000 L CNN
F 1 "Register A" H 4150 2000 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 2350 3350 50  0001 C CNN
F 3 "" H 2350 3350 50  0001 C CNN
	1    3800 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 2550 3750 2550
Wire Wire Line
	3750 2550 3750 2600
Text GLabel 3750 4350 3    50   Input ~ 0
~RESET~
Wire Wire Line
	3650 4300 3750 4300
Wire Wire Line
	3750 4300 3750 4350
Text GLabel 3750 6100 3    50   Input ~ 0
~RESET~
Wire Wire Line
	3650 6050 3750 6050
Wire Wire Line
	3750 6050 3750 6100
Text GLabel 3750 7850 3    50   Input ~ 0
~RESET~
Wire Wire Line
	3650 7800 3750 7800
Wire Wire Line
	3750 7800 3750 7850
Text GLabel 12050 1950 2    50   Output ~ 0
~RESET~
Wire Wire Line
	11950 1800 11950 1950
Wire Wire Line
	11950 1950 12050 1950
$Comp
L CPU_Modules:ALU U5
U 1 1 609174F7
P 7250 2000
F 0 "U5" H 6750 2000 50  0000 L CNN
F 1 "Add/Sub" H 7300 2000 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 5800 3350 50  0001 C CNN
F 3 "" H 5800 3350 50  0001 C CNN
	1    7250 2000
	1    0    0    -1  
$EndComp
Entry Wire Line
	6550 1200 6650 1300
Entry Wire Line
	6650 1200 6750 1300
Entry Wire Line
	6750 1200 6850 1300
Entry Wire Line
	6850 1200 6950 1300
Entry Wire Line
	6950 1200 7050 1300
Entry Wire Line
	7050 1200 7150 1300
Entry Wire Line
	7150 1200 7250 1300
Entry Wire Line
	7250 1200 7350 1300
Connection ~ 5450 1200
Wire Wire Line
	6650 1300 6650 1500
Wire Wire Line
	6750 1300 6750 1500
Wire Wire Line
	6850 1300 6850 1500
Wire Wire Line
	6950 1300 6950 1500
Wire Wire Line
	7050 1300 7050 1500
Wire Wire Line
	7150 1300 7150 1500
Wire Wire Line
	7250 1300 7250 1500
Wire Wire Line
	7350 1300 7350 1500
Text Label 7350 1500 1    50   ~ 0
BUS0
Text Label 7250 1500 1    50   ~ 0
BUS1
Text Label 7150 1500 1    50   ~ 0
BUS2
Text Label 7050 1500 1    50   ~ 0
BUS3
Text Label 6950 1500 1    50   ~ 0
BUS4
Text Label 6850 1500 1    50   ~ 0
BUS5
Text Label 6750 1500 1    50   ~ 0
BUS6
Text Label 6650 1500 1    50   ~ 0
BUS7
Entry Wire Line
	8150 1250 8250 1350
Entry Wire Line
	8050 1250 8150 1350
Entry Wire Line
	7950 1250 8050 1350
Entry Wire Line
	7850 1250 7950 1350
Entry Wire Line
	7750 1250 7850 1350
Entry Wire Line
	7650 1250 7750 1350
Entry Wire Line
	7550 1250 7650 1350
Entry Wire Line
	7450 1250 7550 1350
Wire Bus Line
	7450 1100 5150 1100
Wire Bus Line
	5150 1100 5150 1300
Wire Bus Line
	7450 1100 7450 1250
Connection ~ 5150 1300
Wire Wire Line
	8250 1350 8250 1500
Wire Wire Line
	8150 1350 8150 1500
Wire Wire Line
	8050 1350 8050 1500
Wire Wire Line
	7950 1350 7950 1500
Wire Wire Line
	7850 1350 7850 1500
Wire Wire Line
	7750 1350 7750 1500
Wire Wire Line
	7650 1350 7650 1500
Wire Wire Line
	7550 1350 7550 1500
Entry Wire Line
	8150 2750 8250 2650
Entry Wire Line
	8050 2750 8150 2650
Entry Wire Line
	7850 2750 7950 2650
Entry Wire Line
	7950 2750 8050 2650
Entry Wire Line
	7750 2750 7850 2650
Entry Wire Line
	7650 2750 7750 2650
Entry Wire Line
	7550 2750 7650 2650
Entry Wire Line
	7450 2750 7550 2650
Wire Wire Line
	8250 2550 8250 2650
Wire Wire Line
	8150 2550 8150 2650
Wire Wire Line
	8050 2550 8050 2650
Wire Wire Line
	7950 2550 7950 2650
Wire Wire Line
	7850 2550 7850 2650
Wire Wire Line
	7750 2550 7750 2650
Wire Wire Line
	7650 2550 7650 2650
Wire Wire Line
	7550 2550 7550 2650
Connection ~ 5300 3050
Wire Bus Line
	5300 3050 5300 4500
Text Label 8250 2650 1    50   ~ 0
R0
Text Label 8150 2650 1    50   ~ 0
R1
Text Label 8050 2650 1    50   ~ 0
R2
Text Label 7950 2650 1    50   ~ 0
R3
Text Label 7850 2650 1    50   ~ 0
R4
Text Label 7750 2650 1    50   ~ 0
R5
Text Label 7650 2650 1    50   ~ 0
R6
Text Label 7550 2650 1    50   ~ 0
R7
Entry Wire Line
	7100 2700 7200 2800
Entry Wire Line
	7000 2700 7100 2800
Entry Wire Line
	6900 2700 7000 2800
Entry Wire Line
	6800 2700 6900 2800
Wire Bus Line
	7400 2750 7400 3050
Wire Bus Line
	5300 3050 7400 3050
Text Label 6800 2700 1    50   ~ 0
CFA
Wire Wire Line
	6800 2550 6800 2700
Wire Wire Line
	6900 2550 6900 2700
Wire Wire Line
	7000 2550 7000 2700
Wire Wire Line
	7100 2550 7100 2700
Text Label 6900 2700 1    50   ~ 0
V
Text Label 7000 2700 1    50   ~ 0
CAF
Text Label 7100 2700 1    50   ~ 0
Z
$Comp
L power:VCC #PWR010
U 1 1 60B2B22F
P 6250 1500
F 0 "#PWR010" H 6250 1350 50  0001 C CNN
F 1 "VCC" H 6200 1650 50  0000 C CNN
F 2 "" H 6250 1500 50  0001 C CNN
F 3 "" H 6250 1500 50  0001 C CNN
	1    6250 1500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR014
U 1 1 60B2BB33
P 6350 1500
F 0 "#PWR014" H 6350 1250 50  0001 C CNN
F 1 "GND" H 6250 1500 50  0000 C CNN
F 2 "" H 6350 1500 50  0001 C CNN
F 3 "" H 6350 1500 50  0001 C CNN
	1    6350 1500
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR03
U 1 1 60B2C4A3
P 6050 1850
F 0 "#PWR03" H 6050 1600 50  0001 C CNN
F 1 "GND" V 6050 1650 50  0000 C CNN
F 2 "" H 6050 1850 50  0001 C CNN
F 3 "" H 6050 1850 50  0001 C CNN
	1    6050 1850
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR04
U 1 1 60B2C8FE
P 6050 1950
F 0 "#PWR04" H 6050 1800 50  0001 C CNN
F 1 "VCC" V 6065 2077 50  0000 L CNN
F 2 "" H 6050 1950 50  0001 C CNN
F 3 "" H 6050 1950 50  0001 C CNN
	1    6050 1950
	0    -1   -1   0   
$EndComp
$Comp
L CPU_Modules:ALU U6
U 1 1 60B40560
P 7250 4100
F 0 "U6" H 6750 4100 50  0000 L CNN
F 1 "And/Or" H 7300 4100 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 5800 5450 50  0001 C CNN
F 3 "" H 5800 5450 50  0001 C CNN
	1    7250 4100
	1    0    0    -1  
$EndComp
Entry Wire Line
	6550 3300 6650 3400
Entry Wire Line
	6650 3300 6750 3400
Entry Wire Line
	6750 3300 6850 3400
Entry Wire Line
	6850 3300 6950 3400
Entry Wire Line
	6950 3300 7050 3400
Entry Wire Line
	7050 3300 7150 3400
Entry Wire Line
	7150 3300 7250 3400
Entry Wire Line
	7250 3300 7350 3400
Wire Wire Line
	6650 3400 6650 3600
Wire Wire Line
	6750 3400 6750 3600
Wire Wire Line
	6850 3400 6850 3600
Wire Wire Line
	6950 3400 6950 3600
Wire Wire Line
	7050 3400 7050 3600
Wire Wire Line
	7150 3400 7150 3600
Wire Wire Line
	7250 3400 7250 3600
Wire Wire Line
	7350 3400 7350 3600
Text Label 7350 3600 1    50   ~ 0
BUS0
Text Label 7250 3600 1    50   ~ 0
BUS1
Text Label 7150 3600 1    50   ~ 0
BUS2
Text Label 7050 3600 1    50   ~ 0
BUS3
Text Label 6950 3600 1    50   ~ 0
BUS4
Text Label 6850 3600 1    50   ~ 0
BUS5
Text Label 6750 3600 1    50   ~ 0
BUS6
Text Label 6650 3600 1    50   ~ 0
BUS7
Entry Wire Line
	8150 3350 8250 3450
Entry Wire Line
	8050 3350 8150 3450
Entry Wire Line
	7950 3350 8050 3450
Entry Wire Line
	7850 3350 7950 3450
Entry Wire Line
	7750 3350 7850 3450
Entry Wire Line
	7650 3350 7750 3450
Entry Wire Line
	7550 3350 7650 3450
Entry Wire Line
	7450 3350 7550 3450
Wire Bus Line
	7450 3200 5150 3200
Wire Bus Line
	7450 3200 7450 3350
Wire Wire Line
	8250 3450 8250 3600
Wire Wire Line
	8150 3450 8150 3600
Wire Wire Line
	8050 3450 8050 3600
Wire Wire Line
	7950 3450 7950 3600
Wire Wire Line
	7850 3450 7850 3600
Wire Wire Line
	7750 3450 7750 3600
Wire Wire Line
	7650 3450 7650 3600
Wire Wire Line
	7550 3450 7550 3600
Entry Wire Line
	8150 4850 8250 4750
Entry Wire Line
	8050 4850 8150 4750
Entry Wire Line
	7850 4850 7950 4750
Entry Wire Line
	7950 4850 8050 4750
Entry Wire Line
	7750 4850 7850 4750
Entry Wire Line
	7650 4850 7750 4750
Entry Wire Line
	7550 4850 7650 4750
Entry Wire Line
	7450 4850 7550 4750
Wire Wire Line
	8250 4650 8250 4750
Wire Wire Line
	8150 4650 8150 4750
Wire Wire Line
	8050 4650 8050 4750
Wire Wire Line
	7950 4650 7950 4750
Wire Wire Line
	7850 4650 7850 4750
Wire Wire Line
	7750 4650 7750 4750
Wire Wire Line
	7650 4650 7650 4750
Wire Wire Line
	7550 4650 7550 4750
Text Label 8250 4750 1    50   ~ 0
R0
Text Label 8150 4750 1    50   ~ 0
R1
Text Label 8050 4750 1    50   ~ 0
R2
Text Label 7950 4750 1    50   ~ 0
R3
Text Label 7850 4750 1    50   ~ 0
R4
Text Label 7750 4750 1    50   ~ 0
R5
Text Label 7650 4750 1    50   ~ 0
R6
Text Label 7550 4750 1    50   ~ 0
R7
Entry Wire Line
	7100 4800 7200 4900
Entry Wire Line
	7000 4800 7100 4900
Entry Wire Line
	6900 4800 7000 4900
Entry Wire Line
	6800 4800 6900 4900
Wire Bus Line
	7400 4850 7400 5150
Wire Bus Line
	5300 5150 7400 5150
Text Label 6800 4800 1    50   ~ 0
CFA
Wire Wire Line
	6800 4650 6800 4800
Wire Wire Line
	6900 4650 6900 4800
Wire Wire Line
	7000 4650 7000 4800
Wire Wire Line
	7100 4650 7100 4800
Text Label 6900 4800 1    50   ~ 0
V
Text Label 7000 4800 1    50   ~ 0
CAF
Text Label 7100 4800 1    50   ~ 0
Z
$Comp
L power:VCC #PWR011
U 1 1 60B405BA
P 6250 3600
F 0 "#PWR011" H 6250 3450 50  0001 C CNN
F 1 "VCC" H 6200 3750 50  0000 C CNN
F 2 "" H 6250 3600 50  0001 C CNN
F 3 "" H 6250 3600 50  0001 C CNN
	1    6250 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR015
U 1 1 60B405C0
P 6350 3600
F 0 "#PWR015" H 6350 3350 50  0001 C CNN
F 1 "GND" H 6250 3600 50  0000 C CNN
F 2 "" H 6350 3600 50  0001 C CNN
F 3 "" H 6350 3600 50  0001 C CNN
	1    6350 3600
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR05
U 1 1 60B405C6
P 6050 3950
F 0 "#PWR05" H 6050 3700 50  0001 C CNN
F 1 "GND" V 6050 3750 50  0000 C CNN
F 2 "" H 6050 3950 50  0001 C CNN
F 3 "" H 6050 3950 50  0001 C CNN
	1    6050 3950
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR06
U 1 1 60B405CC
P 6050 4050
F 0 "#PWR06" H 6050 3900 50  0001 C CNN
F 1 "VCC" V 6065 4177 50  0000 L CNN
F 2 "" H 6050 4050 50  0001 C CNN
F 3 "" H 6050 4050 50  0001 C CNN
	1    6050 4050
	0    -1   -1   0   
$EndComp
$Comp
L CPU_Modules:ALU U7
U 1 1 60B566A4
P 7250 6150
F 0 "U7" H 6750 6150 50  0000 L CNN
F 1 "Xor/Not" H 7300 6150 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 5800 7500 50  0001 C CNN
F 3 "" H 5800 7500 50  0001 C CNN
	1    7250 6150
	1    0    0    -1  
$EndComp
Entry Wire Line
	6550 5350 6650 5450
Entry Wire Line
	6650 5350 6750 5450
Entry Wire Line
	6750 5350 6850 5450
Entry Wire Line
	6850 5350 6950 5450
Entry Wire Line
	6950 5350 7050 5450
Entry Wire Line
	7050 5350 7150 5450
Entry Wire Line
	7150 5350 7250 5450
Entry Wire Line
	7250 5350 7350 5450
Wire Wire Line
	6650 5450 6650 5650
Wire Wire Line
	6750 5450 6750 5650
Wire Wire Line
	6850 5450 6850 5650
Wire Wire Line
	6950 5450 6950 5650
Wire Wire Line
	7050 5450 7050 5650
Wire Wire Line
	7150 5450 7150 5650
Wire Wire Line
	7250 5450 7250 5650
Wire Wire Line
	7350 5450 7350 5650
Text Label 7350 5650 1    50   ~ 0
BUS0
Text Label 7250 5650 1    50   ~ 0
BUS1
Text Label 7150 5650 1    50   ~ 0
BUS2
Text Label 7050 5650 1    50   ~ 0
BUS3
Text Label 6950 5650 1    50   ~ 0
BUS4
Text Label 6850 5650 1    50   ~ 0
BUS5
Text Label 6750 5650 1    50   ~ 0
BUS6
Text Label 6650 5650 1    50   ~ 0
BUS7
Entry Wire Line
	8150 5400 8250 5500
Entry Wire Line
	8050 5400 8150 5500
Entry Wire Line
	7950 5400 8050 5500
Entry Wire Line
	7850 5400 7950 5500
Entry Wire Line
	7750 5400 7850 5500
Entry Wire Line
	7650 5400 7750 5500
Entry Wire Line
	7550 5400 7650 5500
Entry Wire Line
	7450 5400 7550 5500
Wire Bus Line
	7450 5250 5150 5250
Wire Bus Line
	7450 5250 7450 5400
Wire Wire Line
	8250 5500 8250 5650
Wire Wire Line
	8150 5500 8150 5650
Wire Wire Line
	8050 5500 8050 5650
Wire Wire Line
	7950 5500 7950 5650
Wire Wire Line
	7850 5500 7850 5650
Wire Wire Line
	7750 5500 7750 5650
Wire Wire Line
	7650 5500 7650 5650
Wire Wire Line
	7550 5500 7550 5650
Entry Wire Line
	8150 6900 8250 6800
Entry Wire Line
	8050 6900 8150 6800
Entry Wire Line
	7850 6900 7950 6800
Entry Wire Line
	7950 6900 8050 6800
Entry Wire Line
	7750 6900 7850 6800
Entry Wire Line
	7650 6900 7750 6800
Entry Wire Line
	7550 6900 7650 6800
Entry Wire Line
	7450 6900 7550 6800
Wire Wire Line
	8250 6700 8250 6800
Wire Wire Line
	8150 6700 8150 6800
Wire Wire Line
	8050 6700 8050 6800
Wire Wire Line
	7950 6700 7950 6800
Wire Wire Line
	7850 6700 7850 6800
Wire Wire Line
	7750 6700 7750 6800
Wire Wire Line
	7650 6700 7650 6800
Wire Wire Line
	7550 6700 7550 6800
Text Label 8250 6800 1    50   ~ 0
R0
Text Label 8150 6800 1    50   ~ 0
R1
Text Label 8050 6800 1    50   ~ 0
R2
Text Label 7950 6800 1    50   ~ 0
R3
Text Label 7850 6800 1    50   ~ 0
R4
Text Label 7750 6800 1    50   ~ 0
R5
Text Label 7650 6800 1    50   ~ 0
R6
Text Label 7550 6800 1    50   ~ 0
R7
Entry Wire Line
	7100 6850 7200 6950
Entry Wire Line
	7000 6850 7100 6950
Entry Wire Line
	6900 6850 7000 6950
Entry Wire Line
	6800 6850 6900 6950
Text Label 6800 6850 1    50   ~ 0
CFA
Wire Wire Line
	6800 6700 6800 6850
Wire Wire Line
	6900 6700 6900 6850
Wire Wire Line
	7000 6700 7000 6850
Wire Wire Line
	7100 6700 7100 6850
Text Label 6900 6850 1    50   ~ 0
V
Text Label 7000 6850 1    50   ~ 0
CAF
Text Label 7100 6850 1    50   ~ 0
Z
$Comp
L power:VCC #PWR012
U 1 1 60B566FE
P 6250 5650
F 0 "#PWR012" H 6250 5500 50  0001 C CNN
F 1 "VCC" H 6200 5800 50  0000 C CNN
F 2 "" H 6250 5650 50  0001 C CNN
F 3 "" H 6250 5650 50  0001 C CNN
	1    6250 5650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 60B56704
P 6350 5650
F 0 "#PWR016" H 6350 5400 50  0001 C CNN
F 1 "GND" H 6250 5650 50  0000 C CNN
F 2 "" H 6350 5650 50  0001 C CNN
F 3 "" H 6350 5650 50  0001 C CNN
	1    6350 5650
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR07
U 1 1 60B5670A
P 6050 6000
F 0 "#PWR07" H 6050 5750 50  0001 C CNN
F 1 "GND" V 6050 5800 50  0000 C CNN
F 2 "" H 6050 6000 50  0001 C CNN
F 3 "" H 6050 6000 50  0001 C CNN
	1    6050 6000
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR08
U 1 1 60B56710
P 6050 6100
F 0 "#PWR08" H 6050 5950 50  0001 C CNN
F 1 "VCC" V 6065 6227 50  0000 L CNN
F 2 "" H 6050 6100 50  0001 C CNN
F 3 "" H 6050 6100 50  0001 C CNN
	1    6050 6100
	0    -1   -1   0   
$EndComp
$Comp
L CPU_Modules:ALU U8
U 1 1 60B739B7
P 10300 2000
F 0 "U8" H 9800 2000 50  0000 L CNN
F 1 "Shift/Swap" H 10350 2000 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 8850 3350 50  0001 C CNN
F 3 "" H 8850 3350 50  0001 C CNN
	1    10300 2000
	1    0    0    -1  
$EndComp
Entry Wire Line
	9600 1200 9700 1300
Entry Wire Line
	9700 1200 9800 1300
Entry Wire Line
	9800 1200 9900 1300
Entry Wire Line
	9900 1200 10000 1300
Entry Wire Line
	10000 1200 10100 1300
Entry Wire Line
	10100 1200 10200 1300
Entry Wire Line
	10200 1200 10300 1300
Entry Wire Line
	10300 1200 10400 1300
Wire Wire Line
	9700 1300 9700 1500
Wire Wire Line
	9800 1300 9800 1500
Wire Wire Line
	9900 1300 9900 1500
Wire Wire Line
	10000 1300 10000 1500
Wire Wire Line
	10100 1300 10100 1500
Wire Wire Line
	10200 1300 10200 1500
Wire Wire Line
	10300 1300 10300 1500
Wire Wire Line
	10400 1300 10400 1500
Text Label 10400 1500 1    50   ~ 0
BUS0
Text Label 10300 1500 1    50   ~ 0
BUS1
Text Label 10200 1500 1    50   ~ 0
BUS2
Text Label 10100 1500 1    50   ~ 0
BUS3
Text Label 10000 1500 1    50   ~ 0
BUS4
Text Label 9900 1500 1    50   ~ 0
BUS5
Text Label 9800 1500 1    50   ~ 0
BUS6
Text Label 9700 1500 1    50   ~ 0
BUS7
Entry Wire Line
	11200 1250 11300 1350
Entry Wire Line
	11100 1250 11200 1350
Entry Wire Line
	11000 1250 11100 1350
Entry Wire Line
	10900 1250 11000 1350
Entry Wire Line
	10800 1250 10900 1350
Entry Wire Line
	10700 1250 10800 1350
Entry Wire Line
	10600 1250 10700 1350
Entry Wire Line
	10500 1250 10600 1350
Wire Bus Line
	10500 1100 10500 1250
Wire Wire Line
	11300 1350 11300 1500
Wire Wire Line
	11200 1350 11200 1500
Wire Wire Line
	11100 1350 11100 1500
Wire Wire Line
	11000 1350 11000 1500
Wire Wire Line
	10900 1350 10900 1500
Wire Wire Line
	10800 1350 10800 1500
Wire Wire Line
	10700 1350 10700 1500
Wire Wire Line
	10600 1350 10600 1500
Entry Wire Line
	11200 2750 11300 2650
Entry Wire Line
	11100 2750 11200 2650
Entry Wire Line
	10900 2750 11000 2650
Entry Wire Line
	11000 2750 11100 2650
Entry Wire Line
	10800 2750 10900 2650
Entry Wire Line
	10700 2750 10800 2650
Entry Wire Line
	10600 2750 10700 2650
Entry Wire Line
	10500 2750 10600 2650
Wire Wire Line
	11300 2550 11300 2650
Wire Wire Line
	11200 2550 11200 2650
Wire Wire Line
	11100 2550 11100 2650
Wire Wire Line
	11000 2550 11000 2650
Wire Wire Line
	10900 2550 10900 2650
Wire Wire Line
	10800 2550 10800 2650
Wire Wire Line
	10700 2550 10700 2650
Wire Wire Line
	10600 2550 10600 2650
Text Label 11300 2650 1    50   ~ 0
R0
Text Label 11200 2650 1    50   ~ 0
R1
Text Label 11100 2650 1    50   ~ 0
R2
Text Label 11000 2650 1    50   ~ 0
R3
Text Label 10900 2650 1    50   ~ 0
R4
Text Label 10800 2650 1    50   ~ 0
R5
Text Label 10700 2650 1    50   ~ 0
R6
Text Label 10600 2650 1    50   ~ 0
R7
Entry Wire Line
	10150 2800 10050 2900
Entry Wire Line
	10050 2800 9950 2900
Entry Wire Line
	9950 2800 9850 2900
Entry Wire Line
	9850 2800 9750 2900
Wire Bus Line
	10450 2750 10450 3050
Text Label 9850 2700 1    50   ~ 0
CFA
Text Label 9950 2700 1    50   ~ 0
V
Text Label 10050 2700 1    50   ~ 0
CAF
Text Label 10150 2700 1    50   ~ 0
Z
$Comp
L power:VCC #PWR019
U 1 1 60B73A11
P 9300 1500
F 0 "#PWR019" H 9300 1350 50  0001 C CNN
F 1 "VCC" H 9250 1650 50  0000 C CNN
F 2 "" H 9300 1500 50  0001 C CNN
F 3 "" H 9300 1500 50  0001 C CNN
	1    9300 1500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR020
U 1 1 60B73A17
P 9400 1500
F 0 "#PWR020" H 9400 1250 50  0001 C CNN
F 1 "GND" H 9300 1500 50  0000 C CNN
F 2 "" H 9400 1500 50  0001 C CNN
F 3 "" H 9400 1500 50  0001 C CNN
	1    9400 1500
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR017
U 1 1 60B73A1D
P 9100 1850
F 0 "#PWR017" H 9100 1600 50  0001 C CNN
F 1 "GND" V 9100 1650 50  0000 C CNN
F 2 "" H 9100 1850 50  0001 C CNN
F 3 "" H 9100 1850 50  0001 C CNN
	1    9100 1850
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR018
U 1 1 60B73A23
P 9100 1950
F 0 "#PWR018" H 9100 1800 50  0001 C CNN
F 1 "VCC" V 9115 2077 50  0000 L CNN
F 2 "" H 9100 1950 50  0001 C CNN
F 3 "" H 9100 1950 50  0001 C CNN
	1    9100 1950
	0    -1   -1   0   
$EndComp
Wire Bus Line
	7400 3050 10450 3050
Connection ~ 7400 3050
Wire Bus Line
	7450 1100 10500 1100
Connection ~ 7450 1100
Wire Bus Line
	8500 2800 8500 2900
Connection ~ 8500 4900
Wire Bus Line
	8500 4900 8500 6950
Text Label 8250 1500 1    50   ~ 0
L0
Text Label 8150 1500 1    50   ~ 0
L1
Text Label 8050 1500 1    50   ~ 0
L2
Text Label 7950 1500 1    50   ~ 0
L3
Text Label 7850 1500 1    50   ~ 0
L4
Text Label 7750 1500 1    50   ~ 0
L5
Text Label 7650 1500 1    50   ~ 0
L6
Text Label 7550 1500 1    50   ~ 0
L7
Text Label 11300 1500 1    50   ~ 0
L0
Text Label 11200 1500 1    50   ~ 0
L1
Text Label 11100 1500 1    50   ~ 0
L2
Text Label 11000 1500 1    50   ~ 0
L3
Text Label 10900 1500 1    50   ~ 0
L4
Text Label 10800 1500 1    50   ~ 0
L5
Text Label 10700 1500 1    50   ~ 0
L6
Text Label 10600 1500 1    50   ~ 0
L7
Text Label 8250 3600 1    50   ~ 0
L0
Text Label 8150 3600 1    50   ~ 0
L1
Text Label 8050 3600 1    50   ~ 0
L2
Text Label 7850 3600 1    50   ~ 0
L4
Text Label 7950 3600 1    50   ~ 0
L3
Text Label 7750 3600 1    50   ~ 0
L5
Text Label 7550 3600 1    50   ~ 0
L7
Text Label 7650 3600 1    50   ~ 0
L6
Text Label 8250 5650 1    50   ~ 0
L0
Text Label 8150 5650 1    50   ~ 0
L1
Text Label 8050 5650 1    50   ~ 0
L2
Text Label 7950 5650 1    50   ~ 0
L3
Text Label 7850 5650 1    50   ~ 0
L4
Text Label 7750 5650 1    50   ~ 0
L5
Text Label 7650 5650 1    50   ~ 0
L6
Text Label 7550 5650 1    50   ~ 0
L7
$Comp
L CPU_Modules:Flags U9
U 1 1 607C2303
P 10300 4100
F 0 "U9" H 9900 4100 50  0000 L CNN
F 1 "Flags" H 10650 4100 50  0000 L CNN
F 2 "CPU_Modules:Flags_board" H 8850 5450 50  0001 C CNN
F 3 "" H 8850 5450 50  0001 C CNN
	1    10300 4100
	1    0    0    -1  
$EndComp
Entry Wire Line
	9600 3300 9700 3400
Entry Wire Line
	9700 3300 9800 3400
Entry Wire Line
	9800 3300 9900 3400
Entry Wire Line
	9900 3300 10000 3400
Entry Wire Line
	10000 3300 10100 3400
Entry Wire Line
	10100 3300 10200 3400
Entry Wire Line
	10200 3300 10300 3400
Entry Wire Line
	10300 3300 10400 3400
Wire Wire Line
	9700 3400 9700 3600
Wire Wire Line
	9800 3400 9800 3600
Wire Wire Line
	9900 3400 9900 3600
Wire Wire Line
	10000 3400 10000 3600
Wire Wire Line
	10100 3400 10100 3600
Wire Wire Line
	10200 3400 10200 3600
Wire Wire Line
	10300 3400 10300 3600
Wire Wire Line
	10400 3400 10400 3600
Text Label 10400 3600 1    50   ~ 0
BUS0
Text Label 10300 3600 1    50   ~ 0
BUS1
Text Label 10200 3600 1    50   ~ 0
BUS2
Text Label 10100 3600 1    50   ~ 0
BUS3
Text Label 10000 3600 1    50   ~ 0
BUS4
Text Label 9900 3600 1    50   ~ 0
BUS5
Text Label 9800 3600 1    50   ~ 0
BUS6
Text Label 9700 3600 1    50   ~ 0
BUS7
$Comp
L power:VCC #PWR023
U 1 1 607D3E2B
P 9300 3600
F 0 "#PWR023" H 9300 3450 50  0001 C CNN
F 1 "VCC" H 9250 3750 50  0000 C CNN
F 2 "" H 9300 3600 50  0001 C CNN
F 3 "" H 9300 3600 50  0001 C CNN
	1    9300 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR024
U 1 1 607D3E31
P 9400 3600
F 0 "#PWR024" H 9400 3350 50  0001 C CNN
F 1 "GND" H 9300 3600 50  0000 C CNN
F 2 "" H 9400 3600 50  0001 C CNN
F 3 "" H 9400 3600 50  0001 C CNN
	1    9400 3600
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR021
U 1 1 607F61B0
P 9100 3950
F 0 "#PWR021" H 9100 3700 50  0001 C CNN
F 1 "GND" V 9100 3750 50  0000 C CNN
F 2 "" H 9100 3950 50  0001 C CNN
F 3 "" H 9100 3950 50  0001 C CNN
	1    9100 3950
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR022
U 1 1 607F67FA
P 9100 4050
F 0 "#PWR022" H 9100 3900 50  0001 C CNN
F 1 "VCC" V 9115 4177 50  0000 L CNN
F 2 "" H 9100 4050 50  0001 C CNN
F 3 "" H 9100 4050 50  0001 C CNN
	1    9100 4050
	0    -1   -1   0   
$EndComp
Entry Wire Line
	11300 3450 11200 3350
Entry Wire Line
	11200 3450 11100 3350
Entry Wire Line
	11100 3450 11000 3350
Entry Wire Line
	11000 3450 10900 3350
Text Label 11000 3450 3    50   ~ 0
CFA
Wire Wire Line
	11000 3600 11000 3450
Wire Wire Line
	11100 3600 11100 3450
Wire Wire Line
	11200 3600 11200 3450
Wire Wire Line
	11300 3600 11300 3450
Text Label 11100 3550 3    50   ~ 0
V
Text Label 11200 3450 3    50   ~ 0
CAF
Text Label 11300 3550 3    50   ~ 0
Z
Wire Bus Line
	10500 3350 10500 3150
Wire Bus Line
	10500 3150 8500 3150
Connection ~ 8500 3150
Wire Bus Line
	8500 3150 8500 4900
Text GLabel 9800 4700 3    50   Input ~ 0
CLK
Text GLabel 9950 4700 3    50   Input ~ 0
~CLK~
Text GLabel 10100 4700 3    50   Input ~ 0
RESET
Text GLabel 10250 4700 3    50   Input ~ 0
~RESET~
Wire Wire Line
	9850 4650 9800 4650
Wire Wire Line
	9800 4650 9800 4700
Wire Wire Line
	9950 4700 9950 4650
Wire Wire Line
	10100 4700 10100 4650
Wire Wire Line
	10100 4650 10050 4650
Wire Wire Line
	10150 4650 10250 4650
Wire Wire Line
	10250 4650 10250 4700
$Comp
L Connector:Conn_01x08_Female J2
U 1 1 60999772
P 5900 7650
F 0 "J2" H 6050 7500 50  0000 C CNN
F 1 "BUS" H 6050 7600 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 5900 7650 50  0001 C CNN
F 3 "~" H 5900 7650 50  0001 C CNN
	1    5900 7650
	1    0    0    1   
$EndComp
Entry Wire Line
	5450 7150 5550 7250
Entry Wire Line
	5450 7850 5550 7950
Connection ~ 5450 6450
Entry Wire Line
	5450 7250 5550 7350
Entry Wire Line
	5450 7350 5550 7450
Entry Wire Line
	5450 7450 5550 7550
Entry Wire Line
	5450 7550 5550 7650
Entry Wire Line
	5450 7650 5550 7750
Entry Wire Line
	5450 7750 5550 7850
Text Label 5550 7250 0    50   ~ 0
BUS0
Text Label 5550 7350 0    50   ~ 0
BUS1
Text Label 5550 7450 0    50   ~ 0
BUS2
Text Label 5550 7550 0    50   ~ 0
BUS3
Text Label 5550 7650 0    50   ~ 0
BUS4
Text Label 5550 7750 0    50   ~ 0
BUS5
Text Label 5550 7850 0    50   ~ 0
BUS6
Text Label 5550 7950 0    50   ~ 0
BUS7
Wire Wire Line
	5550 7250 5700 7250
Wire Wire Line
	5700 7350 5550 7350
Wire Wire Line
	5550 7450 5700 7450
Wire Wire Line
	5700 7550 5550 7550
Wire Wire Line
	5550 7650 5700 7650
Wire Wire Line
	5700 7750 5550 7750
Wire Wire Line
	5550 7850 5700 7850
Wire Wire Line
	5700 7950 5550 7950
$Comp
L Connector:Conn_01x04_Female J3
U 1 1 60C74233
P 11100 4850
F 0 "J3" V 10946 4562 50  0000 R CNN
F 1 "FLAGS" V 11037 4562 50  0000 R CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 11100 4850 50  0001 C CNN
F 3 "~" H 11100 4850 50  0001 C CNN
	1    11100 4850
	0    -1   1    0   
$EndComp
Text GLabel 2800 2550 3    50   Input ~ 0
OUT_A
Text GLabel 2900 2550 3    50   Input ~ 0
LOAD_A
Text GLabel 3000 2550 3    50   Input ~ 0
ARG_AL
Text GLabel 3100 2550 3    50   Input ~ 0
ARG_AR
Text GLabel 2800 4300 3    50   Input ~ 0
OUT_B
Text GLabel 2900 4300 3    50   Input ~ 0
LOAD_B
Text GLabel 3000 4300 3    50   Input ~ 0
ARG_BL
Text GLabel 3100 4300 3    50   Input ~ 0
ARG_BR
Text GLabel 2800 6050 3    50   Input ~ 0
OUT_C
Text GLabel 2900 6050 3    50   Input ~ 0
LOAD_C
Text GLabel 3000 6050 3    50   Input ~ 0
ARG_CL
Text GLabel 3100 6050 3    50   Input ~ 0
ARG_CR
Text GLabel 2800 7800 3    50   Input ~ 0
OUT_D
Text GLabel 2900 7800 3    50   Input ~ 0
LOAD_D
Text GLabel 3000 7800 3    50   Input ~ 0
ARG_DL
Text GLabel 3100 7800 3    50   Input ~ 0
ARG_DR
Text GLabel 6250 2550 3    50   Input ~ 0
OUT_AS
Text GLabel 6350 2550 3    50   Input ~ 0
ALT_AS
Text GLabel 6250 4650 3    50   Input ~ 0
OUT_AO
Text GLabel 6350 4650 3    50   Input ~ 0
ALT_AO
Text GLabel 6250 6700 3    50   Input ~ 0
OUT_XN
Text GLabel 6350 6700 3    50   Input ~ 0
ALT_XN
Wire Bus Line
	5300 7100 7400 7100
Connection ~ 5300 7100
Wire Bus Line
	5300 7100 5300 8000
Wire Bus Line
	7400 6900 7400 7100
Wire Bus Line
	5300 6250 5300 7100
Text GLabel 9300 2550 3    50   Input ~ 0
OUT_S
Text GLabel 9400 2550 3    50   Input ~ 0
ALT_S
Connection ~ 8500 2900
Wire Bus Line
	8500 2900 8500 3150
Wire Wire Line
	9850 2550 9850 2800
Wire Wire Line
	9950 2550 9950 2800
Wire Wire Line
	10050 2550 10050 2800
Wire Wire Line
	10150 2550 10150 2800
$Comp
L Connector:Conn_01x08_Female J4
U 1 1 60A3EB8D
P 11750 3400
F 0 "J4" H 11550 2850 50  0000 C CNN
F 1 "OUT" H 11350 2850 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 11750 3400 50  0001 C CNN
F 3 "~" H 11750 3400 50  0001 C CNN
	1    11750 3400
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x04_Female J6
U 1 1 60A41B94
P 11750 2500
F 0 "J6" H 11550 2200 50  0000 C CNN
F 1 "LOAD" H 11350 2200 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 11750 2500 50  0001 C CNN
F 3 "~" H 11750 2500 50  0001 C CNN
	1    11750 2500
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x08_Female J7
U 1 1 60A674DE
P 8850 6400
F 0 "J7" H 8750 5850 50  0000 C CNN
F 1 "ARGS" H 8450 5850 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 8850 6400 50  0001 C CNN
F 3 "~" H 8850 6400 50  0001 C CNN
	1    8850 6400
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x04_Female J5
U 1 1 60A67D60
P 9400 4850
F 0 "J5" V 9500 5000 50  0000 R CNN
F 1 "FCTL" V 9500 4850 50  0000 R CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 9400 4850 50  0001 C CNN
F 3 "~" H 9400 4850 50  0001 C CNN
	1    9400 4850
	0    -1   1    0   
$EndComp
Text GLabel 11950 3700 2    50   Output ~ 0
OUT_A
Text GLabel 11950 3600 2    50   Output ~ 0
OUT_B
Text GLabel 11950 3500 2    50   Output ~ 0
OUT_C
Text GLabel 11950 3400 2    50   Output ~ 0
OUT_D
Text GLabel 11950 3300 2    50   Output ~ 0
OUT_AS
Text GLabel 11950 3200 2    50   Output ~ 0
OUT_AO
Text GLabel 11950 3100 2    50   Output ~ 0
OUT_S
Text GLabel 11950 3000 2    50   Output ~ 0
OUT_XN
Text GLabel 11950 2600 2    50   Output ~ 0
LOAD_A
Text GLabel 11950 2500 2    50   Output ~ 0
LOAD_B
Text GLabel 11950 2400 2    50   Output ~ 0
LOAD_C
Text GLabel 11950 2300 2    50   Output ~ 0
LOAD_D
Text GLabel 11350 6000 2    50   Input ~ 0
ARG_AL
Text GLabel 11350 6100 2    50   Input ~ 0
ARG_BL
Text GLabel 11350 6200 2    50   Input ~ 0
ARG_CL
Text GLabel 11350 6300 2    50   Input ~ 0
ARG_DL
Text GLabel 10400 7650 2    50   Input ~ 0
ARG_AR
Text GLabel 10400 7750 2    50   Input ~ 0
ARG_BR
Text GLabel 10400 7850 2    50   Input ~ 0
ARG_CR
Text GLabel 10400 7950 2    50   Input ~ 0
ARG_DR
Text GLabel 4350 8850 2    50   Output ~ 0
ALT_AS
Text GLabel 4350 9300 2    50   Output ~ 0
ALT_AO
Text GLabel 3350 9300 2    50   Output ~ 0
ALT_S
Text GLabel 3350 8850 2    50   Output ~ 0
ALT_XN
$Comp
L 74xx:74LS125 U10
U 1 1 6089B08B
P 3050 8850
F 0 "U10" H 3000 8850 50  0000 C CNN
F 1 "74HC125" H 3250 8750 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 3050 8850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS125" H 3050 8850 50  0001 C CNN
	1    3050 8850
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS125 U10
U 2 1 608A640C
P 3050 9300
F 0 "U10" H 3000 9300 50  0000 C CNN
F 1 "74HC125" H 3250 9200 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 3050 9300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS125" H 3050 9300 50  0001 C CNN
	2    3050 9300
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS125 U10
U 3 1 608A9ADD
P 4050 8850
F 0 "U10" H 4000 8850 50  0000 C CNN
F 1 "74HC125" H 4250 8750 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 4050 8850 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS125" H 4050 8850 50  0001 C CNN
	3    4050 8850
	1    0    0    -1  
$EndComp
Text GLabel 2700 8850 0    50   Input ~ 0
ALT
Wire Wire Line
	2700 8850 2750 8850
Wire Wire Line
	2750 8850 2750 9300
Connection ~ 2750 8850
Wire Wire Line
	3750 8850 3750 8650
Wire Wire Line
	3750 8650 2750 8650
Wire Wire Line
	2750 8650 2750 8850
$Comp
L 74xx:74LS125 U10
U 4 1 6093E4F7
P 4050 9300
F 0 "U10" H 4000 9300 50  0000 C CNN
F 1 "74HC125" H 4250 9200 50  0001 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 4050 9300 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS125" H 4050 9300 50  0001 C CNN
	4    4050 9300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3750 8850 3750 9300
Connection ~ 3750 8850
$Comp
L power:GND #PWR025
U 1 1 60964736
P 3050 9550
F 0 "#PWR025" H 3050 9300 50  0001 C CNN
F 1 "GND" H 3200 9400 50  0000 C CNN
F 2 "" H 3050 9550 50  0001 C CNN
F 3 "" H 3050 9550 50  0001 C CNN
	1    3050 9550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4050 9550 3050 9550
Connection ~ 3050 9550
Wire Wire Line
	3050 9100 2650 9100
Wire Wire Line
	2650 9100 2650 9550
Wire Wire Line
	2650 9550 3050 9550
Wire Wire Line
	3050 9100 4050 9100
Connection ~ 3050 9100
$Comp
L 74xx:74LS138 U13
U 1 1 609D6F35
P 10850 6300
F 0 "U13" H 10600 6750 50  0000 C CNN
F 1 "74HC138" H 11050 6750 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 10850 6300 50  0001 C CNN
F 3 "" H 10850 6300 50  0001 C CNN
	1    10850 6300
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS138 U12
U 1 1 60ABDEC3
P 9900 7950
F 0 "U12" H 9650 8400 50  0000 C CNN
F 1 "74HC138" H 10100 8400 50  0000 C CNN
F 2 "Package_SO:SOIC-16_3.9x9.9mm_P1.27mm" H 9900 7950 50  0001 C CNN
F 3 "" H 9900 7950 50  0001 C CNN
	1    9900 7950
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR035
U 1 1 60BA9807
P 10850 7000
F 0 "#PWR035" H 10850 6750 50  0001 C CNN
F 1 "GND" H 11000 6850 50  0000 C CNN
F 2 "" H 10850 7000 50  0001 C CNN
F 3 "" H 10850 7000 50  0001 C CNN
	1    10850 7000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR037
U 1 1 60BAA0E5
P 9900 8650
F 0 "#PWR037" H 9900 8400 50  0001 C CNN
F 1 "GND" H 10050 8500 50  0000 C CNN
F 2 "" H 9900 8650 50  0001 C CNN
F 3 "" H 9900 8650 50  0001 C CNN
	1    9900 8650
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR034
U 1 1 60BAA4E2
P 10850 5700
F 0 "#PWR034" H 10850 5550 50  0001 C CNN
F 1 "VCC" H 10800 5850 50  0000 C CNN
F 2 "" H 10850 5700 50  0001 C CNN
F 3 "" H 10850 5700 50  0001 C CNN
	1    10850 5700
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR036
U 1 1 60BAB358
P 9900 7350
F 0 "#PWR036" H 9900 7200 50  0001 C CNN
F 1 "VCC" H 9850 7500 50  0000 C CNN
F 2 "" H 9900 7350 50  0001 C CNN
F 3 "" H 9900 7350 50  0001 C CNN
	1    9900 7350
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74LS125 U10
U 5 1 60C20A3C
P 5150 9050
F 0 "U10" H 5100 9050 50  0000 C CNN
F 1 "74HC125" V 5300 9050 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 5150 9050 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS125" H 5150 9050 50  0001 C CNN
	5    5150 9050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR027
U 1 1 60C61626
P 5150 9550
F 0 "#PWR027" H 5150 9300 50  0001 C CNN
F 1 "GND" H 5300 9400 50  0000 C CNN
F 2 "" H 5150 9550 50  0001 C CNN
F 3 "" H 5150 9550 50  0001 C CNN
	1    5150 9550
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR026
U 1 1 60C61B2A
P 5150 8550
F 0 "#PWR026" H 5150 8400 50  0001 C CNN
F 1 "VCC" H 5100 8700 50  0000 C CNN
F 2 "" H 5150 8550 50  0001 C CNN
F 3 "" H 5150 8550 50  0001 C CNN
	1    5150 8550
	1    0    0    -1  
$EndComp
Text GLabel 9050 6000 2    50   Output ~ 0
ARG_L0
Text GLabel 9050 6300 2    50   Output ~ 0
ARG_R1
Text GLabel 9050 6400 2    50   Output ~ 0
ARG_R2
Text GLabel 9050 6500 2    50   Output ~ 0
ALT
NoConn ~ 9050 6600
NoConn ~ 9050 6700
Text GLabel 10350 6000 0    50   Input ~ 0
ARG_L0
Text GLabel 10350 6100 0    50   Input ~ 0
ARG_L1
$Comp
L power:VCC #PWR032
U 1 1 60DCBE6D
P 10300 6450
F 0 "#PWR032" H 10300 6300 50  0001 C CNN
F 1 "VCC" H 10400 6550 50  0000 C CNN
F 2 "" H 10300 6450 50  0001 C CNN
F 3 "" H 10300 6450 50  0001 C CNN
	1    10300 6450
	1    0    0    -1  
$EndComp
Wire Wire Line
	10350 6500 10300 6500
Wire Wire Line
	10300 6500 10300 6450
Connection ~ 10850 7000
NoConn ~ 11350 6400
NoConn ~ 11350 6500
NoConn ~ 11350 6600
NoConn ~ 11350 6700
Wire Wire Line
	10350 6200 10250 6200
Wire Wire Line
	10250 6200 10250 6600
Connection ~ 10250 6600
Wire Wire Line
	10250 6600 10250 6700
Connection ~ 10250 6700
Wire Wire Line
	10250 6700 10250 7000
Wire Wire Line
	10250 6600 10350 6600
Wire Wire Line
	10250 7000 10850 7000
Wire Wire Line
	10250 6700 10350 6700
Text GLabel 9400 7650 0    50   Input ~ 0
ARG_R0
Text GLabel 9400 7750 0    50   Input ~ 0
ARG_R1
Text GLabel 9400 7850 0    50   Input ~ 0
ARG_R2
$Comp
L power:VCC #PWR033
U 1 1 60FF32B2
P 9350 8100
F 0 "#PWR033" H 9350 7950 50  0001 C CNN
F 1 "VCC" H 9450 8200 50  0000 C CNN
F 2 "" H 9350 8100 50  0001 C CNN
F 3 "" H 9350 8100 50  0001 C CNN
	1    9350 8100
	1    0    0    -1  
$EndComp
Wire Wire Line
	9400 8150 9350 8150
Wire Wire Line
	9350 8150 9350 8100
Wire Wire Line
	9400 8250 9350 8250
Wire Wire Line
	9350 8250 9350 8350
Wire Wire Line
	9350 8650 9900 8650
Connection ~ 9900 8650
Wire Wire Line
	9400 8350 9350 8350
Connection ~ 9350 8350
Wire Wire Line
	9350 8350 9350 8650
NoConn ~ 10400 8050
NoConn ~ 10400 8150
NoConn ~ 10400 8350
$Comp
L 74xx:74HC245 U11
U 1 1 6115C4D3
P 7750 8400
F 0 "U11" H 7550 9100 50  0000 C CNN
F 1 "74HC245" H 8000 9100 50  0000 C CNN
F 2 "Package_SO:SO-20_12.8x7.5mm_P1.27mm" H 7750 8400 50  0001 C CNN
F 3 "http://www.ti.com/lit/gpn/sn74LS125" H 7750 8400 50  0001 C CNN
	1    7750 8400
	1    0    0    -1  
$EndComp
Text GLabel 7250 8900 0    50   Input ~ 0
ARG_ZR
$Comp
L power:VCC #PWR030
U 1 1 6118E612
P 7750 7600
F 0 "#PWR030" H 7750 7450 50  0001 C CNN
F 1 "VCC" H 7700 7750 50  0000 C CNN
F 2 "" H 7750 7600 50  0001 C CNN
F 3 "" H 7750 7600 50  0001 C CNN
	1    7750 7600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR031
U 1 1 6118EA54
P 7750 9200
F 0 "#PWR031" H 7750 8950 50  0001 C CNN
F 1 "GND" H 7900 9050 50  0000 C CNN
F 2 "" H 7750 9200 50  0001 C CNN
F 3 "" H 7750 9200 50  0001 C CNN
	1    7750 9200
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR029
U 1 1 6118F018
P 7250 8800
F 0 "#PWR029" H 7250 8650 50  0001 C CNN
F 1 "VCC" H 7350 8900 50  0000 C CNN
F 2 "" H 7250 8800 50  0001 C CNN
F 3 "" H 7250 8800 50  0001 C CNN
	1    7250 8800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR028
U 1 1 6118F79B
P 7100 7900
F 0 "#PWR028" H 7100 7650 50  0001 C CNN
F 1 "GND" H 6950 7750 50  0000 C CNN
F 2 "" H 7100 7900 50  0001 C CNN
F 3 "" H 7100 7900 50  0001 C CNN
	1    7100 7900
	1    0    0    -1  
$EndComp
Wire Wire Line
	7100 7900 7250 7900
Wire Wire Line
	7250 7900 7250 8000
Connection ~ 7250 7900
Wire Wire Line
	7250 8000 7250 8100
Connection ~ 7250 8000
Wire Wire Line
	7250 8100 7250 8200
Connection ~ 7250 8100
Wire Wire Line
	7250 8200 7250 8300
Connection ~ 7250 8200
Wire Wire Line
	7250 8300 7250 8400
Connection ~ 7250 8300
Wire Wire Line
	7250 8400 7250 8500
Connection ~ 7250 8400
Wire Wire Line
	7250 8500 7250 8600
Connection ~ 7250 8500
Text Label 8250 8600 0    50   ~ 0
R0
Text Label 8250 8500 0    50   ~ 0
R1
Text Label 8250 8400 0    50   ~ 0
R2
Text Label 8250 8300 0    50   ~ 0
R3
Text Label 8250 8200 0    50   ~ 0
R4
Text Label 8250 8100 0    50   ~ 0
R5
Text Label 8250 8000 0    50   ~ 0
R6
Text Label 8250 7900 0    50   ~ 0
R7
Wire Wire Line
	8250 7900 8400 7900
Entry Wire Line
	8400 7900 8500 7800
Entry Wire Line
	8400 8000 8500 7900
Entry Wire Line
	8400 8100 8500 8000
Entry Wire Line
	8400 8200 8500 8100
Entry Wire Line
	8400 8300 8500 8200
Entry Wire Line
	8400 8400 8500 8300
Entry Wire Line
	8400 8500 8500 8400
Entry Wire Line
	8400 8600 8500 8500
Wire Wire Line
	8250 8000 8400 8000
Wire Wire Line
	8400 8100 8250 8100
Wire Wire Line
	8400 8200 8250 8200
Wire Wire Line
	8400 8300 8250 8300
Wire Wire Line
	8400 8400 8250 8400
Wire Wire Line
	8400 8500 8250 8500
Wire Wire Line
	8400 8600 8250 8600
Wire Bus Line
	8500 7100 7400 7100
Connection ~ 7400 7100
Connection ~ 5150 3200
Wire Bus Line
	5150 3200 5150 4800
Connection ~ 5150 5250
Wire Bus Line
	5150 5250 5150 6550
Connection ~ 5300 5150
Wire Bus Line
	5300 5150 5300 6250
Connection ~ 5450 3300
Wire Bus Line
	5450 3300 5450 2950
Connection ~ 5450 5350
Wire Bus Line
	5450 5350 5450 4700
$Comp
L Connector_Generic:Conn_02x02_Top_Bottom J8
U 1 1 6088427D
P 14200 1350
F 0 "J8" H 14250 1567 50  0000 C CNN
F 1 "POWER" H 14250 1476 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_2x02_P2.54mm_Vertical" H 14200 1350 50  0001 C CNN
F 3 "~" H 14200 1350 50  0001 C CNN
	1    14200 1350
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR038
U 1 1 608879BD
P 13950 1250
F 0 "#PWR038" H 13950 1100 50  0001 C CNN
F 1 "VCC" H 13900 1400 50  0000 C CNN
F 2 "" H 13950 1250 50  0001 C CNN
F 3 "" H 13950 1250 50  0001 C CNN
	1    13950 1250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR039
U 1 1 60887ECB
P 14550 1650
F 0 "#PWR039" H 14550 1400 50  0001 C CNN
F 1 "GND" H 14450 1650 50  0000 C CNN
F 2 "" H 14550 1650 50  0001 C CNN
F 3 "" H 14550 1650 50  0001 C CNN
	1    14550 1650
	1    0    0    -1  
$EndComp
Wire Wire Line
	13950 1250 13950 1350
Wire Wire Line
	13950 1350 14000 1350
Wire Wire Line
	14000 1450 13950 1450
Wire Wire Line
	13950 1450 13950 1350
Connection ~ 13950 1350
Wire Wire Line
	14500 1350 14550 1350
Wire Wire Line
	14550 1350 14550 1450
Wire Wire Line
	14500 1450 14550 1450
Connection ~ 14550 1450
Wire Wire Line
	14550 1450 14550 1650
$Comp
L power:PWR_FLAG #FLG01
U 1 1 60939D6E
P 13950 1350
F 0 "#FLG01" H 13950 1425 50  0001 C CNN
F 1 "PWR_FLAG" V 13950 1477 50  0000 L CNN
F 2 "" H 13950 1350 50  0001 C CNN
F 3 "~" H 13950 1350 50  0001 C CNN
	1    13950 1350
	0    -1   -1   0   
$EndComp
$Comp
L power:PWR_FLAG #FLG02
U 1 1 6093C007
P 14550 1350
F 0 "#FLG02" H 14550 1425 50  0001 C CNN
F 1 "PWR_FLAG" H 14550 1523 50  0000 C CNN
F 2 "" H 14550 1350 50  0001 C CNN
F 3 "~" H 14550 1350 50  0001 C CNN
	1    14550 1350
	1    0    0    -1  
$EndComp
Connection ~ 14550 1350
$Comp
L Device:C C1
U 1 1 6095462B
P 12750 2300
F 0 "C1" H 12800 2400 50  0000 L CNN
F 1 "10uF" H 12800 2200 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 12788 2150 50  0001 C CNN
F 3 "~" H 12750 2300 50  0001 C CNN
	1    12750 2300
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 60954A76
P 13100 2300
F 0 "C2" H 13150 2400 50  0000 L CNN
F 1 "100nF" H 13150 2200 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 13138 2150 50  0001 C CNN
F 3 "~" H 13100 2300 50  0001 C CNN
	1    13100 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	12750 2150 13100 2150
Connection ~ 13100 2150
Wire Wire Line
	12750 2450 13100 2450
Connection ~ 13100 2450
$Comp
L power:VCC #PWR040
U 1 1 60B4F563
P 12750 2150
F 0 "#PWR040" H 12750 2000 50  0001 C CNN
F 1 "VCC" H 12700 2300 50  0000 C CNN
F 2 "" H 12750 2150 50  0001 C CNN
F 3 "" H 12750 2150 50  0001 C CNN
	1    12750 2150
	1    0    0    -1  
$EndComp
Connection ~ 12750 2150
$Comp
L power:GND #PWR041
U 1 1 60B4FE9C
P 12750 2450
F 0 "#PWR041" H 12750 2200 50  0001 C CNN
F 1 "GND" H 12650 2450 50  0000 C CNN
F 2 "" H 12750 2450 50  0001 C CNN
F 3 "" H 12750 2450 50  0001 C CNN
	1    12750 2450
	1    0    0    -1  
$EndComp
Connection ~ 12750 2450
$Comp
L Device:C C3
U 1 1 60B51DE1
P 13450 2300
F 0 "C3" H 13500 2400 50  0000 L CNN
F 1 "100nF" H 13500 2200 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 13488 2150 50  0001 C CNN
F 3 "~" H 13450 2300 50  0001 C CNN
	1    13450 2300
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 60B52033
P 13750 2300
F 0 "C4" H 13800 2400 50  0000 L CNN
F 1 "100nF" H 13800 2200 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 13788 2150 50  0001 C CNN
F 3 "~" H 13750 2300 50  0001 C CNN
	1    13750 2300
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 60B52278
P 14050 2300
F 0 "C5" H 14100 2400 50  0000 L CNN
F 1 "100nF" H 14100 2200 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric_Pad1.18x1.45mm_HandSolder" H 14088 2150 50  0001 C CNN
F 3 "~" H 14050 2300 50  0001 C CNN
	1    14050 2300
	1    0    0    -1  
$EndComp
Connection ~ 13750 2150
Connection ~ 13750 2450
Connection ~ 13450 2150
Connection ~ 13450 2450
Wire Wire Line
	13100 2150 13450 2150
Wire Wire Line
	13100 2450 13450 2450
Wire Wire Line
	13450 2150 13750 2150
Wire Wire Line
	13450 2450 13750 2450
$Comp
L Mechanical:MountingHole H1
U 1 1 60B9F84A
P 13900 3150
F 0 "H1" H 14000 3196 50  0000 L CNN
F 1 "MountingHole" H 14000 3105 50  0000 L CNN
F 2 "MountingHole:MountingHole_3mm" H 13900 3150 50  0001 C CNN
F 3 "~" H 13900 3150 50  0001 C CNN
	1    13900 3150
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 60BA087E
P 13900 3400
F 0 "H2" H 14000 3446 50  0000 L CNN
F 1 "MountingHole" H 14000 3355 50  0000 L CNN
F 2 "MountingHole:MountingHole_3mm" H 13900 3400 50  0001 C CNN
F 3 "~" H 13900 3400 50  0001 C CNN
	1    13900 3400
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H3
U 1 1 60BA0B6F
P 13900 3650
F 0 "H3" H 14000 3696 50  0000 L CNN
F 1 "MountingHole" H 14000 3605 50  0000 L CNN
F 2 "MountingHole:MountingHole_3mm" H 13900 3650 50  0001 C CNN
F 3 "~" H 13900 3650 50  0001 C CNN
	1    13900 3650
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H4
U 1 1 60BA0DA2
P 13900 3900
F 0 "H4" H 14000 3946 50  0000 L CNN
F 1 "MountingHole" H 14000 3855 50  0000 L CNN
F 2 "MountingHole:MountingHole_3mm" H 13900 3900 50  0001 C CNN
F 3 "~" H 13900 3900 50  0001 C CNN
	1    13900 3900
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H5
U 1 1 60BA0F2F
P 13900 4150
F 0 "H5" H 14000 4196 50  0000 L CNN
F 1 "MountingHole" H 14000 4105 50  0000 L CNN
F 2 "MountingHole:MountingHole_3mm" H 13900 4150 50  0001 C CNN
F 3 "~" H 13900 4150 50  0001 C CNN
	1    13900 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	13750 2150 14050 2150
Wire Wire Line
	13750 2450 14050 2450
Text GLabel 9050 6100 2    50   Output ~ 0
ARG_L1
Text GLabel 9050 6200 2    50   Output ~ 0
ARG_R0
Text GLabel 10400 8250 2    50   Output ~ 0
ARG_ZR
Wire Bus Line
	10500 3350 11200 3350
Wire Bus Line
	8500 2900 10050 2900
Wire Bus Line
	6900 6950 8500 6950
Wire Bus Line
	6900 4900 8500 4900
Wire Bus Line
	6900 2800 8500 2800
Wire Bus Line
	7450 1250 8150 1250
Wire Bus Line
	7450 3350 8150 3350
Wire Bus Line
	7450 5400 8150 5400
Wire Bus Line
	10500 1250 11200 1250
Wire Bus Line
	5450 6450 5450 7850
Wire Bus Line
	10450 2750 11200 2750
Wire Bus Line
	7400 6900 8150 6900
Wire Bus Line
	5450 5350 7250 5350
Wire Bus Line
	7400 4850 8150 4850
Wire Bus Line
	7400 2750 8150 2750
Wire Bus Line
	4200 8000 5300 8000
Wire Bus Line
	4200 6550 5150 6550
Wire Bus Line
	3300 6450 5450 6450
Wire Bus Line
	4200 6250 5300 6250
Wire Bus Line
	4200 4800 5150 4800
Wire Bus Line
	3300 4700 5450 4700
Wire Bus Line
	4200 4500 5300 4500
Wire Bus Line
	4200 3050 5150 3050
Wire Bus Line
	3300 2950 5450 2950
Wire Bus Line
	4200 2750 5300 2750
Wire Bus Line
	4200 1300 5150 1300
Wire Bus Line
	3300 1200 5450 1200
Wire Bus Line
	8500 7100 8500 8500
Wire Bus Line
	5450 3300 10300 3300
Wire Bus Line
	5450 1200 10300 1200
$EndSCHEMATC
