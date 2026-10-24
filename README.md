# Hanami Icons

Add any icon library to a Hanami app. Hanami Icons has first-party support for [several libraries](#first-party-libraries) and one interface for all of them. It is a Hanami wrapper for the [Icons Ruby gem](https://github.com/Rails-Designer/icons).

```erb
# Using the default icon library
<%== icon "check", class: "text-gray-500" %>

# Using any custom library
<%== icon "apple", library: "simple_icons", class: "text-black" %>
```

The [Icons](https://github.com/Rails-Designer/icons) gem reads icons from their source repositories, so Hanami Icons stays small.

**Sponsored By [Rails Designer](https://railsdesigner.com/)**

## Install

Hanami loads CLI extensions from the `:cli` Bundler group. The view helpers also need the gem at runtime. Add the gem to both groups:

```ruby
gem "hanami_icons", group: [:default, :cli]
```

Then run:

```bash
bundle install
```

Generate the provider and sync a library:

```bash
hanami generate icons --library=heroicons
```

More examples:

```bash
# Multiple libraries
hanami generate icons --libraries=heroicons lucide

# Selected variants only
hanami generate icons --library=heroicons --variants solid outline
```

The command creates `config/providers/icons.rb`, registers the `icons` provider, and adds the helpers to `app/views/helpers.rb`.

## Usage

```ruby
# Default library and variant from config/providers/icons.rb
icon "check"

# Another variant
icon "check", variant: "solid"

# Explicit library
icon "check", library: "heroicons"

# CSS class
icon "check", class: "text-green-500"

# Data attributes
icon "check", data: { controller: "swap" }

# Stroke width
icon "check", stroke_width: 2

# Base64 data URI
encoded_icon "check"
```

The helpers return `Hanami::View::HTML::SafeString`. Use `<%== %>` in ERB or `==` in Slim.

## Sprites

A sprite references shared `<symbol>` definitions with `<use href="…">`. Use a sprite when a page shows many icons.

### Configuration

```ruby
# config/providers/icons.rb
HanamiIcons.configure do |config|
  config.default_library = "heroicons"
  config.default_variant = "outline"

  # URL for `sprite_icon`. Set to nil for an inline sprite.
  config.default_sprite_location = "/sprite.svg"

  # Check that referenced icons exist on disk.
  config.validate_sprite_icons = false

  # Icons to include in the sprite.
  config.sprite = {
    heroicons: {
      outline: %w[check chevron-down menu search x],
      mini: %w[check chevron-down]
    }
  }
end
```

### External sprite

Generate a sprite file:

```bash
hanami generate icons:sprite
```

Then reference it:

```erb
<%== sprite_icon "check" %>
<%# => <svg><use href="/sprite.svg#heroicons_outline_check"></use></svg> %>
```

Use a CDN or a different file:

```ruby
config.default_sprite_location = "https://cdn.example.com/sprite_icons.svg"
```

Override the location for one icon:

```erb
<%== sprite_icon "check", sprite_location: "/assets/sprites.svg" %>
```

### Inline sprite

Set the location to `nil` and embed the sprite in your layout:

```ruby
config.default_sprite_location = nil
```

```erb
<body>
  <%== icons_sprite %>

  <%== sprite_icon "check" %>
  <%== sprite_icon "search", class: "text-blue-500" %>
  <%== sprite_icon "menu", data: { controller: "nav" } %>
</body>
```

Build a sprite for selected icons:

```erb
<%== icons_sprite ["check", "search"], library: "heroicons", variant: "outline" %>
```

## Sync icons

Sync every first-party library:

```bash
hanami generate icons:sync
```

Sync one library:

```bash
hanami generate icons:sync --library=heroicons
```

Sync several libraries:

```bash
hanami generate icons:sync --libraries=heroicons lucide
```

Sync selected variants:

```bash
hanami generate icons:sync --library=heroicons --variants solid outline
```

The `icons:sync` command runs before the app boots, so it does not load `config/providers/icons.rb`. It sees first-party libraries only.

## Custom icon libraries

Hanami Icons reads SVGs from `<icons_path>/<library>/<name>.svg`. Libraries with variants add a variant directory, such as `<icons_path>/heroicons/outline/check.svg`.

Local libraries need no configuration. Create the directory and add SVGs:

```
app/assets/svg/icons/simple_icons/apple.svg
```

Then use the library:

```ruby
icon "apple", library: "simple_icons"
```

To scaffold a custom library, run `hanami generate icons --library=simple_icons`. The command creates the directory and adds `config.custom_library :simple_icons` to the provider.

### Git-sourced libraries

Add the source to the provider:

```ruby
HanamiIcons.configure do |config|
  config.custom_library :my_icons, source: {
    url: "https://github.com/user/icons.git",
    variants: { default: "." }
  }
end
```

`icons:sync` cannot see this library because it does not load providers. Sync it in the app context:

```bash
bundle exec hanami run 'Icons::Sync.new(:my_icons).now'
```

You can also run the same call in `hanami console`.

## First-party libraries

- [Boxicons](https://railsdesigner.com/open-source/rails-icons/boxicons/) (1600+ icons)
- [Feather](https://railsdesigner.com/open-source/rails-icons/feather/) (280+ icons)
- [Flags](https://railsdesigner.com/open-source/rails-icons/flags/) (540+ icons)
- [Heroicons](https://railsdesigner.com/open-source/rails-icons/heroicons/) (300+ icons)
- [Hugeicons](https://railsdesigner.com/open-source/rails-icons/hugeicons/) (4600+ icons)
- [Linear](https://railsdesigner.com/open-source/rails-icons/linear/) (170+ icons)
- [Lucide](https://railsdesigner.com/open-source/rails-icons/lucide/) (1500+ icons)
- [Phosphor](https://railsdesigner.com/open-source/rails-icons/phosphor/) (9000+ icons)
- [Radix](https://railsdesigner.com/open-source/rails-icons/radix/) (300+ icons)
- [SidekickIcons](https://railsdesigner.com/open-source/rails-icons/sidekickicons/) (49 icons, complementing [Heroicons](https://railsdesigner.com/open-source/rails-icons/heroicons/))
- [Tabler](https://railsdesigner.com/open-source/rails-icons/tabler/) (5700+ icons)
- [Weather](https://railsdesigner.com/open-source/rails-icons/weather/) (215+ icons)

## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for Ruby formatting. Run `bundle exec standardrb` before you open a pull request. Run the tests with `bundle exec rake`.

## License

Hanami Icons is released under the [MIT License](https://opensource.org/licenses/MIT).
