# frozen_string_literal: true

require_relative "lib/hanami_icons/version"

Gem::Specification.new do |spec|
  spec.name = "hanami_icons"
  spec.version = HanamiIcons::VERSION
  spec.authors = ["Rails Designer"]
  spec.email = ["devs@railsdesigner.com"]

  spec.summary = "Add any icon library to a Hanami app"
  spec.description = "Add any icon library to a Hanami app, from Heroicons, to Lucide to Tabler (and others). Hanami Icons is library-agnostic, so you can add any library while using the same interface."
  spec.homepage = "https://railsdesigner.com/open-source/hanami-icons/"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rails-Designer/hanami_icons"
  spec.metadata["changelog_uri"] = "https://github.com/Rails-Designer/hanami_icons/releases"
  spec.metadata["bug_tracker_uri"] = "https://github.com/Rails-Designer/hanami_icons/issues"
  spec.metadata["documentation_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*", "Rakefile", "README.md", "LICENSE.txt", "hanami_icons.gemspec", "Gemfile"]

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.3"

  spec.add_dependency "base64"
  spec.add_dependency "hanami-view", "~> 3.0"
  spec.add_dependency "hanami-cli", "~> 3.0"
  spec.add_dependency "icons", "~> 0.11.0"
end
