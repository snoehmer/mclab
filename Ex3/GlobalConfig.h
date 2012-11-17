/**
	global config file: contains network and node configuration
**/

enum
{
	// general configuration
	
	// create only 1 base station with address 0
	BASE_STATION_MAX_ADDR = 0,  			         // all addresses <= this are treated as base stations
	NIGHT_GUARD_MAX_ADDR = BASE_STATION_MAX_ADDR + 1,


	// base station configuration
	BASE_STATION_BROADCAST_RATE = 5000, 	         // send broadcast packets every 5000ms
	BASE_STATION_NIGHT_GUARD_TARGET = BASE_STATION_MAX_ADDR+1, // night guard to send alarm notification
	TIME_TO_START = 3,                               // this variable defines when the basestation sends the ON signal
													 // it specifies the number of Broadcasts-Intervalls it should wait
													 // e.g.: TIME_TO_START = 10 -> 10*
	
	// night guard configuration
	MAX_MOTES_NEIGHBORS = 20,
	NEIGHBORS_AGING_TIMEOUT = 6000,
	NIGHT_GUARD_BROADCAST_RATE = 2000, 	             // send broadcast packets every 5000ms
	 

	// sensor node configuration
	SENSOR_NODE_MESSAGES_ENABLED = 1,		         // enable or disable the sending of sensor node data to the base station
	SENSOR_NODE_SELECTIVE_ENABLED = 0,		         // enable only a specific sensor node
	SENSOR_NODE_SELECTIVE_ADDR = 2,			         // address of enabled specific node
	SENSOR_NODE_DATA_RATE = 120000,	  		         // send sensor data every 120000ms = 2min
	SENSOR_NODE_RESET_RATE = 2,						 // number after how many sensor data transmissions the mean should be calculated new = 2*2min = 4min
	SENSOR_NODE_TARGET_BASE_STATION = 0,  	         // base station to send sensor data
	SENSOR_NODE_TARGET_NIGHT_GUARD = BASE_STATION_MAX_ADDR+1, // night guard to send alarm notification
	SENSOR_MEASUREMENT_PERIOD = 200,                 // peroidicity of measurements
	SENSOR_TIME_PERIOD_FOR_AVERAGING_IN_MIN = 4,     // which time period of measurements samples should be taken in consideration for average
	//SENSOR_SIZE_SAMPLE_BUFFER = (SENSOR_TIME_PERIOD_FOR_AVERAGING_IN_MIN*60*1000)/SENSOR_MEASUREMENT_PERIOD,  // size of the sample buffer
	SENSOR_ALARM_THRESHOLD = 850,                    // threshold for triggering the alarm
	SENSOR_NODE_LED_PERIOD = 5,                      // timer for LED blinking, always a multiple of the measurement time
	
	
	// routing configuration
	MAX_RT_ENTRIES = 10,					         // size of the static routing table
	ROUTING_AGING_TIMEOUT = 20000,			         // this is the timeout after which entries are deleted from the routing table
	
	// message code config
	CODE_FOUND_MOTE = 1,
	CODE_LOST_MOTE = 2,
	CODE_ALARM = 3,
	CODE_ALARM_OFF = 4,
	CODE_ALARM_SYSTEM_ON = 5,
	CODE_ALARM_SYSTEM_OFF = 6
};
