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
L Connector:Conn_01x08_Male J5
U 1 1 60C6C15C
P 9750 4100
F 0 "J5" H 9600 4000 50  0000 C CNN
F 1 "DISP_ANODES" H 9400 4100 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 9750 4100 50  0001 C CNN
F 3 "~" H 9750 4100 50  0001 C CNN
	1    9750 4100
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x04_Male J6
U 1 1 60C6D3E3
P 9750 3250
F 0 "J6" H 9650 3150 50  0000 C CNN
F 1 "DISP_CATHODES" H 9400 3250 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 9750 3250 50  0001 C CNN
F 3 "~" H 9750 3250 50  0001 C CNN
	1    9750 3250
	-1   0    0    -1  
$EndComp
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
Wire Wire Line
	10050 1250 9950 1250
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
Wire Wire Line
	9950 950  9800 950 
Connection ~ 9950 950 
Wire Wire Line
	9800 950  9550 950 
Connection ~ 9800 950 
Wire Wire Line
	9550 1250 9800 1250
Wire Wire Line
	9800 1250 9950 1250
Connection ~ 9800 1250
Connection ~ 9950 1250
$Comp
L Connector:Conn_01x02_Male J10
U 1 1 60EA1C35
P 9850 2400
F 0 "J10" H 9700 2350 50  0000 L CNN
F 1 "GND_IN" H 9850 2500 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 9850 2400 50  0001 C CNN
F 3 "~" H 9850 2400 50  0001 C CNN
	1    9850 2400
	-1   0    0    -1  
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
$Comp
L Connector:Conn_01x02_Male J9
U 1 1 60EA0DCE
P 9850 1950
F 0 "J9" H 9750 1900 50  0000 L CNN
F 1 "VCC_IN" H 9850 1800 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 9850 1950 50  0001 C CNN
F 3 "~" H 9850 1950 50  0001 C CNN
	1    9850 1950
	-1   0    0    -1  
$EndComp
$EndSCHEMATC
