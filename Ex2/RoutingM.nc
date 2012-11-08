/*
	provides interfaces to receive messages
*/

#define RECEIVE_BUFFER_SIZE 10

includes MessageTypes;

module RoutingM
{
	provides
	{
		interface StdControl;
	}
	uses
	{
		interface StdControl as RoutingControl;
	}
}

implementation
{
	command result_t StdControl.init()
	{
		return SUCCESS;
	}
	
	command result_t StdControl.start()
	{
		pending = FALSE;
		return call ReceiverControl.start();
	}
	
	command result_t StdControl.stop()
	{		
		return call ReceiverControl.stop();
	}
}

