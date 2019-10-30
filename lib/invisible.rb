require "invisible/version"

module Invisible
=begin

Extend any module with +Invisible+ and any methods the module overrides will
maintain their original visibility.

@example With +include+
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

  class MyClass < Base
    include WithFoo
  end

  instance = MyClass.new

  MyClass.public_method_defined?(:public_method)       #=> true
  instance.public_method                               #=> 'publicfoo'

  MyClass.protected_method_defined?(:protected_method) #=> true
  instance.protected_method                            # raises NoMethodError
  instance.send(:protected_method)                     #=> 'protectedfoo'

  MyClass.private_method_defined?(:private_method)     #=> true
  instance.private_method                              # raises NoMethodError
  instance.send(:private_method)                       #=> 'privatefoo'

@example With +prepend+
  Base.prepend WithFoo

  instance = Base.new

  Base.private_method_defined?(:private_method)        # true
  instance.private_method                              # raises NoMethodError
  instance.send(:private_method)                       #=> 'private with foo'

=end
  def append_features(base)
    private_methods, protected_methods = methods_to_hide(base)

    super

    base.send(:private, *private_methods)
    base.send(:protected, *protected_methods)
  end

  def prepend_features(base)
    private_methods, protected_methods = methods_to_hide(base)
    return super if private_methods.empty? && protected_methods.empty?

    mod = dup

    if name
      return if base.const_defined?(mod_name = "Invisible#{name}")
      base.const_set(mod_name, mod)
    end

    mod.send(:private, *private_methods)
    mod.send(:protected, *protected_methods)
    base.prepend mod
  end

  private

  def methods_to_hide(mod)
    [(instance_methods - private_instance_methods)   & mod.private_instance_methods,
     (instance_methods - protected_instance_methods) & mod.protected_instance_methods]
  end
end
