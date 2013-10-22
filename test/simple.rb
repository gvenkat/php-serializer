require 'test/unit'
require 'php'


class Hash
  def compare_intersection(other)
    (self.keys & other.keys).all? {|k| self[k] == other[k]}
  end
end

class TestUnserializeSimple < Test::Unit::TestCase 

  def test_simple_string
    dictionary = {
      "moodle" => 's:6:"moodle";',
      "Hello World!" => 's:12:"Hello World!";',
      "Hello '\" \t\t\t World!" => %q(s:19:"Hello '" 			 World!";)
    }

    dictionary.each do |key, value|
      result = PHP::Serializer.unserialize( value ) 
      assert result.instance_of? String
      assert result.size == key.size 
      assert result == key 
    end
  end

  def test_null
    assert PHP::Serializer.unserialize( 'N;' ).nil?
  end

  def test_whole_number
    assert PHP::Serializer.unserialize( 'i:25;' ) == 25
  end

  def test_simple_array
    test = 'a:2:{i:0;s:5:"hello";i:1;s:6:"Foodle";}'
    result = { '0' => "hello", '1' => "Foodle" }

    assert PHP::Serializer.unserialize( test ).compare_intersection( result )
  end

end
