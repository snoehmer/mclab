configuration Ex1 {
}
implementation {
	components Main, Ex1M, LedsC, SenseM, TimerC, DemoSensorC, BeepM, Sounder;
	Main.StdControl -> Ex1M.StdControl;
	Main.StdControl -> SenseM.StdControl;
	//Main.StdControl -> BeepM.StdControl;
	//Main.StdControl -> DemoSensorC.StdControl;	
	
	BeepM.Timer -> TimerC.Timer[unique("timer")];
	BeepM.Sounder -> Sounder.StdControl;
	BeepM.Leds -> LedsC;
	
	SenseM.Timer -> TimerC.Timer[unique("timer")];
	SenseM.Leds -> LedsC;
	SenseM.BeeperControl -> BeepM.StdControl;
	SenseM.Beeper -> BeepM.Beeper;
	SenseM.ADC -> DemoSensorC;
	SenseM.ADCControl -> DemoSensorC;
}
