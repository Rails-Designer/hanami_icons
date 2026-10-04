# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "hanami_icons"
require "hanami/view"
require "minitest/autorun"
require "tmpdir"

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |file| require file }

Generate = HanamiIcons::CLI::Commands::Generate

module HanamiIconsTestHelper
  def setup
    @original_configuration = Icons.configuration

    Icons.reset_registered_libraries
    Icons.configuration = Icons::Configuration.new
    Icons.configure do |config|
      config.base_path = Pathname.new(File.expand_path("fixtures", __dir__))
      config.default_library = :heroicons
    end
  end

  def teardown
    Icons.configuration = @original_configuration
    Icons.reset_registered_libraries
  end
end

class Minitest::Test
  include HanamiIconsTestHelper
end
