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
P 1500 1950
F 0 "J5" H 1350 1850 50  0000 C CNN
F 1 "DISP_ANODES" H 1150 1950 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 1500 1950 50  0001 C CNN
F 3 "~" H 1500 1950 50  0001 C CNN
	1    1500 1950
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J6
U 1 1 60C6D3E3
P 1500 1150
F 0 "J6" H 1400 1050 50  0000 C CNN
F 1 "DISP_CATHODES" H 1150 1150 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 1500 1150 50  0001 C CNN
F 3 "~" H 1500 1150 50  0001 C CNN
	1    1500 1150
	1    0    0    -1  
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
$Comp
L Display_Character:SC39-11GWA U2
U 1 1 60DAFCE7
P 3550 1250
F 0 "U2" H 3550 1917 50  0000 C CNN
F 1 "SC39-11GWA" H 3550 1826 50  0000 C CNN
F 2 "Display_7Segment:Sx39-1xxxxx" H 3550 700 50  0001 C CNN
F 3 "http://www.kingbrightusa.com/images/catalog/SPEC/sc39-11gwa.pdf" H 3550 1250 50  0001 C CNN
	1    3550 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3850 1650 3900 1650
Text GLabel 1800 1350 2    50   Output ~ 0
CA3
Wire Wire Line
	1700 1350 1800 1350
$Comp
L Display_Character:SC39-11GWA U3
U 1 1 60DBE17C
P 4750 1250
F 0 "U3" H 4750 1917 50  0000 C CNN
F 1 "SC39-11GWA" H 4750 1826 50  0000 C CNN
F 2 "Display_7Segment:Sx39-1xxxxx" H 4750 700 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 4750 1250 50  0001 C CNN
	1    4750 1250
	1    0    0    -1  
$EndComp
$Comp
L Display_Character:SC39-11GWA U4
U 1 1 60DBF043
P 5950 1250
F 0 "U4" H 5950 1917 50  0000 C CNN
F 1 "SC39-11GWA" H 5950 1826 50  0000 C CNN
F 2 "Display_7Segment:Sx39-1xxxxx" H 5950 700 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 5950 1250 50  0001 C CNN
	1    5950 1250
	1    0    0    -1  
$EndComp
$Comp
L Display_Character:SC39-11GWA U5
U 1 1 60DBFFEB
P 7150 1250
F 0 "U5" H 7150 1917 50  0000 C CNN
F 1 "SC39-11GWA" H 7150 1826 50  0000 C CNN
F 2 "Display_7Segment:Sx39-1xxxxx" H 7150 700 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 7150 1250 50  0001 C CNN
	1    7150 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q6
U 1 1 60DC94BA
P 5000 2200
F 0 "Q6" H 5204 2200 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 5204 2155 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 5200 2300 50  0001 C CNN
F 3 "~" H 5000 2200 50  0001 C CNN
	1    5000 2200
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q8
U 1 1 60DCAA4E
P 6200 2200
F 0 "Q8" H 6404 2200 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 6404 2155 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 6400 2300 50  0001 C CNN
F 3 "~" H 6200 2200 50  0001 C CNN
	1    6200 2200
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q11
U 1 1 60DCC845
P 7400 2200
F 0 "Q11" H 7604 2200 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 7604 2155 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 7600 2300 50  0001 C CNN
F 3 "~" H 7400 2200 50  0001 C CNN
	1    7400 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 2900 3500 2850
Text GLabel 3500 2900 3    50   Input ~ 0
CA3
Wire Wire Line
	3900 2400 3900 2450
$Comp
L power:GND #PWR0103
U 1 1 60DB4647
P 3900 2450
F 0 "#PWR0103" H 3900 2200 50  0001 C CNN
F 1 "GND" H 3905 2277 50  0000 C CNN
F 2 "" H 3900 2450 50  0001 C CNN
F 3 "" H 3900 2450 50  0001 C CNN
	1    3900 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	3900 1650 3900 2000
