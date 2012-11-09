/**
	test module for Ex2, tests components functionality
**/

#define SENDER_ADDR 0
#define RECEIVER_ADDR 1

includes MessageTypes;

module Ex2TestM
{
	provides
	{
		interface StdControl;
	}
	uses
	{
		interface StdControl as SenderControl;
		interface StdControl as ReceiverControl;
		
		interface MessageSender;
		interface MessageReceiver;
		
		interface PacketHandler;
		
		interface Timer;
		interface Leds;
	}
}

implementation
{
	command result_t StdControl.init()
	{
		dbg(DBG_USR1, "Ex2TestM: initing\n");
		return rcombine3(call SenderControl.init(), call ReceiverControl.init(), call Leds.init());
	}
	
	command result_t StdControl.start()
	{		
		if(TOS_LOCAL_ADDRESS == SENDER_ADDR)
		{
			dbg(DBG_USR1, "Ex2TestM: I am sender, starting packet sending timer\n");
			call Timer.start(TIMER_REPEAT, 2000);
		}
		else if(TOS_LOCAL_ADDRESS == RECEIVER_ADDR)
		{
			dbg(DBG_USR1, "Ex2TestM: I am receiver, waiting for messages\n");
			call Timer.stop();
		}
		else
		{
			dbg(DBG_USR1, "Ex2TestM: I am unknown, bye bye\n");
			call Timer.stop();
		}
		
		return rcombine(call SenderControl.start(), call ReceiverControl.start());
	}
	
	command result_t StdControl.stop()
	{
		dbg(DBG_USR1, "Ex2TestM: stopping\n");
		return rcombine(call SenderControl.stop(), call ReceiverControl.stop());
	}
	
	event result_t MessageReceiver.receivedMessage(TOS_Msg new_msg)
	{
		dbg(DBG_USR1, "Ex2TestM: received Message: ");
		
		if(call PacketHandler.getMsgType(&new_msg) == MSG_TYPE_BCAST)
		{
			dbg(DBG_USR1, "broadcast from %d, seq %d, hopcount %d\n", call PacketHandler.getBasestationID(&new_msg),
				call PacketHandler.getSequenceNumber(&new_msg), call PacketHandler.getHopcount(&new_msg));
		}
		else if(call PacketHandler.getMsgType(&new_msg) == MSG_TYPE_DATA)
		{
			dbg(DBG_USR1, "data from %d, data = [ %d %d %d %d ]\n", call PacketHandler.getSrc(&new_msg),
				call PacketHandler.getData1(&new_msg), call PacketHandler.getData2(&new_msg),
				call PacketHandler.getData3(&new_msg), call PacketHandler.getData4(&new_msg));
		}
		else
		{
			dbg(DBG_USR1, "unknown\n");
		}
		
		return SUCCESS;	
	}
	
	event result_t Timer.fired()
	{
		TOS_Msg new_msg1;
		TOS_Msg new_msg2;
		result_t res1;
		result_t res2;
		
		if(TOS_LOCAL_ADDRESS == SENDER_ADDR)
		{
			dbg(DBG_USR1, "Ex2TestM: trying to send two packets to addr %d\n", RECEIVER_ADDR);
				
			new_msg1 = call PacketHandler.assembleDataMessage(123, 3, 4, 5, 6);
			new_msg2 = call PacketHandler.assembleDataMessage(15, 7, 6, 5, 4);
			new_msg1.addr = RECEIVER_ADDR;
			new_msg2.addr = RECEIVER_ADDR;
			
			// show packet info
			dbg(DBG_USR1, "Ex2TestM: assembled new data package 1: addr = %d, type = %d, src = %d, data = [%d %d %d %d]\n", 
				new_msg1.addr, call PacketHandler.getMsgType(&new_msg1), call PacketHandler.getSrc(&new_msg1),
				call PacketHandler.getData1(&new_msg1), call PacketHandler.getData2(&new_msg1), call PacketHandler.getData3(&new_msg1),
				call PacketHandler.getData4(&new_msg1));
			
			// show packet info
			dbg(DBG_USR1, "Ex2TestM: assembled new data package 2: addr = %d, type = %d, src = %d, data = [%d %d %d %d]\n", 
				new_msg2.addr, call PacketHandler.getMsgType(&new_msg2), call PacketHandler.getSrc(&new_msg2),
				call PacketHandler.getData1(&new_msg2), call PacketHandler.getData2(&new_msg2), call PacketHandler.getData3(&new_msg2),
				call PacketHandler.getData4(&new_msg2));
			
			res1 = call MessageSender.sendMessage(new_msg1, RECEIVER_ADDR);
			res2 = call MessageSender.sendMessage(new_msg2, RECEIVER_ADDR);
			
			if(res1 != SUCCESS || res2 != SUCCESS)
				dbg(DBG_USR1, "Ex2TestM: sending 2 packets failed!\n");
			
			return rcombine(res1, res2);
		}
		else
		{
			dbg(DBG_USR1, "Ex2TestM: send timer fired, but I am not sender - WTF?!\n");
			return SUCCESS;
		}
	}
}
