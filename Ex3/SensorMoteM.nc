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
		
		interface Leds;
		interface Timer as AcquireTimer;
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
			dbg(DBG_USR2, "SensorMoteM[%d]: starting", TOS_LOCAL_ADDRESS);
			call Leds.yellowOff();  // yellow LED off signals sensor node
			return rcombine(call RoutingControl.start(), call AcquireTimer.start(TIMER_REPEAT, SENSOR_NODE_DATA_RATE));
		}
		return SUCCESS;
	}
	
	command result_t StdControl.stop()
	{
		if(TOS_LOCAL_ADDRESS > NIGHT_GUARD_MAX_ADDR)
		{
			dbg(DBG_USR2, "SensorMoteM[%d]: stopping", TOS_LOCAL_ADDRESS);
			return rcombine(call RoutingControl.stop(), call AcquireTimer.stop());
		}
		
		return SUCCESS;
	}
	
	
	event result_t AcquireTimer.fired()
	{
		if(TOS_LOCAL_ADDRESS > NIGHT_GUARD_MAX_ADDR && SENSOR_NODE_MESSAGES_ENABLED)
		{
			if(!SENSOR_NODE_SELECTIVE_ENABLED || (SENSOR_NODE_SELECTIVE_ENABLED && TOS_LOCAL_ADDRESS == SENSOR_NODE_SELECTIVE_ADDR))
			{
				// send a new data packet
				uint8_t data1 = SENSOR_DUMMY_DATA;
				uint8_t data2 = SENSOR_DUMMY_DATA - 1;
				uint8_t data3 = SENSOR_DUMMY_DATA + 7;
				uint8_t data4 = SENSOR_DUMMY_DATA * 2;
				
				call Leds.greenToggle();  // blinking green LED signals message sending
				
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
			call Leds.redToggle();  // red LED blinking signals message receiving
		
			dbg(DBG_USR3, "SensorMoteM[%d]: aha, I received a data package addressed to me. ignoring.", TOS_LOCAL_ADDRESS);
			dbg(DBG_USR3, " details: src=%d, data=[%d %d %d %d]\n", src, data1, data2, data3, data4);
		}
		
		return SUCCESS;
	}
}
