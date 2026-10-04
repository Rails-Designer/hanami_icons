# frozen_string_literal: true

require "test_helper"

class IconsTest < Minitest::Test
  include CliTestHelpers

  def test_runs_the_initializer
    within_temp_dir do
      create_hanami_app_files

      Generate::Icons.new.call(library: "heroicons", skip_sync: true)

      assert File.exist?("config/providers/icons.rb")
    end
  end

  def test_runs_sync_unless_skipped
    within_temp_dir do
      create_hanami_app_files

      fake_sync = CliTestHelpers::FakeSync.new
      stub_icons_sync(fake_sync) do
        Generate::Icons.new.call(library: "heroicons")
      end

      assert_equal [["heroicons", nil]], fake_sync.instantiations
    end
  end

  def test_skips_sync_when_skip_sync_is_true
    within_temp_dir do
      create_hanami_app_files

      fake_sync = CliTestHelpers::FakeSync.new
      stub_icons_sync(fake_sync) do
        Generate::Icons.new.call(library: "heroicons", skip_sync: true)
      end

      assert_empty fake_sync.instantiations
    end
  end

  def test_skips_sync_when_no_library_is_selected
    within_temp_dir do
      create_hanami_app_files

      fake_sync = CliTestHelpers::FakeSync.new
      stub_icons_sync(fake_sync) do
        Generate::Icons.new.call
      end

      assert_empty fake_sync.instantiations
    end
  end
end
