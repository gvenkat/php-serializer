# A very simple PHP serializer and unserializer 

I'm just trying my hand at trying to parse PHP serialized data structures into
ruby structures and back. PHP has no distinction between arrays and hashes, so all arrays
are hashes in here. Also, PHP Also serializes objects with class names, These are unserialized as
hashes with all properties contained in the object, additionally ```__class``` property is added 
containing the class to which the PHP object belongs to

## TODO:
  - Doesn't parse floating point numbers
  - Doesn't serialize yet

Its still work in progress.

```ruby
  require 'php'

  result = PHP::Serializer.unserialize( serialized_php )

  serialized_string = PHP::Serializer.serialize( ruby_object )

```

