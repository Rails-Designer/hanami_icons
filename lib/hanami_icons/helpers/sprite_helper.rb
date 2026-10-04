# frozen_string_literal: true

require "icons/sprite_icon"

module HanamiIcons
  module Helpers
    # View helpers for rendering SVG icons from a sprite.
    #
    # @api public
    # @since 0.1.0
    module SpriteHelper
      extend self

      # Renders an SVG icon referencing a sprite symbol.
      #
      # @param name [String] The icon name
      # @param library [String] The icon library (defaults to HanamiIcons configuration)
      # @param from [String] Syntactic sugar for a cleanly readable view layer API
      # @param variant [String] The icon variant (optional)
      # @param sprite_location [String] Override URL for the sprite file (optional)
      # @param arguments [Hash] Additional attributes including class, data, stroke_width, etc.
      # @return [Hanami::View::HTML::SafeString] An HTML-safe SVG string
      #
      # @example
      #   <%= sprite_icon "chevron-down" %>
      #   <%= sprite_icon "check", sprite_location: "/sprite.svg" %>
      #
      # @api public
      # @since 0.1.0
      def sprite_icon(name, library: nil, from: library, variant: nil, sprite_location: nil, **arguments)
        Icons::SpriteIcon.new(
          name: name,
          library: from || library || HanamiIcons.configuration.default_library,
          variant: variant,
          sprite_location: sprite_location,
          arguments: arguments
        ).svg.html_safe
      end

      # Returns the inline SVG sprite containing all symbols.
      #
      # @param icons [Array<String>, nil] Optional list of icon names (defaults to all configured icons)
      # @param library [String, nil] Optional library to use for icons
      # @param variant [String, nil] Optional variant to use for icons
      # @return [Hanami::View::HTML::SafeString] An HTML-safe SVG string
      #
      # @example
      #   <%= icons_sprite %>
      #   <%= icons_sprite ["check", "search"], library: "lucide" %>
      #
      # @api public
      # @since 0.1.0
      def icons_sprite(icons = nil, library: nil, variant: nil)
        Icons::Sprite.new(icons: icons, library: library, variant: variant).svg.html_safe
      end
    end
  end
end
