/*
	provides interfaces to send messages
*/

#define SEND_BUFFER_SIZE 10

module SenderM
{
	provides
	{
		interface MessageSender;
		interface StdControl;
	}
	uses
	{
		interface StdControl as SenderControl;
		interface SendMsg;
	}
}

implementation
{
	TOS_Msg buffer[SEND_BUFFER_SIZE];
	uint8_t write_pos;
	uint8_t size;
	
	
	void buffer_add(TOS_Msg new_msg)
	{
		if(size >= SEND_BUFFER_SIZE)
		{
			dbg(DBG_USR1, "ERROR: Send buffer is full, discarding message\n");
			return;
		}
		
		buffer[write_pos++] = new_msg;
		
		if(write_pos >= SEND_BUFFER_SIZE)
			write_pos = 0;
			
		dbg(DBG_USR1, "message added to send buffer\n");
	}
	
	command result_t StdControl.init()
	{
		write_pos = 0;
		size = 0;
		
		return call SenderControl.init();
	}
	
	command result_t StdControl.start()
	{
		return call SenderControl.start();
	}
	
	command result_t StdControl.stop()
	{
		return call SenderControl.stop();
	}
	
	// if the sender is idle, send packet; else queue it in buffer
	command result_t sendMessage(TOS_Msg new_msg)
	{
		if(
		
	}
	
	// send remaining packets from buffer
	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
  	{
    	if(pending && msg == &data)
      	{
		pending = FALSE;
		signal IntOutput.outputComplete(success);
      	}
    
    	return SUCCESS;
  }

}