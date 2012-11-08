includes MessageTypes;

configuration Ex2 {
}
implementation {
	components Main, Ex2M, ReceiverM, SenderM, PacketM, RoutingM, GenericComm;
	
	Main.StdControl -> Ex2M.StdControl;
	
	//Ex2M.StdControl -> RoutingM.StdControl;
	Ex2M.RoutingNetwork -> RoutingM.RoutingNetwork;
	RoutingM.MessageSender -> SenderM.MessageSender;
	RoutingM.MessageReceiver -> ReceiverM.MessageReceiver;
	
	//Ex2M.StdControl -> SenderM.StdControl;
	SenderM.SenderControl -> GenericComm;
	SenderM.SendMsg -> GenericComm.SendMsg[AM_NETMSG];
	
	//Ex2M.StdControl -> ReceiverM.StdControl;
	ReceiverM.ReceiverControl -> GenericComm;
	ReceiverM.ReceiveMsg  -> GenericComm.ReceiveMsg[AM_NETMSG];
	
	PacketM.PacketHandler <- RoutingM.PacketHandler;
}
