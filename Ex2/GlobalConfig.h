/**
	global config file: contains network and node configuration
**/

enum
{
	// general configuration
	
	// create only 1 base station with address 0
	BASE_STATION_MAX_ADDR = 1,  			// all addresses <= this are treated as base stations


	// base station configuration
	BASE_STATION_BROADCAST_RATE = 5000, 	// send broadcast packets every 5000ms


	// sensor node configuration
	SENSOR_NODE_MESSAGES_ENABLED = 1,		// enable or disable the sending of sensor node data to the base station
	SENSOR_NODE_SELECTIVE_ENABLED = 1,		// enable only a specific sensor node
	SENSOR_NODE_SELECTIVE_ADDR = 3,			// address of enabled specific node
	SENSOR_NODE_DATA_RATE = 11000,	  		// send sensor data every 1000ms
	SENSOR_NODE_TARGET_BASE_STATION = 0,  	// base station to send sensor data
	SENSOR_DUMMY_DATA = 42,  				// this is the dummy data that is sent to the base station
	
	
	// routing configuration
	MAX_RT_ENTRIES = 10,					// size of the static routing table
	ROUTING_AGING_TIMEOUT = 20000			// this is the timeout after which entries are deleted from the routing table
};
