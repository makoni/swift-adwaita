# Markup Safety

Choose the safest text API that matches your use case.

## Plain text first

If you do not need rich text, use ``Label/text``:

```swift
label.text = userVisibleMessage
```

This never parses markup.

## Safe rich text with explicit escaping

If you need markup tags, escape interpolated text:

```swift
let title = PangoMarkup.escape(noteTitle)
label.markup = "<b>\(title)</b>"
```

## Styling ranges without markup

Use ``Label/attributes`` and ``TextAttributes`` when you want to highlight or
decorate substrings while keeping the source text plain:

```swift
let text = "Search results"
let attrs = TextAttributes()
attrs.addUnderline(range: text.startIndex..<text.index(text.startIndex, offsetBy: 6), in: text)

let label = Label(text)
label.attributes = attrs
```

Range-based APIs use Pango's UTF-8 byte offsets internally. If you need those
offsets directly, use ``String/pangoByteOffset(of:)`` and
``String/pangoByteRange(for:)``.

## Guard activated links

If markup contains links, filter allowed schemes before launching them:

```swift
label.onActivateLink(
    URIScheme.allowlist(.https, .mailto) { uri in
        print("Open \(uri)")
    }
)
```

## Other markup sinks

The same escaping rule applies to other APIs that parse markup:

- ``Widget/tooltipMarkup``
- ``Expander/useMarkup``
- ``Scale/addMark(_:position:markup:)``

## Avoid

- auto-detecting whether arbitrary text is markup
- interpolating unescaped user text into `Label.markup`
- using markup when ``Label/attributes`` is enough
