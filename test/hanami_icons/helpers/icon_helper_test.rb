# frozen_string_literal: true

require "test_helper"

class IconHelperTest < Minitest::Test
  include HanamiIcons::Helpers::IconHelper

  def test_helper_constant_is_defined
    assert defined?(HanamiIcons::Helpers::IconHelper)
  end

  def test_helper_can_be_included_in_classes
    test_class = Class.new { include HanamiIcons::Helpers::IconHelper }

    assert test_class.new.respond_to?(:icon)
    assert test_class.new.respond_to?(:encoded_icon)
  end

  def test_returns_an_icon_svg
    assert_match(/\A<svg.*<\/svg>\z/m, icon("academic-cap"))
  end

  def test_returns_html_safe_string
    assert_instance_of Hanami::View::HTML::SafeString, icon("academic-cap")
  end

  def test_supports_from_as_a_library_alias
    assert_match(/\A<svg/, icon("academic-cap", from: "heroicons"))
  end

  def test_supports_a_variant
    assert_match(/data-slot="icon"/, icon("academic-cap", variant: "mini"))
  end

  def test_supports_an_explicit_library
    assert_match(/\A<svg/, icon("apple", library: "simple"))
  end

  def test_merges_extra_arguments_into_the_svg
    result = icon("academic-cap", class: "size-6", data: {controller: "swap"}, stroke_width: 2)

    assert_match(/class="size-6"/, result)
    assert_match(/data-controller="swap"/, result)
    assert_match(/stroke-width="2"/, result)
  end

  def test_encoded_icon_returns_a_base64_data_uri
    result = encoded_icon("academic-cap")

    assert result.start_with?("data:image/svg+xml;base64,")
  end

  def test_encoded_icon_encodes_the_svg
    result = encoded_icon("academic-cap")

    assert_includes Base64.strict_decode64(result.delete_prefix("data:image/svg+xml;base64,")), "<svg"
  end
end
