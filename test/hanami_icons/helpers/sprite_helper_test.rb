# frozen_string_literal: true

require "test_helper"

class SpriteHelperTest < Minitest::Test
  include HanamiIcons::Helpers::SpriteHelper

  def setup
    super

    Icons.configure do |config|
      config.default_variant = "outline"
    end
  end

  def test_helper_constant_is_defined
    assert defined?(HanamiIcons::Helpers::SpriteHelper)
  end

  def test_sprite_icon_renders_an_svg_use_element
    result = sprite_icon("academic-cap")

    assert_match(/<svg/, result)
    assert_match(%r{<use href="#heroicons_outline_academic-cap"></use>}, result)
  end

  def test_sprite_icon_with_library_and_variant
    result = sprite_icon("academic-cap", library: "heroicons", variant: "mini")

    assert_match(%r{#heroicons_mini_academic-cap}, result)
  end

  def test_sprite_icon_supports_from_as_a_library_alias
    result = sprite_icon("academic-cap", library: "lucide", from: "heroicons")

    assert_match(%r{#heroicons_outline_academic-cap}, result)
    refute_match(/\sfrom=/, result)
  end

  def test_sprite_icon_merges_extra_arguments_into_the_svg
    result = sprite_icon("academic-cap", class: "size-6", data: {controller: "swap"}, stroke_width: 2)

    assert_match(/class="size-6"/, result)
    assert_match(/data-controller="swap"/, result)
    assert_match(/stroke-width="2"/, result)
  end

  def test_sprite_icon_with_sprite_location
    result = sprite_icon("academic-cap", sprite_location: "/sprite.svg")

    assert_match(%r{<use href="/sprite.svg#heroicons_outline_academic-cap"></use>}, result)
  end

  def test_icons_sprite_generates_inline_svg_with_symbols
    result = icons_sprite(["academic-cap"], library: "heroicons", variant: "outline")

    assert_match(/<svg xmlns/, result)
    assert_match(/<symbol id="heroicons_outline_academic-cap"/, result)
  end

  def test_icons_sprite_with_no_arguments_uses_configured_icons
    Icons.configure do |config|
      config.sprite = {
        heroicons: {
          outline: ["academic-cap"]
        }
      }
    end

    assert_match(/<symbol id="heroicons_outline_academic-cap"/, icons_sprite)
  end

  def test_helpers_return_html_safe_strings
    assert_instance_of Hanami::View::HTML::SafeString, sprite_icon("academic-cap")
    assert_instance_of Hanami::View::HTML::SafeString, icons_sprite(["academic-cap"])
  end
end
