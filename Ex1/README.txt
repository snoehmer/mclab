Mobile Computing Labor
Philipp Miedl, 0831223
Stefan N�hmer, 0830668

Assignment 1: 
Das Projekt wurde grunds�tzlich in 2 Module geteilt:
1) SenseM �bernimmt die ADC-Messung sowie die Mittelwertberechnung. Timer1 l�st periodisch
alle 500ms aus und aktiviert den ADC welcher eine Messung durchf�hrt. Die Messergebnisse werden
in einer Variable zwischengespeichert. Wenn dies erledigt ist wird ein Task gestartet der den Wert
in der tempor�ren Variable in einen Ringbuffer schreibt und dann den Mittelwert des Ringbuffers
berechnet. Dies bedeutet das nach jeder Messung der Mittelwert der letzten 5 Werte berechnet wird
(�hnlich einem sliding window).

Der Mittelwert wird mit einem Threshold verglichen wobei der Beeper nur ausgel�st wird wenn eine 
positive Flanke �ber den Threshold auftritt. Bei positiver Flanke treten 3 periodische beeps auf.

2) BeepM �bernimmt die Steuerung des Beepers abh�ngig von den Werten die SenseM liefert.

