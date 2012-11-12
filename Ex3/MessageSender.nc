/*
	the interface used for sending messages
*/

includes AM;

interface MessageSender
{
	command result_t sendMessage(TOS_Msg new_msg, uint16_t dest);
}
