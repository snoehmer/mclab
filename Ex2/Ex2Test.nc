/**
	this program tests the functionality of the components
**/

includes MessageTypes;

configuration Ex2Test
{
}

implementation
{
	components Main, Ex2TestM, ReceiverM, SenderM, PacketM, GenericComm, LedsC, TimerC;
	
	Main.StdControl -> Ex2TestM.StdControl;
	
	Ex2TestM.Leds -> LedsC;
	Ex2TestM.SenderControl -> SenderM.StdControl;
	Ex2TestM.ReceiverControl -> ReceiverM.StdControl;
	Ex2TestM.MessageSender -> SenderM.MessageSender;
	Ex2TestM.MessageReceiver -> ReceiverM.MessageReceiver;
	Ex2TestM.PacketHandler -> PacketM.PacketHandler;
	Ex2TestM.Timer -> TimerC.Timer[unique("timer")];
	
	SenderM.SenderControl -> GenericComm;
	SenderM.SendMsg -> GenericComm.SendMsg[AM_NETMSG];
	
	ReceiverM.ReceiverControl -> GenericComm;
	ReceiverM.ReceiveMsg -> GenericComm.ReceiveMsg[AM_NETMSG];
}
