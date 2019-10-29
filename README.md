# Invisible

Invisible allows you to quickly define method overrides in a module without worrying about messing up their original visibility. It does this in less than ten lines of code.

## Usage

Suppose you are defining a module which will override a bunch of methods from some class (or module). Simply `extend Invisible` and you can ignore checking whether those methods are public, protected or private -- Invisible will take care of that for you!

Suppose this is the class we are overriding:

```ruby
class Base
  def public_method
    'public'
  end

  protected

  def protected_method
    'protected'
  end

  private

  def private_method
    'private'
  end
end
```

We don't want to care about whether the methods are private or whatever. So we define our module like so:

```ruby
module Foo
  extend Invisible

  def public_method
    super + 'foo'
  end

  def protected_method
    super + 'foo'
  end

  def private_method
    super + 'foo'
  end
end
```

Normally, without Invisible, we would have just made methods that were previously `private` become `public`. But Invisible checks the original visibility and ensures that when the module is included, methods which were originally private or protected stay that way.

```ruby
class MyClass < Base
  include Foo
end

instance = MyClass.new

instance.public_method_defined?(:public_method)       #=> true
instance.public_method                                #=> 'publicfoo'

instance.protected_method_defined?(:protected_method) #=> true
instance.protected_method                             # raises NoMethodError
instance.send(:protected_method)                      #=> 'protectedfoo'

instance.private_method_defined?(:private_method)     #=> true
instance.private_method                               # raises NoMethodError
instance.send(:private_method)                        #=> 'privatefoo'
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
