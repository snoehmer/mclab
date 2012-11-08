/**
	main module of Ex2, acts as base station or sensor node, depending on TOS_LOCAL_ADDRESS
**/

#define BASE_STATION_MAX_ADDR 10
#define BASE_STATION_BROADCAST_RATE 5000  // send broadcast every 5000ms

#define SENSOR_NODE_DATA_RATE 1000  // send sensor data every 1000ms
#define SENSOR_NODE_TARGET_BASE_STATION 0  // base station to send sensor data

module Ex2M
{
	provides
	{
		interface StdControl;
	}
	uses
	{
		interface StdControl as SenderControl;
		interface StdControl as ReceiverControl;
		interface StdControl as RoutingControl;
		interface RoutingNetwork;
		
		interface Leds;
		interface Timer as TransmitTimer;
	}
}

implementation
{

	command result_t StdControl.init()
	{
		return call Leds.init();
	}
	
	command result_t StdControl.start()
	{		
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)  // we are a base station
		{
			dbg(DBG_USR1, "Ex2M: started, I am a base station!\n");
			return call TransmitTimer.start(TIMER_REPEAT, BASE_STATION_BROADCAST_RATE);
		}
		else  // we are a sensor node
		{
			dbg(DBG_USR1, "Ex2M: started, I am a sensor node!\n");
			return call TransmitTimer.start(TIMER_REPEAT, SENSOR_NODE_DATA_RATE);
		}
	}

	command result_t StdControl.stop()
	{
		return call TransmitTimer.stop();
	}

	event result_t RoutingNetwork.receivedDataMsg(uint8_t src, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		dbg(DBG_USR1, "Ex2M: received data message: src=%d, data=[ %d %d %d %d ]\n", src, data1, data2, data3, data4);
		
		return SUCCESS;
	}
	
	event result_t TransmitTimer.fired()
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)
		{
			dbg(DBG_USR1, "Ex2M: transmit timer fired, sending broadcast packet");
			
			return call RoutingNetwork.issueBroadcast(TOS_LOCAL_ADDRESS);
		}
		else
		{
			dbg(DBG_USR1, "Ex2M: transmit timer fired, sending fake sensor data");
			
			return call RoutingNetwork.sendDataMsg(SENSOR_NODE_TARGET_BASE_STATION, 42, 43, 44, 45);
		}
	}
}
