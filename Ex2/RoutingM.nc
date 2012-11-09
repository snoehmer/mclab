/*
	provides interfaces to receive messages
*/

includes MessageTypes;
includes Routingtable;
includes GlobalConfig;

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
		interface StdControl as SenderControl;
		
		interface MessageReceiver;
		interface StdControl as ReceiverControl;
		
		interface PacketHandler;
		
		interface Timer as AgingTimer;
	}
}

implementation
{
	RoutingTableEntry routingtable[MAX_RT_ENTRIES];
	
	command result_t StdControl.init()
	{
		uint8_t i;
		
		for(i = 0; i < MAX_RT_ENTRIES; i++)
		{
			routingtable[i].basestation_id = 0;
			routingtable[i].mote_id = 0;
			routingtable[i].sequence_number = 0;
			routingtable[i].hop_count = 0;
			routingtable[i].aging = FALSE;
			routingtable[i].valid = FALSE;
		}
		
		return rcombine(call SenderControl.init(), call ReceiverControl.init());
	}
	
	command result_t StdControl.start()
	{
		return rcombine3(call SenderControl.start(), call ReceiverControl.start(), call AgingTimer.start(TIMER_REPEAT, ROUTING_AGING_TIMEOUT));
	}
	
	command result_t StdControl.stop()
	{		
		return rcombine3(call SenderControl.stop(), call ReceiverControl.stop(), call AgingTimer.stop());
	}
	
	
	uint8_t getKnownBasestation(uint16_t basestation_id)
	{	
		uint8_t i;
		
		for(i = 0; i < MAX_RT_ENTRIES; i++)
		{
			if(routingtable[i].valid && routingtable[i].basestation_id == basestation_id)
				break;
		}
		
		return i;  // if no entry was found, i = MAX_RT_ENTRIES
	}
	
	uint8_t getFreeRTSlot()
	{
		uint8_t i;
		
		for(i = 0; i < MAX_RT_ENTRIES; i++)
		{
			if(!routingtable[i].valid)  // free slot found
				break;
		}
		
		return i;  // if no free slot is found, i = MAX_RT_ENTRIES
	}
	
	command result_t RoutingNetwork.issueBroadcast(uint16_t basestation_id, uint16_t sequence_number)
	{
		TOS_Msg new_broadcast;
		
		dbg(DBG_USR2, "RoutingM: Broadcast issued with basestation_id = %d\n", basestation_id);
		
		new_broadcast = call PacketHandler.assembleBroadcastMessage(basestation_id, sequence_number, 0);
		
		return call MessageSender.sendMessage(new_broadcast, TOS_BCAST_ADDR);
	}
	
	// tries to update the routing table, returns SUCCESS if this broadcast package should be forwarded (new route)
	command result_t RoutingNetwork.updateRoutingtable(TOS_Msg *nmsg)
	{
		uint16_t bs_id = call PacketHandler.getBasestationID(nmsg);
		uint8_t idx = getKnownBasestation(bs_id);
		uint16_t seq_no = call PacketHandler.getSequenceNumber(nmsg);
		uint16_t hop_count = call PacketHandler.getHopcount(nmsg);
		uint16_t parent_addr = call PacketHandler.getSrc(nmsg);
		
		dbg(DBG_USR2, "RoutingM: got broadcast from bs %d with seq_nr %d, checking...\n", bs_id, seq_no);
		
		// first, check if this bs is me (some node sent back my broadcast)
		if(bs_id == TOS_LOCAL_ADDRESS)
		{
			dbg(DBG_USR1, "RoutingM: received my own broadcast, ignoring\n");
			return FAIL;
		}
		
		if(idx < MAX_RT_ENTRIES)  // check if entry for this BS already exists
		{
			//entry exists, check if newer seq_nr
			if(seq_no > routingtable[idx].sequence_number)
			{
				// newer package, update routing table
				dbg(DBG_USR2, "RoutingM: broadcast from known bs with newer seq_nr, update!\n");
				
				routingtable[idx].mote_id = parent_addr;
				routingtable[idx].sequence_number = seq_no;
				routingtable[idx].hop_count = hop_count;
				routingtable[idx].aging = FALSE;
				
				return SUCCESS;
			}
			else if(seq_no == routingtable[idx].sequence_number)  // entry with same seq_nr exists, check hop_count
			{
				if(hop_count < routingtable[idx].hop_count)  // better route found
				{
					// better route, update routing table
					dbg(DBG_USR2, "RoutingM: broadcast from known bs with smaller hop_count, update!\n");
					
					routingtable[idx].mote_id = parent_addr;
					routingtable[idx].hop_count = hop_count;
					routingtable[idx].aging = FALSE;
					
					return SUCCESS;
				}
				else if(hop_count == routingtable[idx].hop_count)  // same quality route found, possibly not the same route!
				{
					if(parent_addr == routingtable[idx].mote_id)  // exact same route, still alive -> clear aging flag
					{
						dbg(DBG_USR2, "RoutingM: broadcast from known bs over same route, clearing aging flag\n");
						
						routingtable[idx].aging = FALSE;
						
						return SUCCESS;
					}
					else  // other route found, not needed, ignore and drop broadcast package
					{
						dbg(DBG_USR2, "RoutingM: broadcast from known bs over other route with equal hop_count, ignoring\n");
						
						return FAIL;
					}
				}
				else  // worse quality route found, ignore and drop broadcast package
				{
					dbg(DBG_USR2, "RoutingM: broadcast from known bs with higher hop_count, ignoring\n");
					
					return FAIL;
				}
			}
			else  // old broadcast message with smaller seq_nr, ignore and drop
			{
				dbg(DBG_USR2, "RoutingM: old broadcast from known bs with older seq_nr, ignoring\n");
				
				return FAIL;
			}
		}
		else  // no entry exists for this BS
		{
			// add the BS to the routing table
			dbg(DBG_USR2, "RoutingM: broadcast from new bs, adding! (bs %d, route %d, seq_nr %d, hop_count %d\n", bs_id, parent_addr, seq_no, hop_count);
			
			idx = getFreeRTSlot();
			
			if(idx < MAX_RT_ENTRIES)  // free slot found
			{
				routingtable[idx].valid = TRUE;
				routingtable[idx].basestation_id = bs_id;
				routingtable[idx].mote_id = parent_addr;
				routingtable[idx].sequence_number = seq_no;
				routingtable[idx].hop_count = hop_count;
				routingtable[idx].aging = FALSE;
				
				return SUCCESS;
			}
			else  // no free slot found! ignore
			{
				dbg(DBG_USR2, "RoutingM: no free slot in routing table found! ignoring!\n");
				return SUCCESS;
			}
		}
	}
	
	command result_t RoutingNetwork.forwardBroadcast(TOS_Msg *nmsg)
	{
		uint16_t old_hop_count = call PacketHandler.getHopcount(nmsg);
		dbg(DBG_USR1, "RoutingM: forwarding broadcast message\n");	
		call PacketHandler.setHopcount(nmsg, ++old_hop_count);
		call PacketHandler.setSrc(nmsg, TOS_LOCAL_ADDRESS);
		return call MessageSender.sendMessage(*nmsg, TOS_BCAST_ADDR);
	}
	
	command result_t RoutingNetwork.sendDataMsg(uint16_t dest, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		TOS_Msg new_data_msg = call PacketHandler.assembleDataMessage(dest, data1, data2, data3, data4);
		uint8_t idx = getKnownBasestation(dest);
		
		
		if(idx < MAX_RT_ENTRIES)
		{
			dbg(DBG_USR1, "RoutingM: Sending data message to dest %d\n", dest);
			return call MessageSender.sendMessage(new_data_msg, routingtable[idx].mote_id);
		}
		else 
		{
			dbg(DBG_USR1, "RoutingM: unknown destination base station %d, cannot send package\n", dest);
			return SUCCESS;
		}
	}
	
	command result_t RoutingNetwork.forwardDataMsg(TOS_Msg *nmsg)
	{
		uint16_t dest = call PacketHandler.getBasestationID(nmsg); 
		uint8_t idx = getKnownBasestation(dest);
		
		if(idx < MAX_RT_ENTRIES)
		{
			dbg(DBG_USR1, "RoutingM: Forward data message to MoteID %d (dest %d)\n", routingtable[idx].mote_id, dest);
			return call MessageSender.sendMessage(*nmsg, routingtable[idx].mote_id);
		}
		else
		{
			dbg(DBG_USR1, "RoutingM: unknown destination base station %d, not forwarding package\n", dest);
			return SUCCESS;
		}
	}
	
	command bool RoutingNetwork.isKnownBasestation(uint16_t basestation_id)
	{	
		if(getKnownBasestation(basestation_id) < MAX_RT_ENTRIES)
			return TRUE;
		else
			return FALSE;
	}
	
	
	event result_t MessageReceiver.receivedMessage(TOS_Msg new_msg)
	{
		dbg(DBG_USR1, "RoutingM: Received a new Message, event MessageReceiver.receivedMessage triggered.\n");

		if(call PacketHandler.getMsgType(&new_msg) == MSG_TYPE_BCAST)
		{
			// received a broadcast, process it
			if(call RoutingNetwork.updateRoutingtable(&new_msg))
			{
				dbg(DBG_USR1, "RoutingM: updated routing table, forwarding broadcast\n");
				
				return call RoutingNetwork.forwardBroadcast(&new_msg);
			}
			else 
			{
				dbg(DBG_USR1, "RoutingM: routing table not updated, dropping broadcast\n");
				
				return SUCCESS;
			}
		}
		else if(call PacketHandler.getMsgType(&new_msg) == MSG_TYPE_DATA)
		{
			// received a data message, check if I am the destination
			if(new_msg.addr == TOS_LOCAL_ADDRESS)
			{
				dbg(DBG_USR1, "RoutingM: received data package for me, signaling event\n");
				
				signal RoutingNetwork.receivedDataMsg(call PacketHandler.getSrc(&new_msg), 
													  call PacketHandler.getData1(&new_msg),
													  call PacketHandler.getData2(&new_msg),
													  call PacketHandler.getData3(&new_msg),
													  call PacketHandler.getData4(&new_msg));
				
				return SUCCESS;
			}
			else  // I am not the destination, process the data message
			{
				dbg(DBG_USR1, "RoutingM: received data package not for me, trying to forward\n");
				
				return call RoutingNetwork.forwardDataMsg(&new_msg);
			}
		}
		else  // unknown message received, ignore
		{
			dbg(DBG_USR1, "RoutingM: received unknown message type, ignoring!\n");
			return SUCCESS;
		}
	}
	
	event result_t AgingTimer.fired()
	{
		uint8_t i;
		dbg(DBG_USR1, "RoutingM: aging timer fired, searching for old routing table entries\n");
		
		for(i = 0; i < MAX_RT_ENTRIES; i++)
		{
			if(routingtable[i].valid)  // found a valid entry
			{
				if(!routingtable[i].aging)  // found an alive entry, set aging flag to test if still alive
				{
					routingtable[i].aging = TRUE;
				}
				else  // found an entry that is no longer alive and hasnt been reactivated since last check
				{
					// this entry is old, remove it from routing table
					dbg(DBG_USR1, "RoutingM: aging timer found an old entry, deleting! (bs_id=%d, parent=%d, seq_nr=%d, hop_count=%d)\n", 
						routingtable[i].basestation_id, routingtable[i].mote_id, routingtable[i].sequence_number, routingtable[i].hop_count);
						
					routingtable[i].valid = FALSE;
				}
			}
		}
	
		return SUCCESS;
	}
}
