# frozen_string_literal: true

require "test_helper"
require "fileutils"

class InitializerTest < Minitest::Test
  include CliTestHelpers

  def test_creates_the_provider_with_a_default_library
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call(library: "heroicons")

      assert File.exist?("config/providers/icons.rb")
      assert_includes File.read("config/providers/icons.rb"), 'config.default_library = "heroicons"'
    end
  end

  def test_creates_the_provider_without_a_default_library
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call

      refute_includes File.read("config/providers/icons.rb"), "config.default_library"
    end
  end

  def test_registers_a_provider_with_the_app
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call

      content = File.read("config/providers/icons.rb")
      assert_includes content, "Hanami.app.register_provider(:icons)"
      assert_includes content, %(register "icons", HanamiIcons)
    end
  end

  def test_normalizes_library_names
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call(library: "Heroicons")

      assert_includes File.read("config/providers/icons.rb"), 'config.default_library = "heroicons"'
    end
  end

  def test_does_not_insert_a_default_library_when_one_already_exists
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call(library: "heroicons")
      Generate::Initializer.new.call(library: "lucide")

      content = File.read("config/providers/icons.rb")
      assert_equal 1, content.scan("config.default_library").size
      assert_includes content, 'config.default_library = "heroicons"'
    end
  end

  def test_adds_a_custom_library
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call(libraries: ["simple_icons"])

      content = File.read("config/providers/icons.rb")
      assert_includes content, "config.custom_library :simple_icons"
      assert Dir.exist?("app/assets/svg/icons/simple_icons")
    end
  end

  def test_does_not_treat_first_party_libraries_as_custom
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call(libraries: ["heroicons", "lucide"])

      content = File.read("config/providers/icons.rb")
      refute_includes content, "config.custom_library"
    end
  end

  def test_writes_icons_path_for_a_custom_destination
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call(library: "heroicons", destination: "custom/icons")

      assert_includes File.read("config/providers/icons.rb"), 'config.icons_path = "custom/icons"'
    end
  end

  def test_does_not_write_icons_path_for_the_default_destination
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call(library: "heroicons")

      refute_includes File.read("config/providers/icons.rb"), "config.icons_path"
    end
  end

  def test_does_not_modify_config_app
    within_temp_dir do
      create_hanami_app_files

      app_content = File.read("config/app.rb")

      Generate::Initializer.new.call(library: "heroicons")

      assert_equal app_content, File.read("config/app.rb")
    end
  end

  def test_registers_helpers_in_the_app_helpers_module
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call

      content = File.read("app/views/helpers.rb")
      assert_includes content, "include HanamiIcons::Helpers::IconHelper"
      assert_includes content, "include HanamiIcons::Helpers::SpriteHelper"
    end
  end

  def test_does_not_register_helpers_twice
    within_temp_dir do
      create_hanami_app_files

      Generate::Initializer.new.call
      Generate::Initializer.new.call

      content = File.read("app/views/helpers.rb")
      assert_equal 1, content.scan("include HanamiIcons::Helpers::IconHelper").size
    end
  end

  def test_warns_when_the_helpers_module_is_missing
    within_temp_dir do
      create_hanami_app_files
      FileUtils.rm_rf("app/views/helpers.rb")

      output = capture_io do
        Generate::Initializer.new.call
      end.last

      assert_includes output, "[HanamiIcons] Could not find app/views/helpers.rb"
    end
  end
end
