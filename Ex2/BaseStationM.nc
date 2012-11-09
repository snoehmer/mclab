/**
	this module represents a base station
**/

#define BASE_STATION_BROADCAST_RATE 5000  // send broadcast packets every 5000ms

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
		seq_nr = 0;
		dbg(DBG_USR1, "BaseStationM[%d]: initing", TOS_LOCAL_ADDRESS);
		return rcombine(call Leds.init(), call RoutingControl.init());
	}
	
	command result_t StdControl.start()
	{
		dbg(DBG_USR1, "BaseStationM[%d]: starting", TOS_LOCAL_ADDRESS);
		call Leds.yellowOn();  // yellow LED signals base station
		return rcombine(call RoutingControl.start(), call BroadcastTimer.start(TIMER_REPEAT, BASE_STATION_BROADCAST_RATE));
	}
	
	command result_t StdControl.stop()
	{
		dbg(DBG_USR1, "BaseStationM[%d]: stopping", TOS_LOCAL_ADDRESS);
		return rcombine(call RoutingControl.stop(), call BroadcastTimer.stop());
	}
	
	
	// periodically send new broadcast messages
	event result_t BroadcastTimer.fired()
	{
		call Leds.greenToggle();  // green LED blinking signals broadcast sending
		
		// send a new broadcast packet
		dbg(DBG_USR1, "BaseStationM[%d]: broadcast timer fired, sending broadcast with seq_nr=%d\n", TOS_LOCAL_ADDRESS, seq_nr);
		return call RoutingNetwork.issueBroadcast(TOS_LOCAL_ADDRESS, seq_nr++);
	}
	
	
	// display received data messages
	event result_t RoutingNetwork.receivedDataMsg(uint16_t src, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		call Leds.redToggle();  // red LED blinking signals data reception
		
		dbg(DBG_USR1, "BaseStationM[%d]: received a data package for me!", TOS_LOCAL_ADDRESS);
		dbg(DBG_USR1, " details: src=%d, data=[ %d %d %d %d ]\n", src, data1, data2, data3, data4);
		
		return SUCCESS;
	}
}
