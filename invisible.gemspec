lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "invisible/version"

Gem::Specification.new do |spec|
  spec.name          = "invisible"
  spec.version       = Invisible::VERSION
  spec.authors       = ['Chris Salzberg']
  spec.email         = ['chris@dejimata.com']

  spec.summary       = %q{Override methods while maintaining their original visibility.}
  spec.homepage      = 'https://github.com/shioyama/invisible'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/shioyama/invisible'
  spec.metadata['changelog_uri'] = 'https://github.com/shioyama/invisible/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files        = Dir['{lib/**/*,[A-Z]*}']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
