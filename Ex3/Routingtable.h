// This file contains the routingtableentry definition

typedef struct RoutingTableEntry
{
	uint16_t basestation_id;
	uint16_t mote_id;
	uint16_t sequence_number;
	uint16_t hop_count;
	bool aging;
	bool valid;	
} RoutingTableEntry;
