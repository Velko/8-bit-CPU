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
L Custom:AT28C256J U1
U 1 1 60C324A5
P 5950 3150
F 0 "U1" H 5950 4431 50  0000 C CNN
F 1 "AT28C256J" H 5950 4340 50  0000 C CNN
F 2 "Custom:PLCC-32_SMD-Socket" H 5950 3150 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc0006.pdf" H 5950 3150 50  0001 C CNN
	1    5950 3150
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x08_Male J1
U 1 1 60C32F06
P 8050 2050
F 0 "J1" H 8158 2531 50  0000 C CNN
F 1 "Conn_01x08_Male" H 8158 2440 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 8050 2050 50  0001 C CNN
F 3 "~" H 8050 2050 50  0001 C CNN
	1    8050 2050
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J2
U 1 1 60C34145
P 8150 3650
F 0 "J2" H 8258 3931 50  0000 C CNN
F 1 "Conn_01x04_Male" H 8258 3840 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 8150 3650 50  0001 C CNN
F 3 "~" H 8150 3650 50  0001 C CNN
	1    8150 3650
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Female J6
U 1 1 60C34A2B
P 8700 2200
F 0 "J6" H 8808 2481 50  0000 C CNN
F 1 "Conn_01x08_Male" H 8808 2390 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x04_P2.54mm_Vertical" H 8700 2200 50  0001 C CNN
F 3 "~" H 8700 2200 50  0001 C CNN
	1    8700 2200
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x08_Female J5
U 1 1 60C35502
P 6650 2650
F 0 "J5" H 6758 3131 50  0000 C CNN
F 1 "Conn_01x08_Male" H 6758 3040 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 6650 2650 50  0001 C CNN
F 3 "~" H 6650 2650 50  0001 C CNN
	1    6650 2650
	1    0    0    1   
$EndComp
$Comp
L Connector:Conn_01x04_Male J3
U 1 1 60C35FC2
P 8700 3900
F 0 "J3" H 8808 4181 50  0000 C CNN
F 1 "Conn_01x04_Male" H 8808 4090 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 8700 3900 50  0001 C CNN
F 3 "~" H 8700 3900 50  0001 C CNN
	1    8700 3900
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J4
U 1 1 60C36469
P 7500 4300
F 0 "J4" H 7608 4581 50  0000 C CNN
F 1 "Conn_01x04_Male" H 7608 4490 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x02_P2.54mm_Vertical" H 7500 4300 50  0001 C CNN
F 3 "~" H 7500 4300 50  0001 C CNN
	1    7500 4300
	1    0    0    -1  
$EndComp
Wire Wire Line
	6350 2250 6450 2250
Wire Wire Line
	6450 2350 6350 2350
Wire Wire Line
	6350 2450 6450 2450
Wire Wire Line
	6450 2550 6350 2550
Wire Wire Line
	6350 2650 6450 2650
Wire Wire Line
	6450 2750 6350 2750
Wire Wire Line
	6350 2850 6450 2850
Wire Wire Line
	6450 2950 6350 2950
$EndSCHEMATC
