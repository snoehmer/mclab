/*
	provides interfaces to send broadcast messages
*/

#define SEND_BUFFER_SIZE 10
#define DEBUG 0

includes MessageTypes;

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
	// send buffer stuff
	struct TOS_Msg buffer[SEND_BUFFER_SIZE];
	uint16_t dest_addr[SEND_BUFFER_SIZE];
	uint8_t write_pos;
	uint8_t read_pos;
	uint8_t size;
	
	// helpers for current message
	bool pending;
	TOS_Msg current_msg;
	
	// add message to send-buffer
	result_t buffer_add(struct TOS_Msg new_msg, uint16_t dest)
	{
		if(size >= SEND_BUFFER_SIZE)
		{
			dbg(DBG_USR1, "SenderM: ERROR: send buffer is full, discarding message\n");
			return FAIL;
		}
			
		atomic
		{			
			buffer[write_pos] = new_msg;
			dest_addr[write_pos++] = dest;
			
			if(write_pos >= SEND_BUFFER_SIZE)
				write_pos = 0;
				
			size++;
		}
			
		dbg(DBG_USR1, "SenderM: message added to send buffer, dest = %d\n", dest);
		return SUCCESS;
	}
	
	// get message from send-buffer
	result_t buffer_get(TOS_Msg *msg, uint16_t *dest)
	{
		if(size <= 0)
		{
			dbg(DBG_USR1, "SenderM: ERROR: send buffer is empty, underflow!\n");
			return FAIL;
		}
			
		atomic
		{			
			(*msg) = buffer[read_pos];
			(*dest) = dest_addr[read_pos++];
			
			if(read_pos >= SEND_BUFFER_SIZE)
				read_pos = 0;
			
			size--;
		}
		
		dbg(DBG_USR1, "SenderM: message read from send buffer, dest = %d\n", *dest);
		return SUCCESS;
	}
	
	// determe if buffer is empty
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
		
		pending = FALSE;
		
		return call SenderControl.init();
	}
	
	command result_t StdControl.start()
	{
		pending = FALSE;
		return call SenderControl.start();
	}
	
	command result_t StdControl.stop()
	{
		if(pending)
			return FAIL;
		
		return call SenderControl.stop();
	}
	
	// if the sender is idle, send packet; else queue it in buffer
	command result_t MessageSender.sendMessage(struct TOS_Msg new_msg, uint16_t dest)
	{
		result_t res;
		NetworkMsg *nmsg;
		BroadcastMsg *bmsg;
		SimpleDataMsg *dmsg;	
		
		if(pending)  // a message is currently being sent, add to buffer
		{
			dbg(DBG_USR1, "SenderM: sendMessage got new Msg, pending, add to buffer (dest = %d)\n", dest);
			
			res = buffer_add(new_msg, dest);
			
			if(res != SUCCESS)
			{
				dbg(DBG_USR1, "SenderM: sendMessage failed to add to buffer, exiting\n");
				return res;
			}
		}
		else  // no message is currently being sent, send directly
		{
			dbg(DBG_USR1, "SenderM: sendMessage got new Msg, not pending, sending (dest = %d)\n", dest);
			
			atomic
			{
				new_msg.addr = dest;
				current_msg = new_msg;
				pending = TRUE;
			}
			
			if(DEBUG)
			{
				nmsg = (NetworkMsg*) &(current_msg.data);
				dbg(DBG_USR1, "SenderM: sending new packet: addr = %d, type = %d ", current_msg.addr, nmsg->msg_type);
				
				if(nmsg->msg_type == MSG_TYPE_BCAST)
				{
					bmsg = &(nmsg->bmsg);
					
					dbg(DBG_USR1, "(bcast): bs_id = %d, hopcount = %d, seqnr = %d, sender_addr = %d\n", bmsg->basestation_id,
						bmsg->hop_count, bmsg->seq_nr, bmsg->sender_addr);
				}
				else if(nmsg->msg_type == MSG_TYPE_DATA)
				{
					dmsg = &(nmsg->dmsg);
					
					dbg(DBG_USR1, "(data): bs_id = %d, src = %d, data = [%d %d %d %d]\n", dmsg->basestation_id, dmsg->src_addr,
						dmsg->data1, dmsg->data2, dmsg->data3, dmsg->data4);
				}
				else
				{
					dbg(DBG_USR1, "(unknown!) FAIL\n");
				}
			}
			
			res = call SendMsg.send(dest, sizeof(NetworkMsg), &current_msg);
			
			if(res == SUCCESS)  // packet sent successfully
			{
				//pending = FALSE;
				dbg(DBG_USR1, "SenderM: sendMessage sent message immediately\n");
			}
			else
			{
				dbg(DBG_USR1, "SenderM: sendMessage sent message delayed, pending\n");
			}
		}
		
		return SUCCESS;
	}
	
	// send remaining packets from buffer
	event result_t SendMsg.sendDone(TOS_MsgPtr msg, result_t success)
  	{
  		result_t res;
  		TOS_Msg next_msg;
  		uint16_t dest;
  		
    	if(pending && msg == &current_msg)  // current message sent successfully
      	{
      		if(buffer_isEmpty())  // no more messages, feierabend for now
      		{
				pending = FALSE;
				
				dbg(DBG_USR1, "SenderM: sendDone for last message, feierabend for now\n");
			}
			else  // buffer holds more messages, send those
			{	
				res = buffer_get(&next_msg, &dest);
				
				dbg(DBG_USR1, "SenderM: sendDone with pending messages, sending message (dest = %d)\n", dest);
				
				if(res != SUCCESS)  // reading from buffer failed
				{
					dbg(DBG_USR1, "SenderM: sendDone tried to send next message, failed\n");
					return res;
				}
			
				atomic
				{
					pending = TRUE;
					next_msg.addr = dest;
					current_msg = next_msg;
				}
				
				res = call SendMsg.send(dest, sizeof(NetworkMsg), &current_msg);
				
				if(res == SUCCESS)  // packet sent successfully
				{
					//pending = FALSE;
					dbg(DBG_USR1, "SenderM: sendDone sent message immediately\n");
				}
				else
				{
					dbg(DBG_USR1, "SenderM: sendDone sent message delayed, pending\n");
				}
			}
      	}
    
    	return SUCCESS;
  }
}
