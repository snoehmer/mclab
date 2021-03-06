/**
	this module represents a base station
**/

#define I_AM_A_NIGHT_GUARD (TOS_LOCAL_ADDRESS > BASE_STATION_MAX_ADDR && TOS_LOCAL_ADDRESS <= NIGHT_GUARD_MAX_ADDR)

includes GlobalConfig;

module NightGuardM
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
		
		interface StdControl as NGNeighborsControl;
		interface NGNeighbors;
	}
}

implementation
{
	// global variables
	uint16_t seq_nr;  // a unique sequence number for each broadcast
	bool alarm_mode;
	
	command result_t StdControl.init()
	{
		if(TOS_LOCAL_ADDRESS > BASE_STATION_MAX_ADDR && TOS_LOCAL_ADDRESS <= NIGHT_GUARD_MAX_ADDR)
		{
			seq_nr = 0;
			dbg(DBG_USR2, "NightGuard[%d]: initing", TOS_LOCAL_ADDRESS);
			return rcombine3(call Leds.init(), call RoutingControl.init(), call NGNeighborsControl.init());
		}
		
		alarm_mode = FALSE;
		
		return SUCCESS;
	}
	
	command result_t StdControl.start()
	{		
		if(TOS_LOCAL_ADDRESS > BASE_STATION_MAX_ADDR && TOS_LOCAL_ADDRESS <= NIGHT_GUARD_MAX_ADDR)
		{
			dbg(DBG_USR2, "NightGuard[%d]: starting", TOS_LOCAL_ADDRESS);
			
			call Leds.greenOff();  // we are a night guard (toggle green LED)
			call Leds.redOff();    // no alarm detected
			call Leds.yellowOff(); // alarm system not active yet
			return rcombine(call RoutingControl.start(), call NGNeighborsControl.start());
		}
		
		return FAIL;
	} 
	
	command result_t StdControl.stop()
	{
		if(TOS_LOCAL_ADDRESS > BASE_STATION_MAX_ADDR && TOS_LOCAL_ADDRESS <= NIGHT_GUARD_MAX_ADDR)
		{
			dbg(DBG_USR2, "NightGuard[%d]: stopping", TOS_LOCAL_ADDRESS);
			return rcombine(call RoutingControl.stop(), call NGNeighborsControl.stop());
		}
		
		return SUCCESS;
	}
	
	
	// periodically send new broadcast messages
	event result_t BroadcastTimer.fired()
	{
		call Leds.greenToggle();	// toggle green LED so signal I am a night guard
		
		if(alarm_mode)
			call Leds.redToggle();  // toggle red LED when alarm is detected
		else
			call Leds.redOff();		// turn off red LED when alarm has ended
			
		if(TOS_LOCAL_ADDRESS > BASE_STATION_MAX_ADDR && TOS_LOCAL_ADDRESS <= NIGHT_GUARD_MAX_ADDR)
		{		
			// send a new broadcast packet
			dbg(DBG_USR3, "NightGuard[%d]: broadcast timer fired, sending broadcast with seq_nr=%d\n", TOS_LOCAL_ADDRESS, seq_nr);
			return call RoutingNetwork.issueBroadcast(TOS_LOCAL_ADDRESS, seq_nr++);
		}
		
		return SUCCESS;
	}
	
	// received a data message, ignoring
	event result_t RoutingNetwork.receivedDataMsg(uint16_t src, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		if(I_AM_A_NIGHT_GUARD)
		{		
			dbg(DBG_USR3, "NightGuard[%d]: aha, I received a data package addressed to me. ignoring.", TOS_LOCAL_ADDRESS);
			dbg(DBG_USR3, " details: src=%d, data=[%d %d %d %d]\n", src, data1, data2, data3, data4);
		}
		
		return SUCCESS;
	}
	
	// received command messages
	event result_t RoutingNetwork.receivedCommandMsg(uint16_t sender_id, uint16_t command_id, uint16_t argument)
	{
		if(I_AM_A_NIGHT_GUARD)
		{
			dbg(DBG_USR3, "NightGuard[%d]: received a command package for me! sender_id = %d, command_id = %d, argument = %d\n", 
				TOS_LOCAL_ADDRESS, sender_id, command_id, argument);

			switch(command_id)
			{
				case CODE_FOUND_MOTE:
					// look up in neighbors table if mote is already there, because if it is, we don't need to send a command to the basestation
					if(!(call NGNeighbors.isKnownMote(argument)))
					{
						dbg(DBG_USR3, "NightGuard[%d]: Found mote[%d], sending command to basestation.\n", TOS_LOCAL_ADDRESS, argument);
						call NGNeighbors.updateNeighborstable(argument);
						return call RoutingNetwork.sendCommandMsg(SENSOR_NODE_TARGET_BASE_STATION, CODE_FOUND_MOTE, argument);
					}
					else
					{
						dbg(DBG_USR3, "NightGuard[%d]: Found mote[%d], already know mote, nothing to do.\n", TOS_LOCAL_ADDRESS, argument);
						return SUCCESS;
					}
				break;
				case CODE_LOST_MOTE:
					dbg(DBG_USR3, "NightGuard[%d]: Lost mote[%d], sending command to basestation.\n", TOS_LOCAL_ADDRESS, argument);
					return call RoutingNetwork.sendCommandMsg(SENSOR_NODE_TARGET_BASE_STATION, CODE_LOST_MOTE, argument);
				break;
				case CODE_ALARM:
					dbg(DBG_USR3, "NightGuard[%d]: mote[%d] reported an ALARM!\n", TOS_LOCAL_ADDRESS, argument);
					alarm_mode = TRUE;
					return call Leds.redOn();
				break;
				case CODE_ALARM_OFF:
					dbg(DBG_USR3, "NightGuard[%d]: mote[%d] turned alarm off.\n", TOS_LOCAL_ADDRESS, argument);
					alarm_mode = FALSE;
					return call Leds.redOff();
				break;
				case CODE_ALARM_SYSTEM_ON:
					dbg(DBG_USR3, "NightGuard[%d]: Alarm-system turned ON by basestation[%d].", TOS_LOCAL_ADDRESS, argument);
					call Leds.yellowOn();
					// send hello broadcast on startup
					if(call RoutingNetwork.issueBroadcast(TOS_LOCAL_ADDRESS, seq_nr++))
						if(call BroadcastTimer.start(TIMER_REPEAT, NIGHT_GUARD_BROADCAST_RATE))
							return SUCCESS;
				break;
				case CODE_ALARM_SYSTEM_OFF:
					dbg(DBG_USR3, "NightGuard[%d]: Alarm-system turned OFF by basestation[%d].", TOS_LOCAL_ADDRESS, argument);
					call Leds.yellowOff();
					return call BroadcastTimer.stop();
				break;
				default:
					dbg(DBG_USR3, "NightGuard[%d]: Unknown command received, ignoring.", TOS_LOCAL_ADDRESS);
			}
		}
		return SUCCESS;
	}
}
