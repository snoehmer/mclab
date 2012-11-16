includes MessageTypes;

configuration Ex3 {
}
implementation {
	components Main, Ex3M, BaseStationM, NightGuardM, SensorMoteM, ReceiverM,
	SenderM, PacketM, RoutingM, GenericComm, LedsC, TimerC, SenseM, NGNeighborsM,
	DemoSensorC;
	
	// main controls
	Main.StdControl -> Ex3M.StdControl;
	
	// main control module
	Ex3M.BaseStationControl -> BaseStationM.StdControl;
	Ex3M.SensorMoteControl -> SensorMoteM.StdControl;	
	Ex3M.NightGuardControl -> NightGuardM.StdControl;	
	
	// base station control module
	BaseStationM.BroadcastTimer -> TimerC.Timer[unique("Timer")];
	BaseStationM.RoutingControl -> RoutingM.StdControl;
	BaseStationM.RoutingNetwork -> RoutingM.RoutingNetwork;
	BaseStationM.PacketHandler -> PacketM.PacketHandler;
	BaseStationM.Leds -> LedsC;
	
	// night guard control module
	NightGuardM.BroadcastTimer -> TimerC.Timer[unique("Timer")];
	NightGuardM.RoutingControl -> RoutingM.StdControl;
	NightGuardM.RoutingNetwork -> RoutingM.RoutingNetwork;
	NightGuardM.PacketHandler -> PacketM.PacketHandler;
	NightGuardM.Leds -> LedsC;
	NightGuardM.NGNeighbors -> NGNeighborsM.NGNeighbors;
	NightGuardM.NGNeighborsControl -> NGNeighborsM.StdControl;
	
	// sensor node control module
	SensorMoteM.AcquireTimer -> TimerC.Timer[unique("Timer")];
	SensorMoteM.RoutingControl -> RoutingM.StdControl;
	SensorMoteM.RoutingNetwork -> RoutingM.RoutingNetwork;
	SensorMoteM.PacketHandler -> PacketM.PacketHandler;
	SensorMoteM.Leds -> LedsC;
	SensorMoteM.SenseControl -> SenseM.StdControl;
	SensorMoteM.Sense -> SenseM.Sense;
	
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
	
	// Sensor module
	SenseM.Timer  -> TimerC.Timer[unique("Timer")];
	SenseM.ADC -> DemoSensorC;
    SenseM.ADCControl -> DemoSensorC;
    SenseM.Leds -> LedsC;
    SenseM.InternalCommunication -> RoutingM.InternalCommunication;
    
    // Neighbors management
    NGNeighborsM.InternalCommunication -> RoutingM.InternalCommunication; 
	NGNeighborsM.AgingTimer -> TimerC.Timer[unique("Timer")];
}
