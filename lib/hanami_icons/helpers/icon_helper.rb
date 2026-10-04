# frozen_string_literal: true

require "base64"

module HanamiIcons
  module Helpers
    # View helpers for rendering inline SVG icons.
    #
    # @api public
    # @since 0.1.0
    module IconHelper
      extend self

      # Renders an SVG icon.
      #
      # @param name [String] The icon name
      # @param library [String] The icon library (defaults to HanamiIcons configuration)
      # @param from [String] Syntactic sugar for a cleanly readable view layer API
      # @param variant [String] The icon variant (optional)
      # @param arguments [Hash] Additional attributes including class, data, stroke_width, etc.
      # @return [Hanami::View::HTML::SafeString] An HTML-safe SVG string
      #
      # @example
      #   <%= icon "chevron-down" %>
      #   <%= icon "search", class: "text-blue-500" %>
      #
      # @api public
      # @since 0.1.0
      def icon(name, library: HanamiIcons.configuration.default_library, from: library, variant: nil, **arguments)
        Icons::Icon.new(
          name: name,
          library: from || library,
          variant: variant,
          arguments: arguments
        ).svg.html_safe
      end

      # Returns a base64-encoded data URI for an icon.
      #
      # @param name [String] The icon name
      # @param library [String] The icon library (defaults to HanamiIcons configuration)
      # @param from [String] Syntactic sugar for a cleanly readable view layer API
      # @param variant [String] The icon variant (optional)
      # @param arguments [Hash] Additional attributes including class, data, stroke_width, etc.
      # @return [String] A base64-encoded data URI (e.g. "data:image/svg+xml;base64,...")
      #
      # @example
      #   <%= encoded_icon "chevron-down" %>
      #
      # @api public
      # @since 0.1.0
      def encoded_icon(name, library: HanamiIcons.configuration.default_library, from: library, variant: nil, **arguments)
        svg = Icons::Icon.new(
          name: name,
          library: from || library,
          variant: variant,
          arguments: arguments
        ).svg

        "data:image/svg+xml;base64,#{Base64.strict_encode64(svg)}"
      end
    end
  end
end
