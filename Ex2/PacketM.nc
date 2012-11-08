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
	command uint16_t PacketHandler.getBasestationID(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			return ((BroadcastMsg *)message->payload)->basestation_id;
		else if( message->msg_type == MSG_TYPE_DATA )
			return ((SimpleDataMsg *)message->payload)->basestation_id;
		else return 0;
		
	}
	
	command uint16_t PacketHandler.getSequenceNumber(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			return ((BroadcastMsg *)message->payload)->seq_nr;
		else return 0;
	}
	
	command uint16_t PacketHandler.getHopcount(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			return ((BroadcastMsg *)message->payload)->hop_count;
		else return 0;
	}
	
	command uint16_t PacketHandler.getSrc(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			return ((BroadcastMsg *)message->payload)->sender_addr;
		else if( message->msg_type == MSG_TYPE_DATA )
			return ((SimpleDataMsg *)message->payload)->src_addr;
		else return 0;
	}
	
	command uint8_t PacketHandler.getData1(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			return ((SimpleDataMsg *)message->payload)->data1;
		else return 0;
	}
	
	command uint8_t PacketHandler.getData2(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			return ((SimpleDataMsg *)message->payload)->data2;
		else return 0;
	}
	
	command uint8_t PacketHandler.getData3(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			return ((SimpleDataMsg *)message->payload)->data3;
		else return 0;
	}
	
	command uint8_t PacketHandler.getData4(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			return ((SimpleDataMsg *)message->payload)->data4;
		else return 0;
	}
	
	command void PacketHandler.setBasestationID(TOS_Msg *msg, uint16_t new_basestation_id)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			((BroadcastMsg *)message->payload)->basestation_id = new_basestation_id;
		else if( message->msg_type == MSG_TYPE_DATA )
			((SimpleDataMsg *)message->payload)->basestation_id = new_basestation_id;		
	}
	
	command void PacketHandler.setSequenceNumber(TOS_Msg *msg, uint16_t new_sequence_number)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			((BroadcastMsg *)message->payload)->seq_nr = new_sequence_number;
	}
	
	command void PacketHandler.setHopcount(TOS_Msg *msg, uint16_t new_hop_count)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			((BroadcastMsg *)message->payload)->hop_count = new_hop_count;
	}
	
	command void PacketHandler.setSrc(TOS_Msg *msg, uint16_t new_sender_addr)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			((BroadcastMsg *)message->payload)->sender_addr = new_sender_addr;
		else if( message->msg_type == MSG_TYPE_DATA )
			((SimpleDataMsg *)message->payload)->src_addr = new_sender_addr;
	}
	
	command void PacketHandler.setData1(TOS_Msg *msg, uint16_t data)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			((SimpleDataMsg *)message->payload)->data1 = data;
	}
	
	command void PacketHandler.setData2(TOS_Msg *msg, uint16_t data)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			((SimpleDataMsg *)message->payload)->data2 = data;
	}
	
	command void PacketHandler.setData3(TOS_Msg *msg, uint16_t data)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			((SimpleDataMsg *)message->payload)->data3 = data;
	}
	
	command void PacketHandler.setData4(TOS_Msg *msg, uint16_t data)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			((SimpleDataMsg *)message->payload)->data4 = data;
	}
	
	command TOS_Msg PacketHandler.assembleBroadcastMessage
		(uint16_t basestation_id, uint16_t sequence_number, uint16_t hop_count)
	{
		// TODO
		TOS_Msg new_TOS_message;
		NetworkMsg new_network_message;
		BroadcastMsg new_broadcast_message;
		
		new_broadcast_message.basestation_id = basestation_id;
		new_broadcast_message.seq_nr = sequence_number;
		new_broadcast_message.hop_count = hop_count;
		new_broadcast_message.sender_addr = TOS_LOCAL_ADDRESS;
		
		new_network_message.msg_type = MSG_TYPE_BCAST;
		new_network_message.payload = (uint8_t)&new_broadcast_message;
		
		new_TOS_message.data = (uint16_t)&new_network_message;
		
		return new_TOS_message;
	}
	
	command TOS_Msg PacketHandler.assembleDataMessage
		(uint8_t basestation_id, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		// TODO
		TOS_Msg new_TOS_message;
		NetworkMsg new_network_message;
		SimpleDataMsg new_data_message;
		
		new_data_message.basestation_id = basestation_id;
		new_data_message.src_addr = TOS_LOCAL_ADDRESS;
		new_data_message.data1 = data1;
		new_data_message.data2 = data2;
		new_data_message.data3 = data3;
		new_data_message.data4 = data4;
		
		new_network_message.msg_type = MSG_TYPE_BCAST;
		new_network_message.payload = (uint8_t)&new_broadcast_message;
		
		new_TOS_message.data = (uint16_t)&new_network_message;
		
		return new_TOS_message;
	}
	
	command void PacketHandler.setBasestationID(TOS_Msg *msg, uint16_t new_basestation_id)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			((BroadcastMsg *)message->payload)->basestation_id = new_basestation_id;		
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
