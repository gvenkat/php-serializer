require 'strscan'


module PHP


  class Serializer

    attr_accessor :buffer
    attr_accessor :scanner

    class << self 

      def serialize text=''
        raise ArgumentError, "Nothing to serialize" if text.empty? or text.nil?
      end


      def unserialize text
        self.new_from_string( text ).result
      end


      def new_from_string buffer
        new( buffer )
      end

    end


    def initialize buffer
      @buffer = buffer
      @scanner = StringScanner.new( buffer )
    end


    def result
      parse!
    end


    def parse!

      type = scanner.peek( 1 )

      case type 
      when 's'
        string
      when 'N'
        null
      when 'i'
        whole_number
      when 'a'
        array
      else
        raise "Invalid input #{ type } at #{ scanner.pos }"
      end

    end

    def array
      result = { } 

      scanner.scan( /a:(\d+):\{/)

      scanner[ 1 ].to_i.times do
        key, value = parse!, parse!
        result[ key ] = value
      end

      # finish up
      scanner.scan( /\}/ )

      result

    end

    def null
      # move forward
      scanner.scan( /N;/ )
      nil
    end

    def whole_number
      scanner.scan( /i:(\d+);/ )
      scanner[ 1 ].to_i
    end

    def string
      scanner.scan( /s:(\d+):"/ )
      result = scanner.peek( scanner[ 1 ].to_i )
      scanner.pos = scanner.pos + scanner[ 1 ].to_i
      scanner.scan( /";/ )

      result

    end

  end
end

