Mobile Computing Labor
Philipp Miedl, 0831223
Stefan Nöhmer, 0830668

Assignment 1: 
Das Projekt wurde grundsätzlich in 2 Module geteilt:
1) SenseM übernimmt die ADC-Messung sowie die Mittelwertberechnung. Timer1 löst periodisch
alle 500ms aus und aktiviert den ADC welcher eine Messung durchführt. Die Messergebnisse werden
in einer Variable zwischengespeichert. Wenn dies erledigt ist wird ein Task gestartet der den Wert
in der temporären Variable in einen Ringbuffer schreibt und dann den Mittelwert des Ringbuffers
berechnet. Dies bedeutet das nach jeder Messung der Mittelwert der letzten 5 Werte berechnet wird
(ähnlich einem sliding window).

Der Mittelwert wird mit einem Threshold verglichen wobei der Beeper nur ausgelöst wird wenn eine 
positive Flanke über den Threshold auftritt. Bei positiver Flanke treten 3 periodische beeps auf.

2) BeepM übernimmt die Steuerung des Beepers abhängig von den Werten die SenseM liefert.

