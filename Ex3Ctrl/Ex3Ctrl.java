import java.io.*;
import java.util.*;

public class Ex3Ctrl
{
	public static void main(String[] args)
	{
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String inStr;
		
		System.out.println("Ex3Ctrl: alarm system control");
		System.out.println("enter 'enable' to activate the alarm system\nenter 'disable' to deactivate the alarm system\nenter 'exit' to quit the program");
		
		WSNComm comm = new WSNComm();
		
		while(true)
		{
			try
			{
				inStr = br.readLine();
				
				if(inStr.equals("enable"))
				{
					System.out.println("[SYSTEM CTRL ] sending enable alarm system command");
					comm.sendCommand(WSNComm.TARGET_BASESTATION_ID, WSNComm.CODE_ALARM_SYSTEM_ON, WSNComm.SERIAL_ADDRESS);
				}
				else if(inStr.equals("disable"))
				{
					System.out.println("[SYSTEM CTRL ] sending disable alarm system command");
					comm.sendCommand(WSNComm.TARGET_BASESTATION_ID, WSNComm.CODE_ALARM_SYSTEM_OFF, WSNComm.SERIAL_ADDRESS);
				}
				else if(inStr.equals("exit") || inStr.equals("quit"))
				{
					System.out.println("[  GOOD BYE  ] leaving this awesome program - so long, and thanks for all the fish!");
					System.exit(0);
				}
			}
			catch(Exception e)
			{
				System.out.println("[ERROR     io] failed to read user input: " + e.getMessage());
			}
		}

	}
}
