/*
	the interface used for sending messages
*/

interface PacketHandler
{
	command TOS_Msg assembleMessage(uint16_t my_adr, uint16_t sequence_number, uint16_t hopcount, uint16_t base_id);
	command result_t setSequenceNumber(TOS_Msg *msg, uint16_t new_sequence_number);	
	command result_t setHopcount(TOS_Msg *msg, uint16_t new_hopcount);
	command result_t setSrc(TOS_Msg *msg, uint16_t new_src);
	command uint16_t getSequenceNumber(TOS_Msg *msg);
	command uint16_t getHopcount(TOS_Msg *msg);
	command uint16_t getSrc(TOS_Msg *msg);
}
