/**
* Sense Module
* provides lighting data from the ADC
**/

module SenseM {
  provides {
    interface StdControl;
  }
  uses {
    interface Timer;
    interface ADC;
    interface StdControl as ADCControl;
    interface Leds;
    interface Beeper;
    interface StdControl as BeeperControl;
  }
}

implementation {

  //circular buffer for storing the last N values
  enum
  {
  	size = 5,
  };
  
  uint16_t current_value = 0;
  uint16_t values[size];
  uint8_t writePos = 0;
  
  //threshold for alarm
  uint16_t threshold = 850;
  uint16_t old_mean = 0 ;
  

  /**
   * Initialize the component. Initialize ADCControl, Leds
   **/
  // implement StdControl interface 
  command result_t StdControl.init() {
    uint8_t i;
    
    for(i = 0; i < size; i++)
      values[i] = 0;
    
    dbg(DBG_USR1, "SenseM: init'd\n");
    
    return rcombine(rcombine(call ADCControl.init(), call Leds.init()), call BeeperControl.init());
    //return rcombine(call ADCControl.init(), call Leds.init());
  }
  
  /**
   * Start the component. Start the clock.
   **/
  command result_t StdControl.start() {
    dbg(DBG_USR1, "SenseM: start\n");
    call BeeperControl.start();
    
    // problem: gleichzeitiges verwenden von 2 timern oder timer und adc: do krochts
    //return call Beeper.doBeep(500, 500, 10);  // test beeper
    return call Timer.start(TIMER_REPEAT, 500);
  }
  
  /**
   * Stop the component. Stop the clock.
   **/
  command result_t StdControl.stop() {
  	dbg(DBG_USR1, "SenseM: stop\n");
  	call BeeperControl.stop();
  	
    return call Timer.stop();
  }

  /**
   * Read sensor data in response to the <code>Timer.fired</code> event.  
   **/
  event result_t Timer.fired() {
  	call Leds.greenToggle();
  	
  	dbg(DBG_USR1, "SenseM: Timer fired, reading ADC\n");
  	
  	// problem: gleichzeitiges verwenden von 2 timern oder timer und adc: do krochts
    //return SUCCESS;
    return call ADC.getData();
  }

  task void calcMean()
  {
  	uint8_t i;
  	uint16_t sum = 0;
  	uint16_t mean = 0;
  	
  	// write new data to circular buffer
  	atomic
  	{
  	  values[writePos] = current_value;
  	  writePos++;
  	
  	  if(writePos >= size)
  	    writePos = 0;
  	}
  	
  	//calculate mean of circular buffer
  	for(i = 0; i < size; i++)
  	  sum = sum + values[i];
  	  
  	mean = sum / size;
 
 	dbg(DBG_USR1, "SenseM: new mean is %d (threshold is %d)\n", mean, threshold);
 
 	if(mean > threshold && old_mean < threshold)
 	  call Beeper.doBeep(400, 400, 3);
 	//else
 	//  call Beeper.cancel();
 	  
// 	if(mean > threshold)
// 	  call Leds.redOn();
// 	else
// 	  call Leds.redOff();
 	
 	old_mean = mean;
 	
 	call Leds.yellowToggle();
  }
  
  /**
   * call the mean calculation task
   **/
  // ADC data ready event handler 
  async event result_t ADC.dataReady(uint16_t data) {
  	atomic
  	{
  	  current_value = data;
  	}
  	
  	dbg(DBG_USR1, "SenseM: got ADC data %d, calc'ing mean\n", data);
  	
    post calcMean();
    return SUCCESS;
  }

}
