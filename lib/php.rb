require 'strscan'

module PHP


  class Serializer

    # == PHP \ Serializer
    #
    # Provides and interface to convert PHP serialized strings into ruby structures
    # and ruby strctures back into PHP serialized strings
    #
    # There are two class methods +serialize+ and +unserialize+ that does exactly 
    # what you think it does
    #
    # This is still alpha at an alpha stage, serialize is still unimplemented, and doesn't
    # parse references within serialized structures
    #
    #
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
      when 'b'
        boolean
      when 'd'
        double
      when 'i'
        whole_number
      when 'a'
        array
      when 'O'
        object
      else
        raise "Invalid input #{ type } at #{ scanner.pos }"
      end

    end

    def object
      result = { }
      klass_name, slots = nil, nil

      # scan class name
      scanner.scan( /O:(\d+):"/ )
      klass_name = scanner.peek( scanner[ 1 ].to_i )
      scanner.pos = scanner.pos + scanner[ 1 ].to_i

      scanner.scan( /":(\d+):\{/ )
      slots = scanner[ 1 ].to_i

      slots.times do 
        key, value = parse!, parse!
        result[ key ] = value
      end

      result[ '__class' ] = klass_name

      result

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

    def boolean
      scanner.scan( /b:(\d);/ )
      scanner[ 1 ].to_i == true
    end

    def double
      scanner.scan( /d:(\d+\.\d+(?:E[-+]\d+)?);/ )
      scanner[ 1 ].to_f
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

