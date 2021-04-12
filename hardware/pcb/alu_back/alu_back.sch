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
Entry Wire Line
	1800 800  1900 700 
Entry Wire Line
	1900 800  2000 700 
Entry Wire Line
	2000 800  2100 700 
Entry Wire Line
	2100 800  2200 700 
Entry Wire Line
	2200 800  2300 700 
Entry Wire Line
	2300 800  2400 700 
Entry Wire Line
	2400 800  2500 700 
Entry Wire Line
	2500 800  2600 700 
Entry Wire Line
	2700 900  2800 800 
Entry Wire Line
	2800 900  2900 800 
Entry Wire Line
	2900 900  3000 800 
Entry Wire Line
	3000 900  3100 800 
Entry Wire Line
	3100 900  3200 800 
Entry Wire Line
	3200 900  3300 800 
Entry Wire Line
	3300 900  3400 800 
Entry Wire Line
	3400 900  3500 800 
Entry Wire Line
	2700 2150 2800 2250
Entry Wire Line
	2800 2150 2900 2250
Entry Wire Line
	2900 2150 3000 2250
Entry Wire Line
	3000 2150 3100 2250
Entry Wire Line
	3100 2150 3200 2250
Entry Wire Line
	3200 2150 3300 2250
Entry Wire Line
	3300 2150 3400 2250
Entry Wire Line
	3400 2150 3500 2250
$Comp
L power:VCC #PWR09
U 1 1 60752E2C
P 1400 1000
F 0 "#PWR09" H 1400 850 50  0001 C CNN
F 1 "VCC" H 1350 1150 50  0000 C CNN
F 2 "" H 1400 1000 50  0001 C CNN
F 3 "" H 1400 1000 50  0001 C CNN
	1    1400 1000
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR02
U 1 1 60753BAA
P 1200 1450
F 0 "#PWR02" H 1200 1300 50  0001 C CNN
F 1 "VCC" V 1215 1577 50  0000 L CNN
F 2 "" H 1200 1450 50  0001 C CNN
F 3 "" H 1200 1450 50  0001 C CNN
	1    1200 1450
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR013
U 1 1 607546B6
P 1500 1000
F 0 "#PWR013" H 1500 750 50  0001 C CNN
F 1 "GND" H 1400 1000 50  0000 C CNN
F 2 "" H 1500 1000 50  0001 C CNN
F 3 "" H 1500 1000 50  0001 C CNN
	1    1500 1000
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR01
U 1 1 607553B4
P 1200 1350
F 0 "#PWR01" H 1200 1100 50  0001 C CNN
F 1 "GND" V 1200 1150 50  0000 C CNN
F 2 "" H 1200 1350 50  0001 C CNN
F 3 "" H 1200 1350 50  0001 C CNN
	1    1200 1350
	0    1    1    0   
$EndComp
Text GLabel 1900 2100 3    50   Input ~ 0
CLK
Text GLabel 2050 2100 3    50   Input ~ 0
~CLK~
Text GLabel 2200 2100 3    50   Input ~ 0
RESET
Wire Wire Line
	2050 2050 2050 2100
Wire Wire Line
	2150 2050 2200 2050
Wire Wire Line
	2200 2050 2200 2100
Wire Wire Line
	1950 2050 1900 2050
Wire Wire Line
	1900 2050 1900 2100
Text GLabel 10650 1000 2    50   Output ~ 0
CLK
Text GLabel 10650 1150 2    50   Output ~ 0
~CLK~
Text GLabel 10650 1300 2    50   Output ~ 0
RESET
$Comp
L Connector:Conn_01x04_Female J1
U 1 1 608088C3
P 10350 1200
F 0 "J1" H 10242 775 50  0000 C CNN
F 1 "SYNC" H 10242 866 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 10350 1200 50  0001 C CNN
F 3 "~" H 10350 1200 50  0001 C CNN
	1    10350 1200
	-1   0    0    1   
$EndComp
Wire Wire Line
	10550 1000 10650 1000
Wire Wire Line
	10550 1100 10600 1100
Wire Wire Line
	10600 1100 10600 1150
Wire Wire Line
	10600 1150 10650 1150
Wire Wire Line
	10550 1200 10600 1200
Wire Wire Line
	10600 1200 10600 1300
Wire Wire Line
	10600 1300 10650 1300
Wire Wire Line
	2400 800  2400 1000
Wire Wire Line
	2300 800  2300 1000
Wire Wire Line
	2200 800  2200 1000
Wire Wire Line
	2100 800  2100 1000
Wire Wire Line
	2000 800  2000 1000
Wire Wire Line
	1900 800  1900 1000
Wire Wire Line
	1800 800  1800 1000
Text Label 2500 1000 1    50   ~ 0
BUS0
Text Label 2400 1000 1    50   ~ 0
BUS1
Text Label 2300 1000 1    50   ~ 0
BUS2
Text Label 2200 1000 1    50   ~ 0
BUS3
Text Label 2100 1000 1    50   ~ 0
BUS4
Text Label 2000 1000 1    50   ~ 0
BUS5
Text Label 1900 1000 1    50   ~ 0
BUS6
Text Label 1800 1000 1    50   ~ 0
BUS7
Text Label 3400 1000 1    50   ~ 0
A0
Text Label 3300 1000 1    50   ~ 0
A1
Text Label 3200 1000 1    50   ~ 0
A2
Text Label 3100 1000 1    50   ~ 0
A3
Text Label 3000 1000 1    50   ~ 0
A4
Text Label 2900 1000 1    50   ~ 0
A5
Text Label 2800 1000 1    50   ~ 0
A6
Text Label 2700 1000 1    50   ~ 0
A7
Text Label 3400 2150 1    50   ~ 0
B0
Text Label 3300 2150 1    50   ~ 0
B1
Text Label 3200 2150 1    50   ~ 0
B2
Text Label 3100 2150 1    50   ~ 0
B3
Text Label 3000 2150 1    50   ~ 0
B4
Text Label 2900 2150 1    50   ~ 0
B5
Text Label 2800 2150 1    50   ~ 0
B6
Text Label 2700 2150 1    50   ~ 0
B7
Wire Wire Line
	3400 2050 3400 2150
Wire Wire Line
	3300 2050 3300 2150
Wire Wire Line
	3200 2050 3200 2150
Wire Wire Line
	3100 2050 3100 2150
Wire Wire Line
	3000 2050 3000 2150
Wire Wire Line
	2900 2050 2900 2150
Wire Wire Line
	2800 2050 2800 2150
Wire Wire Line
	2700 2050 2700 2150
Wire Wire Line
	3400 900  3400 1000
Wire Wire Line
	3300 900  3300 1000
Wire Wire Line
	3200 900  3200 1000
Wire Wire Line
	3100 900  3100 1000
Wire Wire Line
	3000 900  3000 1000
Wire Wire Line
	2900 900  2900 1000
Wire Wire Line
	2800 900  2800 1000
Wire Wire Line
	2700 900  2700 1000
Wire Wire Line
	2500 800  2500 1000
$Comp
L CPU_Modules:Register U2
U 1 1 608758D7
P 2400 3250
F 0 "U2" H 1950 3250 50  0000 L CNN
F 1 "Register B" H 2750 3250 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 950 4600 50  0001 C CNN
F 3 "" H 950 4600 50  0001 C CNN
	1    2400 3250
	1    0    0    -1  
$EndComp
Entry Wire Line
	1800 2550 1900 2450
Entry Wire Line
	1900 2550 2000 2450
Entry Wire Line
	2000 2550 2100 2450
Entry Wire Line
	2100 2550 2200 2450
Entry Wire Line
	2200 2550 2300 2450
Entry Wire Line
	2300 2550 2400 2450
Entry Wire Line
	2400 2550 2500 2450
Entry Wire Line
	2500 2550 2600 2450
Entry Wire Line
	2700 2650 2800 2550
Entry Wire Line
	2800 2650 2900 2550
Entry Wire Line
	2900 2650 3000 2550
Entry Wire Line
	3000 2650 3100 2550
Entry Wire Line
	3100 2650 3200 2550
Entry Wire Line
	3200 2650 3300 2550
Entry Wire Line
	3300 2650 3400 2550
Entry Wire Line
	3400 2650 3500 2550
Entry Wire Line
	2700 3900 2800 4000
Entry Wire Line
	2800 3900 2900 4000
Entry Wire Line
	2900 3900 3000 4000
Entry Wire Line
	3000 3900 3100 4000
Entry Wire Line
	3100 3900 3200 4000
Entry Wire Line
	3200 3900 3300 4000
Entry Wire Line
	3300 3900 3400 4000
Entry Wire Line
	3400 3900 3500 4000
