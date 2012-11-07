interface Beeper
{
	command result_t doBeep(uint16_t on, uint16_t off, uint8_t repetitions);
	command result_t cancel();
}
