# frozen_string_literal: true

require "fileutils"

module CliTestHelpers
  def within_temp_dir
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        yield dir
      end
    end
  end

  def create_hanami_app_files
    FileUtils.mkdir_p("config")
    File.write("config/app.rb", <<~RUBY)
      # frozen_string_literal: true

      require "hanami"

      module BookStore
        class App < Hanami::App
        end
      end
    RUBY

    FileUtils.mkdir_p("app/views")
    File.write("app/views/helpers.rb", <<~RUBY)
      # frozen_string_literal: true

      module BookStore
        module Views
          module Helpers
            # Add your view helpers here
          end
        end
      end
    RUBY
  end

  def stub_icons_sync(fake_sync)
    singleton = Icons::Sync.singleton_class

    singleton.send(:define_method, :new) do |name, variants: nil|
      fake_sync.new(name, variants: variants)
    end

    yield
  ensure
    singleton.send(:remove_method, :new)
  end

  class FakeSync
    attr_reader :instantiations

    def initialize
      @instantiations = []
    end

    def new(name, variants: nil)
      @instantiations << [name, variants]
      self
    end

    def now
    end
  end
end