$Comp
L power:VCC #PWR0101
U 1 1 608758F5
P 1400 2750
F 0 "#PWR0101" H 1400 2600 50  0001 C CNN
F 1 "VCC" H 1350 2900 50  0000 C CNN
F 2 "" H 1400 2750 50  0001 C CNN
F 3 "" H 1400 2750 50  0001 C CNN
	1    1400 2750
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0102
U 1 1 608758FB
P 1200 3200
F 0 "#PWR0102" H 1200 3050 50  0001 C CNN
F 1 "VCC" V 1215 3327 50  0000 L CNN
F 2 "" H 1200 3200 50  0001 C CNN
F 3 "" H 1200 3200 50  0001 C CNN
	1    1200 3200
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 60875901
P 1500 2750
F 0 "#PWR0103" H 1500 2500 50  0001 C CNN
F 1 "GND" H 1400 2750 50  0000 C CNN
F 2 "" H 1500 2750 50  0001 C CNN
F 3 "" H 1500 2750 50  0001 C CNN
	1    1500 2750
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 60875907
P 1200 3100
F 0 "#PWR0104" H 1200 2850 50  0001 C CNN
F 1 "GND" V 1200 2900 50  0000 C CNN
F 2 "" H 1200 3100 50  0001 C CNN
F 3 "" H 1200 3100 50  0001 C CNN
	1    1200 3100
	0    1    1    0   
$EndComp
Text GLabel 1900 3850 3    50   Input ~ 0
CLK
Text GLabel 2050 3850 3    50   Input ~ 0
~CLK~
Text GLabel 2200 3850 3    50   Input ~ 0
RESET
Wire Wire Line
	2050 3800 2050 3850
Wire Wire Line
	2150 3800 2200 3800
Wire Wire Line
	2200 3800 2200 3850
Wire Wire Line
	1950 3800 1900 3800
Wire Wire Line
	1900 3800 1900 3850
Wire Wire Line
	2400 2550 2400 2750
Wire Wire Line
	2300 2550 2300 2750
Wire Wire Line
	2200 2550 2200 2750
Wire Wire Line
	2100 2550 2100 2750
Wire Wire Line
	2000 2550 2000 2750
Wire Wire Line
	1900 2550 1900 2750
Wire Wire Line
	1800 2550 1800 2750
Text Label 2500 2750 1    50   ~ 0
BUS0
Text Label 2400 2750 1    50   ~ 0
BUS1
Text Label 2300 2750 1    50   ~ 0
BUS2
Text Label 2200 2750 1    50   ~ 0
BUS3
Text Label 2100 2750 1    50   ~ 0
BUS4
Text Label 2000 2750 1    50   ~ 0
BUS5
Text Label 1900 2750 1    50   ~ 0
BUS6
Text Label 1800 2750 1    50   ~ 0
BUS7
Text Label 3400 2750 1    50   ~ 0
A0
Text Label 3300 2750 1    50   ~ 0
A1
Text Label 3200 2750 1    50   ~ 0
A2
Text Label 3100 2750 1    50   ~ 0
A3
Text Label 3000 2750 1    50   ~ 0
A4
Text Label 2900 2750 1    50   ~ 0
A5
Text Label 2800 2750 1    50   ~ 0
A6
Text Label 2700 2750 1    50   ~ 0
A7
Text Label 3400 3900 1    50   ~ 0
B0
Text Label 3300 3900 1    50   ~ 0
B1
Text Label 3200 3900 1    50   ~ 0
B2
Text Label 3100 3900 1    50   ~ 0
B3
Text Label 3000 3900 1    50   ~ 0
B4
Text Label 2900 3900 1    50   ~ 0
B5
Text Label 2800 3900 1    50   ~ 0
B6
Text Label 2700 3900 1    50   ~ 0
B7
Wire Wire Line
	3400 3800 3400 3900
Wire Wire Line
	3300 3800 3300 3900
Wire Wire Line
	3200 3800 3200 3900
Wire Wire Line
	3100 3800 3100 3900
Wire Wire Line
	3000 3800 3000 3900
Wire Wire Line
	2900 3800 2900 3900
Wire Wire Line
	2800 3800 2800 3900
Wire Wire Line
	2700 3800 2700 3900
Wire Wire Line
	3400 2650 3400 2750
Wire Wire Line
	3300 2650 3300 2750
Wire Wire Line
	3200 2650 3200 2750
Wire Wire Line
	3100 2650 3100 2750
Wire Wire Line
	3000 2650 3000 2750
Wire Wire Line
	2900 2650 2900 2750
Wire Wire Line
	2800 2650 2800 2750
Wire Wire Line
	2700 2650 2700 2750
Wire Wire Line
	2500 2550 2500 2750
$Comp
L CPU_Modules:Register U3
U 1 1 6087FC4D
P 2400 5000
F 0 "U3" H 1950 5000 50  0000 L CNN
F 1 "Register C" H 2750 5000 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 950 6350 50  0001 C CNN
F 3 "" H 950 6350 50  0001 C CNN
	1    2400 5000
	1    0    0    -1  
$EndComp
Entry Wire Line
	1800 4300 1900 4200
Entry Wire Line
	1900 4300 2000 4200
Entry Wire Line
	2000 4300 2100 4200
Entry Wire Line
	2100 4300 2200 4200
Entry Wire Line
	2200 4300 2300 4200
Entry Wire Line
	2300 4300 2400 4200
Entry Wire Line
	2400 4300 2500 4200
Entry Wire Line
	2500 4300 2600 4200
Entry Wire Line
	2700 4400 2800 4300
Entry Wire Line
	2800 4400 2900 4300
Entry Wire Line
	2900 4400 3000 4300
Entry Wire Line
	3000 4400 3100 4300
Entry Wire Line
	3100 4400 3200 4300
Entry Wire Line
	3200 4400 3300 4300
Entry Wire Line
	3300 4400 3400 4300
Entry Wire Line
	3400 4400 3500 4300
Entry Wire Line
	2700 5650 2800 5750
Entry Wire Line
	2800 5650 2900 5750
Entry Wire Line
	2900 5650 3000 5750
Entry Wire Line
	3000 5650 3100 5750
Entry Wire Line
	3100 5650 3200 5750
Entry Wire Line
	3200 5650 3300 5750
Entry Wire Line
	3300 5650 3400 5750
Entry Wire Line
	3400 5650 3500 5750
$Comp
L power:VCC #PWR0105
U 1 1 6087FC6B
P 1400 4500
F 0 "#PWR0105" H 1400 4350 50  0001 C CNN
F 1 "VCC" H 1350 4650 50  0000 C CNN
F 2 "" H 1400 4500 50  0001 C CNN
F 3 "" H 1400 4500 50  0001 C CNN
	1    1400 4500
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0106
U 1 1 6087FC71
P 1200 4950
F 0 "#PWR0106" H 1200 4800 50  0001 C CNN
F 1 "VCC" V 1215 5077 50  0000 L CNN
F 2 "" H 1200 4950 50  0001 C CNN
F 3 "" H 1200 4950 50  0001 C CNN
	1    1200 4950
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0107
U 1 1 6087FC77
P 1500 4500
F 0 "#PWR0107" H 1500 4250 50  0001 C CNN
F 1 "GND" H 1400 4500 50  0000 C CNN
F 2 "" H 1500 4500 50  0001 C CNN
F 3 "" H 1500 4500 50  0001 C CNN
	1    1500 4500
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0108
U 1 1 6087FC7D
P 1200 4850
F 0 "#PWR0108" H 1200 4600 50  0001 C CNN
F 1 "GND" V 1200 4650 50  0000 C CNN
F 2 "" H 1200 4850 50  0001 C CNN
F 3 "" H 1200 4850 50  0001 C CNN
	1    1200 4850
	0    1    1    0   
$EndComp
Text GLabel 1900 5600 3    50   Input ~ 0
CLK
Text GLabel 2050 5600 3    50   Input ~ 0
~CLK~
Text GLabel 2200 5600 3    50   Input ~ 0
RESET
Wire Wire Line
	2050 5550 2050 5600
Wire Wire Line
	2150 5550 2200 5550
Wire Wire Line
	2200 5550 2200 5600
Wire Wire Line
	1950 5550 1900 5550
Wire Wire Line
	1900 5550 1900 5600
Wire Wire Line
	2400 4300 2400 4500
Wire Wire Line
	2300 4300 2300 4500
Wire Wire Line
	2200 4300 2200 4500
Wire Wire Line
	2100 4300 2100 4500
Wire Wire Line
	2000 4300 2000 4500
Wire Wire Line
	1900 4300 1900 4500
Wire Wire Line
	1800 4300 1800 4500
