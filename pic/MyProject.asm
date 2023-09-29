_PrepareTFT:
;MyProject.c,68 :: 		void PrepareTFT()
ADDIU	SP, SP, -12
SW	RA, 0(SP)
;MyProject.c,70 :: 		TFT_BLED = 1;
SW	R25, 4(SP)
SW	R26, 8(SP)
LUI	R2, BitMask(LATD2_bit+0)
ORI	R2, R2, BitMask(LATD2_bit+0)
_SX	
;MyProject.c,71 :: 		TFT_Init_ILI9341_8bit(320, 240);
ORI	R26, R0, 240
ORI	R25, R0, 320
JAL	_TFT_Init_ILI9341_8bit+0
NOP	
;MyProject.c,72 :: 		TFT_Fill_Screen(CL_YELLOW);   //Clear screen
ORI	R25, R0, 65504
JAL	_TFT_Fill_Screen+0
NOP	
;MyProject.c,73 :: 		}
L_end_PrepareTFT:
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 12
JR	RA
NOP	
; end of _PrepareTFT
_PrepareADCChannel0:
;MyProject.c,75 :: 		void PrepareADCChannel0()
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;MyProject.c,77 :: 		AD1PCFG = 0xFFFE;  // Configure AN pins as digital I/O,
ORI	R2, R0, 65534
SW	R2, Offset(AD1PCFG+0)(GP)
;MyProject.c,79 :: 		JTAGEN_bit = 0;    // Disable JTAG port
_LX	
INS	R2, R0, BitPos(JTAGEN_bit+0), 1
_SX	
;MyProject.c,80 :: 		TRISB0_bit = 1;    // Set PORTB.B0 as input
LUI	R2, BitMask(TRISB0_bit+0)
ORI	R2, R2, BitMask(TRISB0_bit+0)
_SX	
;MyProject.c,81 :: 		ADC1_Init();       // Initialize ADC module
JAL	_ADC1_Init+0
NOP	
;MyProject.c,82 :: 		Delay_ms(100);     // Get some time to stabilize
LUI	R24, 40
ORI	R24, R24, 45226
L_PrepareADCChannel00:
ADDIU	R24, R24, -1
BNE	R24, R0, L_PrepareADCChannel00
NOP	
;MyProject.c,83 :: 		}
L_end_PrepareADCChannel0:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _PrepareADCChannel0
_PrepareQ15coefBuffer:
;MyProject.c,86 :: 		void PrepareQ15coefBuffer(float CoeffsArr[], int LenOfCoeffs, int Q15_coefficients_buffer [])
ADDIU	SP, SP, -16
SW	RA, 0(SP)
;MyProject.c,89 :: 		for(x =0; x<LenOfCoeffs; x++)
; x start address is: 52 (R13)
MOVZ	R13, R0, R0
; x end address is: 52 (R13)
L_PrepareQ15coefBuffer2:
; x start address is: 52 (R13)
SEH	R3, R13
SEH	R2, R26
SLT	R2, R3, R2
BNE	R2, R0, L__PrepareQ15coefBuffer165
NOP	
J	L_PrepareQ15coefBuffer3
NOP	
L__PrepareQ15coefBuffer165:
;MyProject.c,91 :: 		Q15_Ftoi(CoeffsArr[x], &tmp);
ADDIU	R3, SP, 12
SEH	R2, R13
SLL	R2, R2, 2
ADDU	R2, R25, R2
LW	R2, 0(R2)
SH	R26, 4(SP)
SW	R25, 8(SP)
MOVZ	R26, R3, R0
MOVZ	R25, R2, R0
JAL	_Q15_Ftoi+0
NOP	
LW	R25, 8(SP)
LH	R26, 4(SP)
;MyProject.c,92 :: 		Q15_coefficients_buffer[x] = tmp;
SEH	R2, R13
SLL	R2, R2, 1
ADDU	R3, R27, R2
LH	R2, 12(SP)
SH	R2, 0(R3)
;MyProject.c,89 :: 		for(x =0; x<LenOfCoeffs; x++)
ADDIU	R2, R13, 1
SEH	R13, R2
;MyProject.c,93 :: 		}
; x end address is: 52 (R13)
J	L_PrepareQ15coefBuffer2
NOP	
L_PrepareQ15coefBuffer3:
;MyProject.c,94 :: 		}
L_end_PrepareQ15coefBuffer:
LW	RA, 0(SP)
ADDIU	SP, SP, 16
JR	RA
NOP	
; end of _PrepareQ15coefBuffer
_Drawlines:
;MyProject.c,97 :: 		void   Drawlines()
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;MyProject.c,100 :: 		TFT_Set_Font(TFT_defaultFont,CL_BLUE,FO_HORIZONTAL);
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
MOVZ	R27, R0, R0
ORI	R26, R0, 31
LUI	R25, hi_addr(_TFT_defaultFont+0)
ORI	R25, R25, lo_addr(_TFT_defaultFont+0)
JAL	_TFT_Set_Font+0
NOP	
;MyProject.c,101 :: 		TFT_Write_Text("IN SIG",15,10);
ORI	R27, R0, 10
ORI	R26, R0, 15
LUI	R25, hi_addr(?lstr1_MyProject+0)
ORI	R25, R25, lo_addr(?lstr1_MyProject+0)
JAL	_TFT_Write_Text+0
NOP	
;MyProject.c,102 :: 		TFT_Set_Font(TFT_defaultFont, CL_RED ,FO_HORIZONTAL);
MOVZ	R27, R0, R0
ORI	R26, R0, 63488
LUI	R25, hi_addr(_TFT_defaultFont+0)
ORI	R25, R25, lo_addr(_TFT_defaultFont+0)
JAL	_TFT_Set_Font+0
NOP	
;MyProject.c,103 :: 		TFT_Write_Text("OUT SIG",19,60);
ORI	R27, R0, 60
ORI	R26, R0, 19
LUI	R25, hi_addr(?lstr2_MyProject+0)
ORI	R25, R25, lo_addr(?lstr2_MyProject+0)
JAL	_TFT_Write_Text+0
NOP	
;MyProject.c,104 :: 		TFT_Set_Font(TFT_defaultFont,CL_green,FO_HORIZONTAL);
MOVZ	R27, R0, R0
ORI	R26, R0, 1024
LUI	R25, hi_addr(_TFT_defaultFont+0)
ORI	R25, R25, lo_addr(_TFT_defaultFont+0)
JAL	_TFT_Set_Font+0
NOP	
;MyProject.c,105 :: 		TFT_Write_Text("Amp",15,110);
ORI	R27, R0, 110
ORI	R26, R0, 15
LUI	R25, hi_addr(?lstr3_MyProject+0)
ORI	R25, R25, lo_addr(?lstr3_MyProject+0)
JAL	_TFT_Write_Text+0
NOP	
;MyProject.c,106 :: 		TFT_Set_Font(TFT_defaultFont,CL_BLACK ,FO_HORIZONTAL);
MOVZ	R27, R0, R0
MOVZ	R26, R0, R0
LUI	R25, hi_addr(_TFT_defaultFont+0)
ORI	R25, R25, lo_addr(_TFT_defaultFont+0)
JAL	_TFT_Set_Font+0
NOP	
;MyProject.c,107 :: 		TFT_Write_Text("Period",15,160);
ORI	R27, R0, 160
ORI	R26, R0, 15
LUI	R25, hi_addr(?lstr4_MyProject+0)
ORI	R25, R25, lo_addr(?lstr4_MyProject+0)
JAL	_TFT_Write_Text+0
NOP	
;MyProject.c,108 :: 		TFT_Set_Font(TFT_defaultFont, CL_FUCHSIA, FO_HORIZONTAL);
MOVZ	R27, R0, R0
ORI	R26, R0, 63519
LUI	R25, hi_addr(_TFT_defaultFont+0)
ORI	R25, R25, lo_addr(_TFT_defaultFont+0)
JAL	_TFT_Set_Font+0
NOP	
;MyProject.c,109 :: 		TFT_Write_Text("Rise",15,210);
ORI	R27, R0, 210
ORI	R26, R0, 15
LUI	R25, hi_addr(?lstr5_MyProject+0)
ORI	R25, R25, lo_addr(?lstr5_MyProject+0)
JAL	_TFT_Write_Text+0
NOP	
;MyProject.c,112 :: 		TFT_Set_Pen(CL_BLACK, 2);
ORI	R26, R0, 2
MOVZ	R25, R0, R0
JAL	_TFT_Set_Pen+0
NOP	
;MyProject.c,115 :: 		TFT_Line(0,50, 320,50);
ORI	R28, R0, 50
ORI	R27, R0, 320
ORI	R26, R0, 50
MOVZ	R25, R0, R0
JAL	_TFT_Line+0
NOP	
;MyProject.c,116 :: 		TFT_Line(0,100, 320,100);
ORI	R28, R0, 100
ORI	R27, R0, 320
ORI	R26, R0, 100
MOVZ	R25, R0, R0
JAL	_TFT_Line+0
NOP	
;MyProject.c,117 :: 		TFT_Line(0,150, 320,150);
ORI	R28, R0, 150
ORI	R27, R0, 320
ORI	R26, R0, 150
MOVZ	R25, R0, R0
JAL	_TFT_Line+0
NOP	
;MyProject.c,118 :: 		TFT_Line(0,200, 320,200);
ORI	R28, R0, 200
ORI	R27, R0, 320
ORI	R26, R0, 200
MOVZ	R25, R0, R0
JAL	_TFT_Line+0
NOP	
;MyProject.c,119 :: 		}
L_end_Drawlines:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 20
JR	RA
NOP	
; end of _Drawlines
_drawsignal_in:
;MyProject.c,121 :: 		void drawsignal_in (int in_signal[])
ADDIU	SP, SP, -24
SW	RA, 0(SP)
;MyProject.c,125 :: 		TFT_Set_Pen(CL_BLUE, 1);
SW	R26, 4(SP)
SW	R27, 8(SP)
SW	R28, 12(SP)
SW	R25, 16(SP)
ORI	R26, R0, 1
ORI	R25, R0, 31
JAL	_TFT_Set_Pen+0
NOP	
LW	R25, 16(SP)
;MyProject.c,126 :: 		for(i=1;i<SIZE_OF_BUFFER;i++)
ORI	R2, R0, 1
SH	R2, Offset(_i+0)(GP)
L_drawsignal_in5:
LHU	R2, Offset(_i+0)(GP)
SLTIU	R2, R2, 320
BNE	R2, R0, L__drawsignal_in168
NOP	
J	L_drawsignal_in6
NOP	
L__drawsignal_in168:
;MyProject.c,128 :: 		point = in_signal[i]*240.0/1024.0+150;
LHU	R2, Offset(_i+0)(GP)
SLL	R2, R2, 1
ADDU	R2, R25, R2
LH	R2, 0(R2)
SEH	R4, R2
JAL	__SignedIntegralToFloat+0
NOP	
LUI	R4, 17264
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Mul_FP+0
NOP	
LUI	R6, 17536
ORI	R6, R6, 0
MOVZ	R4, R2, R0
JAL	__Div_FP+0
NOP	
LUI	R4, 17174
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Add_FP+0
NOP	
MOVZ	R4, R2, R0
JAL	__FloatToSignedIntegral+0
NOP	
; point start address is: 64 (R16)
SEH	R16, R2
;MyProject.c,129 :: 		oldpoint = in_signal[i-1]*240.0/1024.0+150;
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, -1
SH	R2, 20(SP)
ANDI	R2, R2, 65535
SLL	R2, R2, 1
ADDU	R2, R25, R2
LH	R2, 0(R2)
SEH	R4, R2
JAL	__SignedIntegralToFloat+0
NOP	
LUI	R4, 17264
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Mul_FP+0
NOP	
LUI	R6, 17536
ORI	R6, R6, 0
MOVZ	R4, R2, R0
JAL	__Div_FP+0
NOP	
LUI	R4, 17174
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Add_FP+0
NOP	
MOVZ	R4, R2, R0
JAL	__FloatToSignedIntegral+0
NOP	
;MyProject.c,130 :: 		TFT_Line(i-1,240-(int)oldpoint ,i,240-(int)point);
ORI	R3, R0, 240
SUBU	R4, R3, R16
; point end address is: 64 (R16)
ORI	R3, R0, 240
SUBU	R3, R3, R2
LHU	R2, 20(SP)
SW	R25, 16(SP)
SEH	R28, R4
LHU	R27, Offset(_i+0)(GP)
SEH	R26, R3
ANDI	R25, R2, 65535
JAL	_TFT_Line+0
NOP	
LW	R25, 16(SP)
;MyProject.c,126 :: 		for(i=1;i<SIZE_OF_BUFFER;i++)
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
SH	R2, Offset(_i+0)(GP)
;MyProject.c,131 :: 		}
J	L_drawsignal_in5
NOP	
L_drawsignal_in6:
;MyProject.c,132 :: 		}
L_end_drawsignal_in:
LW	R28, 12(SP)
LW	R27, 8(SP)
LW	R26, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 24
JR	RA
NOP	
; end of _drawsignal_in
_draw_signal_out:
;MyProject.c,133 :: 		void draw_signal_out (int out_signal[])
ADDIU	SP, SP, -24
SW	RA, 0(SP)
;MyProject.c,138 :: 		TFT_Set_Pen(CL_RED, 1);
SW	R26, 4(SP)
SW	R27, 8(SP)
SW	R28, 12(SP)
SW	R25, 16(SP)
ORI	R26, R0, 1
ORI	R25, R0, 63488
JAL	_TFT_Set_Pen+0
NOP	
LW	R25, 16(SP)
;MyProject.c,139 :: 		for(i=begining;i<SIZE_OF_BUFFER;i++)
ORI	R2, R0, 10
SH	R2, Offset(_i+0)(GP)
L_draw_signal_out8:
LHU	R2, Offset(_i+0)(GP)
SLTIU	R2, R2, 320
BNE	R2, R0, L__draw_signal_out170
NOP	
J	L_draw_signal_out9
NOP	
L__draw_signal_out170:
;MyProject.c,141 :: 		point = out_signal[i]*240.0/1024.0+75;
LHU	R2, Offset(_i+0)(GP)
SLL	R2, R2, 1
ADDU	R2, R25, R2
LH	R2, 0(R2)
SEH	R4, R2
JAL	__SignedIntegralToFloat+0
NOP	
LUI	R4, 17264
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Mul_FP+0
NOP	
LUI	R6, 17536
ORI	R6, R6, 0
MOVZ	R4, R2, R0
JAL	__Div_FP+0
NOP	
LUI	R4, 17046
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Add_FP+0
NOP	
MOVZ	R4, R2, R0
JAL	__FloatToSignedIntegral+0
NOP	
; point start address is: 64 (R16)
SEH	R16, R2
;MyProject.c,142 :: 		oldpoint = out_signal[i-1]*240.0/1024.0+75;
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, -1
SH	R2, 20(SP)
ANDI	R2, R2, 65535
SLL	R2, R2, 1
ADDU	R2, R25, R2
LH	R2, 0(R2)
SEH	R4, R2
JAL	__SignedIntegralToFloat+0
NOP	
LUI	R4, 17264
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Mul_FP+0
NOP	
LUI	R6, 17536
ORI	R6, R6, 0
MOVZ	R4, R2, R0
JAL	__Div_FP+0
NOP	
LUI	R4, 17046
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Add_FP+0
NOP	
MOVZ	R4, R2, R0
JAL	__FloatToSignedIntegral+0
NOP	
;MyProject.c,143 :: 		TFT_Line(i-1,240-(int)oldpoint ,i,240-(int)point);
ORI	R3, R0, 240
SUBU	R4, R3, R16
; point end address is: 64 (R16)
ORI	R3, R0, 240
SUBU	R3, R3, R2
LHU	R2, 20(SP)
SW	R25, 16(SP)
SEH	R28, R4
LHU	R27, Offset(_i+0)(GP)
SEH	R26, R3
ANDI	R25, R2, 65535
JAL	_TFT_Line+0
NOP	
LW	R25, 16(SP)
;MyProject.c,139 :: 		for(i=begining;i<SIZE_OF_BUFFER;i++)
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
SH	R2, Offset(_i+0)(GP)
;MyProject.c,144 :: 		}
J	L_draw_signal_out8
NOP	
L_draw_signal_out9:
;MyProject.c,145 :: 		}
L_end_draw_signal_out:
LW	R28, 12(SP)
LW	R27, 8(SP)
LW	R26, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 24
JR	RA
NOP	
; end of _draw_signal_out
_print_period:
;MyProject.c,146 :: 		void print_period()
ADDIU	SP, SP, -32
SW	RA, 0(SP)
;MyProject.c,148 :: 		TFT_Set_Pen(CL_BLACK, 2);
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
ORI	R26, R0, 2
MOVZ	R25, R0, R0
JAL	_TFT_Set_Pen+0
NOP	
;MyProject.c,149 :: 		i=0;
SH	R0, Offset(_i+0)(GP)
;MyProject.c,150 :: 		while(index_max_arr [i] !=-3 &&index_max_arr [i+1]!=-3)
L_print_period11:
LHU	R2, Offset(_i+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__print_period173
NOP	
J	L__print_period91
NOP	
L__print_period173:
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
ANDI	R2, R2, 65535
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__print_period175
NOP	
J	L__print_period90
NOP	
L__print_period175:
L__print_period89:
;MyProject.c,152 :: 		point= (index_max_arr[i+1]- index_max_arr[i])*240.0/1024.0+50;
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
ANDI	R2, R2, 65535
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
SW	R2, 28(SP)
LH	R4, 0(R2)
LHU	R2, Offset(_i+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
SW	R2, 24(SP)
LH	R2, 0(R2)
SUBU	R2, R4, R2
SEH	R4, R2
JAL	__SignedIntegralToFloat+0
NOP	
LUI	R4, 17264
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Mul_FP+0
NOP	
LUI	R6, 17536
ORI	R6, R6, 0
MOVZ	R4, R2, R0
JAL	__Div_FP+0
NOP	
LUI	R4, 16968
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Add_FP+0
NOP	
MOVZ	R4, R2, R0
JAL	__FloatToSignedIntegral+0
NOP	
SH	R2, 20(SP)
;MyProject.c,153 :: 		TFT_Line( index_max_arr[i+1], 240 - (int)point,  index_max_arr[i], 240 - (int) point);
ORI	R3, R0, 240
SUBU	R4, R3, R2
LW	R2, 24(SP)
LH	R3, 0(R2)
LW	R2, 28(SP)
LH	R2, 0(R2)
SEH	R28, R4
SEH	R27, R3
SEH	R26, R4
SEH	R25, R2
JAL	_TFT_Line+0
NOP	
;MyProject.c,154 :: 		i++;
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
SH	R2, Offset(_i+0)(GP)
;MyProject.c,155 :: 		}
J	L_print_period11
NOP	
;MyProject.c,150 :: 		while(index_max_arr [i] !=-3 &&index_max_arr [i+1]!=-3)
L__print_period91:
L__print_period90:
;MyProject.c,156 :: 		TFT_Line( index_max_arr[i], 240 - (int)point,  320, 240 - (int) point);
LH	R3, 20(SP)
ORI	R2, R0, 240
SUBU	R4, R2, R3
LHU	R2, Offset(_i+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R28, R4
ORI	R27, R0, 320
SEH	R26, R4
SEH	R25, R2
JAL	_TFT_Line+0
NOP	
;MyProject.c,157 :: 		}
L_end_print_period:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 32
JR	RA
NOP	
; end of _print_period
_print_rising_time:
;MyProject.c,158 :: 		void print_rising_time()
ADDIU	SP, SP, -24
SW	RA, 0(SP)
;MyProject.c,159 :: 		{   int flagg=1;
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
ORI	R30, R0, 1
SH	R30, 20(SP)
MOVZ	R30, R0, R0
SH	R30, 22(SP)
;MyProject.c,160 :: 		int point=0;
;MyProject.c,161 :: 		TFT_Set_Pen(CL_FUCHSIA, 2);
ORI	R26, R0, 2
ORI	R25, R0, 63519
JAL	_TFT_Set_Pen+0
NOP	
;MyProject.c,162 :: 		i=0;
SH	R0, Offset(_i+0)(GP)
;MyProject.c,163 :: 		while(risingTimes [i] !=-3)
L_print_rising_time15:
LHU	R2, Offset(_i+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_risingTimes+0)
ORI	R2, R2, lo_addr(_risingTimes+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__print_rising_time178
NOP	
J	L_print_rising_time16
NOP	
L__print_rising_time178:
;MyProject.c,165 :: 		point= (risingTimes [i])*240.0/1024.0+20;
LHU	R2, Offset(_i+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_risingTimes+0)
ORI	R2, R2, lo_addr(_risingTimes+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R4, R2
JAL	__SignedIntegralToFloat+0
NOP	
LUI	R4, 17264
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Mul_FP+0
NOP	
LUI	R6, 17536
ORI	R6, R6, 0
MOVZ	R4, R2, R0
JAL	__Div_FP+0
NOP	
LUI	R4, 16800
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Add_FP+0
NOP	
MOVZ	R4, R2, R0
JAL	__FloatToSignedIntegral+0
NOP	
SH	R2, 22(SP)
;MyProject.c,166 :: 		if(  index_min_arr[i+1]!=-3)
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
ANDI	R2, R2, 65535
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__print_rising_time180
NOP	
J	L_print_rising_time17
NOP	
L__print_rising_time180:
;MyProject.c,167 :: 		TFT_Line( index_min_arr[i], 240 - (int)point,  index_min_arr[i+1], 240 - (int) point);
LH	R3, 22(SP)
ORI	R2, R0, 240
SUBU	R5, R2, R3
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
ANDI	R2, R2, 65535
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
LH	R4, 0(R2)
LHU	R2, Offset(_i+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R28, R5
SEH	R27, R4
SEH	R26, R5
SEH	R25, R2
JAL	_TFT_Line+0
NOP	
J	L_print_rising_time18
NOP	
L_print_rising_time17:
;MyProject.c,170 :: 		TFT_Line( index_min_arr[i], 240 - (int)point,  320, 240 - (int) point);
LH	R3, 22(SP)
ORI	R2, R0, 240
SUBU	R4, R2, R3
LHU	R2, Offset(_i+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R28, R4
ORI	R27, R0, 320
SEH	R26, R4
SEH	R25, R2
JAL	_TFT_Line+0
NOP	
;MyProject.c,171 :: 		flagg=0;
SH	R0, 20(SP)
;MyProject.c,172 :: 		}
L_print_rising_time18:
;MyProject.c,173 :: 		i++;
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
SH	R2, Offset(_i+0)(GP)
;MyProject.c,174 :: 		}
J	L_print_rising_time15
NOP	
L_print_rising_time16:
;MyProject.c,175 :: 		if(flagg)
LH	R2, 20(SP)
BNE	R2, R0, L__print_rising_time182
NOP	
J	L_print_rising_time19
NOP	
L__print_rising_time182:
;MyProject.c,177 :: 		TFT_Line( index_min_arr[i], 240 - (int)point,  320, 240 - (int) point);
LH	R3, 22(SP)
ORI	R2, R0, 240
SUBU	R4, R2, R3
LHU	R2, Offset(_i+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R28, R4
ORI	R27, R0, 320
SEH	R26, R4
SEH	R25, R2
JAL	_TFT_Line+0
NOP	
;MyProject.c,178 :: 		}
L_print_rising_time19:
;MyProject.c,179 :: 		}
L_end_print_rising_time:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 24
JR	RA
NOP	
; end of _print_rising_time
_drawamp:
;MyProject.c,182 :: 		void drawamp()
ADDIU	SP, SP, -28
SW	RA, 0(SP)
;MyProject.c,185 :: 		TFT_Set_Pen(CL_green, 3);
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
ORI	R26, R0, 3
ORI	R25, R0, 1024
JAL	_TFT_Set_Pen+0
NOP	
;MyProject.c,187 :: 		while(present_ind<max_counts&&(max_arr[present_ind]!=-3))
L_drawamp20:
LH	R2, Offset(_present_ind+0)(GP)
SLTI	R2, R2, 25
BNE	R2, R0, L__drawamp184
NOP	
J	L__drawamp106
NOP	
L__drawamp184:
LH	R2, Offset(_present_ind+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__drawamp186
NOP	
J	L__drawamp105
NOP	
L__drawamp186:
L__drawamp96:
;MyProject.c,189 :: 		if(present_ind==0&&max_arr[present_ind]!=-3)
LH	R2, Offset(_present_ind+0)(GP)
BEQ	R2, R0, L__drawamp187
NOP	
J	L__drawamp98
NOP	
L__drawamp187:
LH	R2, Offset(_present_ind+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__drawamp189
NOP	
J	L__drawamp97
NOP	
L__drawamp189:
L__drawamp95:
;MyProject.c,191 :: 		point = max_arr[0] * 240.0 / 1024.0+23;
LH	R4, Offset(_max_arr+0)(GP)
JAL	__SignedIntegralToFloat+0
NOP	
LUI	R4, 17264
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Mul_FP+0
NOP	
LUI	R6, 17536
ORI	R6, R6, 0
MOVZ	R4, R2, R0
JAL	__Div_FP+0
NOP	
LUI	R4, 16824
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Add_FP+0
NOP	
MOVZ	R4, R2, R0
JAL	__FloatToSignedIntegral+0
NOP	
SH	R2, 20(SP)
;MyProject.c,192 :: 		TFT_Line(begining, 240 - (int) point, index_max_arr[0], 240 - (int)point);
ORI	R3, R0, 240
SUBU	R2, R3, R2
SEH	R28, R2
LH	R27, Offset(_index_max_arr+0)(GP)
SEH	R26, R2
ORI	R25, R0, 10
JAL	_TFT_Line+0
NOP	
;MyProject.c,193 :: 		present_ind++;
LH	R2, Offset(_present_ind+0)(GP)
ADDIU	R2, R2, 1
SH	R2, Offset(_present_ind+0)(GP)
;MyProject.c,189 :: 		if(present_ind==0&&max_arr[present_ind]!=-3)
L__drawamp98:
L__drawamp97:
;MyProject.c,195 :: 		if(present_ind!=0&&max_arr[present_ind]!=-3)
LH	R2, Offset(_present_ind+0)(GP)
BNE	R2, R0, L__drawamp191
NOP	
J	L__drawamp100
NOP	
L__drawamp191:
LH	R2, Offset(_present_ind+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__drawamp193
NOP	
J	L__drawamp99
NOP	
L__drawamp193:
L__drawamp94:
;MyProject.c,197 :: 		oldpoint = point;
LH	R2, 20(SP)
SH	R2, 22(SP)
;MyProject.c,198 :: 		point = max_arr[present_ind] * 240.0 / 1024.0+23 ;
LH	R2, Offset(_present_ind+0)(GP)
SLL	R3, R2, 1
SW	R3, 24(SP)
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R4, R2
JAL	__SignedIntegralToFloat+0
NOP	
LUI	R4, 17264
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Mul_FP+0
NOP	
LUI	R6, 17536
ORI	R6, R6, 0
MOVZ	R4, R2, R0
JAL	__Div_FP+0
NOP	
LUI	R4, 16824
ORI	R4, R4, 0
MOVZ	R6, R2, R0
JAL	__Add_FP+0
NOP	
MOVZ	R4, R2, R0
JAL	__FloatToSignedIntegral+0
NOP	
SH	R2, 20(SP)
;MyProject.c,199 :: 		TFT_Line( index_max_arr[present_ind-1], 240 - (int) oldpoint,  index_max_arr[present_ind], 240 - (int) point);
ORI	R3, R0, 240
SUBU	R6, R3, R2
LUI	R3, hi_addr(_index_max_arr+0)
ORI	R3, R3, lo_addr(_index_max_arr+0)
LW	R2, 24(SP)
ADDU	R2, R3, R2
LH	R5, 0(R2)
LH	R3, 22(SP)
ORI	R2, R0, 240
SUBU	R4, R2, R3
LH	R2, Offset(_present_ind+0)(GP)
ADDIU	R2, R2, -1
SEH	R2, R2
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R28, R6
SEH	R27, R5
SEH	R26, R4
SEH	R25, R2
JAL	_TFT_Line+0
NOP	
;MyProject.c,200 :: 		present_ind++;
LH	R2, Offset(_present_ind+0)(GP)
ADDIU	R2, R2, 1
SH	R2, Offset(_present_ind+0)(GP)
;MyProject.c,195 :: 		if(present_ind!=0&&max_arr[present_ind]!=-3)
L__drawamp100:
L__drawamp99:
;MyProject.c,202 :: 		if(present_ind==0&&max_arr[present_ind]==-3)
LH	R2, Offset(_present_ind+0)(GP)
BEQ	R2, R0, L__drawamp194
NOP	
J	L__drawamp102
NOP	
L__drawamp194:
LH	R2, Offset(_present_ind+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BEQ	R3, R2, L__drawamp195
NOP	
J	L__drawamp101
NOP	
L__drawamp195:
L__drawamp93:
;MyProject.c,204 :: 		TFT_Set_Pen(CL_RED, 4);
ORI	R26, R0, 4
ORI	R25, R0, 63488
JAL	_TFT_Set_Pen+0
NOP	
;MyProject.c,205 :: 		TFT_Write_Text("Death or malfunction occurred, emergency! ",begining+20,110);          //dont work becouse of noise
ORI	R27, R0, 110
ORI	R26, R0, 30
LUI	R25, hi_addr(?lstr6_MyProject+0)
ORI	R25, R25, lo_addr(?lstr6_MyProject+0)
JAL	_TFT_Write_Text+0
NOP	
;MyProject.c,202 :: 		if(present_ind==0&&max_arr[present_ind]==-3)
L__drawamp102:
L__drawamp101:
;MyProject.c,207 :: 		if(present_ind!=0&&max_arr[present_ind]==-3)
LH	R2, Offset(_present_ind+0)(GP)
BNE	R2, R0, L__drawamp197
NOP	
J	L__drawamp104
NOP	
L__drawamp197:
LH	R2, Offset(_present_ind+0)(GP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BEQ	R3, R2, L__drawamp198
NOP	
J	L__drawamp103
NOP	
L__drawamp198:
L__drawamp92:
;MyProject.c,208 :: 		TFT_Line(index_max_arr[present_ind-1], 240 - (int)point, 320, 240 - (int)point);   //last max same amp after it.
LH	R3, 20(SP)
ORI	R2, R0, 240
SUBU	R4, R2, R3
LH	R2, Offset(_present_ind+0)(GP)
ADDIU	R2, R2, -1
SEH	R2, R2
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R28, R4
ORI	R27, R0, 320
SEH	R26, R4
SEH	R25, R2
JAL	_TFT_Line+0
NOP	
;MyProject.c,207 :: 		if(present_ind!=0&&max_arr[present_ind]==-3)
L__drawamp104:
L__drawamp103:
;MyProject.c,210 :: 		}
J	L_drawamp20
NOP	
;MyProject.c,187 :: 		while(present_ind<max_counts&&(max_arr[present_ind]!=-3))
L__drawamp106:
L__drawamp105:
;MyProject.c,211 :: 		present_ind=0;
SH	R0, Offset(_present_ind+0)(GP)
;MyProject.c,213 :: 		}
L_end_drawamp:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 28
JR	RA
NOP	
; end of _drawamp
_set_bpm:
;MyProject.c,214 :: 		void  set_bpm()
ADDIU	SP, SP, -44
SW	RA, 0(SP)
;MyProject.c,216 :: 		char tempp [20]="";
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
ADDIU	R23, SP, 16
ADDIU	R22, R23, 25
LUI	R24, hi_addr(?ICSset_bpm_tempp_L0+0)
ORI	R24, R24, lo_addr(?ICSset_bpm_tempp_L0+0)
JAL	___CC2DW+0
NOP	
;MyProject.c,217 :: 		char xx []="bpm:" ;
;MyProject.c,218 :: 		TFT_Set_Font(TFT_defaultFont,CL_RED,FO_HORIZONTAL);
MOVZ	R27, R0, R0
ORI	R26, R0, 63488
LUI	R25, hi_addr(_TFT_defaultFont+0)
ORI	R25, R25, lo_addr(_TFT_defaultFont+0)
JAL	_TFT_Set_Font+0
NOP	
;MyProject.c,219 :: 		IntToStr(bpm,tempp);
ADDIU	R2, SP, 16
MOVZ	R26, R2, R0
LH	R25, Offset(_BPM+0)(GP)
JAL	_IntToStr+0
NOP	
;MyProject.c,220 :: 		TFT_Write_Text(tempp,140,10);
ADDIU	R2, SP, 16
ORI	R27, R0, 10
ORI	R26, R0, 140
MOVZ	R25, R2, R0
JAL	_TFT_Write_Text+0
NOP	
;MyProject.c,221 :: 		TFT_Write_Text(xx,115,10);
ADDIU	R2, SP, 36
ORI	R27, R0, 10
ORI	R26, R0, 115
MOVZ	R25, R2, R0
JAL	_TFT_Write_Text+0
NOP	
;MyProject.c,224 :: 		}
L_end_set_bpm:
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 44
JR	RA
NOP	
; end of _set_bpm
_UpdateScreen:
;MyProject.c,226 :: 		void UpdateScreen(int in_signal[],int out_signal[])
ADDIU	SP, SP, -16
SW	RA, 0(SP)
;MyProject.c,229 :: 		TFT_Fill_Screen(CL_WHITE);
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R25, 12(SP)
ORI	R25, R0, 65535
JAL	_TFT_Fill_Screen+0
NOP	
;MyProject.c,230 :: 		Drawlines();
JAL	_Drawlines+0
NOP	
;MyProject.c,231 :: 		set_bpm();
JAL	_set_bpm+0
NOP	
LW	R25, 12(SP)
;MyProject.c,232 :: 		drawsignal_in(in_signal);
JAL	_drawsignal_in+0
NOP	
LW	R26, 8(SP)
;MyProject.c,233 :: 		draw_signal_out(out_signal) ;
MOVZ	R25, R26, R0
JAL	_draw_signal_out+0
NOP	
;MyProject.c,234 :: 		drawamp ();
JAL	_drawamp+0
NOP	
;MyProject.c,235 :: 		print_period();
JAL	_print_period+0
NOP	
;MyProject.c,236 :: 		print_rising_time();
JAL	_print_rising_time+0
NOP	
;MyProject.c,242 :: 		}
L_end_UpdateScreen:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 16
JR	RA
NOP	
; end of _UpdateScreen
_PIC_DSP_Library_Convolution:
;MyProject.c,243 :: 		void PIC_DSP_Library_Convolution(int CoeffsArrNUM[],int CoeffsArrDENUM[],int LenOfCoeffsDENUM, int signal_in[], int signal_out[], unsigned int Index)
ADDIU	SP, SP, -24
SW	RA, 0(SP)
; signal_out start address is: 36 (R9)
LW	R9, 24(SP)
; Index start address is: 32 (R8)
LHU	R8, 28(SP)
;MyProject.c,248 :: 		for(j=0; j < Index; j++)
; j start address is: 40 (R10)
MOVZ	R10, R0, R0
; Index end address is: 32 (R8)
; j end address is: 40 (R10)
L_PIC_DSP_Library_Convolution36:
; j start address is: 40 (R10)
; Index start address is: 32 (R8)
; signal_out start address is: 36 (R9)
; signal_out end address is: 36 (R9)
ANDI	R3, R10, 65535
ANDI	R2, R8, 65535
SLTU	R2, R3, R2
BNE	R2, R0, L__PIC_DSP_Library_Convolution202
NOP	
J	L_PIC_DSP_Library_Convolution37
NOP	
L__PIC_DSP_Library_Convolution202:
; signal_out end address is: 36 (R9)
;MyProject.c,250 :: 		signal_out[j] = IIR_Radix(0, 0, CoeffsArrNUM, CoeffsArrDENUM,LenOfCoeffsDENUM, signal_in, Index, signal_out, j);
; signal_out start address is: 36 (R9)
ANDI	R2, R10, 65535
SLL	R2, R2, 1
ADDU	R2, R9, R2
SW	R2, 20(SP)
SW	R28, 4(SP)
SH	R27, 8(SP)
SW	R26, 12(SP)
SW	R25, 16(SP)
ADDIU	SP, SP, -20
SH	R10, 16(SP)
SW	R9, 12(SP)
SH	R8, 8(SP)
SW	R28, 4(SP)
SH	R27, 0(SP)
MOVZ	R28, R26, R0
MOVZ	R26, R0, R0
MOVZ	R27, R25, R0
MOVZ	R25, R0, R0
JAL	_IIR_Radix+0
NOP	
ADDIU	SP, SP, 20
LW	R25, 16(SP)
LW	R26, 12(SP)
LH	R27, 8(SP)
LW	R28, 4(SP)
LW	R3, 20(SP)
SH	R2, 0(R3)
;MyProject.c,248 :: 		for(j=0; j < Index; j++)
ADDIU	R2, R10, 1
ANDI	R10, R2, 65535
;MyProject.c,251 :: 		}
; Index end address is: 32 (R8)
; signal_out end address is: 36 (R9)
; j end address is: 40 (R10)
J	L_PIC_DSP_Library_Convolution36
NOP	
L_PIC_DSP_Library_Convolution37:
;MyProject.c,253 :: 		}
L_end_PIC_DSP_Library_Convolution:
LW	RA, 0(SP)
ADDIU	SP, SP, 24
JR	RA
NOP	
; end of _PIC_DSP_Library_Convolution
_AddValueToAcquisitionBuffer:
;MyProject.c,255 :: 		void AddValueToAcquisitionBuffer()
ADDIU	SP, SP, -8
SW	RA, 0(SP)
;MyProject.c,257 :: 		ADCvalue = ADC1_Get_Sample(0);
SW	R25, 4(SP)
MOVZ	R25, R0, R0
JAL	_ADC1_Get_Sample+0
NOP	
SH	R2, Offset(_ADCvalue+0)(GP)
;MyProject.c,258 :: 		acquisitionBuffer[acquisitionBufferCounter++] = ADCvalue;
LH	R3, Offset(_acquisitionBufferCounter+0)(GP)
SLL	R4, R3, 1
LW	R3, Offset(_acquisitionBuffer+0)(GP)
ADDU	R3, R3, R4
SH	R2, 0(R3)
LH	R2, Offset(_acquisitionBufferCounter+0)(GP)
ADDIU	R2, R2, 1
SH	R2, Offset(_acquisitionBufferCounter+0)(GP)
;MyProject.c,259 :: 		if ( acquisitionBufferCounter >= SIZE_OF_BUFFER  )  //checking if the Buffer is filled
SEH	R2, R2
SLTI	R2, R2, 320
BEQ	R2, R0, L__AddValueToAcquisitionBuffer204
NOP	
J	L_AddValueToAcquisitionBuffer39
NOP	
L__AddValueToAcquisitionBuffer204:
;MyProject.c,261 :: 		acquisitionBufferCounter =0;
SH	R0, Offset(_acquisitionBufferCounter+0)(GP)
;MyProject.c,262 :: 		if ( acquisitionBufferNumber == 1 )
LH	R3, Offset(_acquisitionBufferNumber+0)(GP)
ORI	R2, R0, 1
BEQ	R3, R2, L__AddValueToAcquisitionBuffer205
NOP	
J	L_AddValueToAcquisitionBuffer40
NOP	
L__AddValueToAcquisitionBuffer205:
;MyProject.c,264 :: 		acquisitionBuffer = Buffer2;
LUI	R2, hi_addr(_Buffer2+0)
ORI	R2, R2, lo_addr(_Buffer2+0)
SW	R2, Offset(_acquisitionBuffer+0)(GP)
;MyProject.c,265 :: 		acquisitionBufferNumber = 2;
ORI	R2, R0, 2
SH	R2, Offset(_acquisitionBufferNumber+0)(GP)
;MyProject.c,266 :: 		processingBufferNumber = 1;
ORI	R2, R0, 1
SH	R2, Offset(_processingBufferNumber+0)(GP)
;MyProject.c,267 :: 		processingBuffer = Buffer1;
LUI	R2, hi_addr(_Buffer1+0)
ORI	R2, R2, lo_addr(_Buffer1+0)
SW	R2, Offset(_processingBuffer+0)(GP)
;MyProject.c,268 :: 		}
J	L_AddValueToAcquisitionBuffer41
NOP	
L_AddValueToAcquisitionBuffer40:
;MyProject.c,271 :: 		acquisitionBuffer = Buffer1;
LUI	R2, hi_addr(_Buffer1+0)
ORI	R2, R2, lo_addr(_Buffer1+0)
SW	R2, Offset(_acquisitionBuffer+0)(GP)
;MyProject.c,272 :: 		acquisitionBufferNumber = 1;
ORI	R2, R0, 1
SH	R2, Offset(_acquisitionBufferNumber+0)(GP)
;MyProject.c,273 :: 		processingBufferNumber = 2;
ORI	R2, R0, 2
SH	R2, Offset(_processingBufferNumber+0)(GP)
;MyProject.c,274 :: 		processingBuffer = Buffer2;
LUI	R2, hi_addr(_Buffer2+0)
ORI	R2, R2, lo_addr(_Buffer2+0)
SW	R2, Offset(_processingBuffer+0)(GP)
;MyProject.c,275 :: 		}
L_AddValueToAcquisitionBuffer41:
;MyProject.c,277 :: 		processingBufferWasProcessed = 'N';
ORI	R2, R0, 78
SB	R2, Offset(_processingBufferWasProcessed+0)(GP)
;MyProject.c,278 :: 		}
L_AddValueToAcquisitionBuffer39:
;MyProject.c,279 :: 		}
L_end_AddValueToAcquisitionBuffer:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 8
JR	RA
NOP	
; end of _AddValueToAcquisitionBuffer
_intiatlize_bufers:
;MyProject.c,281 :: 		void intiatlize_bufers()
;MyProject.c,283 :: 		int ini=0;
;MyProject.c,284 :: 		for(ini=0;ini<max_counts;ini++)
; ini start address is: 16 (R4)
MOVZ	R4, R0, R0
; ini end address is: 16 (R4)
L_intiatlize_bufers42:
; ini start address is: 16 (R4)
SEH	R2, R4
SLTI	R2, R2, 25
BNE	R2, R0, L__intiatlize_bufers207
NOP	
J	L_intiatlize_bufers43
NOP	
L__intiatlize_bufers207:
;MyProject.c,286 :: 		max_arr[ini]=-3;/// we look for -3 to know that there is no max and min- the values are positve couse they came from the adc and drifted.
SEH	R2, R4
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R3, R2, R3
ORI	R2, R0, 65533
SH	R2, 0(R3)
;MyProject.c,287 :: 		min_arr[ini]=-3;
SEH	R2, R4
SLL	R3, R2, 1
LUI	R2, hi_addr(_min_arr+0)
ORI	R2, R2, lo_addr(_min_arr+0)
ADDU	R3, R2, R3
ORI	R2, R0, 65533
SH	R2, 0(R3)
;MyProject.c,288 :: 		index_max_arr[ini]=-3;
SEH	R2, R4
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R3, R2, R3
ORI	R2, R0, 65533
SH	R2, 0(R3)
;MyProject.c,289 :: 		index_min_arr[ini]=-3;
SEH	R2, R4
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R3, R2, R3
ORI	R2, R0, 65533
SH	R2, 0(R3)
;MyProject.c,290 :: 		risingTimes[ini]=-3;
SEH	R2, R4
SLL	R3, R2, 1
LUI	R2, hi_addr(_risingTimes+0)
ORI	R2, R2, lo_addr(_risingTimes+0)
ADDU	R3, R2, R3
ORI	R2, R0, 65533
SH	R2, 0(R3)
;MyProject.c,284 :: 		for(ini=0;ini<max_counts;ini++)
ADDIU	R2, R4, 1
SEH	R4, R2
;MyProject.c,291 :: 		}
; ini end address is: 16 (R4)
J	L_intiatlize_bufers42
NOP	
L_intiatlize_bufers43:
;MyProject.c,292 :: 		}
L_end_intiatlize_bufers:
JR	RA
NOP	
; end of _intiatlize_bufers
_rising_time_bpm:
;MyProject.c,295 :: 		void rising_time_bpm()
;MyProject.c,297 :: 		int index=0, lastMid=0,  temp_rising_time=0,midIndx=0,IBI=0,sum_BPM=0,index_IBI=0;
; index start address is: 40 (R10)
MOVZ	R10, R0, R0
; lastMid start address is: 20 (R5)
MOVZ	R5, R0, R0
; temp_rising_time start address is: 24 (R6)
MOVZ	R6, R0, R0
; midIndx start address is: 28 (R7)
MOVZ	R7, R0, R0
; sum_BPM start address is: 32 (R8)
MOVZ	R8, R0, R0
; index_IBI start address is: 36 (R9)
MOVZ	R9, R0, R0
;MyProject.c,299 :: 		if(index_max_arr[index]>index_min_arr[index]&&max_arr[index]!=-3 && min_arr[index]!=-3)
SEH	R2, R10
SLL	R4, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R4
LH	R3, 0(R2)
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R4
LH	R2, 0(R2)
SEH	R3, R3
SEH	R2, R2
SLT	R2, R2, R3
BNE	R2, R0, L__rising_time_bpm209
NOP	
J	L__rising_time_bpm113
NOP	
L__rising_time_bpm209:
SEH	R2, R10
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__rising_time_bpm211
NOP	
J	L__rising_time_bpm112
NOP	
L__rising_time_bpm211:
SEH	R2, R10
SLL	R3, R2, 1
LUI	R2, hi_addr(_min_arr+0)
ORI	R2, R2, lo_addr(_min_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__rising_time_bpm213
NOP	
J	L__rising_time_bpm111
NOP	
L__rising_time_bpm213:
; lastMid end address is: 20 (R5)
L__rising_time_bpm110:
;MyProject.c,301 :: 		lastMid =index_min_arr[index] + (index_max_arr[index] -index_min_arr[index])/2;
SEH	R2, R10
; index end address is: 40 (R10)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
LH	R5, 0(R2)
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SUBU	R4, R2, R5
SEH	R3, R4
ORI	R2, R0, 2
DIV	R3, R2
MFLO	R2
ADDU	R2, R5, R2
; lastMid start address is: 8 (R2)
;MyProject.c,302 :: 		risingTimes[0]=index_max_arr[index] -index_min_arr[index];
SH	R4, Offset(_risingTimes+0)(GP)
;MyProject.c,303 :: 		}
SEH	R3, R2
; lastMid end address is: 8 (R2)
J	L_rising_time_bpm48
NOP	
;MyProject.c,299 :: 		if(index_max_arr[index]>index_min_arr[index]&&max_arr[index]!=-3 && min_arr[index]!=-3)
L__rising_time_bpm113:
; lastMid start address is: 20 (R5)
; index start address is: 40 (R10)
L__rising_time_bpm112:
L__rising_time_bpm111:
;MyProject.c,304 :: 		else if (index_max_arr[index]<=index_min_arr[index]&&max_arr[index]!=-3 && min_arr[index]!=-3)
SEH	R2, R10
SLL	R4, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R4
LH	R3, 0(R2)
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R4
LH	R2, 0(R2)
SEH	R3, R3
SEH	R2, R2
SLT	R2, R2, R3
BEQ	R2, R0, L__rising_time_bpm214
NOP	
J	L__rising_time_bpm121
NOP	
L__rising_time_bpm214:
SEH	R2, R10
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__rising_time_bpm216
NOP	
J	L__rising_time_bpm122
NOP	
L__rising_time_bpm216:
SEH	R2, R10
SLL	R3, R2, 1
LUI	R2, hi_addr(_min_arr+0)
ORI	R2, R2, lo_addr(_min_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__rising_time_bpm218
NOP	
J	L__rising_time_bpm123
NOP	
L__rising_time_bpm218:
; lastMid end address is: 20 (R5)
L__rising_time_bpm109:
;MyProject.c,306 :: 		lastMid =index_min_arr[index] + (index_max_arr[index+1] -index_min_arr[index])/2;
SEH	R2, R10
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
LH	R5, 0(R2)
ADDIU	R2, R10, 1
; index end address is: 40 (R10)
SEH	R2, R2
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SUBU	R4, R2, R5
SEH	R3, R4
ORI	R2, R0, 2
DIV	R3, R2
MFLO	R2
ADDU	R2, R5, R2
; lastMid start address is: 8 (R2)
;MyProject.c,307 :: 		risingTimes[0]=index_max_arr[index+1] -index_min_arr[index];
SH	R4, Offset(_risingTimes+0)(GP)
; lastMid end address is: 8 (R2)
;MyProject.c,304 :: 		else if (index_max_arr[index]<=index_min_arr[index]&&max_arr[index]!=-3 && min_arr[index]!=-3)
J	L__rising_time_bpm116
NOP	
L__rising_time_bpm121:
SEH	R2, R5
L__rising_time_bpm116:
; lastMid start address is: 8 (R2)
; lastMid end address is: 8 (R2)
J	L__rising_time_bpm115
NOP	
L__rising_time_bpm122:
SEH	R2, R5
L__rising_time_bpm115:
; lastMid start address is: 8 (R2)
SEH	R3, R2
; lastMid end address is: 8 (R2)
J	L__rising_time_bpm114
NOP	
L__rising_time_bpm123:
SEH	R3, R5
L__rising_time_bpm114:
;MyProject.c,308 :: 		}
; lastMid start address is: 12 (R3)
; lastMid end address is: 12 (R3)
L_rising_time_bpm48:
;MyProject.c,309 :: 		index=1;
; lastMid start address is: 12 (R3)
; index start address is: 8 (R2)
ORI	R2, R0, 1
; temp_rising_time end address is: 24 (R6)
; midIndx end address is: 28 (R7)
; index_IBI end address is: 36 (R9)
; lastMid end address is: 12 (R3)
; index end address is: 8 (R2)
; sum_BPM end address is: 32 (R8)
SEH	R10, R6
SEH	R6, R2
SEH	R5, R7
SEH	R7, R9
SEH	R9, R3
;MyProject.c,311 :: 		while(max_arr[index]!=-3 && min_arr[index]!=-3 )
L_rising_time_bpm52:
; index start address is: 24 (R6)
; lastMid start address is: 36 (R9)
; index_IBI start address is: 28 (R7)
; sum_BPM start address is: 32 (R8)
; midIndx start address is: 20 (R5)
; temp_rising_time start address is: 40 (R10)
SEH	R2, R6
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__rising_time_bpm220
NOP	
J	L__rising_time_bpm120
NOP	
L__rising_time_bpm220:
SEH	R2, R6
SLL	R3, R2, 1
LUI	R2, hi_addr(_min_arr+0)
ORI	R2, R2, lo_addr(_min_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65533
BNE	R3, R2, L__rising_time_bpm222
NOP	
J	L__rising_time_bpm119
NOP	
L__rising_time_bpm222:
L__rising_time_bpm108:
;MyProject.c,314 :: 		if(index_max_arr[index] <index_min_arr[index] && index_max_arr[index+1]!=-1){
SEH	R2, R6
SLL	R4, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R4
LH	R3, 0(R2)
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R4
LH	R2, 0(R2)
SEH	R3, R3
SEH	R2, R2
SLT	R2, R3, R2
BNE	R2, R0, L__rising_time_bpm223
NOP	
J	L__rising_time_bpm124
NOP	
L__rising_time_bpm223:
ADDIU	R2, R6, 1
SEH	R2, R2
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
SEH	R3, R2
LUI	R2, 65535
ORI	R2, R2, 65535
BNE	R3, R2, L__rising_time_bpm225
NOP	
J	L__rising_time_bpm125
NOP	
L__rising_time_bpm225:
; temp_rising_time end address is: 40 (R10)
; midIndx end address is: 20 (R5)
L__rising_time_bpm107:
;MyProject.c,315 :: 		temp_rising_time= index_max_arr[index+1] -index_min_arr[index];
ADDIU	R2, R6, 1
SEH	R2, R2
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R5, 0(R2)
SEH	R2, R6
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
LH	R4, 0(R2)
SUBU	R2, R5, R4
; temp_rising_time start address is: 20 (R5)
SEH	R5, R2
;MyProject.c,316 :: 		midIndx =index_min_arr[index] + (temp_rising_time)/2;
SEH	R3, R2
ORI	R2, R0, 2
DIV	R3, R2
MFLO	R2
ADDU	R2, R4, R2
; midIndx start address is: 12 (R3)
SEH	R3, R2
; temp_rising_time end address is: 20 (R5)
; midIndx end address is: 12 (R3)
SEH	R10, R5
SEH	R5, R3
;MyProject.c,314 :: 		if(index_max_arr[index] <index_min_arr[index] && index_max_arr[index+1]!=-1){
J	L__rising_time_bpm118
NOP	
L__rising_time_bpm124:
L__rising_time_bpm118:
; midIndx start address is: 20 (R5)
; temp_rising_time start address is: 40 (R10)
; temp_rising_time end address is: 40 (R10)
; midIndx end address is: 20 (R5)
J	L__rising_time_bpm117
NOP	
L__rising_time_bpm125:
L__rising_time_bpm117:
;MyProject.c,318 :: 		if(index_max_arr[index] >=index_min_arr[index])
; temp_rising_time start address is: 40 (R10)
; midIndx start address is: 20 (R5)
SEH	R2, R6
SLL	R4, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R4
LH	R3, 0(R2)
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R4
LH	R2, 0(R2)
SEH	R3, R3
SEH	R2, R2
SLT	R2, R3, R2
BEQ	R2, R0, L__rising_time_bpm226
NOP	
J	L__rising_time_bpm126
NOP	
L__rising_time_bpm226:
; temp_rising_time end address is: 40 (R10)
; midIndx end address is: 20 (R5)
;MyProject.c,320 :: 		temp_rising_time= index_max_arr[index] -index_min_arr[index];
SEH	R2, R6
SLL	R4, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R4
LH	R3, 0(R2)
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R4
LH	R4, 0(R2)
SUBU	R2, R3, R4
; temp_rising_time start address is: 20 (R5)
SEH	R5, R2
;MyProject.c,321 :: 		midIndx =index_min_arr[index] + (temp_rising_time)/2;
SEH	R3, R2
ORI	R2, R0, 2
DIV	R3, R2
MFLO	R2
ADDU	R2, R4, R2
; midIndx start address is: 12 (R3)
SEH	R3, R2
; temp_rising_time end address is: 20 (R5)
; midIndx end address is: 12 (R3)
SEH	R4, R5
SEH	R5, R3
;MyProject.c,322 :: 		}
J	L_rising_time_bpm59
NOP	
L__rising_time_bpm126:
;MyProject.c,318 :: 		if(index_max_arr[index] >=index_min_arr[index])
SEH	R4, R10
;MyProject.c,322 :: 		}
L_rising_time_bpm59:
;MyProject.c,323 :: 		IBI= midIndx -lastMid;
; midIndx start address is: 20 (R5)
; temp_rising_time start address is: 16 (R4)
SUBU	R2, R5, R9
; lastMid end address is: 36 (R9)
; IBI start address is: 12 (R3)
SEH	R3, R2
;MyProject.c,325 :: 		if(IBI >=0)
SEH	R2, R2
SLTI	R2, R2, 0
BEQ	R2, R0, L__rising_time_bpm227
NOP	
J	L__rising_time_bpm127
NOP	
L__rising_time_bpm227:
;MyProject.c,327 :: 		sum_BPM+=IBI ;
ADDU	R2, R8, R3
; IBI end address is: 12 (R3)
SEH	R8, R2
;MyProject.c,328 :: 		index_IBI++;
ADDIU	R2, R7, 1
SEH	R7, R2
; index_IBI end address is: 28 (R7)
; sum_BPM end address is: 32 (R8)
;MyProject.c,329 :: 		}
J	L_rising_time_bpm60
NOP	
L__rising_time_bpm127:
;MyProject.c,325 :: 		if(IBI >=0)
;MyProject.c,329 :: 		}
L_rising_time_bpm60:
;MyProject.c,330 :: 		risingTimes[index] = temp_rising_time;
; index_IBI start address is: 28 (R7)
; sum_BPM start address is: 32 (R8)
SEH	R2, R6
SLL	R3, R2, 1
LUI	R2, hi_addr(_risingTimes+0)
ORI	R2, R2, lo_addr(_risingTimes+0)
ADDU	R2, R2, R3
SH	R4, 0(R2)
;MyProject.c,331 :: 		lastMid = midIndx;
; lastMid start address is: 36 (R9)
SEH	R9, R5
;MyProject.c,332 :: 		index++;
ADDIU	R2, R6, 1
SEH	R6, R2
;MyProject.c,333 :: 		}
SEH	R10, R4
; midIndx end address is: 20 (R5)
; temp_rising_time end address is: 16 (R4)
; lastMid end address is: 36 (R9)
; index end address is: 24 (R6)
J	L_rising_time_bpm52
NOP	
;MyProject.c,311 :: 		while(max_arr[index]!=-3 && min_arr[index]!=-3 )
L__rising_time_bpm120:
L__rising_time_bpm119:
;MyProject.c,334 :: 		if (sum_BPM==0)  BPM=0;
SEH	R2, R8
BEQ	R2, R0, L__rising_time_bpm228
NOP	
J	L_rising_time_bpm61
NOP	
L__rising_time_bpm228:
; index_IBI end address is: 28 (R7)
; sum_BPM end address is: 32 (R8)
SH	R0, Offset(_BPM+0)(GP)
J	L_rising_time_bpm62
NOP	
L_rising_time_bpm61:
;MyProject.c,335 :: 		else {BPM= sum_BPM/index_IBI;
; sum_BPM start address is: 32 (R8)
; index_IBI start address is: 28 (R7)
SEH	R3, R8
; sum_BPM end address is: 32 (R8)
SEH	R2, R7
; index_IBI end address is: 28 (R7)
DIV	R3, R2
MFLO	R3
SH	R3, Offset(_BPM+0)(GP)
;MyProject.c,336 :: 		BPM = (unsigned int)(60*1000/(BPM*25));//the time for one instantaneous heart beat called IBI is IBI*25msec=1000/(IBI*25)sec and the bpm is (60*1000)/(IBI*25)
ORI	R2, R0, 25
MUL	R2, R3, R2
SEH	R3, R2
ORI	R2, R0, 60000
DIVU	R2, R3
MFLO	R2
SH	R2, Offset(_BPM+0)(GP)
;MyProject.c,337 :: 		}
L_rising_time_bpm62:
;MyProject.c,338 :: 		}
L_end_rising_time_bpm:
JR	RA
NOP	
; end of _rising_time_bpm
_find_max_min_val_index:
;MyProject.c,341 :: 		void find_max_min_val_index()
ADDIU	SP, SP, -12
SW	RA, 0(SP)
;MyProject.c,343 :: 		int fmax,index_max=0,index_min=0,first_max=1,first_min=1;
ADDIU	R23, SP, 4
ADDIU	R22, R23, 8
LUI	R24, hi_addr(?ICSfind_max_min_val_index_index_max_L0+0)
ORI	R24, R24, lo_addr(?ICSfind_max_min_val_index_index_max_L0+0)
JAL	___CC2DW+0
NOP	
;MyProject.c,344 :: 		int * Fis=filtered_signal;
; Fis start address is: 24 (R6)
LUI	R30, hi_addr(_filtered_signal+0)
ORI	R30, R30, lo_addr(_filtered_signal+0)
MOVZ	R6, R30, R0
;MyProject.c,345 :: 		intiatlize_bufers();
JAL	_intiatlize_bufers+0
NOP	
;MyProject.c,347 :: 		for (fmax=begining;fmax<SIZE_OF_BUFFER-begining;fmax++)
; fmax start address is: 8 (R2)
ORI	R2, R0, 10
; fmax end address is: 8 (R2)
SEH	R5, R2
L_find_max_min_val_index63:
; fmax start address is: 20 (R5)
; Fis start address is: 24 (R6)
; Fis end address is: 24 (R6)
SEH	R2, R5
SLTI	R2, R2, 310
BNE	R2, R0, L__find_max_min_val_index230
NOP	
J	L_find_max_min_val_index64
NOP	
L__find_max_min_val_index230:
; Fis end address is: 24 (R6)
;MyProject.c,349 :: 		if(Fis[fmax-12]<Fis[fmax]&&Fis[fmax-11]<Fis[fmax]&&Fis[fmax-10]<Fis[fmax]&&Fis[fmax-9]<Fis[fmax]&&Fis[fmax-8]<Fis[fmax]&&Fis[fmax-7]<Fis[fmax]&&Fis[fmax-6]<Fis[fmax]&&Fis[fmax-5]<Fis[fmax]&&Fis[fmax-4]<Fis[fmax]&&Fis[fmax-3]<Fis[fmax]&&Fis[fmax-2]<=Fis[fmax] && Fis[fmax-1]<=Fis[fmax] && Fis[fmax+1]<=Fis[fmax]&& Fis[fmax+2]<=Fis[fmax])     //cheak 6 before and 4 after in the enviroment of poin we compare intger no long time
; Fis start address is: 24 (R6)
ADDIU	R2, R5, -12
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R3, 0(R2)
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R2, 0(R2)
SEH	R3, R3
SEH	R2, R2
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index231
NOP	
J	L__find_max_min_val_index143
NOP	
L__find_max_min_val_index231:
ADDIU	R2, R5, -11
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index232
NOP	
J	L__find_max_min_val_index142
NOP	
L__find_max_min_val_index232:
ADDIU	R2, R5, -10
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index233
NOP	
J	L__find_max_min_val_index141
NOP	
L__find_max_min_val_index233:
ADDIU	R2, R5, -9
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index234
NOP	
J	L__find_max_min_val_index140
NOP	
L__find_max_min_val_index234:
ADDIU	R2, R5, -8
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index235
NOP	
J	L__find_max_min_val_index139
NOP	
L__find_max_min_val_index235:
ADDIU	R2, R5, -7
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index236
NOP	
J	L__find_max_min_val_index138
NOP	
L__find_max_min_val_index236:
ADDIU	R2, R5, -6
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index237
NOP	
J	L__find_max_min_val_index137
NOP	
L__find_max_min_val_index237:
ADDIU	R2, R5, -5
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index238
NOP	
J	L__find_max_min_val_index136
NOP	
L__find_max_min_val_index238:
ADDIU	R2, R5, -4
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index239
NOP	
J	L__find_max_min_val_index135
NOP	
L__find_max_min_val_index239:
ADDIU	R2, R5, -3
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BNE	R2, R0, L__find_max_min_val_index240
NOP	
J	L__find_max_min_val_index134
NOP	
L__find_max_min_val_index240:
ADDIU	R2, R5, -2
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BEQ	R2, R0, L__find_max_min_val_index241
NOP	
J	L__find_max_min_val_index133
NOP	
L__find_max_min_val_index241:
ADDIU	R2, R5, -1
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BEQ	R2, R0, L__find_max_min_val_index242
NOP	
J	L__find_max_min_val_index132
NOP	
L__find_max_min_val_index242:
ADDIU	R2, R5, 1
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BEQ	R2, R0, L__find_max_min_val_index243
NOP	
J	L__find_max_min_val_index131
NOP	
L__find_max_min_val_index243:
ADDIU	R2, R5, 2
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BEQ	R2, R0, L__find_max_min_val_index244
NOP	
J	L__find_max_min_val_index130
NOP	
L__find_max_min_val_index244:
L__find_max_min_val_index129:
;MyProject.c,351 :: 		if (first_max)
LH	R2, 8(SP)
BNE	R2, R0, L__find_max_min_val_index246
NOP	
J	L_find_max_min_val_index69
NOP	
L__find_max_min_val_index246:
;MyProject.c,353 :: 		first_max=0;
SH	R0, 8(SP)
;MyProject.c,354 :: 		max_arr[index_max]=Fis[fmax];
LH	R2, 4(SP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R3, R2, R3
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R2, 0(R2)
SH	R2, 0(R3)
;MyProject.c,356 :: 		index_max_arr[index_max++]=fmax;
LH	R2, 4(SP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
SH	R5, 0(R2)
LH	R2, 4(SP)
ADDIU	R2, R2, 1
SH	R2, 4(SP)
;MyProject.c,357 :: 		}
L_find_max_min_val_index69:
;MyProject.c,358 :: 		if(fmax>index_max_arr[index_max-1]+2)    ///for not take same  max sample - asume not more than 3 indentical
LH	R2, 4(SP)
ADDIU	R2, R2, -1
SEH	R2, R2
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
ADDIU	R2, R2, 2
SEH	R3, R5
SEH	R2, R2
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index247
NOP	
J	L_find_max_min_val_index70
NOP	
L__find_max_min_val_index247:
;MyProject.c,360 :: 		max_arr[index_max]=Fis[fmax];
LH	R2, 4(SP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_max_arr+0)
ORI	R2, R2, lo_addr(_max_arr+0)
ADDU	R3, R2, R3
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R2, 0(R2)
SH	R2, 0(R3)
;MyProject.c,362 :: 		index_max_arr[index_max++]=fmax;
LH	R2, 4(SP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_max_arr+0)
ORI	R2, R2, lo_addr(_index_max_arr+0)
ADDU	R2, R2, R3
SH	R5, 0(R2)
LH	R2, 4(SP)
ADDIU	R2, R2, 1
SH	R2, 4(SP)
;MyProject.c,363 :: 		}
L_find_max_min_val_index70:
;MyProject.c,349 :: 		if(Fis[fmax-12]<Fis[fmax]&&Fis[fmax-11]<Fis[fmax]&&Fis[fmax-10]<Fis[fmax]&&Fis[fmax-9]<Fis[fmax]&&Fis[fmax-8]<Fis[fmax]&&Fis[fmax-7]<Fis[fmax]&&Fis[fmax-6]<Fis[fmax]&&Fis[fmax-5]<Fis[fmax]&&Fis[fmax-4]<Fis[fmax]&&Fis[fmax-3]<Fis[fmax]&&Fis[fmax-2]<=Fis[fmax] && Fis[fmax-1]<=Fis[fmax] && Fis[fmax+1]<=Fis[fmax]&& Fis[fmax+2]<=Fis[fmax])     //cheak 6 before and 4 after in the enviroment of poin we compare intger no long time
L__find_max_min_val_index143:
L__find_max_min_val_index142:
L__find_max_min_val_index141:
L__find_max_min_val_index140:
L__find_max_min_val_index139:
L__find_max_min_val_index138:
L__find_max_min_val_index137:
L__find_max_min_val_index136:
L__find_max_min_val_index135:
L__find_max_min_val_index134:
L__find_max_min_val_index133:
L__find_max_min_val_index132:
L__find_max_min_val_index131:
L__find_max_min_val_index130:
;MyProject.c,365 :: 		if(Fis[fmax-2]>=Fis[fmax] && Fis[fmax-1]>=Fis[fmax] && Fis[fmax+1]>=Fis[fmax] && Fis[fmax+2]>=Fis[fmax]&&Fis[fmax+3]>Fis[fmax]&&Fis[fmax+4]>Fis[fmax]&&Fis[fmax+5]>Fis[fmax]&&Fis[fmax+6]>Fis[fmax]&&Fis[fmax+7]>Fis[fmax]&&Fis[fmax+7]>Fis[fmax]&&Fis[fmax+8]>Fis[fmax]&&Fis[fmax+9]>Fis[fmax]&&Fis[fmax+10]>Fis[fmax]&&Fis[fmax+11]>Fis[fmax]&&Fis[fmax+12]>Fis[fmax])
ADDIU	R2, R5, -2
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R3, 0(R2)
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R2, 0(R2)
SEH	R3, R3
SEH	R2, R2
SLT	R2, R3, R2
BEQ	R2, R0, L__find_max_min_val_index248
NOP	
J	L__find_max_min_val_index158
NOP	
L__find_max_min_val_index248:
ADDIU	R2, R5, -1
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BEQ	R2, R0, L__find_max_min_val_index249
NOP	
J	L__find_max_min_val_index157
NOP	
L__find_max_min_val_index249:
ADDIU	R2, R5, 1
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BEQ	R2, R0, L__find_max_min_val_index250
NOP	
J	L__find_max_min_val_index156
NOP	
L__find_max_min_val_index250:
ADDIU	R2, R5, 2
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R3, R2
BEQ	R2, R0, L__find_max_min_val_index251
NOP	
J	L__find_max_min_val_index155
NOP	
L__find_max_min_val_index251:
ADDIU	R2, R5, 3
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index252
NOP	
J	L__find_max_min_val_index154
NOP	
L__find_max_min_val_index252:
ADDIU	R2, R5, 4
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index253
NOP	
J	L__find_max_min_val_index153
NOP	
L__find_max_min_val_index253:
ADDIU	R2, R5, 5
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index254
NOP	
J	L__find_max_min_val_index152
NOP	
L__find_max_min_val_index254:
ADDIU	R2, R5, 6
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index255
NOP	
J	L__find_max_min_val_index151
NOP	
L__find_max_min_val_index255:
ADDIU	R2, R5, 7
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index256
NOP	
J	L__find_max_min_val_index150
NOP	
L__find_max_min_val_index256:
ADDIU	R2, R5, 7
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index257
NOP	
J	L__find_max_min_val_index149
NOP	
L__find_max_min_val_index257:
ADDIU	R2, R5, 8
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index258
NOP	
J	L__find_max_min_val_index148
NOP	
L__find_max_min_val_index258:
ADDIU	R2, R5, 9
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index259
NOP	
J	L__find_max_min_val_index147
NOP	
L__find_max_min_val_index259:
ADDIU	R2, R5, 10
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index260
NOP	
J	L__find_max_min_val_index146
NOP	
L__find_max_min_val_index260:
ADDIU	R2, R5, 11
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index261
NOP	
J	L__find_max_min_val_index145
NOP	
L__find_max_min_val_index261:
ADDIU	R2, R5, 12
SEH	R2, R2
SLL	R2, R2, 1
ADDU	R3, R6, R2
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R4, 0(R2)
LH	R2, 0(R3)
SEH	R3, R2
SEH	R2, R4
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index262
NOP	
J	L__find_max_min_val_index144
NOP	
L__find_max_min_val_index262:
L__find_max_min_val_index128:
;MyProject.c,367 :: 		if(first_min)
LH	R2, 10(SP)
BNE	R2, R0, L__find_max_min_val_index264
NOP	
J	L_find_max_min_val_index74
NOP	
L__find_max_min_val_index264:
;MyProject.c,369 :: 		min_arr[index_min]=Fis[fmax];
LH	R2, 6(SP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_min_arr+0)
ORI	R2, R2, lo_addr(_min_arr+0)
ADDU	R3, R2, R3
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R2, 0(R2)
SH	R2, 0(R3)
;MyProject.c,371 :: 		index_min_arr[index_min++]=fmax;
LH	R2, 6(SP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
SH	R5, 0(R2)
LH	R2, 6(SP)
ADDIU	R2, R2, 1
SH	R2, 6(SP)
;MyProject.c,372 :: 		first_min=0;
SH	R0, 10(SP)
;MyProject.c,373 :: 		}
L_find_max_min_val_index74:
;MyProject.c,374 :: 		if(fmax>index_min_arr[index_min-1]+2)
LH	R2, 6(SP)
ADDIU	R2, R2, -1
SEH	R2, R2
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
LH	R2, 0(R2)
ADDIU	R2, R2, 2
SEH	R3, R5
SEH	R2, R2
SLT	R2, R2, R3
BNE	R2, R0, L__find_max_min_val_index265
NOP	
J	L_find_max_min_val_index75
NOP	
L__find_max_min_val_index265:
;MyProject.c,376 :: 		min_arr[index_min]=Fis[fmax];
LH	R2, 6(SP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_min_arr+0)
ORI	R2, R2, lo_addr(_min_arr+0)
ADDU	R3, R2, R3
SEH	R2, R5
SLL	R2, R2, 1
ADDU	R2, R6, R2
LH	R2, 0(R2)
SH	R2, 0(R3)
;MyProject.c,378 :: 		index_min_arr[index_min++]=fmax;
LH	R2, 6(SP)
SLL	R3, R2, 1
LUI	R2, hi_addr(_index_min_arr+0)
ORI	R2, R2, lo_addr(_index_min_arr+0)
ADDU	R2, R2, R3
SH	R5, 0(R2)
LH	R2, 6(SP)
ADDIU	R2, R2, 1
SH	R2, 6(SP)
;MyProject.c,379 :: 		}
L_find_max_min_val_index75:
;MyProject.c,365 :: 		if(Fis[fmax-2]>=Fis[fmax] && Fis[fmax-1]>=Fis[fmax] && Fis[fmax+1]>=Fis[fmax] && Fis[fmax+2]>=Fis[fmax]&&Fis[fmax+3]>Fis[fmax]&&Fis[fmax+4]>Fis[fmax]&&Fis[fmax+5]>Fis[fmax]&&Fis[fmax+6]>Fis[fmax]&&Fis[fmax+7]>Fis[fmax]&&Fis[fmax+7]>Fis[fmax]&&Fis[fmax+8]>Fis[fmax]&&Fis[fmax+9]>Fis[fmax]&&Fis[fmax+10]>Fis[fmax]&&Fis[fmax+11]>Fis[fmax]&&Fis[fmax+12]>Fis[fmax])
L__find_max_min_val_index158:
L__find_max_min_val_index157:
L__find_max_min_val_index156:
L__find_max_min_val_index155:
L__find_max_min_val_index154:
L__find_max_min_val_index153:
L__find_max_min_val_index152:
L__find_max_min_val_index151:
L__find_max_min_val_index150:
L__find_max_min_val_index149:
L__find_max_min_val_index148:
L__find_max_min_val_index147:
L__find_max_min_val_index146:
L__find_max_min_val_index145:
L__find_max_min_val_index144:
;MyProject.c,347 :: 		for (fmax=begining;fmax<SIZE_OF_BUFFER-begining;fmax++)
ADDIU	R2, R5, 1
; fmax end address is: 20 (R5)
; fmax start address is: 8 (R2)
;MyProject.c,381 :: 		}
; Fis end address is: 24 (R6)
; fmax end address is: 8 (R2)
SEH	R5, R2
J	L_find_max_min_val_index63
NOP	
L_find_max_min_val_index64:
;MyProject.c,384 :: 		}
L_end_find_max_min_val_index:
LW	RA, 0(SP)
ADDIU	SP, SP, 12
JR	RA
NOP	
; end of _find_max_min_val_index
_debug:
;MyProject.c,386 :: 		void debug(int* STR,int x)
ADDIU	SP, SP, -16
SW	RA, 0(SP)
;MyProject.c,388 :: 		if(x==1)
SW	R27, 4(SP)
SEH	R3, R26
ORI	R2, R0, 1
BEQ	R3, R2, L__debug267
NOP	
J	L_debug76
NOP	
L__debug267:
;MyProject.c,390 :: 		for ( i=0;i<7;i++)
SH	R0, Offset(_i+0)(GP)
L_debug77:
LHU	R2, Offset(_i+0)(GP)
SLTIU	R2, R2, 7
BNE	R2, R0, L__debug268
NOP	
J	L_debug78
NOP	
L__debug268:
;MyProject.c,392 :: 		IntToStr(STR [i],TEMP_PRINT);
LHU	R2, Offset(_i+0)(GP)
SLL	R2, R2, 1
ADDU	R2, R25, R2
LH	R2, 0(R2)
SH	R26, 8(SP)
SW	R25, 12(SP)
LUI	R26, hi_addr(_TEMP_PRINT+0)
ORI	R26, R26, lo_addr(_TEMP_PRINT+0)
SEH	R25, R2
JAL	_IntToStr+0
NOP	
;MyProject.c,393 :: 		strcat(PRINT1,TEMP_PRINT);
LUI	R26, hi_addr(_TEMP_PRINT+0)
ORI	R26, R26, lo_addr(_TEMP_PRINT+0)
LUI	R25, hi_addr(_PRINT1+0)
ORI	R25, R25, lo_addr(_PRINT1+0)
JAL	_strcat+0
NOP	
;MyProject.c,394 :: 		strcat(PRINT1," ");
LUI	R26, hi_addr(?lstr7_MyProject+0)
ORI	R26, R26, lo_addr(?lstr7_MyProject+0)
LUI	R25, hi_addr(_PRINT1+0)
ORI	R25, R25, lo_addr(_PRINT1+0)
JAL	_strcat+0
NOP	
LW	R25, 12(SP)
LH	R26, 8(SP)
;MyProject.c,390 :: 		for ( i=0;i<7;i++)
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
SH	R2, Offset(_i+0)(GP)
;MyProject.c,396 :: 		}
J	L_debug77
NOP	
L_debug78:
;MyProject.c,397 :: 		TFT_Write_Text(PRINT1,10,90);
SH	R26, 8(SP)
SW	R25, 12(SP)
ORI	R27, R0, 90
ORI	R26, R0, 10
LUI	R25, hi_addr(_PRINT1+0)
ORI	R25, R25, lo_addr(_PRINT1+0)
JAL	_TFT_Write_Text+0
NOP	
LW	R25, 12(SP)
LH	R26, 8(SP)
;MyProject.c,398 :: 		for ( i=7;i<14;i++)
ORI	R2, R0, 7
SH	R2, Offset(_i+0)(GP)
L_debug80:
LHU	R2, Offset(_i+0)(GP)
SLTIU	R2, R2, 14
BNE	R2, R0, L__debug269
NOP	
J	L_debug81
NOP	
L__debug269:
;MyProject.c,400 :: 		IntToStr(STR[i],TEMP_PRINT);
LHU	R2, Offset(_i+0)(GP)
SLL	R2, R2, 1
ADDU	R2, R25, R2
LH	R2, 0(R2)
SH	R26, 8(SP)
SW	R25, 12(SP)
LUI	R26, hi_addr(_TEMP_PRINT+0)
ORI	R26, R26, lo_addr(_TEMP_PRINT+0)
SEH	R25, R2
JAL	_IntToStr+0
NOP	
;MyProject.c,401 :: 		strcat(PRINT2,TEMP_PRINT);
LUI	R26, hi_addr(_TEMP_PRINT+0)
ORI	R26, R26, lo_addr(_TEMP_PRINT+0)
LUI	R25, hi_addr(_PRINT2+0)
ORI	R25, R25, lo_addr(_PRINT2+0)
JAL	_strcat+0
NOP	
;MyProject.c,402 :: 		strcat(PRINT2," ");
LUI	R26, hi_addr(?lstr8_MyProject+0)
ORI	R26, R26, lo_addr(?lstr8_MyProject+0)
LUI	R25, hi_addr(_PRINT2+0)
ORI	R25, R25, lo_addr(_PRINT2+0)
JAL	_strcat+0
NOP	
LW	R25, 12(SP)
LH	R26, 8(SP)
;MyProject.c,398 :: 		for ( i=7;i<14;i++)
LHU	R2, Offset(_i+0)(GP)
ADDIU	R2, R2, 1
SH	R2, Offset(_i+0)(GP)
;MyProject.c,403 :: 		}
J	L_debug80
NOP	
L_debug81:
;MyProject.c,404 :: 		TFT_Write_Text(PRINT2,10,140);
SH	R26, 8(SP)
SW	R25, 12(SP)
ORI	R27, R0, 140
ORI	R26, R0, 10
LUI	R25, hi_addr(_PRINT2+0)
ORI	R25, R25, lo_addr(_PRINT2+0)
JAL	_TFT_Write_Text+0
NOP	
LW	R25, 12(SP)
LH	R26, 8(SP)
;MyProject.c,405 :: 		}
L_debug76:
;MyProject.c,406 :: 		if(x==0)
SEH	R2, R26
BEQ	R2, R0, L__debug270
NOP	
J	L_debug83
NOP	
L__debug270:
;MyProject.c,408 :: 		IntToStr(*STR,TEMP_PRINT);
LH	R2, 0(R25)
SH	R26, 8(SP)
SW	R25, 12(SP)
LUI	R26, hi_addr(_TEMP_PRINT+0)
ORI	R26, R26, lo_addr(_TEMP_PRINT+0)
SEH	R25, R2
JAL	_IntToStr+0
NOP	
;MyProject.c,409 :: 		strcat(GAL,TEMP_PRINT);
LUI	R26, hi_addr(_TEMP_PRINT+0)
ORI	R26, R26, lo_addr(_TEMP_PRINT+0)
LUI	R25, hi_addr(_GAL+0)
ORI	R25, R25, lo_addr(_GAL+0)
JAL	_strcat+0
NOP	
;MyProject.c,410 :: 		strcat(GAL,"");
LUI	R26, hi_addr(?lstr9_MyProject+0)
ORI	R26, R26, lo_addr(?lstr9_MyProject+0)
LUI	R25, hi_addr(_GAL+0)
ORI	R25, R25, lo_addr(_GAL+0)
JAL	_strcat+0
NOP	
;MyProject.c,411 :: 		TFT_Write_Text(GAL,10,140);
ORI	R27, R0, 140
ORI	R26, R0, 10
LUI	R25, hi_addr(_GAL+0)
ORI	R25, R25, lo_addr(_GAL+0)
JAL	_TFT_Write_Text+0
NOP	
LW	R25, 12(SP)
LH	R26, 8(SP)
;MyProject.c,412 :: 		}
L_debug83:
;MyProject.c,413 :: 		}
L_end_debug:
LW	R27, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 16
JR	RA
NOP	
; end of _debug
_ProcessAndPresentProcessingBuffer:
;MyProject.c,417 :: 		void ProcessAndPresentProcessingBuffer()
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;MyProject.c,419 :: 		if ((processingBufferWasProcessed == 'Y')||(processingBufferWasProcessed == 'S'))
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
LBU	R3, Offset(_processingBufferWasProcessed+0)(GP)
ORI	R2, R0, 89
BNE	R3, R2, L__ProcessAndPresentProcessingBuffer273
NOP	
J	L__ProcessAndPresentProcessingBuffer161
NOP	
L__ProcessAndPresentProcessingBuffer273:
LBU	R3, Offset(_processingBufferWasProcessed+0)(GP)
ORI	R2, R0, 83
BNE	R3, R2, L__ProcessAndPresentProcessingBuffer275
NOP	
J	L__ProcessAndPresentProcessingBuffer160
NOP	
L__ProcessAndPresentProcessingBuffer275:
J	L_ProcessAndPresentProcessingBuffer86
NOP	
L__ProcessAndPresentProcessingBuffer161:
L__ProcessAndPresentProcessingBuffer160:
;MyProject.c,420 :: 		return;
J	L_end_ProcessAndPresentProcessingBuffer
NOP	
L_ProcessAndPresentProcessingBuffer86:
;MyProject.c,421 :: 		PIC_DSP_Library_Convolution(Q15_coefficients_bufferNUM,Q15_coefficients_bufferDENUM,FILTER_ORDER_DENUM+1,processingBuffer,filtered_signal,SIZE_OF_BUFFER);
LW	R28, Offset(_processingBuffer+0)(GP)
ORI	R27, R0, 8
LUI	R26, hi_addr(_Q15_coefficients_bufferDENUM+0)
ORI	R26, R26, lo_addr(_Q15_coefficients_bufferDENUM+0)
LUI	R25, hi_addr(_Q15_coefficients_bufferNUM+0)
ORI	R25, R25, lo_addr(_Q15_coefficients_bufferNUM+0)
ORI	R2, R0, 320
ADDIU	SP, SP, -8
SH	R2, 4(SP)
LUI	R2, hi_addr(_filtered_signal+0)
ORI	R2, R2, lo_addr(_filtered_signal+0)
SW	R2, 0(SP)
JAL	_PIC_DSP_Library_Convolution+0
NOP	
ADDIU	SP, SP, 8
;MyProject.c,424 :: 		find_max_min_val_index();
JAL	_find_max_min_val_index+0
NOP	
;MyProject.c,425 :: 		rising_time_bpm();
JAL	_rising_time_bpm+0
NOP	
;MyProject.c,426 :: 		UpdateScreen(processingBuffer,filtered_signal);
LUI	R26, hi_addr(_filtered_signal+0)
ORI	R26, R26, lo_addr(_filtered_signal+0)
LW	R25, Offset(_processingBuffer+0)(GP)
JAL	_UpdateScreen+0
NOP	
;MyProject.c,429 :: 		processingBufferWasProcessed = 'Y';
ORI	R2, R0, 89
SB	R2, Offset(_processingBufferWasProcessed+0)(GP)
;MyProject.c,430 :: 		}
L_end_ProcessAndPresentProcessingBuffer:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 20
JR	RA
NOP	
; end of _ProcessAndPresentProcessingBuffer
_InitTimer2_3:
;MyProject.c,432 :: 		void InitTimer2_3(){
;MyProject.c,433 :: 		T2CON                 = 0x8008;
ORI	R2, R0, 32776
SW	R2, Offset(T2CON+0)(GP)
;MyProject.c,434 :: 		T3CON                 = 0x0;
SW	R0, Offset(T3CON+0)(GP)
;MyProject.c,435 :: 		TMR2                         = 0;
SW	R0, Offset(TMR2+0)(GP)
;MyProject.c,436 :: 		TMR3                         = 0;
SW	R0, Offset(TMR3+0)(GP)
;MyProject.c,437 :: 		T3IP0_bit                 = 1;
LUI	R2, BitMask(T3IP0_bit+0)
ORI	R2, R2, BitMask(T3IP0_bit+0)
_SX	
;MyProject.c,438 :: 		T3IP1_bit                 = 1;
LUI	R2, BitMask(T3IP1_bit+0)
ORI	R2, R2, BitMask(T3IP1_bit+0)
_SX	
;MyProject.c,439 :: 		T3IP2_bit                 = 1;
LUI	R2, BitMask(T3IP2_bit+0)
ORI	R2, R2, BitMask(T3IP2_bit+0)
_SX	
;MyProject.c,440 :: 		T3IF_bit                 = 0;
LUI	R2, BitMask(T3IF_bit+0)
ORI	R2, R2, BitMask(T3IF_bit+0)
_SX	
;MyProject.c,441 :: 		T3IE_bit                 = 1;
LUI	R2, BitMask(T3IE_bit+0)
ORI	R2, R2, BitMask(T3IE_bit+0)
_SX	
;MyProject.c,442 :: 		PR2                         = 33920;
ORI	R2, R0, 33920
SW	R2, Offset(PR2+0)(GP)
;MyProject.c,443 :: 		PR3                         = 30;
ORI	R2, R0, 30
SW	R2, Offset(PR3+0)(GP)
;MyProject.c,444 :: 		}
L_end_InitTimer2_3:
JR	RA
NOP	
; end of _InitTimer2_3
_Timer2_3Interrupt:
;MyProject.c,446 :: 		void Timer2_3Interrupt() iv IVT_TIMER_3 ilevel 7 ics ICS_SRS{
RDPGPR	SP, SP
ADDIU	SP, SP, -12
MFC0	R30, 12, 2
SW	R30, 8(SP)
MFC0	R30, 14, 0
SW	R30, 4(SP)
MFC0	R30, 12, 0
SW	R30, 0(SP)
INS	R30, R0, 1, 15
ORI	R30, R0, 7168
MTC0	R30, 12, 0
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;MyProject.c,447 :: 		T3IF_bit                 = 0;
LUI	R2, BitMask(T3IF_bit+0)
ORI	R2, R2, BitMask(T3IF_bit+0)
_SX	
;MyProject.c,448 :: 		AddValueToAcquisitionBuffer();
JAL	_AddValueToAcquisitionBuffer+0
NOP	
;MyProject.c,449 :: 		}
L_end_Timer2_3Interrupt:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
DI	
EHB	
LW	R30, 8(SP)
MTC0	R30, 12, 2
LW	R30, 4(SP)
MTC0	R30, 14, 0
LW	R30, 0(SP)
MTC0	R30, 12, 0
ADDIU	SP, SP, 12
WRPGPR	SP, SP
ERET	
; end of _Timer2_3Interrupt
_main:
;MyProject.c,452 :: 		void main()
;MyProject.c,454 :: 		PrepareTFT();
JAL	_PrepareTFT+0
NOP	
;MyProject.c,455 :: 		PrepareADCChannel0();
JAL	_PrepareADCChannel0+0
NOP	
;MyProject.c,456 :: 		TRISA = 0;     // Set PORTA as output
SW	R0, Offset(TRISA+0)(GP)
;MyProject.c,457 :: 		InitTimer2_3();
JAL	_InitTimer2_3+0
NOP	
;MyProject.c,458 :: 		PrepareQ15coefBuffer(IIRFilterCoefficientsNUM, FILTER_ORDER_NUM ,Q15_coefficients_bufferNUM);
LUI	R27, hi_addr(_Q15_coefficients_bufferNUM+0)
ORI	R27, R27, lo_addr(_Q15_coefficients_bufferNUM+0)
ORI	R26, R0, 7
LUI	R25, hi_addr(_IIRFilterCoefficientsNUM+0)
ORI	R25, R25, lo_addr(_IIRFilterCoefficientsNUM+0)
JAL	_PrepareQ15coefBuffer+0
NOP	
;MyProject.c,459 :: 		PrepareQ15coefBuffer(IIRFilterCoefficientsDENUM, FILTER_ORDER_DENUM,Q15_coefficients_bufferDENUM);
LUI	R27, hi_addr(_Q15_coefficients_bufferDENUM+0)
ORI	R27, R27, lo_addr(_Q15_coefficients_bufferDENUM+0)
ORI	R26, R0, 7
LUI	R25, hi_addr(_IIRFilterCoefficientsDENUM+0)
ORI	R25, R25, lo_addr(_IIRFilterCoefficientsDENUM+0)
JAL	_PrepareQ15coefBuffer+0
NOP	
;MyProject.c,460 :: 		EnableInterrupts();
EI	R30
;MyProject.c,461 :: 		while(1)
L_main87:
;MyProject.c,463 :: 		ProcessAndPresentProcessingBuffer();
JAL	_ProcessAndPresentProcessingBuffer+0
NOP	
;MyProject.c,464 :: 		}
J	L_main87
NOP	
;MyProject.c,465 :: 		}
L_end_main:
L__main_end_loop:
J	L__main_end_loop
NOP	
; end of _main
