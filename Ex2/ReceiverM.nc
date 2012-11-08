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
	}
	uses
	{
		interface StdControl as ReceiverControl;
		//interface ReceiveMsg;
	}
}

implementation
{
	// send buffer stuff
	TOS_Msg buffer[RECEIVE_BUFFER_SIZE];
	uint8_t write_pos;
	uint8_t read_pos;
	uint8_t size;
	
	uint16_t my_adr;	
	uint16_t sequence_no;
	
	
	result_t buffer_add(TOS_Msg new_msg, uint16_t dest)
	{
		if(size >= RECEIVE_BUFFER_SIZE)
		{
			dbg(DBG_USR1, "ReceiverM: ERROR: receive buffer is full, discarding message\n");
			return FAIL;
		}
		
		atomic
		{			
			if( dest == TOS_BCAST_ADDR || dest == my_adr)
			{
				uint16_t msg_seq = call PacketDisassembler.getSequenceNumber(&new_msg);
				if( msg_seq > sequence_no )
				{
					buffer[write_pos++] = new_msg;
					size++;
					sequence_no = msq_seq;
				
					if(write_pos >= RECEIVE_BUFFER_SIZE)
						write_pos = 0;
								
					dbg(DBG_USR1, "ReceiverM: message added to receive buffer, new sequence number = \n", sequence_no);		
				}
				else
				{
					dbg(DBG_USR1, "ReceiverM: message sequence number lower than last received, msg_sequence = ", msq_seq);	
					dbg(DBG_USR1, "; sequence_no = \n", sequence_no);	
				}
									
			}
			else
			{
				dbg(DBG_USR1, "ReceiverM: message adressed to other node, messge ignored; dest = \n", dest);			
			}
		}
			
		return SUCCESS;
	}
	
	result_t buffer_get(TOS_Msg *msg)
	{
		if(size <= 0)
		{
			dbg(DBG_USR1, "ReceiveM: ERROR: send buffer is empty, underflow!\n");
			return FAIL;
		}
		
		atomic
		{		
			(*msg) = buffer[read_pos++];
			
			if(read_pos >= RECEIVE_BUFFER_SIZE)
				read_pos = 0;
			
			size--;
		}
		
		dbg(DBG_USR1, "ReceiveM: message read from receive buffer\n");
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
		
		// interface init
		sequence_no = 0;
		my_adr = 0;
		
		return call ReceiverControl.init();
	}
	
	command result_t ReceiverControl.init(uint16_t adress)
	{
		// buffer init
		write_pos = 0;
		read_pos = 0;
		size = 0;
		
		// interface init
		sequence_no = 0;
		my_adr = adress;
		
		return call ReceiverControl.init();
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
