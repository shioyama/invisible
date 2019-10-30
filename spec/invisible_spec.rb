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
    let(:invisible_mod) do
      Module.new do
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
    end

    context 'including module' do
      it 'maintains original method visibility' do
        my_class = Class.new base_class
        my_class.include invisible_mod

        instance = my_class.new

        expect(instance.public_method).to eq('public with foo')

        expect { instance.protected_method }.to raise_error(NoMethodError, /protected method `protected_method' called/)
        expect(instance.send(:protected_method)).to eq('protected with foo')

        expect { instance.private_method }.to raise_error(NoMethodError, /private method `private_method' called/)
        expect(instance.send(:private_method)).to eq('private with foo')
      end
    end

    context 'prepending module' do
      it 'maintains original method visibility' do
        expect { base_class.prepend invisible_mod }.not_to change(invisible_mod, :instance_methods)
        instance = base_class.new

        expect(instance.public_method).to eq('public with foo')

        expect { instance.protected_method }.to raise_error(NoMethodError, /protected method `protected_method' called/)
        expect(instance.send(:protected_method)).to eq('protected with foo')

        expect { instance.private_method }.to raise_error(NoMethodError, /private method `private_method' called/)
        expect(instance.send(:private_method)).to eq('private with foo')
      end

      it 'gives prepended module a name if both prepending class and module have names' do
        stub_const('Foo', base_class)
        stub_const('Bar', invisible_mod)

        base_class.prepend invisible_mod

        expect(base_class.ancestors.first.name).to eq('Foo::InvisibleBar')
      end

      it 'only prepends module once if mod has a name' do
        stub_const('Bar', invisible_mod)

        base_class.prepend invisible_mod

        expect { base_class.prepend invisible_mod }.not_to change { base_class.ancestors.size }
      end

      it 'prepends original module if visibility for all methods match prepending class' do
        mod = Module.new do
          protected

          def protected_method
            super + ' with bar'
          end

          private

          def private_method
            super + ' with bar'
          end
        end

        base_class.prepend mod

        expect { base_class.prepend mod }.not_to change { base_class.ancestors.size }
        expect(base_class.ancestors.first).to eq(mod)
      end
    end
  end
end