$Comp
L Device:Q_NMOS_GSD Q1
U 1 1 60DAD67D
P 3800 2200
F 0 "Q1" H 4004 2200 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 4004 2155 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 4000 2300 50  0001 C CNN
F 3 "~" H 3800 2200 50  0001 C CNN
	1    3800 2200
	1    0    0    -1  
$EndComp
$Comp
L 74xx:74HC04 U1
U 3 1 60DAC25A
P 3500 2550
F 0 "U1" H 3500 2867 50  0000 C CNN
F 1 "74HC04" H 3500 2776 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 3500 2550 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 3500 2550 50  0001 C CNN
	3    3500 2550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5050 1650 5100 1650
Wire Wire Line
	5100 1650 5100 2000
Wire Wire Line
	6250 1650 6300 1650
Wire Wire Line
	6300 1650 6300 2000
Wire Wire Line
	7450 1650 7500 1650
Wire Wire Line
	7500 1650 7500 2000
Wire Wire Line
	3500 2200 3500 2250
Wire Wire Line
	3500 2200 3600 2200
Wire Wire Line
	4750 2900 4750 2850
Text GLabel 4750 2900 3    50   Input ~ 0
CA2
$Comp
L 74xx:74HC04 U1
U 4 1 60DD8BEC
P 4750 2550
F 0 "U1" V 4796 2370 50  0000 R CNN
F 1 "74HC04" V 4705 2370 50  0000 R CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 4750 2550 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 4750 2550 50  0001 C CNN
	4    4750 2550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4750 2200 4750 2250
Wire Wire Line
	5950 2900 5950 2850
Text GLabel 5950 2900 3    50   Input ~ 0
CA1
$Comp
L 74xx:74HC04 U1
U 5 1 60DD96F0
P 5950 2550
F 0 "U1" V 5996 2370 50  0000 R CNN
F 1 "74HC04" V 5905 2370 50  0000 R CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 5950 2550 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 5950 2550 50  0001 C CNN
	5    5950 2550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5950 2200 5950 2250
Wire Wire Line
	7150 2900 7150 2850
Text GLabel 7150 2900 3    50   Input ~ 0
CA0
$Comp
L 74xx:74HC04 U1
U 6 1 60DDA7B8
P 7150 2550
F 0 "U1" V 7196 2370 50  0000 R CNN
F 1 "74HC04" V 7105 2370 50  0000 R CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 7150 2550 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 7150 2550 50  0001 C CNN
	6    7150 2550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7150 2200 7150 2250
Wire Wire Line
	4750 2200 4800 2200
Wire Wire Line
	5950 2200 6000 2200
Wire Wire Line
	7150 2200 7200 2200
$Comp
L power:GND #PWR0104
U 1 1 60DDC8DC
P 5100 2450
F 0 "#PWR0104" H 5100 2200 50  0001 C CNN
F 1 "GND" H 5105 2277 50  0000 C CNN
F 2 "" H 5100 2450 50  0001 C CNN
F 3 "" H 5100 2450 50  0001 C CNN
	1    5100 2450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 60DDD860
P 6300 2450
F 0 "#PWR0105" H 6300 2200 50  0001 C CNN
F 1 "GND" H 6305 2277 50  0000 C CNN
F 2 "" H 6300 2450 50  0001 C CNN
F 3 "" H 6300 2450 50  0001 C CNN
	1    6300 2450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 60DDDFCD
P 7500 2450
F 0 "#PWR0106" H 7500 2200 50  0001 C CNN
F 1 "GND" H 7505 2277 50  0000 C CNN
F 2 "" H 7500 2450 50  0001 C CNN
F 3 "" H 7500 2450 50  0001 C CNN
	1    7500 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7500 2400 7500 2450
Wire Wire Line
	6300 2400 6300 2450
Wire Wire Line
	5100 2400 5100 2450