Text Label 2500 4500 1    50   ~ 0
BUS0
Text Label 2400 4500 1    50   ~ 0
BUS1
Text Label 2300 4500 1    50   ~ 0
BUS2
Text Label 2200 4500 1    50   ~ 0
BUS3
Text Label 2100 4500 1    50   ~ 0
BUS4
Text Label 2000 4500 1    50   ~ 0
BUS5
Text Label 1900 4500 1    50   ~ 0
BUS6
Text Label 1800 4500 1    50   ~ 0
BUS7
Text Label 3400 4500 1    50   ~ 0
A0
Text Label 3300 4500 1    50   ~ 0
A1
Text Label 3200 4500 1    50   ~ 0
A2
Text Label 3100 4500 1    50   ~ 0
A3
Text Label 3000 4500 1    50   ~ 0
A4
Text Label 2900 4500 1    50   ~ 0
A5
Text Label 2800 4500 1    50   ~ 0
A6
Text Label 2700 4500 1    50   ~ 0
A7
Text Label 3400 5650 1    50   ~ 0
B0
Text Label 3300 5650 1    50   ~ 0
B1
Text Label 3200 5650 1    50   ~ 0
B2
Text Label 3100 5650 1    50   ~ 0
B3
Text Label 3000 5650 1    50   ~ 0
B4
Text Label 2900 5650 1    50   ~ 0
B5
Text Label 2800 5650 1    50   ~ 0
B6
Text Label 2700 5650 1    50   ~ 0
B7
Wire Wire Line
	3400 5550 3400 5650
Wire Wire Line
	3300 5550 3300 5650
Wire Wire Line
	3200 5550 3200 5650
Wire Wire Line
	3100 5550 3100 5650
Wire Wire Line
	3000 5550 3000 5650
Wire Wire Line
	2900 5550 2900 5650
Wire Wire Line
	2800 5550 2800 5650
Wire Wire Line
	2700 5550 2700 5650
Wire Wire Line
	3400 4400 3400 4500
Wire Wire Line
	3300 4400 3300 4500
Wire Wire Line
	3200 4400 3200 4500
Wire Wire Line
	3100 4400 3100 4500
Wire Wire Line
	3000 4400 3000 4500
Wire Wire Line
	2900 4400 2900 4500
Wire Wire Line
	2800 4400 2800 4500
Wire Wire Line
	2700 4400 2700 4500
Wire Wire Line
	2500 4300 2500 4500
$Comp
L CPU_Modules:Register U4
U 1 1 6088974D
P 2400 6750
F 0 "U4" H 1950 6750 50  0000 L CNN
F 1 "Register D" H 2750 6750 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 950 8100 50  0001 C CNN
F 3 "" H 950 8100 50  0001 C CNN
	1    2400 6750
	1    0    0    -1  
$EndComp
Entry Wire Line
	1800 6050 1900 5950
Entry Wire Line
	1900 6050 2000 5950
Entry Wire Line
	2000 6050 2100 5950
Entry Wire Line
	2100 6050 2200 5950
Entry Wire Line
	2200 6050 2300 5950
Entry Wire Line
	2300 6050 2400 5950
Entry Wire Line
	2400 6050 2500 5950
Entry Wire Line
	2500 6050 2600 5950
Entry Wire Line
	2700 6150 2800 6050
Entry Wire Line
	2800 6150 2900 6050
Entry Wire Line
	2900 6150 3000 6050
Entry Wire Line
	3000 6150 3100 6050
Entry Wire Line
	3100 6150 3200 6050
Entry Wire Line
	3200 6150 3300 6050
Entry Wire Line
	3300 6150 3400 6050
Entry Wire Line
	3400 6150 3500 6050
Entry Wire Line
	2700 7400 2800 7500
Entry Wire Line
	2800 7400 2900 7500
Entry Wire Line
	2900 7400 3000 7500
Entry Wire Line
	3000 7400 3100 7500
Entry Wire Line
	3100 7400 3200 7500
Entry Wire Line
	3200 7400 3300 7500
Entry Wire Line
	3300 7400 3400 7500
Entry Wire Line
	3400 7400 3500 7500
$Comp
L power:VCC #PWR0109
U 1 1 6088976B
P 1400 6250
F 0 "#PWR0109" H 1400 6100 50  0001 C CNN
F 1 "VCC" H 1350 6400 50  0000 C CNN
F 2 "" H 1400 6250 50  0001 C CNN
F 3 "" H 1400 6250 50  0001 C CNN
	1    1400 6250
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0110
U 1 1 60889771
P 1200 6700
F 0 "#PWR0110" H 1200 6550 50  0001 C CNN
F 1 "VCC" V 1215 6827 50  0000 L CNN
F 2 "" H 1200 6700 50  0001 C CNN
F 3 "" H 1200 6700 50  0001 C CNN
	1    1200 6700
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0111
U 1 1 60889777
P 1500 6250
F 0 "#PWR0111" H 1500 6000 50  0001 C CNN
F 1 "GND" H 1400 6250 50  0000 C CNN
F 2 "" H 1500 6250 50  0001 C CNN
F 3 "" H 1500 6250 50  0001 C CNN
	1    1500 6250
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0112
U 1 1 6088977D
P 1200 6600
F 0 "#PWR0112" H 1200 6350 50  0001 C CNN
F 1 "GND" V 1200 6400 50  0000 C CNN
F 2 "" H 1200 6600 50  0001 C CNN
F 3 "" H 1200 6600 50  0001 C CNN
	1    1200 6600
	0    1    1    0   
$EndComp
Text GLabel 1900 7350 3    50   Input ~ 0
CLK
Text GLabel 2050 7350 3    50   Input ~ 0
~CLK~
Text GLabel 2200 7350 3    50   Input ~ 0
RESET
Wire Wire Line
	2050 7300 2050 7350
Wire Wire Line
	2150 7300 2200 7300
Wire Wire Line
	2200 7300 2200 7350
Wire Wire Line
	1950 7300 1900 7300
Wire Wire Line
	1900 7300 1900 7350
Wire Wire Line
	2400 6050 2400 6250
Wire Wire Line
	2300 6050 2300 6250
Wire Wire Line
	2200 6050 2200 6250
Wire Wire Line
	2100 6050 2100 6250
Wire Wire Line
	2000 6050 2000 6250
Wire Wire Line
	1900 6050 1900 6250
Wire Wire Line
	1800 6050 1800 6250
Text Label 2500 6250 1    50   ~ 0
BUS0
Text Label 2400 6250 1    50   ~ 0
BUS1
Text Label 2300 6250 1    50   ~ 0
BUS2
Text Label 2200 6250 1    50   ~ 0
BUS3
Text Label 2100 6250 1    50   ~ 0
BUS4
Text Label 2000 6250 1    50   ~ 0
BUS5
Text Label 1900 6250 1    50   ~ 0
BUS6
Text Label 1800 6250 1    50   ~ 0
BUS7
Text Label 3400 6250 1    50   ~ 0
A0
Text Label 3300 6250 1    50   ~ 0
A1
Text Label 3200 6250 1    50   ~ 0
A2
Text Label 3100 6250 1    50   ~ 0
A3
Text Label 3000 6250 1    50   ~ 0
A4
Text Label 2900 6250 1    50   ~ 0
A5
Text Label 2800 6250 1    50   ~ 0
A6
Text Label 2700 6250 1    50   ~ 0
A7
Text Label 3400 7400 1    50   ~ 0
B0
Text Label 3300 7400 1    50   ~ 0
B1
Text Label 3200 7400 1    50   ~ 0
B2
Text Label 3100 7400 1    50   ~ 0
B3
Text Label 3000 7400 1    50   ~ 0
B4
Text Label 2900 7400 1    50   ~ 0
B5
Text Label 2800 7400 1    50   ~ 0
B6
Text Label 2700 7400 1    50   ~ 0
B7
Wire Wire Line
	3400 7300 3400 7400
Wire Wire Line
	3300 7300 3300 7400
Wire Wire Line
	3200 7300 3200 7400
Wire Wire Line
	3100 7300 3100 7400
Wire Wire Line
	3000 7300 3000 7400
Wire Wire Line
	2900 7300 2900 7400
Wire Wire Line
	2800 7300 2800 7400
Wire Wire Line
	2700 7300 2700 7400
Wire Wire Line
	3400 6150 3400 6250
Wire Wire Line
	3300 6150 3300 6250
Wire Wire Line
	3200 6150 3200 6250
Wire Wire Line
	3100 6150 3100 6250
Wire Wire Line
	3000 6150 3000 6250
Wire Wire Line
	2900 6150 2900 6250
Wire Wire Line
	2800 6150 2800 6250
Wire Wire Line
	2700 6150 2700 6250
Wire Wire Line
	2500 6050 2500 6250
Wire Bus Line
	3750 800  3750 2550
Wire Bus Line
	3750 2550 3750 4300
Connection ~ 3750 2550
Wire Bus Line
	3750 4300 3750 6050
Connection ~ 3750 4300
Wire Bus Line
	3900 2250 3900 2550
