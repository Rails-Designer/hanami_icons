# frozen_string_literal: true

require "hanami/cli"

module HanamiIcons
  module CLI
    module Commands
      module Generate
        # Creates the Hanami Icons provider file (`config/providers/icons.rb`),
        # which Hanami auto-loads, and registers the view helpers in the app's
        # helpers module (`app/views/helpers.rb`).
        #
        # @api public
        # @since 0.1.0
        class Initializer < Hanami::CLI::Command
          desc "Create the Hanami Icons provider file"

          option :library, desc: "Choose a library"
          option :libraries, type: :array, default: [], desc: "Choose libraries"
          option :variants, type: :array, desc: "Only sync specific variants (e.g. solid outline)"
          option :destination, type: :string, default: HanamiIcons.configuration.icons_path, desc: "Specify destination folder for icons"

          PROVIDER = "config/providers/icons.rb"
          HELPERS = "app/views/helpers.rb"
          TEMPLATE = File.expand_path("../../templates/provider.rb", __dir__)

          # @param library [String, nil]
          # @param libraries [Array<String>]
          # @param variants [Array<String>, nil]
          # @param destination [String]
          #
          # @api public
          # @since 0.1.0
          def call(library: nil, libraries: [], variants: nil, destination: HanamiIcons.configuration.icons_path, **)
            copy_provider

            insert_default_configuration(selected_libraries(library, libraries).first)
            insert_icons_path(destination)
            setup_custom_libraries(selected_libraries(library, libraries), destination)

            register_helpers
          end

          private

          # @api private
          # @since 0.1.0
          def copy_provider
            return if fs.exist?(PROVIDER)

            fs.mkdir(File.dirname(PROVIDER))
            fs.write(PROVIDER, File.read(TEMPLATE))
          end

          # @api private
          # @since 0.1.0
          def insert_default_configuration(library)
            return if library.nil? || default_configuration_exists?

            insert_into_provider(
              indent("config.default_library = \"#{library}\"\n", 2),
              after: "HanamiIcons.configure do |config|\n"
            )
          end

          # @api private
          # @since 0.1.0
          def insert_icons_path(destination)
            return if destination == HanamiIcons.configuration.icons_path
            return if icons_path_exists?

            insert_into_provider(
              indent("# Default icons path\nconfig.icons_path = \"#{destination}\"\n", 2),
              after: "HanamiIcons.configure do |config|\n"
            )
          end

          # @api private
          # @since 0.1.0
          def setup_custom_libraries(libraries, destination)
            custom_libraries(libraries).each do |name|
              fs.mkdir(File.join(destination, name))

              insert_into_provider(
                "\n#{indent("config.custom_library :#{name}", 2)}",
                before: "end"
              )
            end
          end

          # @api private
          # @since 0.1.0
          def register_helpers
            unless fs.exist?(HELPERS)
              warn "[HanamiIcons] Could not find #{HELPERS}. Add `include HanamiIcons::Helpers::IconHelper` and `include HanamiIcons::Helpers::SpriteHelper` to your app's Views::Helpers module manually."

              return
            end

            content = fs.read(HELPERS)

            return if content.include?("include HanamiIcons::Helpers::IconHelper")

            line = content.lines.find { it.match?(/^\s*module\s+Helpers\b/) }

            unless line
              warn "[HanamiIcons] Could not find a `module Helpers` in #{HELPERS}. Add the helper includes manually."

              return
            end

            indentation = line[/^\s*/]
            includes = "\n#{indentation}  include HanamiIcons::Helpers::IconHelper\n#{indentation}  include HanamiIcons::Helpers::SpriteHelper"

            fs.write(HELPERS, content.sub(/^(\s*module\s+Helpers\b.*)$/, "\\1#{includes}"))
          end

          # @api private
          # @since 0.1.0
          def insert_into_provider(content, after: nil, before: nil)
            text = fs.read(PROVIDER)

            if after
              text = text.sub(after, "#{after}#{content}")
            elsif before
              text = text.sub(before, "#{content}\n#{before}")
            end

            fs.write(PROVIDER, text)
          end

          # @api private
          # @since 0.1.0
          def default_configuration_exists?
            line = /^\s*config\.default_library\s*=/

            fs.read(PROVIDER).lines.any? { it.match?(line) }
          end

          # @api private
          # @since 0.1.0
          def icons_path_exists?
            line = /^\s*config\.icons_path\s*=/

            fs.read(PROVIDER).lines.any? { it.match?(line) }
          end

          # @api private
          # @since 0.1.0
          def custom_libraries(libraries)
            libraries.reject { HanamiIcons.libraries.key?(it.to_sym) }
          end

          # @api private
          # @since 0.1.0
          def selected_libraries(library, libraries)
            [library, *libraries].compact.reject(&:empty?).map(&:downcase).uniq
          end

          # @api private
          # @since 0.1.0
          def indent(text, spaces)
            prefix = " " * spaces

            text.lines.map { "#{prefix}#{it}" }.join
          end
        end
      end
    end
  end
end
