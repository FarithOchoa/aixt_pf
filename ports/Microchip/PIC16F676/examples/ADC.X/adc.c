// This C code was automatically generated by Aixt Project
// Device = PIC16F676
// Board = Nothing
// Backend = c

#include <xc.h>
#include <stdio.h>
#define _XTAL_FREQ 4000000
#define true   1
#define false  0
#pragma config FOSC = INTRCIO
#pragma config WDTE = OFF
#pragma config PWRTE = OFF
#pragma config MCLRE = OFF
#pragma config BOREN = OFF
#pragma config CP = OFF
#pragma config CPD = OFF
#define TRISa		TRISA	// port setup name equivalents
#define TRISc		TRISC
#define PORTa		PORTA	// port in name equivalents
#define PORTc		PORTC
#define a0_s    TRISAbits.TRISA0    // pin configuration pits
#define a1_s    TRISAbits.TRISA1
#define a2_s    TRISAbits.TRISA2
#define a3_s    TRISAbits.TRISA3
#define a4_s    TRISAbits.TRISA4
#define a5_s    TRISAbits.TRISA5
#define c0_s    TRISCbits.TRISC0    // pin configuration pits
#define c1_s    TRISCbits.TRISC1
#define c2_s    TRISCbits.TRISC2
#define c3_s    TRISCbits.TRISC3
#define c4_s    TRISCbits.TRISC4
#define c5_s    TRISCbits.TRISC5
#define a0      PORTAbits.RA0       // pin input and output pits
#define a1      PORTAbits.RA1
#define a2      PORTAbits.RA2
#define a3      PORTAbits.RA3
#define a4      PORTAbits.RA4
#define a5      PORTAbits.RA5
#define c0      PORTCbits.RC0
#define c1      PORTCbits.RC1
#define c2      PORTCbits.RC2
#define c3      PORTCbits.RC3
#define c4      PORTCbits.RC4
#define c5      PORTCbits.RC5
#define adc__setup()  ANSEL = 0b00000010;  ADCON0 = 0b10000000;  ADCON1 = 0b00110000;  ADCON0bits.ADON = 1
#define pin__output  0   // pin direction
#define pin__input   1
#define pin__digital()  ANSEL = 0
#define pin__high(PIN_NAME)  PIN_NAME = 1
#define pin__low(PIN_NAME)   PIN_NAME = 0
#define pin__read(PIN_NAME)  PIN_NAME
#define pin__setup(PIN_NAME, PIN_MODE)   PIN_NAME ## _s = PIN_MODE
#define pin__write(PIN_NAME,VAL) PIN_NAME = VAL

void main__init();

void adc__init();

unsigned int adc__read(unsigned char channel);

void pin__init();

void main__init() {
	adc__init();
	pin__init();
	
}

void adc__init() {
}

unsigned int adc__read(unsigned char channel) {
	ADCON0bits.CHS = channel;
	ADCON0bits.GO_DONE = 1;
	while(ADCON0bits.GO_DONE == 1) {
	}
	return ((ADRESH << 8) | ADRESL);
}

void pin__init() {
}

void main(void) {
	main__init();
	unsigned int x = 0;
	pin__setup(c0, pin__output);
	pin__setup(c1, pin__output);
	pin__setup(c2, pin__output);
	pin__setup(c3, pin__output);
	pin__setup(c4, pin__output);
	pin__setup(c5, pin__output);
	pin__write(c0, 0);
	pin__write(c1, 0);
	pin__write(c2, 0);
	pin__write(c3, 0);
	pin__write(c4, 0);
	pin__write(c5, 0);
	adc__setup();
	while(true) {
		x = adc__read(2);
		if(x >= 1020) {
			pin__high(c0);
			pin__high(c1);
			pin__high(c2);
			pin__high(c3);
			pin__high(c4);
			pin__high(c5);
		}
		else if(x >= 820) {
			pin__high(c0);
			pin__high(c1);
			pin__high(c2);
			pin__high(c3);
			pin__high(c4);
			pin__low(c5);
		}
		else if(x >= 620) {
			pin__high(c0);
			pin__high(c1);
			pin__high(c2);
			pin__high(c3);
			pin__low(c4);
			pin__low(c5);
		}
		else if(x >= 420) {
			pin__high(c0);
			pin__high(c1);
			pin__high(c2);
			pin__low(c3);
			pin__low(c4);
			pin__low(c5);
		}
		else if(x >= 220) {
			pin__high(c0);
			pin__high(c1);
			pin__low(c2);
			pin__low(c3);
			pin__low(c4);
			pin__low(c5);
		}
		else if(x >= 120) {
			pin__high(c0);
			pin__low(c1);
			pin__low(c2);
			pin__low(c3);
			pin__low(c4);
			pin__low(c5);
		}
		else {
			pin__low(c0);
			pin__low(c1);
			pin__low(c2);
			pin__low(c3);
			pin__low(c4);
			pin__low(c5);
		}
	}
}
