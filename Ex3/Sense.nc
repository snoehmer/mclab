/*
	the interface used for offering data from the measurements
*/

interface Sense
{
	command uint16_t getMean();
	command void resetMean();
}
