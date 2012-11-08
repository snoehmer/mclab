/**
	this interface provides functions for routing of packages in a simple WSN
**/

includes MessageTypes;

interface RoutingNetwork
{
	command result_t issueBroadcast(uint8_t basestation_id);
	command result_t forwardBroadcast(NetworkMsg *nmsg);
	
	command result_t sendDataMsg(uint8_t dest, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4);
	command result_t forwardDataMsg(NetworkMsg *nmsg);
	
	command bool isKnownBasestation(uint8_t basestation_id);
	
	event result_t receivedDataMsg(uint8_t src, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4);
}
