/**
	this interface provides functions for routing of packages in a simple WSN
**/

includes MessageTypes;
includes AM;

interface RoutingNetwork
{
	command result_t issueBroadcast(uint16_t basestation_id, uint16_t sequence_number);
	command result_t forwardBroadcast(TOS_Msg *nmsg);
	command result_t updateRoutingtable(TOS_Msg *nmsg);
	
	command result_t sendDataMsg(uint16_t dest, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4);
	command result_t forwardDataMsg(TOS_Msg *nmsg);
	
	command result_t sendCommandMsg(uint16_t destination_id, uint8_t command_id, uint16_t argument);
	command result_t forwardCommandMsg(TOS_Msg *nmsg);
	
	command bool isKnownBasestation(uint16_t basestation_id);
	
	event result_t receivedDataMsg(uint16_t src, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4);
	event result_t receivedCommandMsg(uint16_t sender_id, uint8_t command_id, uint16_t argument);
}
