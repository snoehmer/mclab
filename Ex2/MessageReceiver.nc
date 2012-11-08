/*
	the interface used for receiving messages
*/

interface MessageReceiver
{
	event result_t receivedMessage(TOS_Msg new_msg);
}
