/**
 * 
 * This class enables the communication with a WSN node over TinyOS stuff
 *
 */

import net.tinyos.util.*;
import net.tinyos.message.*;
import java.io.*;

public class WSNComm implements MessageListener
{
	MoteIF mote_;	
	public static final int GROUP_ID = 125;	 // TOS_DEFAULT_AM_GROUP = 0x7d
	
	public static final boolean DEBUG = false;
	
	// message types
	public static final int MSG_TYPE_BCAST = 1;
	public static final int MSG_TYPE_DATA = 2;
	public static final int MSG_TYPE_COMMAND = 3;
	
	// command codes
	public static final int CODE_FOUND_MOTE = 1;
	public static final int CODE_LOST_MOTE = 2;
	public static final int CODE_ALARM = 3;
	public static final int CODE_ALARM_OFF = 4;
	public static final int CODE_ALARM_SYSTEM_ON = 5;
	public static final int CODE_ALARM_SYSTEM_OFF = 6;
	
	// target base station address
	public static final int TARGET_BASESTATION_ID = 0;
	
	public static final int SERIAL_ADDRESS = 126;  // TOS_UART_ADDR = 0x007e
	
	
	private int command_sequence_nr = 0;
	
	
	
	public WSNComm()
	{
		mote_ = new MoteIF(PrintStreamMessenger.err, GROUP_ID);
		mote_.registerListener(new NetworkMsg(), this);
	}
	
	
	
	public void messageReceived(int dest_addr, Message msg)
	{
		if(msg instanceof NetworkMsg)
		{
			NetworkMsg nmsg = (NetworkMsg) msg;
			//System.out.println("[MESSAGE DUMP] " + msg.toString());
			
			switch(nmsg.get_msg_type())
			{
				case MSG_TYPE_BCAST:
					System.out.println("[WARNING     ] received a broadcast message from " + nmsg.get_bmsg_basestation_id() + ", ignoring");
					break;
					
				case MSG_TYPE_DATA:
					dataReceived(nmsg.get_dmsg_src_addr(), nmsg.get_dmsg_data1(), nmsg.get_dmsg_data2(), nmsg.get_dmsg_data3(), nmsg.get_dmsg_data4());
					break;
					
				case MSG_TYPE_COMMAND:
					commandReceived(nmsg.get_cmsg_sender_id(), nmsg.get_cmsg_command_id(), nmsg.get_cmsg_argument());
					break;
					
				default:
					System.out.println("[WARNING     ] received an unknown message type " + nmsg.get_msg_type() + ", ignoring");
			}
		}
		else
		{
			System.out.println("[WARNING     ] received a message that is not of type NetworkMsg, ignoring");
		}
	}
	
	
	// is called when a data packet is received
	public void dataReceived(int src, int data1, int data2, int data3, int data4)
	{
		if(DEBUG)
			System.out.println("[DATA    rcvd] src=" + src + ", data=[" + data1 + " " + data2 + " " + data3 + " " + data4 + " ");
		
		int average = 256 * data1 + data2;
		
		System.out.println("[MOTE avgdata] received average from mote " + src + ": " + average);
	}
	
	// is called when a command packet is received
	public void commandReceived(int sender_id, int command_id, int argument)
	{
		if(DEBUG)
			System.out.println("[COMMAND rcvd] src=" + sender_id + ", command=" + command_id + ", arg=" + argument);
		
		switch(command_id)
		{
			case CODE_ALARM:
				System.out.println("[ !! ALARM ON] mote " + sender_id + " detected an ALARM");
				break;
				
			case CODE_ALARM_OFF:
				System.out.println("[ ~ ALARM OFF] mote " + sender_id + " dismissed ALARM");
				break;
				
			case CODE_ALARM_SYSTEM_OFF:
				System.out.println("[SYSTEM CTRL ] alarm system disabled from base station " + sender_id);
				break;
				
			case CODE_ALARM_SYSTEM_ON:
				System.out.println("[SYSTEM CTRL ] alarm system enabled from base station " + sender_id);
				break;
				
			case CODE_FOUND_MOTE:
				System.out.println("[NIGHT GUARD ] guard found mote " + argument);
				break;
				
			case CODE_LOST_MOTE:
				System.out.println("[NIGHT GUARD ] guard lost mote " + argument);
				break;
				
			default:
				System.out.println("[COMMAND rcvd] received unknown command " + command_id + ", ignoring");
		}
	}
	
	// sends a command packet to a destination
	public void sendData(int dest, short data1, short data2, short data3, short data4)
	{
		NetworkMsg nmsg = new NetworkMsg();
		
		nmsg.set_msg_type(MSG_TYPE_DATA);
		nmsg.set_dmsg_basestation_id(dest);
		nmsg.set_dmsg_src_addr(SERIAL_ADDRESS);
		nmsg.set_dmsg_data1(data1);
		nmsg.set_dmsg_data2(data2);
		nmsg.set_dmsg_data3(data3);
		nmsg.set_dmsg_data4(data4);
		
		if(DEBUG)
			System.out.println("[SEND    data] sending data packet to " + dest + " with data=[" + data1 + " " + data2 + " " + data3 + " " + data4);
		
		try
		{
			mote_.send(TARGET_BASESTATION_ID, (Message) nmsg);
		}
		catch(Exception e)
		{
			System.out.println("[ERROR   send] failed to send data message to base station " + TARGET_BASESTATION_ID);
		}
	}
	
	// sends a command packet to a destination
	public void sendCommand(int dest_id, int command_id, int argument)
	{
		NetworkMsg nmsg = new NetworkMsg();
		
		nmsg.set_msg_type(MSG_TYPE_COMMAND);
		nmsg.set_cmsg_destination_id(dest_id);
		nmsg.set_cmsg_sender_id(SERIAL_ADDRESS);
		nmsg.set_cmsg_command_id(command_id);
		nmsg.set_cmsg_argument(argument);
		nmsg.set_cmsg_cmd_seq_no(command_sequence_nr++);
		
		if(DEBUG)
			System.out.println("[SEND command] sending command packet to " + dest_id + " with command=" + command_id + ", argument=" + argument);
		
		try
		{
			mote_.send(TARGET_BASESTATION_ID, (Message) nmsg);
		}
		catch(Exception e)
		{
			System.out.println("[ERROR   send] failed to send command message to base station " + TARGET_BASESTATION_ID);
		}
	}
}
