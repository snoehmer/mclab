/**
	this module represents a base station
**/

includes GlobalConfig;

module BaseStationM
{
	provides
	{
		interface StdControl;
	}
	uses
	{
		interface StdControl as RoutingControl;
		interface RoutingNetwork;
		interface PacketHandler;
		
		interface Leds;
		interface Timer as BroadcastTimer;
	}
}

implementation
{
	// global variables
	uint16_t seq_nr;  // a unique sequence number for each broadcast
	
	
	command result_t StdControl.init()
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)
		{
			seq_nr = 0;
			dbg(DBG_USR2, "BaseStationM[%d]: initing", TOS_LOCAL_ADDRESS);
			return rcombine(call Leds.init(), call RoutingControl.init());
		}
		
		return SUCCESS;
	}
	
	command result_t StdControl.start()
	{		
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)
		{
			call Leds.greenOn();
			call Leds.redOff();
			call Leds.yellowOff();
			
			dbg(DBG_USR2, "BaseStationM[%d]: starting", TOS_LOCAL_ADDRESS);
			
			// send hello broadcast on startup
			if(call RoutingControl.start() == SUCCESS)
				if(call RoutingNetwork.issueBroadcast(TOS_LOCAL_ADDRESS, seq_nr++))
					if(call BroadcastTimer.start(TIMER_REPEAT, BASE_STATION_BROADCAST_RATE))
						return SUCCESS;
			
			return FAIL;
		}
		
		return SUCCESS;
	}
	
	command result_t StdControl.stop()
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)
		{
			dbg(DBG_USR2, "BaseStationM[%d]: stopping", TOS_LOCAL_ADDRESS);
			call RoutingNetwork.sendCommandMsg(TOS_BCAST_ADDR, CODE_ALARM_SYSTEM_OFF, TOS_LOCAL_ADDRESS);
			return rcombine(call RoutingControl.stop(), call BroadcastTimer.stop());
		}
		
		return SUCCESS;
	}
	
	// periodically send new broadcast messages
	event result_t BroadcastTimer.fired()
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)
		{
			// toogle green LED to tell the user that this is a basestation
			call Leds.greenToggle();
			if(seq_nr == TIME_TO_START)
				call RoutingNetwork.sendCommandMsg(TOS_BCAST_ADDR, CODE_ALARM_SYSTEM_ON, TOS_LOCAL_ADDRESS);
			// send a new broadcast packet
			dbg(DBG_USR3, "BaseStationM[%d]: broadcast timer fired, sending broadcast with seq_nr=%d\n", TOS_LOCAL_ADDRESS, seq_nr);
			return call RoutingNetwork.issueBroadcast(TOS_LOCAL_ADDRESS, seq_nr++);
		}
		
		return SUCCESS;
	}
		
	// display received data messages
	event result_t RoutingNetwork.receivedDataMsg(uint16_t src, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)
		{		
			dbg(DBG_USR3, "BaseStationM[%d]: received a data package for me!", TOS_LOCAL_ADDRESS);
			dbg(DBG_USR3, " details: src=%d, data=[ %d %d %d %d ]\n", src, data1, data2, data3, data4);
		}
		
		return SUCCESS;
	}
	
	// received command messages
	event result_t RoutingNetwork.receivedCommandMsg(uint16_t sender_id, uint16_t command_id, uint16_t argument)
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)
		{
			dbg(DBG_USR3, "Basestation[%d]: received a command package for me!", TOS_LOCAL_ADDRESS);
			dbg(DBG_USR3, " details: =%d, data=[ %d %d %d %d ]\n", sender_id, command_id, argument);
			
		}
		return SUCCESS;
	}
}
