# Search Bar Setup

`SearchBar` needs two connections to behave like a normal GNOME search UI.

## 1. Put a `SearchEntry` inside it

```swift
let searchEntry = SearchEntry()
let searchBar = SearchBar()
searchBar.child = searchEntry
```

## 2. Connect the entry

```swift
searchBar.connectEntry(searchEntry)
```

This wires up the entry so the search bar can reveal, close, and forward the
expected keyboard behavior.

## 3. Set the key-capture widget

```swift
searchBar.setKeyCaptureWidget(window)
```

Usually this should be your top-level window or another ancestor that receives
the keystrokes you want to use for search activation.

## Full example

```swift
let searchEntry = SearchEntry()
let searchBar = SearchBar()
searchBar.child = searchEntry
searchBar.connectEntry(searchEntry)
searchBar.setKeyCaptureWidget(window)
searchBar.showCloseButton = true

searchEntry.onSearchChanged { [searchEntry] in
    print("Searching for \(searchEntry.text)")
}
```

## Common pitfall

If the search entry works only when it already has focus, you probably forgot
``SearchBar/setKeyCaptureWidget(_:)``.
