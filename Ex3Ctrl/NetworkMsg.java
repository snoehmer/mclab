/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'NetworkMsg'
 * message type.
 */

public class NetworkMsg extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 12;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = 5;

    /** Create a new NetworkMsg of size 12. */
    public NetworkMsg() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new NetworkMsg of the given data_length. */
    public NetworkMsg(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new NetworkMsg with the given data_length
     * and base offset.
     */
    public NetworkMsg(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new NetworkMsg using the given byte array
     * as backing store.
     */
    public NetworkMsg(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new NetworkMsg using the given byte array
     * as backing store, with the given base offset.
     */
    public NetworkMsg(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new NetworkMsg using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public NetworkMsg(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new NetworkMsg embedded in the given message
     * at the given base offset.
     */
    public NetworkMsg(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new NetworkMsg embedded in the given message
     * at the given base offset and length.
     */
    public NetworkMsg(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <NetworkMsg> \n";
      try {
        s += "  [msg_type=0x"+Long.toHexString(get_msg_type())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [bmsg.basestation_id=0x"+Long.toHexString(get_bmsg_basestation_id())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [bmsg.seq_nr=0x"+Long.toHexString(get_bmsg_seq_nr())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [bmsg.hop_count=0x"+Long.toHexString(get_bmsg_hop_count())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [bmsg.parent_addr=0x"+Long.toHexString(get_bmsg_parent_addr())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [dmsg.basestation_id=0x"+Long.toHexString(get_dmsg_basestation_id())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [dmsg.src_addr=0x"+Long.toHexString(get_dmsg_src_addr())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [dmsg.data1=0x"+Long.toHexString(get_dmsg_data1())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [dmsg.data2=0x"+Long.toHexString(get_dmsg_data2())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [dmsg.data3=0x"+Long.toHexString(get_dmsg_data3())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [dmsg.data4=0x"+Long.toHexString(get_dmsg_data4())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [cmsg.sender_id=0x"+Long.toHexString(get_cmsg_sender_id())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [cmsg.destination_id=0x"+Long.toHexString(get_cmsg_destination_id())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [cmsg.command_id=0x"+Long.toHexString(get_cmsg_command_id())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [cmsg.argument=0x"+Long.toHexString(get_cmsg_argument())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [cmsg.cmd_seq_no=0x"+Long.toHexString(get_cmsg_cmd_seq_no())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: msg_type
    //   Field type: int
    //   Offset (bits): 0
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'msg_type' is signed (false).
     */
    public static boolean isSigned_msg_type() {
        return false;
    }

    /**
     * Return whether the field 'msg_type' is an array (false).
     */
    public static boolean isArray_msg_type() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'msg_type'
     */
    public static int offset_msg_type() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'msg_type'
     */
    public static int offsetBits_msg_type() {
        return 0;
    }

    /**
     * Return the value (as a int) of the field 'msg_type'
     */
    public int get_msg_type() {
        return (int)getUIntElement(offsetBits_msg_type(), 16);
    }

    /**
     * Set the value of the field 'msg_type'
     */
    public void set_msg_type(int value) {
        setUIntElement(offsetBits_msg_type(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'msg_type'
     */
    public static int size_msg_type() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'msg_type'
     */
    public static int sizeBits_msg_type() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: bmsg.basestation_id
    //   Field type: int
    //   Offset (bits): 16
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'bmsg.basestation_id' is signed (false).
     */
    public static boolean isSigned_bmsg_basestation_id() {
        return false;
    }

    /**
     * Return whether the field 'bmsg.basestation_id' is an array (false).
     */
    public static boolean isArray_bmsg_basestation_id() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'bmsg.basestation_id'
     */
    public static int offset_bmsg_basestation_id() {
        return (16 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'bmsg.basestation_id'
     */
    public static int offsetBits_bmsg_basestation_id() {
        return 16;
    }

    /**
     * Return the value (as a int) of the field 'bmsg.basestation_id'
     */
    public int get_bmsg_basestation_id() {
        return (int)getUIntElement(offsetBits_bmsg_basestation_id(), 16);
    }

    /**
     * Set the value of the field 'bmsg.basestation_id'
     */
    public void set_bmsg_basestation_id(int value) {
        setUIntElement(offsetBits_bmsg_basestation_id(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'bmsg.basestation_id'
     */
    public static int size_bmsg_basestation_id() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'bmsg.basestation_id'
     */
    public static int sizeBits_bmsg_basestation_id() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: bmsg.seq_nr
    //   Field type: int
    //   Offset (bits): 32
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'bmsg.seq_nr' is signed (false).
     */
    public static boolean isSigned_bmsg_seq_nr() {
        return false;
    }

    /**
     * Return whether the field 'bmsg.seq_nr' is an array (false).
     */
    public static boolean isArray_bmsg_seq_nr() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'bmsg.seq_nr'
     */
    public static int offset_bmsg_seq_nr() {
        return (32 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'bmsg.seq_nr'
     */
    public static int offsetBits_bmsg_seq_nr() {
        return 32;
    }

    /**
     * Return the value (as a int) of the field 'bmsg.seq_nr'
     */
    public int get_bmsg_seq_nr() {
        return (int)getUIntElement(offsetBits_bmsg_seq_nr(), 16);
    }

    /**
     * Set the value of the field 'bmsg.seq_nr'
     */
    public void set_bmsg_seq_nr(int value) {
        setUIntElement(offsetBits_bmsg_seq_nr(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'bmsg.seq_nr'
     */
    public static int size_bmsg_seq_nr() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'bmsg.seq_nr'
     */
    public static int sizeBits_bmsg_seq_nr() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: bmsg.hop_count
    //   Field type: int
    //   Offset (bits): 48
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'bmsg.hop_count' is signed (false).
     */
    public static boolean isSigned_bmsg_hop_count() {
        return false;
    }

    /**
     * Return whether the field 'bmsg.hop_count' is an array (false).
     */
    public static boolean isArray_bmsg_hop_count() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'bmsg.hop_count'
     */
    public static int offset_bmsg_hop_count() {
        return (48 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'bmsg.hop_count'
     */
    public static int offsetBits_bmsg_hop_count() {
        return 48;
    }

    /**
     * Return the value (as a int) of the field 'bmsg.hop_count'
     */
    public int get_bmsg_hop_count() {
        return (int)getUIntElement(offsetBits_bmsg_hop_count(), 16);
    }

    /**
     * Set the value of the field 'bmsg.hop_count'
     */
    public void set_bmsg_hop_count(int value) {
        setUIntElement(offsetBits_bmsg_hop_count(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'bmsg.hop_count'
     */
    public static int size_bmsg_hop_count() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'bmsg.hop_count'
     */
    public static int sizeBits_bmsg_hop_count() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: bmsg.parent_addr
    //   Field type: int
    //   Offset (bits): 64
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'bmsg.parent_addr' is signed (false).
     */
    public static boolean isSigned_bmsg_parent_addr() {
        return false;
    }

    /**
     * Return whether the field 'bmsg.parent_addr' is an array (false).
     */
    public static boolean isArray_bmsg_parent_addr() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'bmsg.parent_addr'
     */
    public static int offset_bmsg_parent_addr() {
        return (64 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'bmsg.parent_addr'
     */
    public static int offsetBits_bmsg_parent_addr() {
        return 64;
    }

    /**
     * Return the value (as a int) of the field 'bmsg.parent_addr'
     */
    public int get_bmsg_parent_addr() {
        return (int)getUIntElement(offsetBits_bmsg_parent_addr(), 16);
    }

    /**
     * Set the value of the field 'bmsg.parent_addr'
     */
    public void set_bmsg_parent_addr(int value) {
        setUIntElement(offsetBits_bmsg_parent_addr(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'bmsg.parent_addr'
     */
    public static int size_bmsg_parent_addr() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'bmsg.parent_addr'
     */
    public static int sizeBits_bmsg_parent_addr() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: dmsg.basestation_id
    //   Field type: int
    //   Offset (bits): 16
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'dmsg.basestation_id' is signed (false).
     */
    public static boolean isSigned_dmsg_basestation_id() {
        return false;
    }

    /**
     * Return whether the field 'dmsg.basestation_id' is an array (false).
     */
    public static boolean isArray_dmsg_basestation_id() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'dmsg.basestation_id'
     */
    public static int offset_dmsg_basestation_id() {
        return (16 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'dmsg.basestation_id'
     */
    public static int offsetBits_dmsg_basestation_id() {
        return 16;
    }

    /**
     * Return the value (as a int) of the field 'dmsg.basestation_id'
     */
    public int get_dmsg_basestation_id() {
        return (int)getUIntElement(offsetBits_dmsg_basestation_id(), 16);
    }

    /**
     * Set the value of the field 'dmsg.basestation_id'
     */
    public void set_dmsg_basestation_id(int value) {
        setUIntElement(offsetBits_dmsg_basestation_id(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'dmsg.basestation_id'
     */
    public static int size_dmsg_basestation_id() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'dmsg.basestation_id'
     */
    public static int sizeBits_dmsg_basestation_id() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: dmsg.src_addr
    //   Field type: int
    //   Offset (bits): 32
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'dmsg.src_addr' is signed (false).
     */
    public static boolean isSigned_dmsg_src_addr() {
        return false;
    }

    /**
     * Return whether the field 'dmsg.src_addr' is an array (false).
     */
    public static boolean isArray_dmsg_src_addr() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'dmsg.src_addr'
     */
    public static int offset_dmsg_src_addr() {
        return (32 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'dmsg.src_addr'
     */
    public static int offsetBits_dmsg_src_addr() {
        return 32;
    }

    /**
     * Return the value (as a int) of the field 'dmsg.src_addr'
     */
    public int get_dmsg_src_addr() {
        return (int)getUIntElement(offsetBits_dmsg_src_addr(), 16);
    }

    /**
     * Set the value of the field 'dmsg.src_addr'
     */
    public void set_dmsg_src_addr(int value) {
        setUIntElement(offsetBits_dmsg_src_addr(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'dmsg.src_addr'
     */
    public static int size_dmsg_src_addr() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'dmsg.src_addr'
     */
    public static int sizeBits_dmsg_src_addr() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: dmsg.data1
    //   Field type: short
    //   Offset (bits): 48
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'dmsg.data1' is signed (false).
     */
    public static boolean isSigned_dmsg_data1() {
        return false;
    }

    /**
     * Return whether the field 'dmsg.data1' is an array (false).
     */
    public static boolean isArray_dmsg_data1() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'dmsg.data1'
     */
    public static int offset_dmsg_data1() {
        return (48 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'dmsg.data1'
     */
    public static int offsetBits_dmsg_data1() {
        return 48;
    }

    /**
     * Return the value (as a short) of the field 'dmsg.data1'
     */
    public short get_dmsg_data1() {
        return (short)getUIntElement(offsetBits_dmsg_data1(), 8);
    }

    /**
     * Set the value of the field 'dmsg.data1'
     */
    public void set_dmsg_data1(short value) {
        setUIntElement(offsetBits_dmsg_data1(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'dmsg.data1'
     */
    public static int size_dmsg_data1() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'dmsg.data1'
     */
    public static int sizeBits_dmsg_data1() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: dmsg.data2
    //   Field type: short
    //   Offset (bits): 56
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'dmsg.data2' is signed (false).
     */
    public static boolean isSigned_dmsg_data2() {
        return false;
    }

    /**
     * Return whether the field 'dmsg.data2' is an array (false).
     */
    public static boolean isArray_dmsg_data2() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'dmsg.data2'
     */
    public static int offset_dmsg_data2() {
        return (56 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'dmsg.data2'
     */
    public static int offsetBits_dmsg_data2() {
        return 56;
    }

    /**
     * Return the value (as a short) of the field 'dmsg.data2'
     */
    public short get_dmsg_data2() {
        return (short)getUIntElement(offsetBits_dmsg_data2(), 8);
    }

    /**
     * Set the value of the field 'dmsg.data2'
     */
    public void set_dmsg_data2(short value) {
        setUIntElement(offsetBits_dmsg_data2(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'dmsg.data2'
     */
    public static int size_dmsg_data2() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'dmsg.data2'
     */
    public static int sizeBits_dmsg_data2() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: dmsg.data3
    //   Field type: short
    //   Offset (bits): 64
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'dmsg.data3' is signed (false).
     */
    public static boolean isSigned_dmsg_data3() {
        return false;
    }

    /**
     * Return whether the field 'dmsg.data3' is an array (false).
     */
    public static boolean isArray_dmsg_data3() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'dmsg.data3'
     */
    public static int offset_dmsg_data3() {
        return (64 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'dmsg.data3'
     */
    public static int offsetBits_dmsg_data3() {
        return 64;
    }

    /**
     * Return the value (as a short) of the field 'dmsg.data3'
     */
    public short get_dmsg_data3() {
        return (short)getUIntElement(offsetBits_dmsg_data3(), 8);
    }

    /**
     * Set the value of the field 'dmsg.data3'
     */
    public void set_dmsg_data3(short value) {
        setUIntElement(offsetBits_dmsg_data3(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'dmsg.data3'
     */
    public static int size_dmsg_data3() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'dmsg.data3'
     */
    public static int sizeBits_dmsg_data3() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: dmsg.data4
    //   Field type: short
    //   Offset (bits): 72
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'dmsg.data4' is signed (false).
     */
    public static boolean isSigned_dmsg_data4() {
        return false;
    }

    /**
     * Return whether the field 'dmsg.data4' is an array (false).
     */
    public static boolean isArray_dmsg_data4() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'dmsg.data4'
     */
    public static int offset_dmsg_data4() {
        return (72 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'dmsg.data4'
     */
    public static int offsetBits_dmsg_data4() {
        return 72;
    }

    /**
     * Return the value (as a short) of the field 'dmsg.data4'
     */
    public short get_dmsg_data4() {
        return (short)getUIntElement(offsetBits_dmsg_data4(), 8);
    }

    /**
     * Set the value of the field 'dmsg.data4'
     */
    public void set_dmsg_data4(short value) {
        setUIntElement(offsetBits_dmsg_data4(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'dmsg.data4'
     */
    public static int size_dmsg_data4() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'dmsg.data4'
     */
    public static int sizeBits_dmsg_data4() {
        return 8;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: cmsg.sender_id
    //   Field type: int
    //   Offset (bits): 16
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'cmsg.sender_id' is signed (false).
     */
    public static boolean isSigned_cmsg_sender_id() {
        return false;
    }

    /**
     * Return whether the field 'cmsg.sender_id' is an array (false).
     */
    public static boolean isArray_cmsg_sender_id() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'cmsg.sender_id'
     */
    public static int offset_cmsg_sender_id() {
        return (16 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'cmsg.sender_id'
     */
    public static int offsetBits_cmsg_sender_id() {
        return 16;
    }

    /**
     * Return the value (as a int) of the field 'cmsg.sender_id'
     */
    public int get_cmsg_sender_id() {
        return (int)getUIntElement(offsetBits_cmsg_sender_id(), 16);
    }

    /**
     * Set the value of the field 'cmsg.sender_id'
     */
    public void set_cmsg_sender_id(int value) {
        setUIntElement(offsetBits_cmsg_sender_id(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'cmsg.sender_id'
     */
    public static int size_cmsg_sender_id() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'cmsg.sender_id'
     */
    public static int sizeBits_cmsg_sender_id() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: cmsg.destination_id
    //   Field type: int
    //   Offset (bits): 32
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'cmsg.destination_id' is signed (false).
     */
    public static boolean isSigned_cmsg_destination_id() {
        return false;
    }

    /**
     * Return whether the field 'cmsg.destination_id' is an array (false).
     */
    public static boolean isArray_cmsg_destination_id() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'cmsg.destination_id'
     */
    public static int offset_cmsg_destination_id() {
        return (32 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'cmsg.destination_id'
     */
    public static int offsetBits_cmsg_destination_id() {
        return 32;
    }

    /**
     * Return the value (as a int) of the field 'cmsg.destination_id'
     */
    public int get_cmsg_destination_id() {
        return (int)getUIntElement(offsetBits_cmsg_destination_id(), 16);
    }

    /**
     * Set the value of the field 'cmsg.destination_id'
     */
    public void set_cmsg_destination_id(int value) {
        setUIntElement(offsetBits_cmsg_destination_id(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'cmsg.destination_id'
     */
    public static int size_cmsg_destination_id() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'cmsg.destination_id'
     */
    public static int sizeBits_cmsg_destination_id() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: cmsg.command_id
    //   Field type: int
    //   Offset (bits): 48
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'cmsg.command_id' is signed (false).
     */
    public static boolean isSigned_cmsg_command_id() {
        return false;
    }

    /**
     * Return whether the field 'cmsg.command_id' is an array (false).
     */
    public static boolean isArray_cmsg_command_id() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'cmsg.command_id'
     */
    public static int offset_cmsg_command_id() {
        return (48 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'cmsg.command_id'
     */
    public static int offsetBits_cmsg_command_id() {
        return 48;
    }

    /**
     * Return the value (as a int) of the field 'cmsg.command_id'
     */
    public int get_cmsg_command_id() {
        return (int)getUIntElement(offsetBits_cmsg_command_id(), 16);
    }

    /**
     * Set the value of the field 'cmsg.command_id'
     */
    public void set_cmsg_command_id(int value) {
        setUIntElement(offsetBits_cmsg_command_id(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'cmsg.command_id'
     */
    public static int size_cmsg_command_id() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'cmsg.command_id'
     */
    public static int sizeBits_cmsg_command_id() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: cmsg.argument
    //   Field type: int
    //   Offset (bits): 64
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'cmsg.argument' is signed (false).
     */
    public static boolean isSigned_cmsg_argument() {
        return false;
    }

    /**
     * Return whether the field 'cmsg.argument' is an array (false).
     */
    public static boolean isArray_cmsg_argument() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'cmsg.argument'
     */
    public static int offset_cmsg_argument() {
        return (64 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'cmsg.argument'
     */
    public static int offsetBits_cmsg_argument() {
        return 64;
    }

    /**
     * Return the value (as a int) of the field 'cmsg.argument'
     */
    public int get_cmsg_argument() {
        return (int)getUIntElement(offsetBits_cmsg_argument(), 16);
    }

    /**
     * Set the value of the field 'cmsg.argument'
     */
    public void set_cmsg_argument(int value) {
        setUIntElement(offsetBits_cmsg_argument(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'cmsg.argument'
     */
    public static int size_cmsg_argument() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'cmsg.argument'
     */
    public static int sizeBits_cmsg_argument() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: cmsg.cmd_seq_no
    //   Field type: int
    //   Offset (bits): 80
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'cmsg.cmd_seq_no' is signed (false).
     */
    public static boolean isSigned_cmsg_cmd_seq_no() {
        return false;
    }

    /**
     * Return whether the field 'cmsg.cmd_seq_no' is an array (false).
     */
    public static boolean isArray_cmsg_cmd_seq_no() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'cmsg.cmd_seq_no'
     */
    public static int offset_cmsg_cmd_seq_no() {
        return (80 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'cmsg.cmd_seq_no'
     */
    public static int offsetBits_cmsg_cmd_seq_no() {
        return 80;
    }

    /**
     * Return the value (as a int) of the field 'cmsg.cmd_seq_no'
     */
    public int get_cmsg_cmd_seq_no() {
        return (int)getUIntElement(offsetBits_cmsg_cmd_seq_no(), 16);
    }

    /**
     * Set the value of the field 'cmsg.cmd_seq_no'
     */
    public void set_cmsg_cmd_seq_no(int value) {
        setUIntElement(offsetBits_cmsg_cmd_seq_no(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'cmsg.cmd_seq_no'
     */
    public static int size_cmsg_cmd_seq_no() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'cmsg.cmd_seq_no'
     */
    public static int sizeBits_cmsg_cmd_seq_no() {
        return 16;
    }

}