Connection ~ 3900 4000
Wire Bus Line
	3900 4000 3900 5750
Connection ~ 3900 5750
Wire Bus Line
	4050 5950 4050 4200
Wire Bus Line
	4050 4200 4050 2450
Connection ~ 4050 4200
Wire Bus Line
	4050 2450 4050 700 
Connection ~ 4050 2450
Text GLabel 2350 2100 3    50   Input ~ 0
~RESET~
$Comp
L CPU_Modules:Register U1
U 1 1 60734785
P 2400 1500
F 0 "U1" H 1950 1500 50  0000 L CNN
F 1 "Register A" H 2750 1500 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 950 2850 50  0001 C CNN
F 3 "" H 950 2850 50  0001 C CNN
	1    2400 1500
	1    0    0    -1  
$EndComp
Wire Wire Line
	2250 2050 2350 2050
Wire Wire Line
	2350 2050 2350 2100
Text GLabel 2350 3850 3    50   Input ~ 0
~RESET~
Wire Wire Line
	2250 3800 2350 3800
Wire Wire Line
	2350 3800 2350 3850
Text GLabel 2350 5600 3    50   Input ~ 0
~RESET~
Wire Wire Line
	2250 5550 2350 5550
Wire Wire Line
	2350 5550 2350 5600
Text GLabel 2350 7350 3    50   Input ~ 0
~RESET~
Wire Wire Line
	2250 7300 2350 7300
Wire Wire Line
	2350 7300 2350 7350
Text GLabel 10650 1450 2    50   Output ~ 0
~RESET~
Wire Wire Line
	10550 1300 10550 1450
Wire Wire Line
	10550 1450 10650 1450
$Comp
L CPU_Modules:ALU U5
U 1 1 609174F7
P 5850 1500
F 0 "U5" H 5350 1500 50  0000 L CNN
F 1 "Add/Sub" H 5900 1500 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 4400 2850 50  0001 C CNN
F 3 "" H 4400 2850 50  0001 C CNN
	1    5850 1500
	1    0    0    -1  
$EndComp
Entry Wire Line
	5150 700  5250 800 
Entry Wire Line
	5250 700  5350 800 
Entry Wire Line
	5350 700  5450 800 
Entry Wire Line
	5450 700  5550 800 
Entry Wire Line
	5550 700  5650 800 
Entry Wire Line
	5650 700  5750 800 
Entry Wire Line
	5750 700  5850 800 
Entry Wire Line
	5850 700  5950 800 
Connection ~ 4050 700 
Wire Wire Line
	5250 800  5250 1000
Wire Wire Line
	5350 800  5350 1000
Wire Wire Line
	5450 800  5450 1000
Wire Wire Line
	5550 800  5550 1000
Wire Wire Line
	5650 800  5650 1000
Wire Wire Line
	5750 800  5750 1000
Wire Wire Line
	5850 800  5850 1000
Wire Wire Line
	5950 800  5950 1000
Text Label 5950 1000 1    50   ~ 0
BUS0
Text Label 5850 1000 1    50   ~ 0
BUS1
Text Label 5750 1000 1    50   ~ 0
BUS2
Text Label 5650 1000 1    50   ~ 0
BUS3
Text Label 5550 1000 1    50   ~ 0
BUS4
Text Label 5450 1000 1    50   ~ 0
BUS5
Text Label 5350 1000 1    50   ~ 0
BUS6
Text Label 5250 1000 1    50   ~ 0
BUS7
Entry Wire Line
	6750 750  6850 850 
Entry Wire Line
	6650 750  6750 850 
Entry Wire Line
	6550 750  6650 850 
Entry Wire Line
	6450 750  6550 850 
Entry Wire Line
	6350 750  6450 850 
Entry Wire Line
	6250 750  6350 850 
Entry Wire Line
	6150 750  6250 850 
Entry Wire Line
	6050 750  6150 850 
Wire Bus Line
	6050 600  3750 600 
Wire Bus Line
	3750 600  3750 800 
Wire Bus Line
	6050 600  6050 750 
Connection ~ 3750 800 
Wire Wire Line
	6850 850  6850 1000
Wire Wire Line
	6750 850  6750 1000
Wire Wire Line
	6650 850  6650 1000
Wire Wire Line
	6550 850  6550 1000
Wire Wire Line
	6450 850  6450 1000
Wire Wire Line
	6350 850  6350 1000
Wire Wire Line
	6250 850  6250 1000
Wire Wire Line
	6150 850  6150 1000
Entry Wire Line
	6750 2250 6850 2150
Entry Wire Line
	6650 2250 6750 2150
Entry Wire Line
	6450 2250 6550 2150
Entry Wire Line
	6550 2250 6650 2150
Entry Wire Line
	6350 2250 6450 2150
Entry Wire Line
	6250 2250 6350 2150
Entry Wire Line
	6150 2250 6250 2150
Entry Wire Line
	6050 2250 6150 2150
Wire Wire Line
	6850 2050 6850 2150
Wire Wire Line
	6750 2050 6750 2150
Wire Wire Line
	6650 2050 6650 2150
Wire Wire Line
	6550 2050 6550 2150
Wire Wire Line
	6450 2050 6450 2150
Wire Wire Line
	6350 2050 6350 2150
Wire Wire Line
	6250 2050 6250 2150
Wire Wire Line
	6150 2050 6150 2150
Connection ~ 3900 2550
Wire Bus Line
	3900 2550 3900 4000
Text Label 6850 2150 1    50   ~ 0
B0
Text Label 6750 2150 1    50   ~ 0
B1
Text Label 6650 2150 1    50   ~ 0
B2
Text Label 6550 2150 1    50   ~ 0
B3
Text Label 6450 2150 1    50   ~ 0
B4
Text Label 6350 2150 1    50   ~ 0
B5
Text Label 6250 2150 1    50   ~ 0
B6
Text Label 6150 2150 1    50   ~ 0
B7
Entry Wire Line
	5700 2200 5800 2300
Entry Wire Line
	5600 2200 5700 2300
Entry Wire Line
	5500 2200 5600 2300
Entry Wire Line
	5400 2200 5500 2300
Wire Bus Line
	6000 2250 6000 2550
Wire Bus Line
	3900 2550 6000 2550
Text Label 5400 2200 1    50   ~ 0
CFA
Wire Wire Line
	5400 2050 5400 2200
Wire Wire Line
	5500 2050 5500 2200
Wire Wire Line
	5600 2050 5600 2200
Wire Wire Line
	5700 2050 5700 2200
Text Label 5500 2200 1    50   ~ 0
V
Text Label 5600 2200 1    50   ~ 0
CAF
Text Label 5700 2200 1    50   ~ 0
Z
$Comp
L power:VCC #PWR010
U 1 1 60B2B22F
P 4850 1000
F 0 "#PWR010" H 4850 850 50  0001 C CNN
F 1 "VCC" H 4800 1150 50  0000 C CNN
F 2 "" H 4850 1000 50  0001 C CNN
F 3 "" H 4850 1000 50  0001 C CNN
	1    4850 1000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR014
U 1 1 60B2BB33
P 4950 1000
F 0 "#PWR014" H 4950 750 50  0001 C CNN
F 1 "GND" H 4850 1000 50  0000 C CNN
F 2 "" H 4950 1000 50  0001 C CNN
F 3 "" H 4950 1000 50  0001 C CNN
	1    4950 1000
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR03
U 1 1 60B2C4A3
P 4650 1350
F 0 "#PWR03" H 4650 1100 50  0001 C CNN
F 1 "GND" V 4650 1150 50  0000 C CNN
F 2 "" H 4650 1350 50  0001 C CNN
F 3 "" H 4650 1350 50  0001 C CNN
	1    4650 1350
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR04
U 1 1 60B2C8FE
P 4650 1450
F 0 "#PWR04" H 4650 1300 50  0001 C CNN
F 1 "VCC" V 4665 1577 50  0000 L CNN
F 2 "" H 4650 1450 50  0001 C CNN
F 3 "" H 4650 1450 50  0001 C CNN
	1    4650 1450
	0    -1   -1   0   
$EndComp
$Comp
L CPU_Modules:ALU U6
U 1 1 60B40560
P 5850 3600
F 0 "U6" H 5350 3600 50  0000 L CNN
F 1 "And/Or" H 5900 3600 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 4400 4950 50  0001 C CNN
F 3 "" H 4400 4950 50  0001 C CNN
	1    5850 3600
	1    0    0    -1  
$EndComp
Entry Wire Line
	5150 2800 5250 2900
Entry Wire Line
	5250 2800 5350 2900
Entry Wire Line
	5350 2800 5450 2900
Entry Wire Line
	5450 2800 5550 2900
Entry Wire Line
	5550 2800 5650 2900
Entry Wire Line
	5650 2800 5750 2900
