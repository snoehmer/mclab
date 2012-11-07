/**
* Beep Module
* creates beep sequences
**/

// switch between sounder and LEDs
#define ENABLE_SOUNDER 1

module BeepM {  
  provides {
  	interface StdControl;
    interface Beeper;
  }
  uses {
    interface Timer;
    interface StdControl as Sounder;
    interface Leds;
  }
}

implementation {

  //parameters for beeping
  uint16_t duration_on;
  uint16_t duration_off;
  uint8_t repetitions_remaining;
  uint8_t sounder_on;
  uint8_t beep_active;
  

  // implement StdControl interface 
  command result_t StdControl.init() {
  	result_t r;
  	
  	beep_active = 0;
    
    if(ENABLE_SOUNDER)
    	r = call Sounder.init();
    else
    	r = call Leds.init();
    
    dbg(DBG_USR1, "BeepM: init'd\n");
    
    return r;
  }
  
  /**
   * Start the component. Start the clock.
   **/
  command result_t StdControl.start() {
  	beep_active = 0;
  	dbg(DBG_USR1, "BeepM: started\n");
    return SUCCESS;
  }
  
  /**
   * Stop the component. Stop the clock.
   **/
  command result_t StdControl.stop() {
  	atomic
  	{
	  	if(beep_active)
	  	{
	  		if(ENABLE_SOUNDER)
	  			call Sounder.stop();
	  		else
	  			call Leds.redOff();
	  		
	  		sounder_on = 0;
	  		beep_active = 0;
	  	}
	  	
	  	call Timer.stop();
	}
	
	dbg(DBG_USR1, "BeepM: stopped\n");
	
    return SUCCESS;
  }

  /**
   * perform beeper pattern 
   **/
  event result_t Timer.fired()
  {
  	if(sounder_on)	//sounder is on, turn it off
  	{
  		dbg(DBG_USR1, "BeepM: beep active, turning off sounder\n");
  		if(ENABLE_SOUNDER)
  			call Sounder.stop();
  		else
  			call Leds.redOff();
  			
  		sounder_on = 0;
  	
    	if(--repetitions_remaining > 0)	//there are still repetitions remaining
    	{
    		call Timer.start(TIMER_ONE_SHOT, duration_off);
    		dbg(DBG_USR1, "BeepM: beep active, %d repetitions remaining\n", repetitions_remaining);
    	}
    	else
    	{
    		beep_active = 0;
    		dbg(DBG_USR1, "BeepM: beep finished\n");
    	}
    }
    else	//sounder if off, turn it on
    {
    	dbg(DBG_USR1, "BeepM: beep active, turning on sounder\n");
    
    	if(ENABLE_SOUNDER)
    		call Sounder.start();
    	else
    		call Leds.redOn();
    		
    	sounder_on = 1;
    	
    	call Timer.start(TIMER_ONE_SHOT, duration_on);
    }
    
    return SUCCESS;	
  }
  
  command result_t Beeper.doBeep(uint16_t on, uint16_t off, uint8_t repetitions)
  {
  	if(beep_active)	// beeper is already running, ignore
  	{
  		dbg(DBG_USR1, "BeepM: called doBeep, but beep is still active\n");
  		return SUCCESS;
  	}
  		
  	duration_on = on;
  	duration_off = off;
  	repetitions_remaining = repetitions;
  	
  	sounder_on = 1;
  	beep_active = 1;
  	
  	dbg(DBG_USR1, "BeepM: starting beep with t_on=%d, t_off=%d, N=%d; turning on sounder\n", on, off, repetitions);
  	
  	if(ENABLE_SOUNDER)
  		call Sounder.start();
  	else
  		call Leds.redOn();
  	
    call Timer.start(TIMER_ONE_SHOT, on);
    
    return SUCCESS;
  }
  
  command result_t Beeper.cancel()
  {
  	if(beep_active)
  	{
  		dbg(DBG_USR1, "BeepM: called cancel, beep active -> cancelling\n");
  		
  		call Timer.stop();
  		
  		beep_active = 0;
  		sounder_on = 0;
  		repetitions_remaining = 0;
  		
  		if(ENABLE_SOUNDER)
  			call Sounder.stop();
  		else
  			call Leds.redOff();
  	}
  	else
  	{
  		dbg(DBG_USR1, "BeepM: called cancel, but no beep active -> DC\n");
  	}
  	
  	return SUCCESS;
  }
}