Text GLabel 3200 950  0    50   Input ~ 0
A
Text GLabel 3200 1050 0    50   Input ~ 0
B
Text GLabel 3200 1150 0    50   Input ~ 0
C
Text GLabel 3200 1250 0    50   Input ~ 0
D
Text GLabel 3200 1350 0    50   Input ~ 0
E
Text GLabel 3200 1450 0    50   Input ~ 0
F
Text GLabel 3200 1550 0    50   Input ~ 0
G
Text GLabel 3200 1650 0    50   Input ~ 0
DP
Text GLabel 4400 950  0    50   Input ~ 0
A
Text GLabel 4400 1050 0    50   Input ~ 0
B
Text GLabel 4400 1150 0    50   Input ~ 0
C
Text GLabel 4400 1250 0    50   Input ~ 0
D
Text GLabel 4400 1350 0    50   Input ~ 0
E
Text GLabel 4400 1450 0    50   Input ~ 0
F
Text GLabel 4400 1550 0    50   Input ~ 0
G
Text GLabel 4400 1650 0    50   Input ~ 0
DP
Text GLabel 5600 950  0    50   Input ~ 0
A
Text GLabel 5600 1050 0    50   Input ~ 0
B
Text GLabel 5600 1150 0    50   Input ~ 0
C
Text GLabel 5600 1250 0    50   Input ~ 0
D
Text GLabel 5600 1350 0    50   Input ~ 0
E
Text GLabel 5600 1450 0    50   Input ~ 0
F
Text GLabel 5600 1550 0    50   Input ~ 0
G
Text GLabel 5600 1650 0    50   Input ~ 0
DP
Text GLabel 6800 950  0    50   Input ~ 0
A
Text GLabel 6800 1050 0    50   Input ~ 0
B
Text GLabel 6800 1150 0    50   Input ~ 0
C
Text GLabel 6800 1250 0    50   Input ~ 0
D
Text GLabel 6800 1350 0    50   Input ~ 0
E
Text GLabel 6800 1450 0    50   Input ~ 0
F
Text GLabel 6800 1550 0    50   Input ~ 0
G
Text GLabel 6800 1650 0    50   Input ~ 0
DP
Wire Wire Line
	3200 950  3250 950 
Wire Wire Line
	3250 1050 3200 1050
Wire Wire Line
	3200 1150 3250 1150
Wire Wire Line
	3250 1250 3200 1250
Wire Wire Line
	3200 1350 3250 1350
Wire Wire Line
	3250 1450 3200 1450
Wire Wire Line
	3200 1550 3250 1550
Wire Wire Line
	3250 1650 3200 1650
Wire Wire Line
	4400 950  4450 950 
Wire Wire Line
	4450 1050 4400 1050
Wire Wire Line
	4400 1150 4450 1150
Wire Wire Line
	4450 1250 4400 1250
Wire Wire Line
	4400 1350 4450 1350
Wire Wire Line
	4450 1450 4400 1450
Wire Wire Line
	4400 1550 4450 1550
Wire Wire Line
	4450 1650 4400 1650
Wire Wire Line
	5600 950  5650 950 
Wire Wire Line
	5650 1050 5600 1050
Wire Wire Line
	5600 1150 5650 1150
Wire Wire Line
	5650 1250 5600 1250
Wire Wire Line
	5600 1350 5650 1350
Wire Wire Line
	5650 1450 5600 1450
Wire Wire Line
	5600 1550 5650 1550
Wire Wire Line
	5650 1650 5600 1650
Wire Wire Line
	6800 950  6850 950 
Wire Wire Line
	6850 1050 6800 1050
Wire Wire Line
	6800 1150 6850 1150
Wire Wire Line
	6850 1250 6800 1250
Wire Wire Line
	6800 1350 6850 1350
Wire Wire Line
	6800 1550 6850 1550
Wire Wire Line
	6850 1450 6800 1450
