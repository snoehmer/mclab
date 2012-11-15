/*
   this header contains the struct definitions for different message types
*/

typedef struct BroadcastMsg
{
	uint16_t basestation_id;
	uint16_t seq_nr;
	uint16_t hop_count;
	uint16_t parent_addr;
} BroadcastMsg;

typedef struct CommandMsg
{
	uint16_t sender_id;
	uint16_t destination_id;
	uint8_t command_id;
	uint16_t argument;
	uint16_t cmd_seq_no;
} CommandMsg;

typedef struct SimpleDataMsg
{
	uint16_t basestation_id;
	uint16_t src_addr;
	uint8_t data1;
	uint8_t data2;
	uint8_t data3;
	uint8_t data4;
} SimpleDataMsg;

typedef struct NetworkMsg
{
	uint8_t msg_type;
	
	union
	{
		BroadcastMsg bmsg;
		SimpleDataMsg dmsg;
		CommandMsg cmsg;
	};
	
} NetworkMsg;

enum
{
	AM_NETMSG = 5,
	MSG_TYPE_BCAST = 1,
	MSG_TYPE_DATA = 2,
	MSG_TYPE_COMMAND = 3
};
