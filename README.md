# Invisible

[![Gem Version](https://badge.fury.io/rb/invisible.svg)][gem]
[![Build Status](https://travis-ci.com/shioyama/invisible.svg?branch=master)][travis]

[gem]: https://rubygems.org/gems/invisible
[travis]: https://travis-ci.com/shioyama/invisible

Public? Private? Protected? Who cares! I just wanna monkey patch that shit!

No fear: Invisible has your back! In a dozen lines of code, this little gem does away with the problem of maintaining original method visibility, so you can get on with your monkey-patching mayhem.

## Usage

Suppose you are defining a module which will override a bunch of methods from some class (or module). Simply `extend Invisible` and you can ignore checking whether those methods are public, protected or private -- Invisible will take care of that for you.

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
module WithFoo
  extend Invisible

  def public_method
    super + ' with foo'
  end

  def protected_method
    super + ' with foo'
  end

  def private_method
    super + ' with foo'
  end
end
```

Normally, without Invisible, we would have just made methods that were previously `private` or `protected` become `public`. But Invisible checks the original visibility and ensures that when the module is included, methods which were originally private or protected stay that way.

```ruby
class MyClass < Base
  include WithFoo
end

instance = MyClass.new

MyClass.public_method_defined?(:public_method)       #=> true
instance.public_method                               #=> 'public with foo'

MyClass.protected_method_defined?(:protected_method) #=> true
instance.protected_method                            # raises NoMethodError
instance.send(:protected_method)                     #=> 'protected with foo'

MyClass.private_method_defined?(:private_method)     #=> true
instance.private_method                              # raises NoMethodError
instance.send(:private_method)                       #=> 'private with foo'
```

Also works with `prepend`:

```ruby
Base.prepend WithFoo

instance = Base.new

Base.private_method_defined?(:private_method)        # true
instance.private_method                              # raises NoMethodError
instance.send(:private_method)                       #=> 'private with foo'
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
