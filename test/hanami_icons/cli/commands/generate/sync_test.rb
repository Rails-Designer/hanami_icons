# frozen_string_literal: true

require "test_helper"

class SyncTest < Minitest::Test
  include CliTestHelpers

  def test_calls_sync_for_each_selected_library
    fake_sync = CliTestHelpers::FakeSync.new

    stub_icons_sync(fake_sync) do
      Generate::Sync.new.call(libraries: ["heroicons", "lucide"])
    end

    assert_equal [["heroicons", nil], ["lucide", nil]], fake_sync.instantiations
  end

  def test_normalizes_and_deduplicates_libraries
    fake_sync = CliTestHelpers::FakeSync.new

    stub_icons_sync(fake_sync) do
      Generate::Sync.new.call(library: "Heroicons", libraries: ["heroicons", ""])
    end

    assert_equal [["heroicons", nil]], fake_sync.instantiations
  end

  def test_passes_variants_as_symbols
    fake_sync = CliTestHelpers::FakeSync.new

    stub_icons_sync(fake_sync) do
      Generate::Sync.new.call(library: "heroicons", variants: ["solid", "outline"])
    end

    assert_equal [["heroicons", [:solid, :outline]]], fake_sync.instantiations
  end
end
