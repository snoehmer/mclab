/*
	provides interfaces to receive messages
*/

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
		result_t res;
		NetworkMsg *nmsg = (NetworkMsg*) new_msg.data;
		BroadcastMsg *bmsg;
		SimpleDataMsg *dmsg;
		
		// check type of received message
		if(nmsg->msg_type == MSG_TYPE_BCAST)
		{
			bmsg = &(nmsg->bmsg);
			
			// received message is a broadcast, update routing table
			// TODO
			
		}
		else if(nmsg->msg_type == MSG_TYPE_DATA)
		{
			dmsg = &(nmsg->dmsg);
			
			// received a data packet, check if I am the destination
			if(new_msg.addr == TOS_LOCAL_ADDRESS)
			{
				// I am the destination, forward to application
				signal RoutingNetwork.receivedDataMsg(dmsg->src_addr, dmsg->data1, dmsg->data2, dmsg->data3, dmsg->data4);
				
				return SUCCESS;
			}
			// now check if we know the destination (base station)
			//TODO: else if(
			
		}
		else  // unknown message received
		{
			dbg(DBG_USR1, "RoutingM: received unknown message type, ignoring!\n");
			return SUCCESS;
		}
		
		return SUCCESS;
	}
}

