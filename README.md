# Hanami Icons

Add any icon library to a Hanami app. Hanami Icons has first-party support for a [handful of libraries](#first-party-libraries). It is library agnostic so it can be used with any icon library using the same interface. Hanami Icons is a Hanami gem for the [Icons Ruby gem](https://github.com/Rails-Designer/icons).

```erb
# Using the default icon library
<%== icon "check", class: "text-gray-500" %>

# Using any custom library
<%== icon "apple", library: "simple_icons", class: "text-black" %>
```

The icons are sourced directly from their respective GitHub repositories via the [Icons](https://github.com/Rails-Designer/icons) gem, ensuring Hanami Icons remain lightweight.

**Sponsored By [Rails Designer](https://railsdesigner.com/)**

## Install

Add the gem:

```bash
bundle add hanami_icons
```

Install, choosing one of the supported libraries:

```bash
hanami generate icons --library=heroicons
```

**Example**

```bash
hanami generate icons --library=heroicons

# Or multiple at once
hanami generate icons --libraries=heroicons lucide

# Or only specific variants
hanami generate icons --library=heroicons --variants solid outline
```

This creates `config/providers/icons.rb`, registers the provider with the app container and adds the view helpers into `app/views/helpers.rb`.

## Usage

```ruby
# Uses the default library and variant defined in config/providers/icons.rb
icon "check"

# Use another variant
icon "check", variant: "solid"

# Set library explicitly
icon "check", library: "heroicons"

# Add CSS
icon "check", class: "text-green-500"

# Add data attributes
icon "check", data: { controller: "swap" }

# Set the stroke-width
icon "check", stroke_width: 2

# Base64-encoded data URI
encoded_icon "check"
```

The helpers return `Hanami::View::HTML::SafeString`, so they are safe to output in templates (`<%== … %>` or `&= …`).

## Sprites

Hanami Icons supports SVG sprites for improved performance. Instead of inlining each icon's full SVG, sprite icons reference a shared set of `<symbol>` definitions via `<use href="…">`.

### Configuration

```ruby
# config/providers/icons.rb
HanamiIcons.configure do |config|
  config.default_library = "heroicons"
  config.default_variant = "outline"

  # Where `sprite_icon` references symbols. Set to nil to use inline mode (`<%== icons_sprite %>` in layout).
  config.default_sprite_location = "/sprite.svg"

  # Set to true to validate that referenced icons exist on disk
  config.validate_sprite_icons = false

  # Define which icons to include in the sprite
  config.sprite = {
    heroicons: {
      outline: %w[check chevron-down menu search x],
      mini: %w[check chevron-down]
    }
  }
end
```

### External sprite

Generate a static sprite file and reference it with `sprite_icon`:

```bash
hanami generate icons:sprite
```

```erb
<%== sprite_icon "check" %>
<%# renders: <svg><use href="/sprite.svg#heroicons_outline_check"></use></svg> %>
```

Point at a precompiled file or a CDN by changing the location:

```ruby
config.default_sprite_location = "https://cdn.example.com/sprite_icons.svg"
```

Override per icon:

```erb
<%== sprite_icon "check", sprite_location: "/assets/sprites.svg" %>
```

### Inline sprite

Set the location to `nil` and embed the sprite directly in your layout:

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

You can also generate a sprite for a specific set of icons:

```erb
<%== icons_sprite ["check", "search"], library: "heroicons", variant: "outline" %>
```

## Sync icons

To sync all libraries, run:

```bash
hanami generate icons:sync
```

To sync only a specific library, run:

```bash
hanami generate icons:sync --library=heroicons

# Or multiple at once:
hanami generate icons:sync --libraries=heroicons lucide
```

To sync only specific variants for a library:

```bash
hanami generate icons:sync --library=heroicons --variants solid outline
```

## Custom icon libraries

Hanami Icons pulls SVGs straight from the path `<icons_path>/<library_name>/<name>.svg`. No generator is required for custom icons. Configuration is optional and only used to define defaults.

To add a custom library, create its directory and drop in your SVGs:

```
app/assets/svg/icons/simple_icons/apple.svg
```

(alternatively, scaffold it with `hanami generate icons --library=simple_icons`, which creates the directory and adds `config.custom_library :simple_icons` in the provider.)

Use them like any other library:

```ruby
icon "apple", library: "simple_icons"
```

To add a git source for syncing, edit the provider:

```ruby
HanamiIcons.configure do |config|
  config.custom_library :my_icons, source: {
    url: "https://github.com/user/icons.git",
    variants: { default: "." }
  }
end
```

Then sync:

```bash
hanami generate icons:sync --library=my_icons
```

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

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `bundle exec standardrb` before submitting pull requests. Run tests via `bundle exec rake`.

## License

Hanami Icons is released under the [MIT License](https://opensource.org/licenses/MIT).