Wire Wire Line
	6800 1650 6850 1650
$Comp
L Device:Q_NMOS_GSD Q2
U 1 1 60E0A6E3
P 2700 4500
F 0 "Q2" H 2904 4500 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 2904 4455 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 2900 4600 50  0001 C CNN
F 3 "~" H 2700 4500 50  0001 C CNN
	1    2700 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q3
U 1 1 60E0AD70
P 4950 4500
F 0 "Q3" H 5154 4500 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 5154 4455 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 5150 4600 50  0001 C CNN
F 3 "~" H 4950 4500 50  0001 C CNN
	1    4950 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q4
U 1 1 60E0B5EB
P 4200 4500
F 0 "Q4" H 4404 4500 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 4404 4455 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 4400 4600 50  0001 C CNN
F 3 "~" H 4200 4500 50  0001 C CNN
	1    4200 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q5
U 1 1 60E0BB01
P 3450 4500
F 0 "Q5" H 3654 4500 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 3654 4455 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 3650 4600 50  0001 C CNN
F 3 "~" H 3450 4500 50  0001 C CNN
	1    3450 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q7
U 1 1 60E0EEAC
P 5700 4500
F 0 "Q7" H 5904 4500 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 5904 4455 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 5900 4600 50  0001 C CNN
F 3 "~" H 5700 4500 50  0001 C CNN
	1    5700 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q9
U 1 1 60E0EEB2
P 6450 4500
F 0 "Q9" H 6654 4500 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 6654 4455 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 6650 4600 50  0001 C CNN
F 3 "~" H 6450 4500 50  0001 C CNN
	1    6450 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q10
U 1 1 60E0EEB8
P 7200 4500
F 0 "Q10" H 7404 4500 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 7404 4455 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 7400 4600 50  0001 C CNN
F 3 "~" H 7200 4500 50  0001 C CNN
	1    7200 4500
	1    0    0    -1  
$EndComp
$Comp
L Device:Q_NMOS_GSD Q12
U 1 1 60E0EEBE
P 8000 4500
F 0 "Q12" H 8204 4500 50  0000 L CNN
F 1 "Q_NMOS_GSD" H 8204 4455 50  0001 L CNN
F 2 "Package_TO_SOT_SMD:SOT-23" H 8200 4600 50  0001 C CNN
F 3 "~" H 8000 4500 50  0001 C CNN
	1    8000 4500
	1    0    0    -1  
$EndComp
Text GLabel 2800 4750 3    50   Output ~ 0
A
Text GLabel 3550 4750 3    50   Output ~ 0
B
Text GLabel 4300 4750 3    50   Output ~ 0
C
Text GLabel 5050 4750 3    50   Output ~ 0
D
Text GLabel 5800 4750 3    50   Output ~ 0
E
Text GLabel 6550 4750 3    50   Output ~ 0
F
Text GLabel 7300 4750 3    50   Output ~ 0
G
Text GLabel 8100 4750 3    50   Output ~ 0
DP
$Comp
L Device:R R1
U 1 1 60E1E8A2
P 2800 4050
F 0 "R1" H 2870 4096 50  0000 L CNN
F 1 "100" H 2870 4005 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 2730 4050 50  0001 C CNN
F 3 "~" H 2800 4050 50  0001 C CNN
	1    2800 4050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 60E20041
P 3550 4050
F 0 "R2" H 3620 4096 50  0000 L CNN
F 1 "100" H 3620 4005 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 3480 4050 50  0001 C CNN
F 3 "~" H 3550 4050 50  0001 C CNN
	1    3550 4050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 60E2050E
P 4300 4050
F 0 "R3" H 4370 4096 50  0000 L CNN
F 1 "100" H 4370 4005 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 4230 4050 50  0001 C CNN
F 3 "~" H 4300 4050 50  0001 C CNN
	1    4300 4050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R4
