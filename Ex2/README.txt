Mobile Computing Labor
Philipp Miedl, 0831223
Stefan Nöhmer, 0830668

* * * Assignment 2: * * *

Message Format:
Wir arbeiten mit Kapselung von Nachrichten wobei es 3 Layer gibt:
1) Die erste Schicht ist entweder eine BroadcastMsg oder eine SimpleDataMsg. 
BroadcastMsg werden als broadcasts an alle Stationen versendet und enthalten 
Informationen über die Basisstations ID, den Hop Count, Sequence Number sowie 
ID der letzten Mote (sender_addr).
SimpleDataMsg dienen zum versenden von Daten von den Motes zur Basisstation. 
Diese Pakete enthalten nur die ID der Basisstation, die ID der sendenden Mote 
sowie 4 Datenfelder.
2) BroadcastMsg oder SimpleDataMsg werden in eine sog. NetworkMsg gekapselt, 
welche aus einer Message plus Message Typ besteht.
3) Um die NetworkMsg versenden zu können wird sie als Payload in einer TOS_Msg 
(Standardtyp) verschickt.

Routingtable:
Die Routingtable hat eine fixe Größe die sich im RoutingM.nc via #define 
Anweisung leicht ändern lässt. Ein RoutingtableEntry besteht aus der 
basestation_id, der mote_id über welche zur Basisstation gesendet werden muss, 
sequence_number der letzten empfangenen Broadcastmessage, hop_count der 
aktuellen Route, aging Flag und ein valid Flag.
Wird ein gültiger Eintrag in die Routingtable geschrieben so muss das valid 
Flag auf TRUE und das aging Flag auf FALSE gesetzt werden. Auf den Motes läuft 
ein Aging-Timer der Periodisch das aging Flag der RoutingtableEntries auf TRUE 
setzt. Ist das aging Flag TRUE wird der Eintrag bei der nächsten gültigen 
Broadcastmessage upgedated und wieder auf FALSE gesetzt.

Ex2M:
Dies ist das Top Modul, hier werden die Transmittimers für periodische 
Übertragungen sowie das ReceivedPacket event gehandelt.

PacketM:
Dieses Modul ist ausschließlich für das erstellen der Pakete sowie dem 
extrahieren der Daten aus Paketen zuständig. Es stellt das PacketHandler 
Interface zur Verfügung welches vom SenderM und RoutingM genutzt werden.

RoutingM:
Die Verwaltung der Routingtable sowie das weiterleiten der Pakete an SenderM 
oder die interne Verarbeitung (bei Datenpaketen), passiert in diesem Modul.

SenderM:
Zuständig für das Senden der Pakete sowie die Verwaltung des send-FIFO. Aufruf 
bei Transmittimer-fired-event oder durch das RoutingM welches Pakete zum 
Weiterleiten übergibt. Verwendet das PacketM um Pakete zu erstellen welche 
daraufhin in den send-FIFO geschrieben werden.

ReceiverM:
Zuständig für das Empfangen der Pakete sowie die Verwaltung des receive-FIFO. 
Aufruf bei MessageReceived-event. Leitet die Messages an das RoutingM Modul 
weiter. ReceivedMessage wird als Task asynchron behandelt.


