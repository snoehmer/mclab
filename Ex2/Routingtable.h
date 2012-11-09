// This file contains the routingtableentry definition

typedef struct RoutingTableEntry
{
	uint8_t basestation_id;
	uint8_t mote_id;
	uint8_t sequence_number;
	uint8_t hop_count;
	bool aging;
	bool valid;	
} RoutingTableEntry;