U 1 1 60E208F5
P 5050 4050
F 0 "R4" H 5120 4096 50  0000 L CNN
F 1 "100" H 5120 4005 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 4980 4050 50  0001 C CNN
F 3 "~" H 5050 4050 50  0001 C CNN
	1    5050 4050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 60E26579
P 5800 4050
F 0 "R5" H 5870 4096 50  0000 L CNN
F 1 "100" H 5870 4005 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 5730 4050 50  0001 C CNN
F 3 "~" H 5800 4050 50  0001 C CNN
	1    5800 4050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R6
U 1 1 60E2682E
P 6550 4050
F 0 "R6" H 6620 4096 50  0000 L CNN
F 1 "100" H 6620 4005 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 6480 4050 50  0001 C CNN
F 3 "~" H 6550 4050 50  0001 C CNN
	1    6550 4050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R7
U 1 1 60E26B4D
P 7300 4050
F 0 "R7" H 7370 4096 50  0000 L CNN
F 1 "100" H 7370 4005 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 7230 4050 50  0001 C CNN
F 3 "~" H 7300 4050 50  0001 C CNN
	1    7300 4050
	1    0    0    -1  
$EndComp
$Comp
L Device:R R8
U 1 1 60E26F34
P 8100 4050
F 0 "R8" H 8170 4096 50  0000 L CNN
F 1 "100" H 8170 4005 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric_Pad1.20x1.40mm_HandSolder" V 8030 4050 50  0001 C CNN
F 3 "~" H 8100 4050 50  0001 C CNN
	1    8100 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 4700 2800 4750
Wire Wire Line
	3550 4700 3550 4750
Wire Wire Line
	4300 4700 4300 4750
Wire Wire Line
	5050 4700 5050 4750
Wire Wire Line
	5800 4700 5800 4750
Wire Wire Line
	6550 4700 6550 4750
Wire Wire Line
	7300 4700 7300 4750
Wire Wire Line
	8100 4700 8100 4750
Wire Wire Line
	8100 4200 8100 4300
Wire Wire Line
	7300 4200 7300 4300
Wire Wire Line
	6550 4200 6550 4300
Wire Wire Line
	5800 4200 5800 4300
Wire Wire Line
	5050 4200 5050 4300
Wire Wire Line
	4300 4200 4300 4300
Wire Wire Line
	3550 4200 3550 4300
Wire Wire Line
	2800 4200 2800 4300
$Comp
L power:VCC #PWR0107
U 1 1 60E4A585
P 2800 3800
F 0 "#PWR0107" H 2800 3650 50  0001 C CNN
F 1 "VCC" H 2815 3973 50  0000 C CNN
F 2 "" H 2800 3800 50  0001 C CNN
F 3 "" H 2800 3800 50  0001 C CNN
	1    2800 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	2800 3800 2800 3900
$Comp
L power:VCC #PWR0108
U 1 1 60E4DC2A
P 3550 3800
F 0 "#PWR0108" H 3550 3650 50  0001 C CNN
F 1 "VCC" H 3565 3973 50  0000 C CNN
F 2 "" H 3550 3800 50  0001 C CNN
F 3 "" H 3550 3800 50  0001 C CNN
	1    3550 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	3550 3800 3550 3900
$Comp
L power:VCC #PWR0109
U 1 1 60E5090C
P 4300 3800
F 0 "#PWR0109" H 4300 3650 50  0001 C CNN
F 1 "VCC" H 4315 3973 50  0000 C CNN
F 2 "" H 4300 3800 50  0001 C CNN
F 3 "" H 4300 3800 50  0001 C CNN
	1    4300 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 3800 4300 3900
$Comp
L power:VCC #PWR0110
U 1 1 60E536D1
P 5050 3800
F 0 "#PWR0110" H 5050 3650 50  0001 C CNN
F 1 "VCC" H 5065 3973 50  0000 C CNN
F 2 "" H 5050 3800 50  0001 C CNN
F 3 "" H 5050 3800 50  0001 C CNN
	1    5050 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5050 3800 5050 3900
