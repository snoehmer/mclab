module Ex2M
{
	provides
	{
		interface StdControl;
	}
	uses
	{
		interface StdControl as SenderControl;
		interface RoutingNetwork;
	}
}

implementation
{

	command result_t StdControl.init()
	{
		return SUCCESS;
	}
	
	command result_t StdControl.start()
	{
		return SUCCESS;
	}

	command result_t StdControl.stop()
	{
		return SUCCESS;
	}

	event result_t RoutingNetwork.receivedDataMsg(uint8_t src, uint8_t data1, uint8_t data2, uint8_t data3, uint8_t data4)
	{
		return SUCCESS;
	}
}
