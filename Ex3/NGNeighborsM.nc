/*
	provides interfaces to receive messages
*/

#define I_AM_A_NIGHT_GUARD (TOS_LOCAL_ADDRESS > BASE_STATION_MAX_ADDR && TOS_LOCAL_ADDRESS <= NIGHT_GUARD_MAX_ADDR)

includes MessageTypes;
includes NGMotetable;
includes GlobalConfig;

module NGNeighborsM
{
	provides
	{
		interface StdControl;
		
		interface NGNeighbors;
	}
	uses
	{		
    	interface InternalCommunication;	
    				
		interface Timer as AgingTimer;
	}
}

implementation
{
	NGMoteTableEntry neighborstable[MAX_MOTES_NEIGHBORS];
	
	command result_t StdControl.init()
	{
		uint8_t i;
		
		for(i = 0; i < MAX_MOTES_NEIGHBORS; i++)
		{
			neighborstable[i].mote_id = 0;
			neighborstable[i].aging = FALSE;
			neighborstable[i].valid = FALSE;
		}
		
		return SUCCESS;
	}
	
	command result_t StdControl.start()
	{
		return call AgingTimer.start(TIMER_REPEAT, NEIGHBORS_AGING_TIMEOUT);
	}
	
	command result_t StdControl.stop()
	{		
		return call AgingTimer.stop();
	}
	
	
	uint8_t getKnownMote(uint16_t mote_id)
	{	
		uint8_t i;
		
		for(i = 0; i < MAX_MOTES_NEIGHBORS; i++)
		{
			if(neighborstable[i].valid && neighborstable[i].mote_id == mote_id)
				break;
		}
		
		return i;  // if no entry was found, i = MAX_MOTES_NEIGHBORS
	}
	
	uint8_t getFreeNTSlot()
	{
		uint8_t i;
		
		for(i = 0; i < MAX_MOTES_NEIGHBORS; i++)
		{
			if(!neighborstable[i].valid)  // free slot found
				break;
		}
		
		return i;  // if no free slot is found, i = MAX_RT_ENTRIES
	}
	
	// tries to update the routing table, returns SUCCESS if this broadcast package should be forwarded (new route)
	command result_t NGNeighbors.updateNeighborstable(uint16_t mote_id)
	{	
		uint16_t idx = getKnownMote(mote_id);
		
		if(idx == MAX_MOTES_NEIGHBORS) // unknown mote or invalid entry found
			idx = getFreeNTSlot();
			
		// update current entry
		neighborstable[idx].valid = TRUE;
		neighborstable[idx].aging = FALSE;
		neighborstable[idx].mote_id = mote_id;	
		
		return SUCCESS;		
	}
	
	event result_t AgingTimer.fired()
	{
		uint8_t i;
		dbg(DBG_USR2, "NeighborsM: aging timer fired, searching for old neighbor table entries\n");
		
		for(i = 0; i < MAX_RT_ENTRIES; i++)
		{
			if(neighborstable[i].valid)  // found a valid entry
			{
				if(!neighborstable[i].aging)  // found an alive entry, set aging flag to test if still alive
				{
					neighborstable[i].aging = TRUE;
				}
				else  // found an entry that is no longer alive and hasnt been reactivated since last check
				{
					// this entry is old, remove it from routing table
					dbg(DBG_USR2, "NeighborsM: aging timer found an old entry, deleting! (mote_id=%d)\n", neighborstable[i].mote_id);
					
					if(I_AM_A_NIGHT_GUARD)
						call InternalCommunication.triggerCommand(CODE_LOST_MOTE, neighborstable[i].mote_id);
					
					neighborstable[i].valid = FALSE;
				}
			}
		}
	
		return SUCCESS;
	}
}
