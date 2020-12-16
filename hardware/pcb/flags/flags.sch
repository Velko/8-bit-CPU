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
L Connector:Conn_01x08_Male J1
U 1 1 5FDBBD51
P 6250 5300
F 0 "J1" H 6358 5781 50  0000 C CNN
F 1 "Bus" H 6358 5690 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 6250 5300 50  0001 C CNN
F 3 "~" H 6250 5300 50  0001 C CNN
	1    6250 5300
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J2
U 1 1 5FDBC542
P 7050 5250
F 0 "J2" H 7158 5531 50  0000 C CNN
F 1 "Control" H 7158 5440 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 7050 5250 50  0001 C CNN
F 3 "~" H 7050 5250 50  0001 C CNN
	1    7050 5250
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J3
U 1 1 5FDBCC63
P 7850 5250
F 0 "J3" H 7958 5531 50  0000 C CNN
F 1 "Sync" H 7958 5440 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 7850 5250 50  0001 C CNN
F 3 "~" H 7850 5250 50  0001 C CNN
	1    7850 5250
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J4
U 1 1 5FDBD1A4
P 8700 6100
F 0 "J4" H 8808 6381 50  0000 C CNN
F 1 "Power" H 8808 6290 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x02_P2.54mm_Vertical" H 8700 6100 50  0001 C CNN
F 3 "~" H 8700 6100 50  0001 C CNN
	1    8700 6100
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x08_Male J5
U 1 1 5FDBD7A5
P 9500 5200
F 0 "J5" H 9608 5681 50  0000 C CNN
F 1 "Conn_01x08_Male" H 9608 5590 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 9500 5200 50  0001 C CNN
F 3 "~" H 9500 5200 50  0001 C CNN
	1    9500 5200
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x08_Male J6
U 1 1 5FDBE128
P 10350 5200
F 0 "J6" H 10458 5681 50  0000 C CNN
F 1 "Conn_01x08_Male" H 10458 5590 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x08_P2.54mm_Vertical" H 10350 5200 50  0001 C CNN
F 3 "~" H 10350 5200 50  0001 C CNN
	1    10350 5200
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5FDC948F
P 8250 6250
F 0 "#PWR?" H 8250 6000 50  0001 C CNN
F 1 "GND" H 8255 6077 50  0000 C CNN
F 2 "" H 8250 6250 50  0001 C CNN
F 3 "" H 8250 6250 50  0001 C CNN
	1    8250 6250
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR?
U 1 1 5FDC9C73
P 8250 5850
F 0 "#PWR?" H 8250 5700 50  0001 C CNN
F 1 "VCC" H 8265 6023 50  0000 C CNN
F 2 "" H 8250 5850 50  0001 C CNN
F 3 "" H 8250 5850 50  0001 C CNN
	1    8250 5850
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG?
U 1 1 5FDCA76A
P 8000 5850
F 0 "#FLG?" H 8000 5925 50  0001 C CNN
F 1 "PWR_FLAG" H 8000 6023 50  0000 C CNN
F 2 "" H 8000 5850 50  0001 C CNN
F 3 "~" H 8000 5850 50  0001 C CNN
	1    8000 5850
	1    0    0    -1  
$EndComp
$Comp
L power:PWR_FLAG #FLG?
U 1 1 5FDCAD03
P 8000 6250
F 0 "#FLG?" H 8000 6325 50  0001 C CNN
F 1 "PWR_FLAG" H 8000 6423 50  0000 C CNN
F 2 "" H 8000 6250 50  0001 C CNN
F 3 "~" H 8000 6250 50  0001 C CNN
	1    8000 6250
	-1   0    0    1   
$EndComp
Wire Wire Line
	8500 6000 8500 5900
Wire Wire Line
	8250 5850 8250 5900
Wire Wire Line
	8250 5900 8500 5900
Connection ~ 8500 5900
Wire Wire Line
	8000 5850 8000 5900
Wire Wire Line
	8000 5900 8250 5900
Connection ~ 8250 5900
Wire Wire Line
	8500 6100 8500 6200
Wire Wire Line
	8250 6250 8250 6200
Wire Wire Line
	8250 6200 8500 6200
Connection ~ 8500 6200
Wire Wire Line
	8000 6250 8000 6200
Wire Wire Line
	8000 6200 8250 6200
Connection ~ 8250 6200
$EndSCHEMATC
