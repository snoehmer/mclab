/*
   this header contains the struct definitions for different message types
*/

typedef struct NetworkMsg
{
	uint8_t msg_type;
	uint8_t *payload;
} NetworkMsg;

typedef struct BroadcastMsg
{
	uint8_t basestation_id;
	uint8_t seq_nr;
	uint8_t hop_count;
	uint16_t sender_addr;
} BroadcastMsg;

typedef struct SimpleDataMsg
{
	uint8_t basestation_id;
	uint16_t src_addr;
	uint8_t data1;
	uint8_t data2;
	uint8_t data3;
	uint8_t data4;
} SimpleDataMsg;


enum
{
	AM_NETMSG = 5;
	MSG_TYPE_BCAST = 1;
	MSG_TYPE_DATA = 2;
};