Entry Wire Line
	5750 2800 5850 2900
Entry Wire Line
	5850 2800 5950 2900
Wire Wire Line
	5250 2900 5250 3100
Wire Wire Line
	5350 2900 5350 3100
Wire Wire Line
	5450 2900 5450 3100
Wire Wire Line
	5550 2900 5550 3100
Wire Wire Line
	5650 2900 5650 3100
Wire Wire Line
	5750 2900 5750 3100
Wire Wire Line
	5850 2900 5850 3100
Wire Wire Line
	5950 2900 5950 3100
Text Label 5950 3100 1    50   ~ 0
BUS0
Text Label 5850 3100 1    50   ~ 0
BUS1
Text Label 5750 3100 1    50   ~ 0
BUS2
Text Label 5650 3100 1    50   ~ 0
BUS3
Text Label 5550 3100 1    50   ~ 0
BUS4
Text Label 5450 3100 1    50   ~ 0
BUS5
Text Label 5350 3100 1    50   ~ 0
BUS6
Text Label 5250 3100 1    50   ~ 0
BUS7
Entry Wire Line
	6750 2850 6850 2950
Entry Wire Line
	6650 2850 6750 2950
Entry Wire Line
	6550 2850 6650 2950
Entry Wire Line
	6450 2850 6550 2950
Entry Wire Line
	6350 2850 6450 2950
Entry Wire Line
	6250 2850 6350 2950
Entry Wire Line
	6150 2850 6250 2950
Entry Wire Line
	6050 2850 6150 2950
Wire Bus Line
	6050 2700 3750 2700
Wire Bus Line
	6050 2700 6050 2850
Wire Wire Line
	6850 2950 6850 3100
Wire Wire Line
	6750 2950 6750 3100
Wire Wire Line
	6650 2950 6650 3100
Wire Wire Line
	6550 2950 6550 3100
Wire Wire Line
	6450 2950 6450 3100
Wire Wire Line
	6350 2950 6350 3100
Wire Wire Line
	6250 2950 6250 3100
Wire Wire Line
	6150 2950 6150 3100
Entry Wire Line
	6750 4350 6850 4250
Entry Wire Line
	6650 4350 6750 4250
Entry Wire Line
	6450 4350 6550 4250
Entry Wire Line
	6550 4350 6650 4250
Entry Wire Line
	6350 4350 6450 4250
Entry Wire Line
	6250 4350 6350 4250
Entry Wire Line
	6150 4350 6250 4250
Entry Wire Line
	6050 4350 6150 4250
Wire Wire Line
	6850 4150 6850 4250
Wire Wire Line
	6750 4150 6750 4250
Wire Wire Line
	6650 4150 6650 4250
Wire Wire Line
	6550 4150 6550 4250
Wire Wire Line
	6450 4150 6450 4250
Wire Wire Line
	6350 4150 6350 4250
Wire Wire Line
	6250 4150 6250 4250
Wire Wire Line
	6150 4150 6150 4250
Text Label 6850 4250 1    50   ~ 0
B0
Text Label 6750 4250 1    50   ~ 0
B1
Text Label 6650 4250 1    50   ~ 0
B2
Text Label 6550 4250 1    50   ~ 0
B3
Text Label 6450 4250 1    50   ~ 0
B4
Text Label 6350 4250 1    50   ~ 0
B5
Text Label 6250 4250 1    50   ~ 0
B6
Text Label 6150 4250 1    50   ~ 0
B7
Entry Wire Line
	5700 4300 5800 4400
Entry Wire Line
	5600 4300 5700 4400
Entry Wire Line
	5500 4300 5600 4400
Entry Wire Line
	5400 4300 5500 4400
Wire Bus Line
	6000 4350 6000 4650
Wire Bus Line
	3900 4650 6000 4650
Text Label 5400 4300 1    50   ~ 0
CFA
Wire Wire Line
	5400 4150 5400 4300
Wire Wire Line
	5500 4150 5500 4300
Wire Wire Line
	5600 4150 5600 4300
Wire Wire Line
	5700 4150 5700 4300
Text Label 5500 4300 1    50   ~ 0
V
Text Label 5600 4300 1    50   ~ 0
CAF
Text Label 5700 4300 1    50   ~ 0
Z
$Comp
L power:VCC #PWR011
U 1 1 60B405BA
P 4850 3100
F 0 "#PWR011" H 4850 2950 50  0001 C CNN
F 1 "VCC" H 4800 3250 50  0000 C CNN
F 2 "" H 4850 3100 50  0001 C CNN
F 3 "" H 4850 3100 50  0001 C CNN
	1    4850 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR015
U 1 1 60B405C0
P 4950 3100
F 0 "#PWR015" H 4950 2850 50  0001 C CNN
F 1 "GND" H 4850 3100 50  0000 C CNN
F 2 "" H 4950 3100 50  0001 C CNN
F 3 "" H 4950 3100 50  0001 C CNN
	1    4950 3100
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR05
U 1 1 60B405C6
P 4650 3450
F 0 "#PWR05" H 4650 3200 50  0001 C CNN
F 1 "GND" V 4650 3250 50  0000 C CNN
F 2 "" H 4650 3450 50  0001 C CNN
F 3 "" H 4650 3450 50  0001 C CNN
	1    4650 3450
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR06
U 1 1 60B405CC
P 4650 3550
F 0 "#PWR06" H 4650 3400 50  0001 C CNN
F 1 "VCC" V 4665 3677 50  0000 L CNN
F 2 "" H 4650 3550 50  0001 C CNN
F 3 "" H 4650 3550 50  0001 C CNN
	1    4650 3550
	0    -1   -1   0   
$EndComp
$Comp
L CPU_Modules:ALU U7
U 1 1 60B566A4
P 5850 5650
F 0 "U7" H 5350 5650 50  0000 L CNN
F 1 "Xor/Not" H 5900 5650 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 4400 7000 50  0001 C CNN
F 3 "" H 4400 7000 50  0001 C CNN
	1    5850 5650
	1    0    0    -1  
$EndComp
Entry Wire Line
	5150 4850 5250 4950
Entry Wire Line
	5250 4850 5350 4950
Entry Wire Line
	5350 4850 5450 4950
Entry Wire Line
	5450 4850 5550 4950
Entry Wire Line
	5550 4850 5650 4950
Entry Wire Line
	5650 4850 5750 4950
Entry Wire Line
	5750 4850 5850 4950
Entry Wire Line
	5850 4850 5950 4950
Wire Wire Line
	5250 4950 5250 5150
Wire Wire Line
	5350 4950 5350 5150
Wire Wire Line
	5450 4950 5450 5150
Wire Wire Line
	5550 4950 5550 5150
Wire Wire Line
	5650 4950 5650 5150
Wire Wire Line
	5750 4950 5750 5150
Wire Wire Line
	5850 4950 5850 5150
Wire Wire Line
	5950 4950 5950 5150
Text Label 5950 5150 1    50   ~ 0
BUS0
Text Label 5850 5150 1    50   ~ 0
BUS1
Text Label 5750 5150 1    50   ~ 0
BUS2
Text Label 5650 5150 1    50   ~ 0
BUS3
Text Label 5550 5150 1    50   ~ 0
BUS4
Text Label 5450 5150 1    50   ~ 0
BUS5
Text Label 5350 5150 1    50   ~ 0
BUS6
Text Label 5250 5150 1    50   ~ 0
BUS7
Entry Wire Line
	6750 4900 6850 5000
Entry Wire Line
	6650 4900 6750 5000
Entry Wire Line
	6550 4900 6650 5000
Entry Wire Line
	6450 4900 6550 5000
Entry Wire Line
	6350 4900 6450 5000
Entry Wire Line
	6250 4900 6350 5000
Entry Wire Line
	6150 4900 6250 5000
Entry Wire Line
	6050 4900 6150 5000
Wire Bus Line
	6050 4750 3750 4750
Wire Bus Line
	6050 4750 6050 4900
Wire Wire Line
	6850 5000 6850 5150
Wire Wire Line
	6750 5000 6750 5150
Wire Wire Line
	6650 5000 6650 5150
Wire Wire Line
	6550 5000 6550 5150
Wire Wire Line
	6450 5000 6450 5150
Wire Wire Line
	6350 5000 6350 5150
Wire Wire Line
	6250 5000 6250 5150
Wire Wire Line
	6150 5000 6150 5150
Entry Wire Line
	6750 6400 6850 6300
Entry Wire Line
	6650 6400 6750 6300
Entry Wire Line
	6450 6400 6550 6300
Entry Wire Line
	6550 6400 6650 6300
Entry Wire Line
	6350 6400 6450 6300
Entry Wire Line
	6250 6400 6350 6300
Entry Wire Line
	6150 6400 6250 6300
Entry Wire Line
	6050 6400 6150 6300
