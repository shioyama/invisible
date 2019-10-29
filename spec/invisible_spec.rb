describe Invisible do
  it 'has a version number' do
    expect(Invisible::VERSION).not_to be nil
  end

  describe 'module extends Invisible' do
    let(:base_class) do
      Class.new do
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
    end

    it 'maintains original method visibility' do
      invisible_mod = Module.new do
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
      my_class = Class.new base_class
      my_class.include invisible_mod

      instance = my_class.new

      expect(instance.public_method).to eq('publicfoo')

      expect { instance.protected_method }.to raise_error(NoMethodError, /protected method `protected_method' called/)
      expect(instance.send(:protected_method)).to eq('protectedfoo')

      expect { instance.private_method }.to raise_error(NoMethodError, /private method `private_method' called/)
      expect(instance.send(:private_method)).to eq('privatefoo')
    end
  end
end
