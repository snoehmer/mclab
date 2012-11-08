/*
	provides interfaces to receive messages
*/

#define RECEIVE_BUFFER_SIZE 10

includes MessageTypes;

module RoutingM
{
	provides
	{
		interface StdControl;
		interface RoutingNetwork;
	}
	uses
	{
		interface MessageSender;
		interface MessageReceiver;
	}
}

implementation
{
	command result_t StdControl.init()
	{
		return SUCCESS;
	}
	
	command result_t StdControl.start()
	{
		return SUCCESS;
	}
	
	command result_t StdControl.stop()
	{		
		return SUCCESS;
	}
	
	
	command result_t RoutingNetwork.issueBroadcast(uint8_t basestation_id)
	{
		return SUCCESS;
	}
	
	command result_t RoutingNetwork.forwardBroadcast(NetworkMsg *nmsg)
	{
		return SUCCESS;
	}
	
	command result_t RoutingNetwork.sendDataMsg(uint8_t dest, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		return SUCCESS;
	}
	
	command result_t RoutingNetwork.forwardDataMsg(NetworkMsg *nmsg)
	{
		return SUCCESS;
	}
	
	command bool RoutingNetwork.isKnownBasestation(uint8_t basestation_id)
	{
		return SUCCESS;
	}
	
	
	event result_t MessageReceiver.receivedMessage(TOS_Msg new_msg)
	{
		return SUCCESS;
	}
}