Wire Wire Line
	6850 6200 6850 6300
Wire Wire Line
	6750 6200 6750 6300
Wire Wire Line
	6650 6200 6650 6300
Wire Wire Line
	6550 6200 6550 6300
Wire Wire Line
	6450 6200 6450 6300
Wire Wire Line
	6350 6200 6350 6300
Wire Wire Line
	6250 6200 6250 6300
Wire Wire Line
	6150 6200 6150 6300
Text Label 6850 6300 1    50   ~ 0
B0
Text Label 6750 6300 1    50   ~ 0
B1
Text Label 6650 6300 1    50   ~ 0
B2
Text Label 6550 6300 1    50   ~ 0
B3
Text Label 6450 6300 1    50   ~ 0
B4
Text Label 6350 6300 1    50   ~ 0
B5
Text Label 6250 6300 1    50   ~ 0
B6
Text Label 6150 6300 1    50   ~ 0
B7
Entry Wire Line
	5700 6350 5800 6450
Entry Wire Line
	5600 6350 5700 6450
Entry Wire Line
	5500 6350 5600 6450
Entry Wire Line
	5400 6350 5500 6450
Text Label 5400 6350 1    50   ~ 0
CFA
Wire Wire Line
	5400 6200 5400 6350
Wire Wire Line
	5500 6200 5500 6350
Wire Wire Line
	5600 6200 5600 6350
Wire Wire Line
	5700 6200 5700 6350
Text Label 5500 6350 1    50   ~ 0
V
Text Label 5600 6350 1    50   ~ 0
CAF
Text Label 5700 6350 1    50   ~ 0
Z
$Comp
L power:VCC #PWR012
U 1 1 60B566FE
P 4850 5150
F 0 "#PWR012" H 4850 5000 50  0001 C CNN
F 1 "VCC" H 4800 5300 50  0000 C CNN
F 2 "" H 4850 5150 50  0001 C CNN
F 3 "" H 4850 5150 50  0001 C CNN
	1    4850 5150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR016
U 1 1 60B56704
P 4950 5150
F 0 "#PWR016" H 4950 4900 50  0001 C CNN
F 1 "GND" H 4850 5150 50  0000 C CNN
F 2 "" H 4950 5150 50  0001 C CNN
F 3 "" H 4950 5150 50  0001 C CNN
	1    4950 5150
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR07
U 1 1 60B5670A
P 4650 5500
F 0 "#PWR07" H 4650 5250 50  0001 C CNN
F 1 "GND" V 4650 5300 50  0000 C CNN
F 2 "" H 4650 5500 50  0001 C CNN
F 3 "" H 4650 5500 50  0001 C CNN
	1    4650 5500
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR08
U 1 1 60B56710
P 4650 5600
F 0 "#PWR08" H 4650 5450 50  0001 C CNN
F 1 "VCC" V 4665 5727 50  0000 L CNN
F 2 "" H 4650 5600 50  0001 C CNN
F 3 "" H 4650 5600 50  0001 C CNN
	1    4650 5600
	0    -1   -1   0   
$EndComp
$Comp
L CPU_Modules:ALU U8
U 1 1 60B739B7
P 8900 1500
F 0 "U8" H 8400 1500 50  0000 L CNN
F 1 "Shift" H 8950 1500 50  0000 L CNN
F 2 "CPU_Modules:Register_board" H 7450 2850 50  0001 C CNN
F 3 "" H 7450 2850 50  0001 C CNN
	1    8900 1500
	1    0    0    -1  
$EndComp
Entry Wire Line
	8200 700  8300 800 
Entry Wire Line
	8300 700  8400 800 
Entry Wire Line
	8400 700  8500 800 
Entry Wire Line
	8500 700  8600 800 
Entry Wire Line
	8600 700  8700 800 
Entry Wire Line
	8700 700  8800 800 
Entry Wire Line
	8800 700  8900 800 
Entry Wire Line
	8900 700  9000 800 
Wire Wire Line
	8300 800  8300 1000
Wire Wire Line
	8400 800  8400 1000
Wire Wire Line
	8500 800  8500 1000
Wire Wire Line
	8600 800  8600 1000
Wire Wire Line
	8700 800  8700 1000
Wire Wire Line
	8800 800  8800 1000
Wire Wire Line
	8900 800  8900 1000
Wire Wire Line
	9000 800  9000 1000
Text Label 9000 1000 1    50   ~ 0
BUS0
Text Label 8900 1000 1    50   ~ 0
BUS1
Text Label 8800 1000 1    50   ~ 0
BUS2
Text Label 8700 1000 1    50   ~ 0
BUS3
Text Label 8600 1000 1    50   ~ 0
BUS4
Text Label 8500 1000 1    50   ~ 0
BUS5
Text Label 8400 1000 1    50   ~ 0
BUS6
Text Label 8300 1000 1    50   ~ 0
BUS7
Entry Wire Line
	9800 750  9900 850 
Entry Wire Line
	9700 750  9800 850 
Entry Wire Line
	9600 750  9700 850 
Entry Wire Line
	9500 750  9600 850 
Entry Wire Line
	9400 750  9500 850 
Entry Wire Line
	9300 750  9400 850 
Entry Wire Line
	9200 750  9300 850 
Entry Wire Line
	9100 750  9200 850 
Wire Bus Line
	9100 600  9100 750 
Wire Wire Line
	9900 850  9900 1000
Wire Wire Line
	9800 850  9800 1000
Wire Wire Line
	9700 850  9700 1000
Wire Wire Line
	9600 850  9600 1000
Wire Wire Line
	9500 850  9500 1000
Wire Wire Line
	9400 850  9400 1000
Wire Wire Line
	9300 850  9300 1000
Wire Wire Line
	9200 850  9200 1000
Entry Wire Line
	9800 2250 9900 2150
Entry Wire Line
	9700 2250 9800 2150
Entry Wire Line
	9500 2250 9600 2150
Entry Wire Line
	9600 2250 9700 2150
Entry Wire Line
	9400 2250 9500 2150
Entry Wire Line
	9300 2250 9400 2150
Entry Wire Line
	9200 2250 9300 2150
Entry Wire Line
	9100 2250 9200 2150
Wire Wire Line
	9900 2050 9900 2150
Wire Wire Line
	9800 2050 9800 2150
Wire Wire Line
	9700 2050 9700 2150
Wire Wire Line
	9600 2050 9600 2150
Wire Wire Line
	9500 2050 9500 2150
Wire Wire Line
	9400 2050 9400 2150
Wire Wire Line
	9300 2050 9300 2150
Wire Wire Line
	9200 2050 9200 2150
Text Label 9900 2150 1    50   ~ 0
B0
Text Label 9800 2150 1    50   ~ 0
B1
Text Label 9700 2150 1    50   ~ 0
B2
Text Label 9600 2150 1    50   ~ 0
B3
Text Label 9500 2150 1    50   ~ 0
B4
Text Label 9400 2150 1    50   ~ 0
B5
Text Label 9300 2150 1    50   ~ 0
B6
Text Label 9200 2150 1    50   ~ 0
B7
Entry Wire Line
	8750 2300 8650 2400
Entry Wire Line
	8650 2300 8550 2400
Entry Wire Line
	8550 2300 8450 2400
Entry Wire Line
	8450 2300 8350 2400
Wire Bus Line
	9050 2250 9050 2550
Text Label 8450 2200 1    50   ~ 0
CFA
Text Label 8550 2200 1    50   ~ 0
V
Text Label 8650 2200 1    50   ~ 0
CAF
Text Label 8750 2200 1    50   ~ 0
Z
$Comp
L power:VCC #PWR019
U 1 1 60B73A11
P 7900 1000
F 0 "#PWR019" H 7900 850 50  0001 C CNN
F 1 "VCC" H 7850 1150 50  0000 C CNN
F 2 "" H 7900 1000 50  0001 C CNN
F 3 "" H 7900 1000 50  0001 C CNN
	1    7900 1000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR020
U 1 1 60B73A17
P 8000 1000
F 0 "#PWR020" H 8000 750 50  0001 C CNN
F 1 "GND" H 7900 1000 50  0000 C CNN
F 2 "" H 8000 1000 50  0001 C CNN
F 3 "" H 8000 1000 50  0001 C CNN
	1    8000 1000
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR017
U 1 1 60B73A1D
P 7700 1350
F 0 "#PWR017" H 7700 1100 50  0001 C CNN
F 1 "GND" V 7700 1150 50  0000 C CNN
F 2 "" H 7700 1350 50  0001 C CNN
F 3 "" H 7700 1350 50  0001 C CNN
	1    7700 1350
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR018
U 1 1 60B73A23
P 7700 1450
F 0 "#PWR018" H 7700 1300 50  0001 C CNN
F 1 "VCC" V 7715 1577 50  0000 L CNN
F 2 "" H 7700 1450 50  0001 C CNN
F 3 "" H 7700 1450 50  0001 C CNN
	1    7700 1450
	0    -1   -1   0   
