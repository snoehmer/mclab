/*
	provides interfaces to send broadcast/adressed messages
*/

#define SEND_BUFFER_SIZE 10

includes MessageTypes;

module SenderM
{
	provides
	{
		interface PacketHandler;
		interface StdControl;
	}
	uses
	{
		interface StdControl as PacketControl;
	}
}

implementation
{
	command uint16_t PacketHandler.getSequenceNumber(TOS_Msg *msg)
	{	
		BroadcastMsg *message = (BroadcastMsg *)msg->data;	
		return message->seq_nr;
	}
	
	command uint16_t PacketHandler.getHopcount(TOS_Msg *msg)
	{	
		BroadcastMsg *message = (BroadcastMsg *)msg->data;	
		return message->hop_count;
	}
	
	command uint16_t PacketHandler.getSrc(TOS_Msg *msg)
	{	
		BroadcastMsg *message = (BroadcastMsg *)msg->data;	
		return message->sender_addr;
	}
	
	command TOS_Msg PacketHandler.assembleMessage(uint16_t my_adr, uint16_t sequence_number, uint16_t hopcount, uint16_t base_id)
	{
		// TODO
		TOS_Msg new_TOS_message;
		BroadcastMsg new_broadcast_message;
		
		new_hop_message.sender_addr = myadr;
		new_hop_message.seq_nr = sequence_number;
		new_hop_message.hop_count = hopcount;
		new_hop_message.basestation_id = base_id;
		
		new_TOS_message.data = (uint16_t)new_hop_message;
		
		return new_TOS_message;
	}
	
	command result_t PacketHandler.setSequenceNumber(TOS_Msg *msg, uint16_t new_sequence_number)
	{	
		BroadcastMsg *message = (BroadcastMsg *)msg->data;	
		message->seq_nr = new_sequence_number;
		return SUCCESS;
	}
	
	command result_t PacketHandler.setHopcount(TOS_Msg *msg, uint16_t new_hopcount)
	{	
		BroadcastMsg *message = (BroadcastMsg *)msg->data;	
		message->hop_count = new_hopcount;
		return SUCCESS;
	}
	
	command result_t PacketHandler.setSrc(TOS_Msg *msg, uint16_t new_src)
	{	
		BroadcastMsg *message = (BroadcastMsg *)msg->data;	
		message->sender_addr = new_src;
		return SUCCESS;
	}
	
	command result_t StdControl.init()
	{		
		return call PacketControl.init();
	}
	
	command result_t StdControl.start()
	{
		return call PacketControl.start();
	}
	
	command result_t StdControl.stop()
	{		
		return call PacketControl.stop();
	}
}
