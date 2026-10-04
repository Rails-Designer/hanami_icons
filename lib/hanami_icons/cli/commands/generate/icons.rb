# frozen_string_literal: true

require "hanami/cli"

module HanamiIcons
  module CLI
    module Commands
      module Generate
        # Installs Hanami Icons by creating the provider file, wiring the view
        # helpers and syncing the chosen libraries.
        #
        # @api public
        # @since 0.1.0
        class Icons < Hanami::CLI::Command
          desc "Install Hanami Icons with the chosen libraries"

          option :library, desc: "Choose a library"
          option :libraries, type: :array, default: [], desc: "Choose libraries"
          option :variants, type: :array, desc: "Only sync specific variants (e.g. solid outline)"
          option :destination, type: :string, default: HanamiIcons.configuration.icons_path, desc: "Specify destination folder for icons"
          option :skip_sync, type: :boolean, default: false

          # @param library [String, nil]
          # @param libraries [Array<String>]
          # @param variants [Array<String>, nil]
          # @param destination [String]
          # @param skip_sync [Boolean]
          #
          # @api public
          # @since 0.1.0
          def call(library: nil, libraries: [], variants: nil, destination: HanamiIcons.configuration.icons_path, skip_sync: false, **)
            run_initializer(library: library, libraries: libraries, variants: variants, destination: destination)

            if !skip_sync && selected_libraries(library, libraries).any?
              run_sync(library: library, libraries: libraries, variants: variants)
            end
          end

          private

          # @api private
          # @since 0.1.0
          def run_initializer(library:, libraries:, variants:, destination:)
            Generate::Initializer.new(out: out, err: err, fs: fs).call(
              library: library,
              libraries: libraries,
              variants: variants,
              destination: destination
            )
          end

          # @api private
          # @since 0.1.0
          def run_sync(library:, libraries:, variants:)
            Generate::Sync.new(out: out, err: err, fs: fs).call(
              library: library,
              libraries: libraries,
              variants: variants
            )
          end

          # @api private
          # @since 0.1.0
          def selected_libraries(library, libraries)
            [library, *libraries].compact.reject(&:empty?).map(&:downcase).uniq
          end
        end
      end
    end
  end
end
