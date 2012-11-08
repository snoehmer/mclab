/*
	provides interfaces to receive messages
*/

#define BS_ID_INDEX         0
#define HOP_COUNT_INDEX     1 
#define MOTE_ID_INDEX       2
#define MAX_RT_ENTRIES      3


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
		interface PacketHandler;
	}
}

implementation
{
	uint16_t routingtable[MAX_RT_ENTRIES][3];
	uint16_t sequence_number;
	uint8_t rt_idx;
	
	command result_t StdControl.init()
	{
		uint8_t count1 = 0;
		uint8_t count2 = 0;
		for(count1 = 0; count1 < MAX_RT_ENTRIES; count1++)
			for(count2 = 0; count2 < 3; count2++)
				routingtable[count1][count2] = 0;
		sequence_number = 0;
		rt_idx = 0;
		
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
		TOS_Msg new_broadcast = call PacketHandler.assembleBroadcastMessage(basestation_id, sequence_number++, 0);
		return call MessageSender.sendMessage(new_broadcast, TOS_BCAST_ADDR);
	}
	
	command result_t RoutingNetwork.forwardBroadcast(TOS_Msg *nmsg)
	{
		if( call PacketHandler.getSequenceNumber(nmsg) > sequence_number )
		{
			uint8_t idx = call RoutingNetwork.isKnownBasestation(call PacketHandler.getBasestationID(nmsg));
			uint16_t old_hop_count = 0;
			
			if(idx < MAX_RT_ENTRIES)
			{
				uint16_t hop_count = call PacketHandler.getHopcount(nmsg);
				if(hop_count < routingtable[idx][HOP_COUNT_INDEX])
				{
					// update entry
					routingtable[idx][HOP_COUNT_INDEX] = hop_count;
					routingtable[idx][MOTE_ID_INDEX] = call PacketHandler.getSrc(nmsg);
				}
			}
			else
			{
				// add new entry to RT
				routingtable[rt_idx][BS_ID_INDEX] =  call PacketHandler.getBasestationID(nmsg);
				routingtable[rt_idx][HOP_COUNT_INDEX] =  call PacketHandler.getHopcount(nmsg);
				routingtable[rt_idx++][MOTE_ID_INDEX] =  call PacketHandler.getSrc(nmsg);
			
				if(rt_idx >= MAX_RT_ENTRIES)
					rt_idx = 0;
			}
				
			old_hop_count = call PacketHandler.getHopcount(nmsg);
			call PacketHandler.setHopcount(nmsg, ++old_hop_count);
			call PacketHandler.setSrc(nmsg, TOS_LOCAL_ADDRESS);
			return call MessageSender.sendMessage(*nmsg, TOS_BCAST_ADDR);
		}
		return FAIL;
	}
	
	command result_t RoutingNetwork.sendDataMsg(uint8_t dest, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		TOS_Msg new_data_msg = call PacketHandler.assembleDataMessage(dest, data1, data2, data3, data4);
		uint8_t idx = call RoutingNetwork.isKnownBasestation(dest);
		if(idx < MAX_RT_ENTRIES)
			return call MessageSender.sendMessage(new_data_msg, routingtable[idx][MOTE_ID_INDEX]);
		else return FAIL;
	}
	
	command result_t RoutingNetwork.forwardDataMsg(TOS_Msg *nmsg)
	{
		uint16_t dest = call PacketHandler.getBasestationID(nmsg); 
		uint8_t idx = call RoutingNetwork.isKnownBasestation(dest);
		if(idx < MAX_RT_ENTRIES)
			return call MessageSender.sendMessage(*nmsg, routingtable[idx][MOTE_ID_INDEX]);
		else return FAIL;
	}
	
	command uint8_t RoutingNetwork.isKnownBasestation(uint8_t basestation_id)
	{	
		uint8_t count1 = 0;
		for(count1 = 0; count1 < MAX_RT_ENTRIES; count1++)
			if(routingtable[count1][0] == basestation_id)
				return count1;
		return MAX_RT_ENTRIES+1;
	}
	
	
	event result_t MessageReceiver.receivedMessage(TOS_Msg new_msg)
	{
		if(call PacketHandler.getMsgType(&new_msg) == MSG_TYPE_BCAST)
		{
			// received a broadcast, process it
			return call RoutingNetwork.forwardBroadcast(&new_msg);
		}
		else if(call PacketHandler.getMsgType(&new_msg) == MSG_TYPE_DATA)
		{
			// received a data message, check if I am the destination
			if(new_msg.addr == TOS_LOCAL_ADDRESS)
			{
				signal RoutingNetwork.receivedDataMsg(call PacketHandler.getSrc(&new_msg), 
													  call PacketHandler.getData1(&new_msg),
													  call PacketHandler.getData2(&new_msg),
													  call PacketHandler.getData3(&new_msg),
													  call PacketHandler.getData4(&new_msg));
				
				return SUCCESS;
			}
			else  // I am not the destination, process the data message
			{
				return call RoutingNetwork.forwardDataMsg(&new_msg);
			}
		}
		else  // unknown message received, ignore
		{
			dbg(DBG_USR1, "RoutingM: received unknown message type, ignoring!\n");
			return SUCCESS;
		}
	}
}

