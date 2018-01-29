# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab_build_output/version'

Gem::Specification.new do |spec|
  spec.name          = 'gitlab-build-output'
  spec.version       = GitLabBuildOutput::VERSION
  spec.authors       = ['Jacob Carlborg']
  spec.email         = ['doob@me.com']

  spec.summary       = 'Prints the output of a GitLab CI job.'
  spec.description   = 'Prints the output of a GitLab CI job.'
  spec.homepage      = 'https://github.com/jacob-carlborg/gitlab-build-output'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'git', '~> 1.3'
  spec.add_dependency 'gitlab', '~> 4.0'
  spec.add_dependency 'git_clone_url', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.48.1'
  spec.add_development_dependency 'pry', '~> 0.11'
  # spec.add_development_dependency 'pry-byebug', '~> 3.5'
  spec.add_development_dependency 'pry-rescue', '~> 1.4'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4.9'
end
