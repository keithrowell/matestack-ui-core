# Article

The HTML `<article>` tag, implemented in Ruby.

## Parameters

This component can take various optional configuration params and either yield content or display what gets passed to the `text` configuration param.

### Text \(optional\)

Expects a string which will be displayed as the content inside the `<article>` tag. If this is not passed, a block must be passed instead.

### HMTL attributes \(optional\)

This component accepts all the canonical [HTML global attributes](https://www.w3schools.com/tags/ref_standardattributes.asp) like `id` or `class`.

## Examples

### Example 1: Yield a given block

```ruby
article do
  paragraph text: "Hello world"
end
```

returns

```markup
<article>
  <p>Hello world</p>
</article>
```

### Example 2: Render options\[:text\] param

```ruby
article text: "Hello world"
```

returns

```markup
<article>Hello world</article>
```

