/*
	the interface used for offering data from the measurements
*/

interface InternalCommunication
{
	command result_t triggerCommand(uint16_t command_id, uint16_t argument);
}
