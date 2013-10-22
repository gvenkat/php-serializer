# A very simple PHP serializer and unserializer 

I'm just trying my hand at trying to parse PHP serialized data structures into
ruby structures and back. PHP has no distinction between arrays and hashes, so all arrays
are hashes in here. Also, PHP Also serializes objects with class names, so a quick struct is
created as class and attributes are placed in that object

Its still work in progress.

```ruby
  require 'php'

  result = PHP::Serializer.unserialize( serialized_php )

  serialized_string = PHP::Serializer.serialize( ruby_object )

```

