/*
	provides interfaces to receive messages
*/

#define RECEIVE_BUFFER_SIZE 10

includes MessageTypes;

module ReceiverM
{
	provides
	{
		interface StdControl;
		interface MessageReceiver;
	}
	uses
	{
		interface StdControl as ReceiverControl;
		interface ReceiveMsg;
		interface PacketHandler;
	}
}

implementation
{
	// send buffer stuff
	TOS_Msg buffer[RECEIVE_BUFFER_SIZE];
	uint8_t write_pos;
	uint8_t read_pos;
	uint8_t size;
	
	
	result_t buffer_add(TOS_Msg new_msg)
	{
		if(size >= RECEIVE_BUFFER_SIZE)
		{
			dbg(DBG_USR1, "ReceiverM: ERROR: receive buffer is full, discarding message\n");
			return FAIL;
		}
		
		atomic
		{			
			buffer[write_pos++] = new_msg;
			size++;
				
			if(write_pos >= RECEIVE_BUFFER_SIZE)
				write_pos = 0;
							
			dbg(DBG_USR1, "ReceiverM: message added to receive buffer, src = %d\n", new_msg.addr);		
		}
			
		return SUCCESS;
	}
	
	result_t buffer_get(TOS_Msg *msg)
	{
		if(size <= 0)
		{
			dbg(DBG_USR1, "ReceiveM: ERROR: receive buffer is empty, underflow!\n");
			return FAIL;
		}
		
		atomic
		{		
			(*msg) = buffer[read_pos++];
			
			if(read_pos >= RECEIVE_BUFFER_SIZE)
				read_pos = 0;
			
			size--;
		}
		
		dbg(DBG_USR1, "ReceiveM: message read from receive buffer, src = %d\n", msg->addr);
		return SUCCESS;
	}
	
	bool buffer_isEmpty()
	{
		return (size == 0);
	}
	
	command result_t StdControl.init()
	{
		// buffer init
		write_pos = 0;
		read_pos = 0;
		size = 0;
		
		return call ReceiverControl.init();
	}
	
	command result_t StdControl.start()
	{
		return call ReceiverControl.start();
	}
	
	command result_t StdControl.stop()
	{		
		return call ReceiverControl.stop();
	}
	
	// reads the received packet and performs proper actions
	task void receivedMsgTask()
	{
		result_t res;
		TOS_Msg new_msg;
		
		// get new message from buffer
		res = buffer_get(&new_msg);
		
		// TODO: discard message on special reasons?
		
		// signal event to process message
		signal MessageReceiver.receivedMessage(new_msg);
	}
	
	event TOS_MsgPtr ReceiveMsg.receive(TOS_MsgPtr m)
	{
		result_t res;
		
		// add new message to buffer to process it later
		res = buffer_add(*m);
		
		if(res != SUCCESS)
		{
			dbg(DBG_USR1, "ReceiverM: receive could not add new message to buffer!\n");
			return m;
		}

		// now schedule processing of new package
		post receivedMsgTask();
		
	    return m;
  	}
	
}
