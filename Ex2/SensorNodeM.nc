/**
	this module represents a standard sensor node
**/

#define SENSOR_NODE_DATA_RATE 1000  // send sensor data every 1000ms
#define SENSOR_NODE_TARGET_BASE_STATION 0  // base station to send sensor data
#define SENSOR_DUMMY_DATA 42  // this is the dummy data that is sent to the base station

module SensorNodeM
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
	// global variables
	
	
	command result_t StdControl.init()
	{	
		dbg(DBG_USR1, "SensorNodeM[%d]: initing", TOS_LOCAL_ADDRESS);
		return rcombine(call Leds.init(), call RoutingControl.init());
	}
	
	command result_t StdControl.start()
	{
		dbg(DBG_USR1, "SensorNodeM[%d]: starting", TOS_LOCAL_ADDRESS);
		call Leds.yellowOff();  // yellow LED off signals sensor node
		return rcombine(call RoutingControl.start(), call AcquireTimer.start(TIMER_REPEAT, SENSOR_NODE_DATA_RATE));
	}
	
	command result_t StdControl.stop()
	{
		dbg(DBG_USR1, "SensorNodeM[%d]: stopping", TOS_LOCAL_ADDRESS);
		return rcombine(call RoutingControl.stop(), call AcquireTimer.stop());
	}
	
	
	event result_t AcquireTimer.fired()
	{
		// send a new data packet
		uint8_t data1 = SENSOR_DUMMY_DATA;
		uint8_t data2 = SENSOR_DUMMY_DATA - 1;
		uint8_t data3 = SENSOR_DUMMY_DATA + 7;
		uint8_t data4 = SENSOR_DUMMY_DATA * 2;
		
		call Leds.greenToggle();  // blinking green LED signals message sending
		
		if(call RoutingNetwork.isKnownBasestation(SENSOR_NODE_TARGET_BASE_STATION))
		{
			dbg(DBG_USR1, "SensorNodeM[%d]: acquire timer fired, sending data packet to known bs %d\n", TOS_LOCAL_ADDRESS, SENSOR_NODE_TARGET_BASE_STATION);
			
			return call RoutingNetwork.sendDataMsg(SENSOR_NODE_TARGET_BASE_STATION, data1, data2, data3, data4);
		}
		else  // base station is not in routing table, ignore
		{
			dbg(DBG_USR1, "SensorNodeM[%d]: aquire timer fired, but bs %d is unknown! ignoring packet.\n", TOS_LOCAL_ADDRESS, SENSOR_NODE_TARGET_BASE_STATION);
			
			return SUCCESS;
		}
	}
	
	
	event result_t RoutingNetwork.receivedDataMsg(uint16_t src, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		call Leds.redToggle();  // red LED blinking signals message receiving
		
		dbg(DBG_USR1, "SensorNodeM[%d]: aha, I received a data message addressed to me. ignoring.", TOS_LOCAL_ADDRESS);
		dbg(DBG_USR1, " details: src=%d, data=[%d %d %d %d]\n", src, data1, data2, data3, data4);
		
		return SUCCESS;
	}
}
