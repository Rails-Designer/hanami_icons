# frozen_string_literal: true

require "test_helper"

class HanamiIconsTest < Minitest::Test
  def test_has_a_version_number
    assert HanamiIcons::VERSION
  end

  def test_configure_yields_the_icons_configuration
    HanamiIcons.configure do |config|
      config.default_library = :lucide
    end

    assert_equal :lucide, HanamiIcons.configuration.default_library
  end

  def test_configuration_returns_the_icons_configuration
    assert_instance_of Icons::Configuration, HanamiIcons.configuration
  end

  def test_configuration_initializes_when_unset
    Icons.configuration = nil

    assert_instance_of Icons::Configuration, HanamiIcons.configuration
    refute_nil Icons.configuration
  end

  def test_sync_can_be_initialized_when_configuration_was_unset
    Icons.configuration = nil
    HanamiIcons.configuration

    assert_instance_of Icons::Sync, Icons::Sync.new(:heroicons)
  end

  def test_config_is_an_alias_for_configuration
    assert_same HanamiIcons.configuration, HanamiIcons.config
  end

  def test_libraries_returns_registered_icon_libraries
    assert HanamiIcons.libraries.key?(:heroicons)
  end

  def test_registers_the_generate_icons_commands
    HanamiIcons.register_cli_commands!

    {
      ["generate", "icons"] => HanamiIcons::CLI::Commands::Generate::Icons,
      ["generate", "icons:initializer"] => HanamiIcons::CLI::Commands::Generate::Initializer,
      ["generate", "icons:sync"] => HanamiIcons::CLI::Commands::Generate::Sync,
      ["generate", "icons:sprite"] => HanamiIcons::CLI::Commands::Generate::Sprite
    }.each do |path, command|
      assert_equal command, Hanami::CLI.get(path).command
    end
  end
end
