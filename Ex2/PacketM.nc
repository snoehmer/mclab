/*
	provides interfaces to send broadcast/adressed messages
*/

#define SEND_BUFFER_SIZE 10

includes MessageTypes;
includes HopMsg;

module SenderM
{
	provides
	{
		interface PacketAssembler;
		interface PacketDisassembler;
		interface StdControl;
	}
	uses
	{
		interface StdControl as PacketControl;
	}
}

implementation
{
	command uint16_t PacketDisassembler.getSequenceNumber(TOS_Msg *msg)
	{	
		HopMsg *message = (HopMsg *)msg->data;	
		return message->sequence_number;
	}
	
	command uint16_t PacketDisassembler.getHopcount(TOS_Msg *msg)
	{	
		HopMsg *message = (HopMsg *)msg->data;	
		return message->hopcount;
	}
	
	command uint16_t PacketDisassembler.getSrc(TOS_Msg *msg)
	{	
		HopMsg *message = (HopMsg *)msg->data;	
		return message->src;
	}
	
	command TOS_Msg PacketAssembler.assembleMessage(uint16_t my_adr, uint16_t sequence_number, uint16_t hopcount)
	{
		// TODO
		TOS_Msg new_TOS_message;
		HopMsg new_hop_message;
		
		new_hop_message.src = myadr;
		new_hop_message.sequence_number = sequence_number;
		new_hop_message.hopcount = hopcount;
		
		new_TOS_message.data = (uint16_t)new_hop_message;
		
		return new_TOS_message;
	}
	
	command result_t PacketAssembler.setSequenceNumber(TOS_Msg *msg, uint16_t new_sequence_number)
	{	
		HopMsg *message = (HopMsg *)msg->data;	
		message->sequence_number = new_sequence_number;
		return SUCCESS;
	}
	
	command result_t PacketAssembler.setHopcount(TOS_Msg *msg, uint16_t new_hopcount)
	{	
		HopMsg *message = (HopMsg *)msg->data;	
		message->hopcount = new_hopcount;
		return SUCCESS;
	}
	
	command result_t PacketAssembler.setSrc(TOS_Msg *msg, uint16_t new_src)
	{	
		HopMsg *message = (HopMsg *)msg->data;	
		message->src = new_src;
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
