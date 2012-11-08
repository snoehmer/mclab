/**
 * Message for EX2
 */

typedef struct HopMsg {
  uint16_t hopcount;
  uint16_t sequence_number;
  uint16_t src;
} HopMsg;

