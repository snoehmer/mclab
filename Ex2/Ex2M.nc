/**
	main module of Ex2, acts as base station or sensor node, depending on TOS_LOCAL_ADDRESS
**/

includes GlobalConfig;

module Ex2M
{
	provides
	{
		interface StdControl;
	}
	uses
	{
		interface StdControl as BaseStationControl;
		interface StdControl as SensorMoteControl;
	}
}

implementation
{

	command result_t StdControl.init()
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)  // we are a base station
		{
			dbg(DBG_USR3, "Ex2M[%d]: initing, I am a base station!\n", TOS_LOCAL_ADDRESS);
			return call BaseStationControl.init();
		}
		else  // we are a sensor node
		{
			dbg(DBG_USR3, "Ex2M[%d]: initing, I am a sensor node!\n", TOS_LOCAL_ADDRESS);
			return call SensorMoteControl.init();
		}
	}
	
	command result_t StdControl.start()
	{		
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)  // we are a base station
		{
			dbg(DBG_USR3, "Ex2M[%d]: starting, I am a base station!\n", TOS_LOCAL_ADDRESS);
			return call BaseStationControl.start();
		}
		else  // we are a sensor node
		{
			dbg(DBG_USR3, "Ex2M[%d]: starting, I am a sensor node!\n", TOS_LOCAL_ADDRESS);
			return call SensorMoteControl.start();
		}
	}

	command result_t StdControl.stop()
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)  // we are a base station
		{
			dbg(DBG_USR3, "Ex2M[%d]: stopping, I am a base station!\n", TOS_LOCAL_ADDRESS);
			return call BaseStationControl.start();
		}
		else  // we are a sensor node
		{
			dbg(DBG_USR3, "Ex2M[%d]: stopping, I am a sensor node!\n", TOS_LOCAL_ADDRESS);
			return call SensorMoteControl.start();
		}
	}
}
