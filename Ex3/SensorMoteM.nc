/**
	this module represents a standard sensor mote
**/

includes GlobalConfig;

module SensorMoteM
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
				
		interface StdControl as SenseControl;
		interface Sense;
		
		interface Leds;
		interface Timer as AcquireTimer;
		//interface Timer as LedsTimer;  //TODO LED TIMER FOR BLINKING YELLOW LED
	}
}

implementation
{		
	command result_t StdControl.init()
	{	
		if(TOS_LOCAL_ADDRESS > NIGHT_GUARD_MAX_ADDR)
		{
			dbg(DBG_USR2, "SensorMoteM[%d]: initing", TOS_LOCAL_ADDRESS);
			return rcombine(call Leds.init(), call RoutingControl.init());
		}
		
		return SUCCESS;
	}
	
	command result_t StdControl.start()
	{
		if(TOS_LOCAL_ADDRESS > NIGHT_GUARD_MAX_ADDR)
		{
			call Leds.greenOff();
			call Leds.redOff();
			call Leds.yellowOff();
			
			dbg(DBG_USR2, "SensorMoteM[%d]: starting", TOS_LOCAL_ADDRESS);
			
			return call RoutingControl.start();
		}
		return SUCCESS;
	}
	
	command result_t StdControl.stop()
	{
		if(TOS_LOCAL_ADDRESS > NIGHT_GUARD_MAX_ADDR)
		{
			dbg(DBG_USR2, "SensorMoteM[%d]: stopping", TOS_LOCAL_ADDRESS);
			return call RoutingControl.stop();
		}
		
		return SUCCESS;
	}
	
	
	event result_t AcquireTimer.fired()
	{
		if(TOS_LOCAL_ADDRESS > NIGHT_GUARD_MAX_ADDR)
		{
			if(!SENSOR_NODE_SELECTIVE_ENABLED || (SENSOR_NODE_SELECTIVE_ENABLED && TOS_LOCAL_ADDRESS == SENSOR_NODE_SELECTIVE_ADDR))
			{
				// send a new data packet
				uint16_t mean = call Sense.getMean();
				uint8_t data1 = (mean & 0xFF);
				uint8_t data2 = mean>>8;
				uint8_t data3 = 0;
				uint8_t data4 = 0;
								
				if(call RoutingNetwork.isKnownBasestation(SENSOR_NODE_TARGET_BASE_STATION))
				{
					dbg(DBG_USR3, "SensorMoteM[%d]: acquire timer fired, sending data package to known bs %d\n", TOS_LOCAL_ADDRESS, SENSOR_NODE_TARGET_BASE_STATION);
					
					return call RoutingNetwork.sendDataMsg(SENSOR_NODE_TARGET_BASE_STATION, data1, data2, data3, data4);
				}
				else  // base station is not in routing table, ignore
				{
					dbg(DBG_USR3, "SensorMoteM[%d]: aquire timer fired, but bs %d is unknown! ignoring packet.\n", TOS_LOCAL_ADDRESS, SENSOR_NODE_TARGET_BASE_STATION);
					
					return SUCCESS;
				}
			}
		}
		
		return SUCCESS;
	}
	
	
	event result_t RoutingNetwork.receivedDataMsg(uint16_t src, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		if(TOS_LOCAL_ADDRESS > NIGHT_GUARD_MAX_ADDR)
		{		
			dbg(DBG_USR3, "SensorMoteM[%d]: aha, I received a data package addressed to me. ignoring.", TOS_LOCAL_ADDRESS);
			dbg(DBG_USR3, " details: src=%d, data=[%d %d %d %d]\n", src, data1, data2, data3, data4);
		}
		
		return SUCCESS;
	}
	
	// received command messages
	event result_t RoutingNetwork.receivedCommandMsg(uint16_t sender_id, uint8_t command_id, uint16_t argument)
	{
		if(TOS_LOCAL_ADDRESS > NIGHT_GUARD_MAX_ADDR)
		{
			dbg(DBG_USR3, "SensorMote[%d]: received a command package for me! sender_id = %d, command_id = %d, argument = %d\n", 
				TOS_LOCAL_ADDRESS, sender_id, command_id, argument);
			
			switch(command_id)
			{
				case CODE_FOUND_MOTE:
					dbg(DBG_USR3, "SensorMote[%d]: This command is not relevant, ignoring.\n", TOS_LOCAL_ADDRESS);
					return SUCCESS;
				break;
				case CODE_LOST_MOTE:
					dbg(DBG_USR3, "SensorMote[%d]: This command is not relevant, ignoring.\n", TOS_LOCAL_ADDRESS);
					return SUCCESS;
				break;
				case CODE_ALARM:
					dbg(DBG_USR3, "SensorMote[%d]: ALARM ON.\n", TOS_LOCAL_ADDRESS);
					call Leds.redOn();
					// alarm on, need to send notifications to night guard and base station
					call RoutingNetwork.sendCommandMsg(SENSOR_NODE_TARGET_NIGHT_GUARD, CODE_ALARM, TOS_LOCAL_ADDRESS);
					call RoutingNetwork.sendCommandMsg(SENSOR_NODE_TARGET_BASE_STATION, CODE_ALARM, TOS_LOCAL_ADDRESS);
					return SUCCESS;
				break;
				case CODE_ALARM_OFF:
					dbg(DBG_USR3, "SensorMote[%d]: Alarm off.\n", TOS_LOCAL_ADDRESS);
					call Leds.redOff();
					// alarm off, need to send notifications to night guard and base station
					call RoutingNetwork.sendCommandMsg(sender_id, CODE_ALARM_OFF, TOS_LOCAL_ADDRESS);
					call RoutingNetwork.sendCommandMsg(SENSOR_NODE_TARGET_BASE_STATION, CODE_ALARM_OFF, TOS_LOCAL_ADDRESS);
					return SUCCESS;
				break;
				case CODE_ALARM_SYSTEM_ON:
					dbg(DBG_USR3, "SensorMote[%d]: Alarm-system turned ON by basestation[%d].", TOS_LOCAL_ADDRESS, argument);
					return rcombine(call SenseControl.start(), call AcquireTimer.start(TIMER_REPEAT, SENSOR_NODE_DATA_RATE));
				break;
				case CODE_ALARM_SYSTEM_OFF:
					dbg(DBG_USR3, "SensorMote[%d]: Alarm-system turned OFF by basestation[%d].", TOS_LOCAL_ADDRESS, argument);
					return rcombine(call SenseControl.stop(), call AcquireTimer.stop());
				break;
				default:
					dbg(DBG_USR3, "SensorMote[%d]: Unknown command received, ignoring.", TOS_LOCAL_ADDRESS);
			}
		}
		return SUCCESS;
	}
}
