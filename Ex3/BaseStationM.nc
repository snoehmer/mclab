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
			call Leds.greenOn();  // we are a base station
			call Leds.redOff();   // no alarm is detected
			call Leds.yellowOff(); // status display disabled
			
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
			/*
			if(seq_nr == TIME_TO_START) {
				call RoutingNetwork.sendCommandMsg(TOS_BCAST_ADDR, CODE_ALARM_SYSTEM_ON, TOS_LOCAL_ADDRESS);
				dbg(DBG_USR3, "BaseStationM[%d]: Time to start, sending start command.\n", TOS_LOCAL_ADDRESS);
			}
			*/
			
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
			
			// forward data package to PC
			call RoutingNetwork.sendDataMsg(TOS_UART_ADDR, data1, data2, data3, data4);
		}
		
		return SUCCESS;
	}
	
	// received command messages
	event result_t RoutingNetwork.receivedCommandMsg(uint16_t sender_id, uint16_t command_id, uint16_t argument)
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)
		{
			dbg(DBG_USR3, "Basestation[%d]: received a command package for me! sender_id = %d, command_id = %d, argument = %d\n", 
				TOS_LOCAL_ADDRESS, sender_id, command_id, argument);
			
			switch(command_id)
			{
				case CODE_FOUND_MOTE:
					// night guard found mote, forward message to PC
					dbg(DBG_USR3, "Basestation[%d]: guard[%d] found mote[%d].\n", TOS_LOCAL_ADDRESS, sender_id, argument);
					return call RoutingNetwork.sendCommandMsg(TOS_UART_ADDR, CODE_FOUND_MOTE, argument);
				break;
				
				case CODE_LOST_MOTE:
					// night guard lost mote, forward message to PC
					dbg(DBG_USR3, "Basestation[%d]: guard[%d] lost mote[%d].\n", TOS_LOCAL_ADDRESS, sender_id, argument);
					return call RoutingNetwork.sendCommandMsg(TOS_UART_ADDR, CODE_LOST_MOTE, argument);
					return SUCCESS;
				break;
				
				case CODE_ALARM:
					dbg(DBG_USR3, "Basestation[%d]: mote[%d] activated an ALARM!\n", TOS_LOCAL_ADDRESS, sender_id);
					call Leds.redOn();  // active alarm detected!
					
					// tell the night guard about the active alarm
					call RoutingNetwork.sendCommandMsg(BASE_STATION_NIGHT_GUARD_TARGET, CODE_ALARM, TOS_LOCAL_ADDRESS);
					
					// forward the message to the PC
					return call RoutingNetwork.sendCommandMsg(TOS_UART_ADDR, CODE_ALARM, argument);
				break;
				
				case CODE_ALARM_OFF:
					dbg(DBG_USR3, "Basestation[%d]: mote[%d] deactivated the alarm.\n", TOS_LOCAL_ADDRESS, sender_id);
					call Leds.redOff();  // end of active alarm
					
					// tell the night guard about the end of the active alarm
					call RoutingNetwork.sendCommandMsg(BASE_STATION_NIGHT_GUARD_TARGET, CODE_ALARM_OFF, TOS_LOCAL_ADDRESS);
					
					// forward the message to the PC
					return call RoutingNetwork.sendCommandMsg(TOS_UART_ADDR, CODE_ALARM_OFF, argument);
				break;
				
				case CODE_ALARM_SYSTEM_ON:
					dbg(DBG_USR3, "Basestation[%d]: Alarm on received, activating alarm system.\n", TOS_LOCAL_ADDRESS);
					call RoutingNetwork.sendCommandMsg(TOS_UART_ADDR, CODE_ALARM_SYSTEM_ON, TOS_LOCAL_ADDRESS);
					return call RoutingNetwork.sendCommandMsg(TOS_BCAST_ADDR, CODE_ALARM_SYSTEM_ON, TOS_LOCAL_ADDRESS);
				break;
				
				case CODE_ALARM_SYSTEM_OFF:
					dbg(DBG_USR3, "Basestation[%d]: Alarm off received, deactivating alarm system.\n", TOS_LOCAL_ADDRESS);
					call RoutingNetwork.sendCommandMsg(TOS_UART_ADDR, CODE_ALARM_SYSTEM_OFF, TOS_LOCAL_ADDRESS);
					return call RoutingNetwork.sendCommandMsg(TOS_BCAST_ADDR, CODE_ALARM_SYSTEM_OFF, TOS_LOCAL_ADDRESS);
				break;
				
				default:
					dbg(DBG_USR3, "Basestation[%d]: Unknown command %d, ignoring.\n", TOS_LOCAL_ADDRESS, command_id);
			}
		}
		return SUCCESS;
	}
}