$EndComp
Wire Bus Line
	6000 2550 9050 2550
Connection ~ 6000 2550
Wire Bus Line
	6050 600  9100 600 
Connection ~ 6050 600 
Wire Bus Line
	7100 2300 7100 2400
Connection ~ 7100 4400
Wire Bus Line
	7100 4400 7100 6450
Text Label 6850 1000 1    50   ~ 0
A0
Text Label 6750 1000 1    50   ~ 0
A1
Text Label 6650 1000 1    50   ~ 0
A2
Text Label 6550 1000 1    50   ~ 0
A3
Text Label 6450 1000 1    50   ~ 0
A4
Text Label 6350 1000 1    50   ~ 0
A5
Text Label 6250 1000 1    50   ~ 0
A6
Text Label 6150 1000 1    50   ~ 0
A7
Text Label 9900 1000 1    50   ~ 0
A0
Text Label 9800 1000 1    50   ~ 0
A1
Text Label 9700 1000 1    50   ~ 0
A2
Text Label 9600 1000 1    50   ~ 0
A3
Text Label 9500 1000 1    50   ~ 0
A4
Text Label 9400 1000 1    50   ~ 0
A5
Text Label 9300 1000 1    50   ~ 0
A6
Text Label 9200 1000 1    50   ~ 0
A7
Text Label 6850 3100 1    50   ~ 0
A0
Text Label 6750 3100 1    50   ~ 0
A1
Text Label 6650 3100 1    50   ~ 0
A2
Text Label 6450 3100 1    50   ~ 0
A4
Text Label 6550 3100 1    50   ~ 0
A3
Text Label 6350 3100 1    50   ~ 0
A5
Text Label 6150 3100 1    50   ~ 0
A7
Text Label 6250 3100 1    50   ~ 0
A6
Text Label 6850 5150 1    50   ~ 0
A0
Text Label 6750 5150 1    50   ~ 0
A1
Text Label 6650 5150 1    50   ~ 0
A2
Text Label 6550 5150 1    50   ~ 0
A3
Text Label 6450 5150 1    50   ~ 0
A4
Text Label 6350 5150 1    50   ~ 0
A5
Text Label 6250 5150 1    50   ~ 0
A6
Text Label 6150 5150 1    50   ~ 0
A7
$Comp
L CPU_Modules:Flags U9
U 1 1 607C2303
P 8900 3600
F 0 "U9" H 8500 3600 50  0000 L CNN
F 1 "Flags" H 9250 3600 50  0000 L CNN
F 2 "CPU_Modules:Flags_board" H 7450 4950 50  0001 C CNN
F 3 "" H 7450 4950 50  0001 C CNN
	1    8900 3600
	1    0    0    -1  
$EndComp
Entry Wire Line
	8200 2800 8300 2900
Entry Wire Line
	8300 2800 8400 2900
Entry Wire Line
	8400 2800 8500 2900
Entry Wire Line
	8500 2800 8600 2900
Entry Wire Line
	8600 2800 8700 2900
Entry Wire Line
	8700 2800 8800 2900
Entry Wire Line
	8800 2800 8900 2900
Entry Wire Line
	8900 2800 9000 2900
Wire Wire Line
	8300 2900 8300 3100
Wire Wire Line
	8400 2900 8400 3100
Wire Wire Line
	8500 2900 8500 3100
Wire Wire Line
	8600 2900 8600 3100
Wire Wire Line
	8700 2900 8700 3100
Wire Wire Line
	8800 2900 8800 3100
Wire Wire Line
	8900 2900 8900 3100
Wire Wire Line
	9000 2900 9000 3100
Text Label 9000 3100 1    50   ~ 0
BUS0
Text Label 8900 3100 1    50   ~ 0
BUS1
Text Label 8800 3100 1    50   ~ 0
BUS2
Text Label 8700 3100 1    50   ~ 0
BUS3
Text Label 8600 3100 1    50   ~ 0
BUS4
Text Label 8500 3100 1    50   ~ 0
BUS5
Text Label 8400 3100 1    50   ~ 0
BUS6
Text Label 8300 3100 1    50   ~ 0
BUS7
$Comp
L power:VCC #PWR023
U 1 1 607D3E2B
P 7900 3100
F 0 "#PWR023" H 7900 2950 50  0001 C CNN
F 1 "VCC" H 7850 3250 50  0000 C CNN
F 2 "" H 7900 3100 50  0001 C CNN
F 3 "" H 7900 3100 50  0001 C CNN
	1    7900 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR024
U 1 1 607D3E31
P 8000 3100
F 0 "#PWR024" H 8000 2850 50  0001 C CNN
F 1 "GND" H 7900 3100 50  0000 C CNN
F 2 "" H 8000 3100 50  0001 C CNN
F 3 "" H 8000 3100 50  0001 C CNN
	1    8000 3100
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR021
U 1 1 607F61B0
P 7700 3450
F 0 "#PWR021" H 7700 3200 50  0001 C CNN
F 1 "GND" V 7700 3250 50  0000 C CNN
F 2 "" H 7700 3450 50  0001 C CNN
F 3 "" H 7700 3450 50  0001 C CNN
	1    7700 3450
	0    1    1    0   
$EndComp
$Comp
L power:VCC #PWR022
U 1 1 607F67FA
P 7700 3550
F 0 "#PWR022" H 7700 3400 50  0001 C CNN
F 1 "VCC" V 7715 3677 50  0000 L CNN
F 2 "" H 7700 3550 50  0001 C CNN
F 3 "" H 7700 3550 50  0001 C CNN
	1    7700 3550
	0    -1   -1   0   
$EndComp
Entry Wire Line
	9900 2950 9800 2850
Entry Wire Line
	9800 2950 9700 2850
Entry Wire Line
	9700 2950 9600 2850
Entry Wire Line
	9600 2950 9500 2850
Text Label 9600 2950 3    50   ~ 0
CFA
Wire Wire Line
	9600 3100 9600 2950
Wire Wire Line
	9700 3100 9700 2950
Wire Wire Line
	9800 3100 9800 2950
Wire Wire Line
	9900 3100 9900 2950
Text Label 9700 3050 3    50   ~ 0
V
Text Label 9800 2950 3    50   ~ 0
CAF
Text Label 9900 3050 3    50   ~ 0
Z
Wire Bus Line
	9100 2850 9100 2650
Wire Bus Line
	9100 2650 7100 2650
Connection ~ 7100 2650
Wire Bus Line
	7100 2650 7100 4400
Text GLabel 8400 4200 3    50   Input ~ 0
CLK
Text GLabel 8550 4200 3    50   Input ~ 0
~CLK~
Text GLabel 8700 4200 3    50   Input ~ 0
RESET
Text GLabel 8850 4200 3    50   Input ~ 0
~RESET~
Wire Wire Line
	8450 4150 8400 4150
Wire Wire Line
	8400 4150 8400 4200
Wire Wire Line
	8550 4200 8550 4150
Wire Wire Line
	8700 4200 8700 4150
Wire Wire Line
	8700 4150 8650 4150
Wire Wire Line
	8750 4150 8850 4150
Wire Wire Line
	8850 4150 8850 4200
$Comp
L Connector:Conn_01x08_Female J2
U 1 1 60999772
P 4500 7150
F 0 "J2" H 4650 7000 50  0000 C CNN
F 1 "BUS" H 4650 7100 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 4500 7150 50  0001 C CNN
F 3 "~" H 4500 7150 50  0001 C CNN
	1    4500 7150
	1    0    0    1   
$EndComp
Entry Wire Line
	4050 6650 4150 6750
Entry Wire Line
	4050 7350 4150 7450
Connection ~ 4050 5950
Entry Wire Line
	4050 6750 4150 6850
Entry Wire Line
	4050 6850 4150 6950
Entry Wire Line
	4050 6950 4150 7050
Entry Wire Line
	4050 7050 4150 7150
Entry Wire Line
	4050 7150 4150 7250
Entry Wire Line
	4050 7250 4150 7350
Text Label 4150 6750 0    50   ~ 0
BUS0
Text Label 4150 6850 0    50   ~ 0
BUS1
Text Label 4150 6950 0    50   ~ 0
BUS2
Text Label 4150 7050 0    50   ~ 0
BUS3
Text Label 4150 7150 0    50   ~ 0
BUS4
Text Label 4150 7250 0    50   ~ 0
BUS5
Text Label 4150 7350 0    50   ~ 0
BUS6
Text Label 4150 7450 0    50   ~ 0
BUS7
Wire Wire Line
	4150 6750 4300 6750
Wire Wire Line
	4300 6850 4150 6850
