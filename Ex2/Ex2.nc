includes MessageTypes;

configuration Ex2 {
}
implementation {
	components Main, Ex2M, BaseStationM, SensorMoteM, ReceiverM, SenderM, PacketM, RoutingM, GenericComm, LedsC, TimerC;
	
	// main controls
	Main.StdControl -> Ex2M.StdControl;
	
	// main control module
	Ex2M.BaseStationControl -> BaseStationM.StdControl;
	Ex2M.SensorMoteControl -> SensorMoteM.StdControl;	
	
	// base station control module
	BaseStationM.BroadcastTimer -> TimerC.Timer[unique("Timer")];
	BaseStationM.RoutingControl -> RoutingM.StdControl;
	BaseStationM.RoutingNetwork -> RoutingM.RoutingNetwork;
	BaseStationM.PacketHandler -> PacketM.PacketHandler;
	BaseStationM.Leds -> LedsC;
	
	// sensor node control module
	SensorMoteM.AcquireTimer -> TimerC.Timer[unique("Timer")];
	SensorMoteM.RoutingControl -> RoutingM.StdControl;
	SensorMoteM.RoutingNetwork -> RoutingM.RoutingNetwork;
	SensorMoteM.PacketHandler -> PacketM.PacketHandler;
	SensorMoteM.Leds -> LedsC;
	
	// routing manager
	RoutingM.MessageSender -> SenderM.MessageSender;
	RoutingM.MessageReceiver -> ReceiverM.MessageReceiver;
	RoutingM.PacketHandler -> PacketM.PacketHandler;
	RoutingM.AgingTimer -> TimerC.Timer[unique("Timer")];
	
	// low-level buffered sender
	RoutingM.SenderControl -> SenderM.StdControl;
	SenderM.SenderControl -> GenericComm;
	SenderM.SendMsg -> GenericComm.SendMsg[AM_NETMSG];
	
	// low-level buffered receiver
	RoutingM.ReceiverControl -> ReceiverM.StdControl;
	ReceiverM.ReceiverControl -> GenericComm;
	ReceiverM.ReceiveMsg  -> GenericComm.ReceiveMsg[AM_NETMSG];
}
