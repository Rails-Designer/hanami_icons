# frozen_string_literal: true

require "hanami_icons"

HanamiIcons.configure do |config|
end

Hanami.app.register_provider(:icons) do
  start do
    register "icons", HanamiIcons
  end
end
