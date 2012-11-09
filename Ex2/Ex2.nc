includes MessageTypes;

configuration Ex2 {
}
implementation {
	components Main, Ex2M, BaseStationM, SensorNodeM, ReceiverM, SenderM, PacketM, RoutingM, GenericComm, LedsC, TimerC;
	
	// main controls
	Main.StdControl -> Ex2M.StdControl;
	
	// main control module
	Ex2M.BaseStationControl -> BaseStationM.StdControl;
	Ex2M.SensorNodeControl -> SensorNodeM.StdControl;	
	
	// base station control module
	BaseStationM.BroadcastTimer -> TimerC.Timer[unique("timer")];
	BaseStationM.RoutingControl -> RoutingM.StdControl;
	BaseStationM.RoutingNetwork -> RoutingM.RoutingNetwork;
	BaseStationM.PacketHandler -> PacketM.PacketHandler;
	BaseStationM.Leds -> LedsC;
	
	// sensor node control module
	SensorNodeM.AcquireTimer -> TimerC.Timer[unique("timer")];
	SensorNodeM.RoutingControl -> RoutingM.StdControl;
	SensorNodeM.RoutingNetwork -> RoutingM.RoutingNetwork;
	SensorNodeM.PacketHandler -> PacketM.PacketHandler;
	SensorNodeM.Leds -> LedsC;
	
	// routing manager
	RoutingM.MessageSender -> SenderM.MessageSender;
	RoutingM.MessageReceiver -> ReceiverM.MessageReceiver;
	RoutingM.PacketHandler -> PacketM.PacketHandler;
	
	// low-level buffered sender
	RoutingM.SenderControl -> SenderM.StdControl;
	SenderM.SenderControl -> GenericComm;
	SenderM.SendMsg -> GenericComm.SendMsg[AM_NETMSG];
	
	// low-level buffered receiver
	RoutingM.ReceiverControl -> ReceiverM.StdControl;
	ReceiverM.ReceiverControl -> GenericComm;
	ReceiverM.ReceiveMsg  -> GenericComm.ReceiveMsg[AM_NETMSG];
}
