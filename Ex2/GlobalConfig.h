/**
	global config file: contains network and node configuration
**/

enum
{
	// general configuration
	
	// create only 1 base station with address 0
	BASE_STATION_MAX_ADDR = 0,  			// all addresses <= this are treated as base stations


	// base station configuration
	BASE_STATION_BROADCAST_RATE = 5000, 	// send broadcast packets every 5000ms


	// sensor node configuration
	SENSOR_NODE_MESSAGES_ENABLED = 0,		// enable or disable the sending of sensor node data to the base station
	SENSOR_NODE_DATA_RATE = 1000,	  		// send sensor data every 1000ms
	SENSOR_NODE_TARGET_BASE_STATION = 0,  	// base station to send sensor data
	SENSOR_DUMMY_DATA = 42,  				// this is the dummy data that is sent to the base station
	
	
	// routing configuration
	MAX_RT_ENTRIES = 10,					// size of the static routing table
	ROUTING_AGING_TIMEOUT = 20000			// this is the timeout after which entries are deleted from the routing table
};
