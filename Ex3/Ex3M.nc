/**
	main module of Ex2, acts as base station or sensor node, depending on TOS_LOCAL_ADDRESS
**/

includes GlobalConfig;

module Ex3M
{
	provides
	{
		interface StdControl;
	}
	uses
	{
		interface StdControl as BaseStationControl;
		interface StdControl as SensorMoteControl;
		interface StdControl as NightGuardControl;
	}
}

implementation
{

	command result_t StdControl.init()
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)  // we are a base station
		{
			dbg(DBG_USR3, "Ex3M[%d]: initing, I am a base station!\n", TOS_LOCAL_ADDRESS);
			return call BaseStationControl.init();
		}
		else if(TOS_LOCAL_ADDRESS > BASE_STATION_MAX_ADDR && TOS_LOCAL_ADDRESS <= NIGHT_GUARD_MAX_ADDR)
		{
			dbg(DBG_USR3, "Ex3M[%d]: initing, I am a night guard!\n", TOS_LOCAL_ADDRESS);
			return call NightGuardControl.init();
		}
		else  // we are a sensor node
		{
			dbg(DBG_USR3, "Ex3M[%d]: initing, I am a sensor node!\n", TOS_LOCAL_ADDRESS);
			return call SensorMoteControl.init();
		}
	}
	
	command result_t StdControl.start()
	{		
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)  // we are a base station
		{
			dbg(DBG_USR3, "Ex3M[%d]: starting, I am a base station!\n", TOS_LOCAL_ADDRESS);
			return call BaseStationControl.start();
		}
		else if(TOS_LOCAL_ADDRESS > BASE_STATION_MAX_ADDR && TOS_LOCAL_ADDRESS <= NIGHT_GUARD_MAX_ADDR)
		{
			dbg(DBG_USR3, "Ex3M[%d]: starting, I am a night guard!\n", TOS_LOCAL_ADDRESS);
			return call NightGuardControl.start();		
		}
		else  // we are a sensor node
		{
			dbg(DBG_USR3, "Ex3M[%d]: starting, I am a sensor node!\n", TOS_LOCAL_ADDRESS);
			return call SensorMoteControl.start();
		}
	}

	command result_t StdControl.stop()
	{
		if(TOS_LOCAL_ADDRESS <= BASE_STATION_MAX_ADDR)  // we are a base station
		{
			dbg(DBG_USR3, "Ex3M[%d]: stopping, I am a base station!\n", TOS_LOCAL_ADDRESS);
			return call BaseStationControl.stop();
		}
		else if(TOS_LOCAL_ADDRESS > BASE_STATION_MAX_ADDR && TOS_LOCAL_ADDRESS <= NIGHT_GUARD_MAX_ADDR)
		{
			dbg(DBG_USR3, "Ex3M[%d]: stopping, I am a night guard!\n", TOS_LOCAL_ADDRESS);
			return call NightGuardControl.stop();
		}
		else  // we are a sensor node
		{
			dbg(DBG_USR3, "Ex3M[%d]: stopping, I am a sensor node!\n", TOS_LOCAL_ADDRESS);
			return call SensorMoteControl.stop();
		}
	}
}
