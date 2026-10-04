# frozen_string_literal: true

require "hanami/cli"

module HanamiIcons
  module CLI
    module Commands
      module Generate
        # Syncs the chosen icon libraries from their respective git repositories.
        #
        # @api public
        # @since 0.1.0
        class Sync < Hanami::CLI::Command
          desc "Sync the chosen icon libraries from their respective git repos"

          option :library, desc: "Choose a library"
          option :libraries, type: :array, default: [], desc: "Choose libraries"
          option :variants, type: :array, desc: "Only sync specific variants (e.g. solid outline)"

          # @param library [String, nil]
          # @param libraries [Array<String>]
          # @param variants [Array<String>, nil]
          #
          # @api public
          # @since 0.1.0
          def call(library: nil, libraries: [], variants: nil, **)
            selected_libraries(library, libraries).each do |name|
              ::Icons::Sync.new(name, variants: variants&.map(&:to_sym)).now
            end
          end

          private

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
