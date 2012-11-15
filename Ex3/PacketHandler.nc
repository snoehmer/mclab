/*
	the interface used for sending messages
*/

includes AM;

interface PacketHandler
{
	command uint8_t getMsgType(TOS_Msg *msg);
	command uint16_t getBasestationID(TOS_Msg *msg);
	command uint16_t getSequenceNumber(TOS_Msg *msg);
	command uint16_t getHopcount(TOS_Msg *msg);
	command uint16_t getSrc(TOS_Msg *msg);
	command uint8_t getData1(TOS_Msg *msg);
	command uint8_t getData2(TOS_Msg *msg);
	command uint8_t getData3(TOS_Msg *msg);
	command uint8_t getData4(TOS_Msg *msg);
	command uint16_t getSenderID(TOS_Msg *msg);
	command uint16_t getCommandID(TOS_Msg *msg);
	command uint16_t getArgument(TOS_Msg *msg);
	command uint16_t getSeqNo(TOS_Msg *msg);
	command void setBasestationID(TOS_Msg *msg, uint16_t new_basestation_id);
	command void setSequenceNumber(TOS_Msg *msg, uint16_t new_sequence_number);
	command void setHopcount(TOS_Msg *msg, uint16_t new_hop_count);
	command void setSrc(TOS_Msg *msg, uint16_t new_sender_addr);
	command void setData1(TOS_Msg *msg, uint8_t data);
	command void setData2(TOS_Msg *msg, uint8_t data);
	command void setData3(TOS_Msg *msg, uint8_t data);
	command void setData4(TOS_Msg *msg, uint8_t data);
	command TOS_Msg assembleBroadcastMessage
		(uint16_t basestation_id, uint16_t sequence_number, uint16_t hop_count);	
	command TOS_Msg assembleDataMessage
		(uint16_t basestation_id, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4);
	command TOS_Msg assembleCommandMessage
		(uint16_t new_destination_id, uint8_t new_command_id, uint16_t new_argument, uint16_t cmd_seq_no);
}