$Comp
L power:VCC #PWR0111
U 1 1 60E564E2
P 5800 3800
F 0 "#PWR0111" H 5800 3650 50  0001 C CNN
F 1 "VCC" H 5815 3973 50  0000 C CNN
F 2 "" H 5800 3800 50  0001 C CNN
F 3 "" H 5800 3800 50  0001 C CNN
	1    5800 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	5800 3800 5800 3900
$Comp
L power:VCC #PWR0112
U 1 1 60E59530
P 6550 3800
F 0 "#PWR0112" H 6550 3650 50  0001 C CNN
F 1 "VCC" H 6565 3973 50  0000 C CNN
F 2 "" H 6550 3800 50  0001 C CNN
F 3 "" H 6550 3800 50  0001 C CNN
	1    6550 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	6550 3800 6550 3900
$Comp
L power:VCC #PWR0113
U 1 1 60E5C5C0
P 7300 3800
F 0 "#PWR0113" H 7300 3650 50  0001 C CNN
F 1 "VCC" H 7315 3973 50  0000 C CNN
F 2 "" H 7300 3800 50  0001 C CNN
F 3 "" H 7300 3800 50  0001 C CNN
	1    7300 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	7300 3800 7300 3900
$Comp
L power:VCC #PWR0114
U 1 1 60E5F8F1
P 8100 3800
F 0 "#PWR0114" H 8100 3650 50  0001 C CNN
F 1 "VCC" H 8115 3973 50  0000 C CNN
F 2 "" H 8100 3800 50  0001 C CNN
F 3 "" H 8100 3800 50  0001 C CNN
	1    8100 3800
	1    0    0    -1  
$EndComp
Wire Wire Line
	8100 3800 8100 3900
Text GLabel 1800 1250 2    50   Output ~ 0
CA2
Text GLabel 1800 1150 2    50   Output ~ 0
CA1
Text GLabel 1800 1050 2    50   Output ~ 0
CA0
Wire Wire Line
	1700 1250 1800 1250
Wire Wire Line
	1800 1150 1700 1150
Wire Wire Line
	1700 1050 1800 1050
Text GLabel 2450 4500 0    50   Input ~ 0
DA
Text GLabel 3200 4500 0    50   Input ~ 0
DB
Text GLabel 3950 4500 0    50   Input ~ 0
DC
Text GLabel 4700 4500 0    50   Input ~ 0
DD
Text GLabel 5450 4500 0    50   Input ~ 0
DE
Text GLabel 6200 4500 0    50   Input ~ 0
DF
Text GLabel 6950 4500 0    50   Input ~ 0
DG
Text GLabel 7750 4500 0    50   Input ~ 0
DDP
Wire Wire Line
	7750 4500 7800 4500
Wire Wire Line
	6950 4500 7000 4500
Wire Wire Line
	6200 4500 6250 4500
Wire Wire Line
	5450 4500 5500 4500
Wire Wire Line
	4700 4500 4750 4500
Wire Wire Line
	3950 4500 4000 4500
Wire Wire Line
	3200 4500 3250 4500
Wire Wire Line
	2450 4500 2500 4500
Text GLabel 1800 1650 2    50   Output ~ 0
DA
Text GLabel 1800 1750 2    50   Output ~ 0
DB
Text GLabel 1800 1850 2    50   Output ~ 0
DC
Text GLabel 1800 1950 2    50   Output ~ 0
DD
Text GLabel 1800 2050 2    50   Output ~ 0
DE
Text GLabel 1800 2150 2    50   Output ~ 0
DF
Text GLabel 1800 2250 2    50   Output ~ 0
DG
Text GLabel 1800 2350 2    50   Output ~ 0
DDP
Wire Wire Line
	1700 1650 1800 1650
