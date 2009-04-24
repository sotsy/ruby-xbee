module XBee
  module Frame
    def Frame.checksum(data)
      0xFF - (data.unpack("c*").inject(0) { |sum, byte| (sum + byte) & 0xFF })
    end

    def Frame.factory(source_io)
      stray_bytes = []
      source_io.read_timeout = 10000
      until (start_delimiter = source_io.readchar) == 0x7e
        puts "Stray byte 0x%x" % start_delimiter
        stray_bytes << start_delimiter
      end
      puts "Got some stray bytes for ya: #{stray_bytes.map {|b| "0x%x" % b} .join(", ")}" unless stray_bytes.empty?
      length = source_io.read(2).unpack("n").first
      data = source_io.read(length) || [0,0]
      sent_checksum = source_io.getc
      unless sent_checksum == Frame.checksum(data)
        raise "Bad checksum - data discarded"
      end
      ReceivedFrame.instantiate_with(data)
    end

    class Base
      attr_accessor :api_identifier, :cmd_data

      def api_identifier ; 0x00 ; end

      def cmd_data ; "" ; end

      def length ; data.length ; end

      def data
        Array(api_identifier).pack("c") + cmd_data
      end

      def _dump
        raise "Too much data (#{self.length} bytes) to fit into one frame!" if (self.length > 0xFFFF)
        [0x7E, length].pack("cn") + data + [Frame.checksum(data)].pack("c")
      end
    end

    class ReceivedFrame < Base
      def ReceivedFrame.instantiate_with(data)
        case data[0]
        when 0x8A : ModemStatus.new(data)
        when 0x88 : ATCommandResponse.new(data)
        when 0x97 : RemoteCommandResponse.new(data)
        when 0x8B : TransmitStatus.new(data)
        when 0x90 : ReceivePacket.new(data)
        when 0x91 : ExplicitRxIndicator.new(data)
        else ReceivedFrame.new(data)
        end
      end

      def initialize(frame_data)
        raise "Frame data must be an enumerable type" unless frame_data.kind_of?(Enumerable)
        self.api_identifier = frame_data[0]
        self.cmd_data = frame_data[1..-1]
      end
    end

    class ModemStatus < ReceivedFrame
      def api_identifier ; 0x8A ; end

      attr_accessor :status

      def initialize(data = nil)
        super(data) && (yield self if block_given?)
      end

      def modem_statuses
        [
          [1, :Hardware_Reset],
          [2, :Watchdog_Timer_Reset],
          [3, :Associated],
        ]
      end

      def cmd_data=(data_string)
        status_byte = data_string.unpack("c")
        # update status ivar for later use
        self.status = case status_byte
        when 1..3 : modem_statuses.assoc(status_byte)
        else raise "ModemStatus frame appears to include an invalid status value: #{data_string}"
        end
        #actually assign and move along
        @cmd_data = data_string
      end
    end

    class ATCommand < Base
      def api_identifier ; 0x08 ; end

      attr_accessor :frame_id, :at_command, :parameter_value, :parameter_pack_string

      def initialize(at_command, frame_id = nil, parameter_value = nil)
        self.frame_id = frame_id
        self.at_command = at_command # TODO: Check for valid AT command codes here
        self.parameter_value = parameter_value
        self.parameter_pack_string = parameter_pack_string
        yield self if block_given?
      end

      def cmd_data=(data_string)
        self.frame_id, self.at_command, self.parameter_value = data_string.unpack("ca2#{parameter_pack_string}")
      end

      def cmd_data
        [frame_id, at_command, parameter_value].pack("ca2#{parameter_pack_string}")
      end
    end

    class ATCommandQueueParameterValue < ATCommand
      def api_identifier ; 0x09 ; end
    end

    class ATCommandResponse < ReceivedFrame
      def api_identifier ; 0x88 ; end
      attr_accessor :frame_id, :at_command, :status, :retrieved_value

      def initialize(data = nil)
        super(data) && (yield self if block_given?)
      end

      def command_statuses
        [:OK, :ERROR, :Invalid_Command, :Invalid_Parameter]
      end

      def cmd_data=(data_string)
        self.frame_id, self.at_command, status_byte, self.retrieved_value = data_string.unpack("ca2ca*")
        self.status = case status_byte
        when 0..3 : command_statuses[status_byte]
        else raise "AT Command Response frame appears to include an invalid status: 0x%x" % status_byte
        end
        #actually assign and move along
        @cmd_data = data_string
      end
    end

    class RemoteCommandRequest < Base
      def api_identifier ; 0x17 ; end
    end

    class RemoteCommandResponse < ReceivedFrame
      def api_identifier ; 0x97 ; end
    end

    class TransmitRequest < Base
      def api_identifier ; 0x10 ; end
    end

    class ExplicitAddressingCommand < Base
      def api_identifier ; 0x11 ; end
    end

    class TransmitStatus < ReceivedFrame
      def api_identifier ; 0x8B ; end
    end

    class ReceivePacket < ReceivedFrame
      def api_identifier ; 0x90 ; end
    end

    class ExplicitRxIndicator < ReceivedFrame
      def api_identifier ; 0x91 ; end
    end
  end
end