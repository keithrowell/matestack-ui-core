# Template

The HTML `<template>` tag, implemented in Ruby.

## Parameters

This component accepts all the canonical [HTML global attributes](https://www.w3schools.com/tags/ref_standardattributes.asp) like `id` or `class`.

## Examples

### Example 1: Yield other components inside a template

```ruby
template id: 'foo', class: 'bar' do
  paragraph text: 'Template example 1' # optional content
end
```

returns

```markup
<template id="foo" class="bar">
  <p>Template example 1</p>
</template>
```

### Example 2: Render a given block, e.g. a partial

```ruby
template id: 'foo', class: 'bar' do
  example_content
end

def example_content
  paragraph text: 'I am part of a partial'
end
```

returns

\`\`\`html

I am part of a partial

