# frozen_string_literal: true

require "zeitwerk"
require "icons"
require "hanami/cli"

module HanamiIcons
  # @api private
  # @since 0.1.0
  def self.gem_loader
    @gem_loader ||= Zeitwerk::Loader.new.tap do |loader|
      root = __dir__

      loader.tag = "hanami-icons"
      loader.inflector = Zeitwerk::GemInflector.new("#{root}/hanami_icons.rb")
      loader.inflector.inflect("cli" => "CLI")
      loader.push_dir(root)

      loader.ignore("#{root}/hanami_icons.rb", "#{root}/hanami_icons/version.rb")
    end
  end

  gem_loader.setup

  require_relative "hanami_icons/version"

  class << self
    # @yield [config] Yields the Icons configuration
    # @yieldparam config [Icons::Configuration]
    #
    # @api public
    # @since 0.1.0
    def configure(&block) = Icons.configure(&block)

    # @return [Icons::Configuration]
    #
    # @api public
    # @since 0.1.0
    def configuration = Icons.config

    alias_method :config, :configuration

    # @return [Hash{Symbol => Icons::Library}] The registered icon libraries
    #
    # @api public
    # @since 0.1.0
    def libraries = Icons.libraries
  end

  if Hanami::CLI.within_hanami_app?
    Hanami::CLI.register "generate icons", CLI::Commands::Generate::Icons
    Hanami::CLI.register "generate icons:initializer", CLI::Commands::Generate::Initializer
    Hanami::CLI.register "generate icons:sync", CLI::Commands::Generate::Sync
    Hanami::CLI.register "generate icons:sprite", CLI::Commands::Generate::Sprite
  end
end
