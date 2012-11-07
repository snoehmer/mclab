module Ex2M
{
	provides
	{
		interface StdControl;
	}
	uses
	{
		interface StdControl as SenderControl;
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

}