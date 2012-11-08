includes MessageTypes;

configuration Ex2 {
}
implementation {
	components Main, Ex2M, ReceiverM, SenderM, PacketM, RoutingM, GenericComm, LedsC, TimerC;
	
	Main.StdControl -> Ex2M.StdControl;
	
	Ex2M.Leds -> LedsC;
	Ex2M.TransmitTimer -> TimerC.Timer[unique("timer")];
	
	Ex2M.RoutingControl -> RoutingM.StdControl;
	Ex2M.RoutingNetwork -> RoutingM.RoutingNetwork;
	RoutingM.MessageSender -> SenderM.MessageSender;
	RoutingM.MessageReceiver -> ReceiverM.MessageReceiver;
	
	Ex2M.SenderControl -> SenderM.StdControl;
	SenderM.SenderControl -> GenericComm;
	SenderM.SendMsg -> GenericComm.SendMsg[AM_NETMSG];
	
	Ex2M.ReceiverControl -> ReceiverM.StdControl;
	ReceiverM.ReceiverControl -> GenericComm;
	ReceiverM.ReceiveMsg  -> GenericComm.ReceiveMsg[AM_NETMSG];
	
	PacketM.PacketHandler <- RoutingM.PacketHandler;
}
