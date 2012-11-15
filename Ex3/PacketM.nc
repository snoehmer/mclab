/*
	provides interfaces to send broadcast/adressed messages
*/

includes MessageTypes;

module PacketM
{
	provides
	{
		interface PacketHandler;
	}
}

implementation
{
	command uint8_t PacketHandler.getMsgType(TOS_Msg *msg)
	{
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		return message->msg_type;
	}
	
	command uint16_t PacketHandler.getBasestationID(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			return message->bmsg.basestation_id;
		else if( message->msg_type == MSG_TYPE_DATA )
			return message->dmsg.basestation_id;
		else if( message->msg_type == MSG_TYPE_COMMAND)
			return message->cmsg.destination_id;
		else return 0;
		
	}
	
	command uint16_t PacketHandler.getSequenceNumber(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			return message->bmsg.seq_nr;
		else return 0;
	}
	
	command uint16_t PacketHandler.getHopcount(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			return message->bmsg.hop_count;
		else return 0;
	}
	
	command uint16_t PacketHandler.getSrc(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			return message->bmsg.parent_addr;
		else if( message->msg_type == MSG_TYPE_DATA )
			return message->dmsg.src_addr;
		else return 0;
	}
	
	command uint8_t PacketHandler.getData1(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			return message->dmsg.data1;
		else return 0;
	}
	
	command uint8_t PacketHandler.getData2(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			return message->dmsg.data2;
		else return 0;
	}
	
	command uint8_t PacketHandler.getData3(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			return message->dmsg.data3;
		else return 0;
	}
	
	command uint8_t PacketHandler.getData4(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			return message->dmsg.data4;
		else return 0;
	}	
	
	command uint16_t PacketHandler.getSenderID(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_COMMAND )
			return message->cmsg.sender_id;
		else return 0;
	}	
	
	command uint16_t PacketHandler.getCommandID(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_COMMAND )
			return message->cmsg.command_id;
		else return 0;
	}	
	
	command uint16_t PacketHandler.getArgument(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_COMMAND )
			return message->cmsg.argument;
		else return 0;
	}
	
	command uint16_t PacketHandler.getSeqNo(TOS_Msg *msg)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_COMMAND )
			return message->cmsg.cmd_seq_no;
		else return 0;
	}
	
	command void PacketHandler.setBasestationID(TOS_Msg *msg, uint16_t new_basestation_id)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			message->bmsg.basestation_id = new_basestation_id;
		else if( message->msg_type == MSG_TYPE_DATA )
			message->dmsg.basestation_id = new_basestation_id;		
	}
	
	command void PacketHandler.setSequenceNumber(TOS_Msg *msg, uint16_t new_sequence_number)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			message->bmsg.seq_nr = new_sequence_number;
	}
	
	command void PacketHandler.setHopcount(TOS_Msg *msg, uint16_t new_hop_count)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			message->bmsg.hop_count = new_hop_count;
	}
	
	command void PacketHandler.setSrc(TOS_Msg *msg, uint16_t new_sender_addr)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_BCAST )
			message->bmsg.parent_addr = new_sender_addr;
		else if( message->msg_type == MSG_TYPE_DATA )
			message->dmsg.src_addr = new_sender_addr;
	}
	
	command void PacketHandler.setData1(TOS_Msg *msg, uint8_t data)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			message->dmsg.data1 = data;
	}
	
	command void PacketHandler.setData2(TOS_Msg *msg, uint8_t data)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			message->dmsg.data2 = data;
	}
	
	command void PacketHandler.setData3(TOS_Msg *msg, uint8_t data)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			message->dmsg.data3 = data;
	}
	
	command void PacketHandler.setData4(TOS_Msg *msg, uint8_t data)
	{	
		NetworkMsg *message = (NetworkMsg *) msg->data;	
		if( message->msg_type == MSG_TYPE_DATA )
			message->dmsg.data4 = data;
	}
	
	command TOS_Msg PacketHandler.assembleBroadcastMessage
		(uint16_t basestation_id, uint16_t sequence_number, uint16_t hop_count)
	{
		TOS_Msg new_TOS_message;
		NetworkMsg *new_network_message = (NetworkMsg*) new_TOS_message.data;
		BroadcastMsg *new_broadcast_message = &(new_network_message->bmsg);
		
		new_network_message->msg_type = MSG_TYPE_BCAST;
		
		new_broadcast_message->basestation_id = basestation_id;
		new_broadcast_message->seq_nr = sequence_number;
		new_broadcast_message->hop_count = hop_count;
		new_broadcast_message->parent_addr = TOS_LOCAL_ADDRESS;
		
		return new_TOS_message;
	}
	
	command TOS_Msg PacketHandler.assembleCommandMessage
		(uint16_t new_destination_id, uint8_t new_command_id, uint16_t new_argument, uint16_t new_cmd_seq_no)
	{
		TOS_Msg new_TOS_message;
		NetworkMsg *new_network_message = (NetworkMsg*) new_TOS_message.data;
		CommandMsg *new_command_message = &(new_network_message->cmsg);
		
		new_network_message->msg_type = MSG_TYPE_COMMAND;
		
		new_command_message->sender_id = TOS_LOCAL_ADDRESS;
		new_command_message->destination_id = new_destination_id;
		new_command_message->command_id = new_command_id;
		new_command_message->argument = new_argument;
		new_command_message->cmd_seq_no = new_cmd_seq_no;
		
		return new_TOS_message;
	}
	
	command TOS_Msg PacketHandler.assembleDataMessage
		(uint16_t basestation_id, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		TOS_Msg new_TOS_message;
		NetworkMsg *new_network_message = (NetworkMsg*) new_TOS_message.data;
		SimpleDataMsg *new_data_message = &(new_network_message->dmsg);
		
		new_network_message->msg_type = MSG_TYPE_DATA;
		
		new_data_message->basestation_id = basestation_id;
		new_data_message->src_addr = TOS_LOCAL_ADDRESS;
		new_data_message->data1 = data1;
		new_data_message->data2 = data2;
		new_data_message->data3 = data3;
		new_data_message->data4 = data4;
		
		return new_TOS_message;
	}
}
