lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'changefu/version'

Gem::Specification.new do |s|
  #
  ## INFORMATION
  #
  s.name        = 'changefu'
  s.version     = Changefu.version
  s.summary     = 'A tool for keep a changelog'
  s.description = 'Command-line utility that help you to keep a good changelog'
  s.homepage    = 'https://github.com/javierav/changefu'
  s.license     = 'MIT'

  #
  ## AUTHOR
  #
  s.author = 'Javier Aranda'
  s.email  = 'javier.aranda.varo@gmail.com'

  #
  ## METADATA
  #
  s.metadata = {
    'source_code_uri' => "https://github.com/javierav/changefu/tree/v#{s.version}",
    'changelog_uri' => "https://github.com/javierav/changefu/blob/v#{s.version}/CHANGELOG.md",
    'homepage_uri' => s.homepage
  }

  #
  ## GEM
  #
  s.files        = Dir['lib/**/*', 'exe/*', 'LICENSE', 'Rakefile', 'README.md', 'Gemfile*']
  s.require_path = 'lib'
  s.bindir       = 'exe'
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }

  #
  ## DOCUMENTATION
  #
  s.extra_rdoc_files = %w[LICENSE README.md]
  s.rdoc_options     = ['--charset=UTF-8']

  #
  ## REQUIREMENTS
  #
  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = Changefu.required_ruby_version

  #
  ## DEPENDENCIES
  #
  s.add_dependency 'pastel', '~> 0.7', '>= 0.7.3'
  s.add_dependency 'thor', '~> 0.20', '>= 0.20.3'
  s.add_dependency 'tty-table', '~> 0.11', '>= 0.11.0'
end
