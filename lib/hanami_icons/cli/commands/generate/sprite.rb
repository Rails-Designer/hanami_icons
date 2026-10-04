# frozen_string_literal: true

require "hanami/cli"

module HanamiIcons
  module CLI
    module Commands
      module Generate
        # Writes a static SVG sprite file for use with `sprite_icon`.
        #
        # @api public
        # @since 0.1.0
        class Sprite < Hanami::CLI::Command
          desc "Generate a static SVG sprite file"

          option :output, type: :string, default: "public/sprite.svg", desc: "Where to write the sprite file"

          # @param output [String]
          #
          # @api public
          # @since 0.1.0
          def call(output: "public/sprite.svg", **)
            fs.mkdir(File.dirname(output))
            fs.write(output, ::Icons::Sprite.new.svg)

            location = "/#{File.basename(output)}"

            out.puts "Sprite written to #{output}"
            out.puts "Set config.default_sprite_location = \"#{location}\" in config/providers/icons.rb to use it."
          end
        end
      end
    end
  end
end
