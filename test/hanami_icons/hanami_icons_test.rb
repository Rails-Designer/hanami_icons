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

  def test_config_is_an_alias_for_configuration
    assert_same HanamiIcons.configuration, HanamiIcons.config
  end

  def test_libraries_returns_registered_icon_libraries
    assert HanamiIcons.libraries.key?(:heroicons)
  end
end
