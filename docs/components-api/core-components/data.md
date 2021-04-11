# Data

The HTML `<data>` tag, implemented in Ruby.

## Parameters

This component can take various optional configuration params and either yield content or display what gets passed to the `text` configuration param.

### Value \(optional\)

Expects a string and specifies the machine-readable translation of the content of the `<data>` element.

### Text \(optional\)

Expects a string which will be displayed as the content inside the `<data>` tag.

### HMTL attributes \(optional\)

This component accepts all the canonical [HTML global attributes](https://www.w3schools.com/tags/ref_standardattributes.asp) like `id` or `class`.

## Examples

### Example 1: Yield a given block

```ruby
data id: 'foo', class: 'bar', value: '1300' do
  plain 'Data example 1' # optional content
end
```

returns

```markup
<data id="foo" class="bar" value="1300">
  Data example 1
</data>
```

### Example 2: Render `options[:text]` param

```ruby
data id: 'foo', class: 'bar', value: '1301', text: 'Data example 2'
```

returns

```markup
<data id="foo" class="bar" value="1301">
  Data example 2
</data>
```