Wire Wire Line
	4150 6950 4300 6950
Wire Wire Line
	4300 7050 4150 7050
Wire Wire Line
	4150 7150 4300 7150
Wire Wire Line
	4300 7250 4150 7250
Wire Wire Line
	4150 7350 4300 7350
Wire Wire Line
	4300 7450 4150 7450
$Comp
L Connector:Conn_01x04_Female J3
U 1 1 60C74233
P 9700 4350
F 0 "J3" V 9546 4062 50  0000 R CNN
F 1 "FLAGS" V 9637 4062 50  0000 R CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 9700 4350 50  0001 C CNN
F 3 "~" H 9700 4350 50  0001 C CNN
	1    9700 4350
	0    -1   1    0   
$EndComp
Text GLabel 1400 2050 3    50   Input ~ 0
OUT_A
Text GLabel 1500 2050 3    50   Input ~ 0
LOAD_A
Text GLabel 1600 2050 3    50   Input ~ 0
ARG_AA
Text GLabel 1700 2050 3    50   Input ~ 0
ARG_AB
Text GLabel 1400 3800 3    50   Input ~ 0
OUT_B
Text GLabel 1500 3800 3    50   Input ~ 0
LOAD_B
Text GLabel 1600 3800 3    50   Input ~ 0
ARG_BA
Text GLabel 1700 3800 3    50   Input ~ 0
ARG_BB
Text GLabel 1400 5550 3    50   Input ~ 0
OUT_C
Text GLabel 1500 5550 3    50   Input ~ 0
LOAD_C
Text GLabel 1600 5550 3    50   Input ~ 0
ARG_CA
Text GLabel 1700 5550 3    50   Input ~ 0
ARG_CB
Text GLabel 1400 7300 3    50   Input ~ 0
OUT_D
Text GLabel 1500 7300 3    50   Input ~ 0
LOAD_D
Text GLabel 1600 7300 3    50   Input ~ 0
ARG_DA
Text GLabel 1700 7300 3    50   Input ~ 0
ARG_DB
Text GLabel 4850 2050 3    50   Input ~ 0
OUT_AS
Text GLabel 4950 2050 3    50   Input ~ 0
ALT_AS
Text GLabel 4850 4150 3    50   Input ~ 0
OUT_AO
Text GLabel 4950 4150 3    50   Input ~ 0
ALT_AO
Text GLabel 4850 6200 3    50   Input ~ 0
OUT_XN
Text GLabel 4950 6200 3    50   Input ~ 0
ALT_XN
Wire Bus Line
	3900 6600 6000 6600
Connection ~ 3900 6600
Wire Bus Line
	3900 6600 3900 7500
Wire Bus Line
	6000 6400 6000 6600
Wire Bus Line
	3900 5750 3900 6600
Text GLabel 7900 2050 3    50   Input ~ 0
OUT_S
Text GLabel 8000 2050 3    50   Input ~ 0
ALT_S
Connection ~ 7100 2400
Wire Bus Line
	7100 2400 7100 2650
Wire Wire Line
	8450 2050 8450 2300
Wire Wire Line
	8550 2050 8550 2300
Wire Wire Line
	8650 2050 8650 2300
Wire Wire Line
	8750 2050 8750 2300
$Comp
L Connector:Conn_01x08_Female J4
U 1 1 60A3EB8D
P 7450 5600
F 0 "J4" H 7250 5050 50  0000 C CNN
F 1 "OUT" H 7050 5050 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 7450 5600 50  0001 C CNN
F 3 "~" H 7450 5600 50  0001 C CNN
	1    7450 5600
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x04_Female J6
U 1 1 60A41B94
P 8150 5400
F 0 "J6" H 7950 5100 50  0000 C CNN
F 1 "LOAD" H 7750 5100 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 8150 5400 50  0001 C CNN
F 3 "~" H 8150 5400 50  0001 C CNN
	1    8150 5400
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x04_Female J8
U 1 1 60A674DE
P 8850 5400
F 0 "J8" H 8750 5050 50  0000 C CNN
F 1 "ARG_A" H 8500 5050 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 8850 5400 50  0001 C CNN
F 3 "~" H 8850 5400 50  0001 C CNN
	1    8850 5400
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x04_Female J5
U 1 1 60A67D60
P 8000 4350
F 0 "J5" V 8100 4500 50  0000 R CNN
F 1 "F_CTRL" V 8100 4350 50  0000 R CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 8000 4350 50  0001 C CNN
F 3 "~" H 8000 4350 50  0001 C CNN
	1    8000 4350
	0    -1   1    0   
$EndComp
$Comp
L Connector:Conn_01x04_Female J9
U 1 1 60A69B1B
P 8850 6000
F 0 "J9" H 8750 5700 50  0000 C CNN
F 1 "ARG_B" H 8500 5700 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 8850 6000 50  0001 C CNN
F 3 "~" H 8850 6000 50  0001 C CNN
	1    8850 6000
	-1   0    0    1   
$EndComp
Text GLabel 7650 5900 2    50   Output ~ 0
OUT_A
Text GLabel 7650 5800 2    50   Output ~ 0
OUT_B
Text GLabel 7650 5700 2    50   Output ~ 0
OUT_C
Text GLabel 7650 5600 2    50   Output ~ 0
OUT_D
Text GLabel 7650 5500 2    50   Output ~ 0
OUT_AS
Text GLabel 7650 5400 2    50   Output ~ 0
OUT_AO
Text GLabel 7650 5300 2    50   Output ~ 0
OUT_S
Text GLabel 7650 5200 2    50   Output ~ 0
OUT_XN
Text GLabel 8350 5500 2    50   Output ~ 0
LOAD_A
Text GLabel 8350 5400 2    50   Output ~ 0
LOAD_B
Text GLabel 8350 5300 2    50   Output ~ 0
LOAD_C
Text GLabel 8350 5200 2    50   Output ~ 0
LOAD_D
Text GLabel 9050 5500 2    50   Input ~ 0
ARG_AA
Text GLabel 9050 5400 2    50   Input ~ 0
ARG_BA
Text GLabel 9050 5300 2    50   Input ~ 0
ARG_CA
Text GLabel 9050 5200 2    50   Input ~ 0
ARG_DA
Text GLabel 9050 6100 2    50   Input ~ 0
ARG_AB
Text GLabel 9050 6000 2    50   Input ~ 0
ARG_BB
Text GLabel 9050 5900 2    50   Input ~ 0
ARG_CB
Text GLabel 9050 5800 2    50   Input ~ 0
ARG_DB
Wire Bus Line
	5500 6450 7100 6450
Wire Bus Line
	5500 4400 7100 4400
Wire Bus Line
	5500 2300 7100 2300
Wire Bus Line
	9100 2850 9800 2850
Wire Bus Line
	7100 2400 8650 2400
Wire Bus Line
	6050 750  6750 750 
Wire Bus Line
	6050 2850 6750 2850
Wire Bus Line
	6050 4900 6750 4900
Wire Bus Line
	9100 750  9800 750 
Wire Bus Line
	4050 5950 4050 7350
Wire Bus Line
	2800 7500 3900 7500
Wire Bus Line
	2800 6050 3750 6050
Wire Bus Line
	1900 5950 4050 5950
Wire Bus Line
	2800 5750 3900 5750
Wire Bus Line
	2800 4300 3750 4300
Wire Bus Line
	1900 4200 4050 4200
Wire Bus Line
	2800 4000 3900 4000
Wire Bus Line
	2800 2550 3750 2550
Wire Bus Line
	1900 2450 4050 2450
Wire Bus Line
	2800 2250 3900 2250
Wire Bus Line
	2800 800  3750 800 
Wire Bus Line
	1900 700  4050 700 
Wire Bus Line
	6000 2250 6750 2250
Wire Bus Line
	6000 4350 6750 4350
Wire Bus Line
	4050 4850 5850 4850
Wire Bus Line
	6000 6400 6750 6400
Wire Bus Line
	9050 2250 9800 2250
Wire Bus Line
	4050 2800 8900 2800
Wire Bus Line
	4050 700  8900 700 
$Comp
L Connector:Conn_01x04_Female J7
U 1 1 60B96D3C
P 8150 6000
F 0 "J7" H 7950 5700 50  0000 C CNN
F 1 "ALT" H 7750 5700 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 8150 6000 50  0001 C CNN
F 3 "~" H 8150 6000 50  0001 C CNN
	1    8150 6000
	-1   0    0    1   
$EndComp
Text GLabel 8350 6100 2    50   Output ~ 0
ALT_AS
Text GLabel 8350 6000 2    50   Output ~ 0
ALT_AO
Text GLabel 8350 5900 2    50   Output ~ 0
ALT_S
Text GLabel 8350 5800 2    50   Output ~ 0
ALT_XN
$EndSCHEMATC
