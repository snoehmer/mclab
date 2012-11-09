/*
	provides interfaces to receive messages
*/

#define MAX_RT_ENTRIES      3


includes MessageTypes;
includes Routingtable;

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
	uint8_t rt_idx;
	uint16_t sequence_number;	// sequence number counter for broadcast issueing
	RoutingTableEntry routingtable[MAX_RT_ENTRIES];
	
	command result_t StdControl.init()
	{
		uint8_t count1 = 0;
		uint8_t count2 = 0;
		for(count1 = 0; count1 < MAX_RT_ENTRIES; count1++)
		{
			routingtable[count1].basestation_id = 0;
			routingtable[count1].mote_id = 0;
			routingtable[count1].sequence_number = 0;
			routingtable[count1].hop_count = 0;
			routingtable[count1].aging = FALSE;
			routingtable[count1].valid = FALSE;
		}
		rt_idx = 0;
		sequence_number = 0;
		
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
		TOS_Msg new_broadcast;
		
		dbg(DBG_USR1, "RoutingM: Broadcast issued with basestation_id = \n", basestation_id);
		
		new_broadcast = call PacketHandler.assembleBroadcastMessage(basestation_id, sequence_number++, 0);
		
		return call MessageSender.sendMessage(new_broadcast, TOS_BCAST_ADDR);
	}
	
	command result_t RoutingNetwork.updateRoutingtable(TOS_Msg *nmsg)
	{
		uint8_t idx = call RoutingNetwork.isKnownBasestation(call PacketHandler.getBasestationID(nmsg));
		uint8_t seq_no = call PacketHandler.getSequenceNumber(nmsg);
		
		if( seq_no > routingtable[idx].sequence_number )
		{
			uint16_t hop_count = call PacketHandler.getHopcount(nmsg);
			
			if(idx < MAX_RT_ENTRIES)
			{
				if(hop_count < routingtable[idx].hop_count || routingtable[idx].valid == FALSE || routingtable[idx].aging == TRUE)
				{
					// update entry
					routingtable[idx].mote_id = call PacketHandler.getSrc(nmsg);
					routingtable[idx].sequence_number = seq_no;
					routingtable[idx].hop_count = hop_count;
					routingtable[idx].aging = FALSE;
					routingtable[idx].valid = TRUE;
					dbg(DBG_USR1, "RoutingM: Updating Routingtable entry for basestation_id = \n", routingtable[idx].basestation_id);
				}
				else dbg(DBG_USR1, "RoutingM: No update to routingtable due to higher hop_count to basestation_id = \n", routingtable[idx].basestation_id);
			}
			else
			{			
				// add new entry to RT
				routingtable[rt_idx].basestation_id = call PacketHandler.getBasestationID(nmsg);
				routingtable[rt_idx].mote_id = call PacketHandler.getSrc(nmsg);
				routingtable[rt_idx].sequence_number = seq_no;
				routingtable[rt_idx].hop_count = hop_count;
				routingtable[rt_idx].aging = FALSE;
				routingtable[rt_idx].valid = TRUE;
			
				dbg(DBG_USR1, "RoutingM: New Routingtable entry for basestation_id = \n", routingtable[rt_idx-1].basestation_id);
				
				if(rt_idx >= MAX_RT_ENTRIES)
					rt_idx = 0;
			}
			return SUCCESS;
		}
		
		return FAIL;
	}
	
	command result_t RoutingNetwork.forwardBroadcast(TOS_Msg *nmsg)
	{
		uint16_t old_hop_count = call PacketHandler.getHopcount(nmsg);
		dbg(DBG_USR1, "RoutingM: Broadcastmessage forwarded.\n");	
		call PacketHandler.setHopcount(nmsg, ++old_hop_count);
		call PacketHandler.setSrc(nmsg, TOS_LOCAL_ADDRESS);
		return call MessageSender.sendMessage(*nmsg, TOS_BCAST_ADDR);
	}
	
	command result_t RoutingNetwork.sendDataMsg(uint8_t dest, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		TOS_Msg new_data_msg = call PacketHandler.assembleDataMessage(dest, data1, data2, data3, data4);
		uint8_t idx = call RoutingNetwork.isKnownBasestation(dest);
		
		
		if(idx < MAX_RT_ENTRIES)
		{
			dbg(DBG_USR1, "RoutingM: Sending data message to dest = \n", dest);
			return call MessageSender.sendMessage(new_data_msg, routingtable[idx].mote_id);
		}
		else 
		{
			dbg(DBG_USR1, "RoutingM: Sending data message failed due to unsufficent destination = \n", dest);
			return FAIL;
		}
	}
	
	command result_t RoutingNetwork.forwardDataMsg(TOS_Msg *nmsg)
	{
		uint16_t dest = call PacketHandler.getBasestationID(nmsg); 
		uint8_t idx = call RoutingNetwork.isKnownBasestation(dest);
		if(idx < MAX_RT_ENTRIES)
		{
			dbg(DBG_USR1, "RoutingM: Forward data message to MoteID = \n", routingtable[idx].mote_id);
			return call MessageSender.sendMessage(*nmsg, routingtable[idx].mote_id);
		}
		else
		{
			dbg(DBG_USR1, "RoutingM: Forward data message failed due to unsufficent destination = \n", dest);
			return FAIL;
		}
	}
	
	command uint8_t RoutingNetwork.isKnownBasestation(uint8_t basestation_id)
	{	
		uint8_t count1 = 0;
		for(count1 = 0; count1 < MAX_RT_ENTRIES; count1++)
			if(routingtable[count1].basestation_id == basestation_id)
				return count1;
		return MAX_RT_ENTRIES+1;
	}
	
	
	event result_t MessageReceiver.receivedMessage(TOS_Msg new_msg)
	{
		dbg(DBG_USR1, "RoutingM: Received a new Message, event MessageReceiver.receivedMessage triggered.\n");

		if(call PacketHandler.getMsgType(&new_msg) == MSG_TYPE_BCAST)
		{
			// received a broadcast, process it
			if(call RoutingNetwork.updateRoutingtable(&new_msg))
				return call RoutingNetwork.forwardBroadcast(&new_msg);
			else 
			{
				dbg(DBG_USR1, "RoutingM: Discarded Message due to old sequence number\n");
				return SUCCESS;
			}
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

