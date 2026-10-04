# frozen_string_literal: true

require "test_helper"

class SpriteTest < Minitest::Test
  include CliTestHelpers

  def test_writes_the_sprite_file
    within_temp_dir do
      Generate::Sprite.new.call(output: "public/sprite.svg")

      assert File.exist?("public/sprite.svg")
      assert_includes File.read("public/sprite.svg"), "<svg"
    end
  end

  def test_uses_the_default_output_path
    within_temp_dir do
      Generate::Sprite.new.call

      assert File.exist?("public/sprite.svg")
    end
  end
end
