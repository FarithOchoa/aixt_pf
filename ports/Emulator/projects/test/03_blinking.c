// This C code was automatically generated by Aixt Project
// Device = Emulator
// Board = Software Emulator
// Backend = c



#include <stdbool.h>
#include "/home/aixt-project/ports/Emulator/api/builtin.c"
#include "/home/aixt-project/ports/Emulator/api/time/sleep_us.c"
#include "/home/aixt-project/ports/Emulator/api/machine/pin.c"
#include "/home/aixt-project/ports/Emulator/api/time/sleep_us.c"
#include "/home/aixt-project/ports/Emulator/api/machine/pin.c"
#include "/home/aixt-project/ports/Emulator/api/time/sleep_us.c"


int main() {
	pin_update();
	sleep_us(500000);
	for(int i=0; i<5; i++) {
		pin_high(a);
		sleep_us(500000);
		pin_low(a);
		sleep_us(500000);
	}
	return 0;
}