Wire Wire Line
	1800 1750 1700 1750
Wire Wire Line
	1700 1850 1800 1850
Wire Wire Line
	1800 1950 1700 1950
Wire Wire Line
	1700 2050 1800 2050
Wire Wire Line
	1800 2150 1700 2150
Wire Wire Line
	1700 2250 1800 2250
Wire Wire Line
	1800 2350 1700 2350
$Comp
L 74xx:74HC04 U1
U 1 1 60EC9D8E
P 9250 3950
F 0 "U1" V 9296 3770 50  0000 R CNN
F 1 "74HC04" V 9205 3770 50  0000 R CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 9250 3950 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 9250 3950 50  0001 C CNN
	1    9250 3950
	0    -1   -1   0   
$EndComp
$Comp
L 74xx:74HC04 U1
U 2 1 60ECA5E2
P 9900 3950
F 0 "U1" V 9946 3770 50  0000 R CNN
F 1 "74HC04" V 9855 3770 50  0000 R CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 9900 3950 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 9900 3950 50  0001 C CNN
	2    9900 3950
	0    -1   -1   0   
$EndComp
NoConn ~ 9900 3650
NoConn ~ 9250 3650
$Comp
L power:GND #PWR0115
U 1 1 60ED3788
P 9250 4350
F 0 "#PWR0115" H 9250 4100 50  0001 C CNN
F 1 "GND" H 9255 4177 50  0000 C CNN
F 2 "" H 9250 4350 50  0001 C CNN
F 3 "" H 9250 4350 50  0001 C CNN
	1    9250 4350
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0116
U 1 1 60ED3A84
P 9900 4350
F 0 "#PWR0116" H 9900 4100 50  0001 C CNN
F 1 "GND" H 9905 4177 50  0000 C CNN
F 2 "" H 9900 4350 50  0001 C CNN
F 3 "" H 9900 4350 50  0001 C CNN
	1    9900 4350
	1    0    0    -1  
$EndComp
Wire Wire Line
	9900 4250 9900 4350
Wire Wire Line
	9250 4250 9250 4350
$Comp
L 74xx:74HC04 U1
U 7 1 60EDCEC4
P 10450 4050
F 0 "U1" H 10680 4096 50  0000 L CNN
F 1 "74HC04" H 10680 4005 50  0000 L CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 10450 4050 50  0001 C CNN
F 3 "https://assets.nexperia.com/documents/data-sheet/74HC_HCT04.pdf" H 10450 4050 50  0001 C CNN
	7    10450 4050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0117
U 1 1 60EECE78
P 10450 4600
F 0 "#PWR0117" H 10450 4350 50  0001 C CNN
F 1 "GND" H 10455 4427 50  0000 C CNN
F 2 "" H 10450 4600 50  0001 C CNN
F 3 "" H 10450 4600 50  0001 C CNN
	1    10450 4600
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0118
U 1 1 60EED21B
P 10450 3450
F 0 "#PWR0118" H 10450 3300 50  0001 C CNN
F 1 "VCC" H 10465 3623 50  0000 C CNN
F 2 "" H 10450 3450 50  0001 C CNN
F 3 "" H 10450 3450 50  0001 C CNN
	1    10450 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	10450 3450 10450 3550
Wire Wire Line
	10450 4550 10450 4600
Wire Wire Line
	7450 1550 7500 1550
Wire Wire Line
	7500 1550 7500 1650
Connection ~ 7500 1650
Wire Wire Line
	6250 1550 6300 1550
Wire Wire Line
	6300 1550 6300 1650
Connection ~ 6300 1650
Wire Wire Line
	5050 1550 5100 1550
Wire Wire Line
	5100 1550 5100 1650
Connection ~ 5100 1650
Wire Wire Line
	3850 1550 3900 1550
Wire Wire Line
	3900 1550 3900 1650
Connection ~ 3900 1650
$EndSCHEMATC
