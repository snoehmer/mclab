configuration Ex2 {
}
implementation {
	components Main, Ex2M, ReceiverM, SenderM, PacketM, RoutingM;
	
	Main.StdControl -> Ex2M.StdControl;
	
	

}