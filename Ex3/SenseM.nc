/**
* Sense Module
* provides lighting data from the ADC
**/

module SenseM {
  provides {
    interface StdControl;
    
    interface Sense;
  }
  uses {    
    interface Timer;
    interface ADC;
    
    interface InternalCommunication;
    
    interface StdControl as ADCControl;
    interface Leds;
  }
}

implementation {

  //circular buffer for storing the last N values  
  uint16_t values[SENSOR_SIZE_SAMPLE_BUFFER];
  uint16_t writePos;
  
  uint16_t mean;
  
  uint8_t periodCount;
  

  /**
   * Initialize the component. Initialize ADCControl, Leds
   **/
  // implement StdControl interface 
  command result_t StdControl.init() {
    uint16_t i;
    
    for(i = 0; i < SENSOR_SIZE_SAMPLE_BUFFER; i++)
      values[i] = 0;
	writePos = 0;
	mean = 0 ;
	periodCount = 0;
    
    dbg(DBG_USR1, "SensorMote[%d] - SenseM: init.\n", TOS_LOCAL_ADDRESS);
    
    return rcombine(call ADCControl.init(), call Leds.init());
  }
  
  /**
   * Start the component. Start the clock.
   **/
  command result_t StdControl.start() {
    dbg(DBG_USR1, "SensorMote[%d] - SenseM: start\n", TOS_LOCAL_ADDRESS);
    return call Timer.start(TIMER_REPEAT, SENSOR_MEASUREMENT_PERIOD);
  }
  
  /**
   * Stop the component. Stop the clock.
   **/
  command result_t StdControl.stop() {
  	dbg(DBG_USR1, "SensorMote[%d] - SenseM: stop\n", TOS_LOCAL_ADDRESS);
  	
    return call Timer.stop();
  }
  
  /**
   * Read sensor data in response to the <code>Timer.fired</code> event.  
   **/
  event result_t Timer.fired() {
  	dbg(DBG_USR1, "SensorMote[%d] - SenseM: Timer fired, reading ADC\n", TOS_LOCAL_ADDRESS);
  	
  	// check if we need to toogle the LED
	if(periodCount == SENSOR_NODE_LED_PERIOD)
	{
		call Leds.yellowToggle();
		periodCount = 0;
	}
	periodCount++;
	 	
    return call ADC.getData();
  }

  task void calcMean()
  {
  	uint16_t i;
  	uint16_t sum = 0;
  	 
  	atomic
  	{	
	  	//calculate mean of circular buffer
	  	for(i = 0; i < SENSOR_SIZE_SAMPLE_BUFFER; i++)
	  	  sum = sum + values[i];
  	}
  	
  	mean = sum / SENSOR_SIZE_SAMPLE_BUFFER;
 
 	dbg(DBG_USR3, "SensorMote[%d] - SenseM: new mean is %d (SENSOR_ALARM_THRESHOLD is %d)\n", TOS_LOCAL_ADDRESS, mean, SENSOR_ALARM_THRESHOLD);
  }
    
  command uint16_t Sense.getMean()
  {
  	//post calcMean();
  	return mean;
  }
  
  /**
   * call the mean calculation task
   **/
  // ADC data ready event handler 
  async event result_t ADC.dataReady(uint16_t data) 
  {
   	// write new data to circular buffer
  	atomic
  	{
  	  values[writePos] = data;
  	  writePos++;
  	
  	  if(writePos >= SENSOR_SIZE_SAMPLE_BUFFER)
  	    writePos = 0;
  	}
 
 	if(data > SENSOR_ALARM_THRESHOLD)
 	  call InternalCommunication.triggerCommand(CODE_ALARM, data); 
  	
  	dbg(DBG_USR1, "SensorMote[%d]: got ADC data %d\n", TOS_LOCAL_ADDRESS, data);
  	
  	post calcMean();
  	
    return SUCCESS;
  }
}
