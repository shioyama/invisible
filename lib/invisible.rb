require "invisible/version"

module Invisible
=begin

Extend any module with +Invisible+ and any methods the module overrides will
maintain their original visibility.

@example
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

=end
  def append_features(base)
    private_methods   = instance_methods.select { |m| base.private_method_defined? m }
    protected_methods = instance_methods.select { |m| base.protected_method_defined? m }

    super

    private_methods.each   { |method_name| base.class_eval { private method_name } }
    protected_methods.each { |method_name| base.class_eval { protected method_name } }
  end
end
