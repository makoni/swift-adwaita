# Localization

Translate an app with gettext, let the user pick a language without
restarting, and get right-to-left layouts right.

## Overview

Translations come from gettext catalogues. You ship a compiled `.mo` per
language, gettext resolves the one matching the interface language, and
``localized(_:)`` (or `String.localized`) looks strings up in it.

Three things have to line up, and only the first is obvious:

1. the domain must be **bound** to the directory holding the catalogues,
2. the **language** has to be selected before or during startup — and, if you
   offer a picker, again whenever the user changes it,
3. the **reading direction** has to follow the language, because GTK will not
   do that for a language your app chose.

## Setting up

``configureLocalization(domain:localeDirectory:codeset:)`` does the whole
setup in one call. Do it before your first lookup and before
`Application.run()`:

```swift
configureLocalization(
    domain: "com.example.MyApp",
    localeDirectory: "/app/share/locale",
)
```

gettext resolves `<localeDirectory>/<lang>/LC_MESSAGES/<domain>.mo`, so the
layout on disk has to be exactly that. A `.mo` sitting directly in
`localeDirectory` is never found — a resource-bundling rule that flattens
directories will silently ship an untranslated app.

Which is why the call reports back. It returns `false` when no catalogue for
the domain is reachable, and that is worth acting on rather than discarding:

```swift
if !configureLocalization(domain: appID, localeDirectory: localeDirectory()) {
    FileHandle.standardError.write(Data("no catalogue found — running untranslated\n".utf8))
}
```

``catalogueLanguages(in:domain:)`` answers the same question in more detail,
and is the honest way to build a language picker: it lists what the build
actually installed rather than what you meant to install.

The directory differs by packaging, so resolve it at runtime rather than
hard-coding one:

```swift
func localeDirectory() -> String? {
    if FileManager.default.fileExists(atPath: "/app/share/locale") {
        return "/app/share/locale"          // Flatpak
    }
    if let bundled = Bundle.module.resourceURL?.appendingPathComponent("locale") {
        return bundled.path                 // SwiftPM build
    }
    return "/usr/share/locale"              // system install
}
```

### Building the catalogues

`msgfmt` compiles `.po` into the `.mo` the app ships. On macOS, Homebrew's
gettext is keg-only, so `brew install gettext` leaves `msgfmt` off `PATH`
entirely — a build script that assumes otherwise fails on a developer's Mac
and in macOS CI while working everywhere else. Look under
`brew --prefix gettext`/bin before giving up.

## Looking strings up

```swift
Label("Welcome".localized)
Label(localized("Welcome"))
```

Counted phrases need ``nlocalized(_:_:count:)`` rather than an `if` on the
number — the form is the translator's decision, and languages differ in how
many forms they have. Russian needs three; a binary singular/plural choice
reads as a grammatical error there:

```swift
String(format: nlocalized("%d note", "%d notes", count: UInt(count)), count)
```

`nlocalized` only selects the form; the specifier survives in the string it
returns, so the `String(format:)` wrapper is what actually substitutes the
number.

When one English string means two different things, disambiguate with a
context rather than inventing a second wording. ``localizedWithContext(_:_:)``
and ``nlocalizedWithContext(_:_:_:count:)`` take one:

```swift
localizedWithContext("verb", "Open")        // the action
localizedWithContext("adjective", "Open")   // the state
```

Extract these with `xgettext --keyword=localizedWithContext:1c,2
--keyword=nlocalizedWithContext:1c,2,3` so the context reaches the catalogue.

The lookup key is the context, `U+0004`, then the msgid — which is why adding a
context to a string that already had a translation makes it a *new* entry.
`msgmerge` then pairs it with the old bare entry, copies the translation over
and flags the guess `#, fuzzy`; `msgfmt` leaves fuzzy entries out of the
compiled catalogue. So the string that had a translation a moment ago comes out
English, in the language it was already translated into, with every tool
reporting success. Review the flagged entry and delete the flag.

A missing context is not an error, either: gettext returns the bare msgid, so a
context nobody translated shows English rather than leaking the `U+0004` key.
Convenient in production, invisible in review — a test is the only thing that
notices.

## Letting the user pick a language

``setLanguage(_:localeCandidates:)`` selects the catalogue at runtime; `nil`
goes back to following the session:

```swift
setLanguage("ru")   // pinned
setLanguage(nil)    // follow LANGUAGE / LC_ALL / LANG again
```

It takes effect immediately for *new* lookups. Widgets already on screen keep
the strings they were built with, so a picker also has to re-read them — walk
the chrome you set once at construction (titles, tooltips, accessible labels,
menu models, combo-row models) and assign it again. Dialogs, toasts and
context menus built at the moment they are shown need nothing.

Accessible labels are the ones that get forgotten, because nothing on screen
shows the omission — the interface looks fully translated while a screen
reader still reads the old language. GTK4 has no getter for an accessible
property, so ``Widget/accessibleLabel`` returns a copy this module keeps: set
it through ``Widget/setAccessibleLabel(_:)`` and a test can assert the
retranslation happened.

One trap worth knowing before you wire a picker up: a language change often
arrives from inside a widget's own signal emission — a combo row emits
`notify::selected` synchronously — and retranslating rebuilds that widget.
GTK keeps using the old model as it unwinds, which is a use-after-free. Defer
the retranslation to the next main-loop turn rather than running it inside the
handler.

Two limits worth designing around:

- gettext ignores `LANGUAGE` entirely while `LC_MESSAGES` names the `C` or
  `POSIX` locale — and `C.UTF-8` counts as `C`. ``setLanguage(_:localeCandidates:)``
  installs a real locale to lift that block and **returns `false`** if it
  could not: on such a session nothing is translated with or without a
  picker. Record the preference anyway; it will apply on a launch that has a
  locale.

  Do not put `C.UTF-8` in `localeCandidates` hoping it will do as a fallback.
  It is generated nearly everywhere, which makes it tempting, but gettext
  treats it as the C locale — so it can never satisfy the check. Such
  candidates are skipped rather than attempted, precisely so a doomed try does
  not move `LC_MESSAGES` off whatever it was on before failing.

  ``currentMessagesLocale()`` and ``setMessagesLocale(_:)`` are there for
  callers that need the process locale put back the way they found it — test
  suites above all, since this is process-global state.

  The locale is **exported** as well as installed, and that matters more than
  it looks. `gtk_init` calls `setlocale(LC_ALL, "")`, which reads the
  environment — so a locale that was only installed reverts to whatever `LANG`
  says, and in a container or the Flatpak sandbox that is `C.UTF-8`. GLib then
  decides **once per process** whether the program is translated at all, and
  decides "no" when the first `g_dgettext` runs under a locale that neither
  equals `C` nor begins with `en_` while no catalogue is loaded — `C.UTF-8` is
  exactly that gap. GTK looks up its own strings while initializing, so the
  decision is latched before an app makes its first lookup; afterwards every
  `g_dgettext` returns its msgid however correct the locale, the language and
  the binding have since become, while plain `dgettext` returns the
  translation. An interface that comes up in English with translated *dates* —
  Foundation formats those without going through GLib — is this and nothing
  else.

  Three consequences worth knowing, all of them handled rather than left to
  the caller:

  - ``configureLocalization(domain:localeDirectory:codeset:)`` escapes the C
    locale too, not just ``setLanguage(_:localeCandidates:)``. An app whose
    user has *not* pinned a language would otherwise be latched by GTK's own
    initialization, and a language picked later in that session could never
    take effect — the picker would appear to do nothing.
  - `LC_ALL` is cleared when it names a C locale, because
    `setlocale(LC_ALL, "")` gives it precedence over `LC_MESSAGES`; exporting
    the per-category variable alone changes nothing on a session that sets
    `LC_ALL=C.UTF-8`, which Debian and Python container images do.
  - ``setLanguage(nil)`` does **not** undo the escape, and that is deliberate:
    putting `LC_MESSAGES` back to a session value of `C` returns the process to
    the locale where GLib latches it, so "follow the system language" would
    break translation for the rest of the session — including for the language
    the session itself asks for. What `.system` means is read from the locale
    variables captured *before* the first escape, which is also what
    ``isRightToLeft(language:)`` uses for that case; reading the escape back
    would decide an Arabic session's direction from the `en_US` locale the app
    installed for itself.

  ``messagesLocaleSupportsTranslation`` answers the remaining question: `false`
  means the process is stuck on the C locale because nothing else is generated
  on the machine, and nothing will be translated with or without a picker.
  Worth saying out loud to the user — the interface comes up English with no
  other sign of why.
- ``canChangeLanguageAtRuntime`` is `false` where libintl does not export the
  catalogue-cache counter. Say "takes effect at the next launch" rather than
  promising an instant switch.

## Right-to-left languages

GTK mirrors most of a window on its own once the direction is right: box and
header-bar child order, `halign` and margin start/end, `GtkLabel.xalign`
(`0` means the *start* edge, so it becomes the right edge), and directional
icons such as `pan-end-symbolic`, which are looked up with an `-rtl` variant.
Characters with the Unicode `Bidi_Mirrored` property — `›`, `«`, `»` — are
flipped by Pango.

What GTK does **not** do is take the direction from a language your app
selected. It reads its own translation of the string `default:LTR` during
initialization, which means the direction is decided once, at startup, from
GTK's catalogue rather than yours. Two consequences:

- it cannot follow a language the user picks later, and
- it depends on GTK's own translations being installed for that language.
  They are in the GNOME Flatpak runtime; on a bare system they are often
  absent, and an Arabic session then comes up left-to-right.

So set the direction yourself, alongside the language:

```swift
setLanguage(code)
applyTextDirection(forLanguage: code)
```

``applyTextDirection(forLanguage:)`` maps the language to a direction with
``isRightToLeft(language:)`` and assigns ``defaultTextDirection``. Assigning
it re-lays-out widgets that are already realized, so a live switch to Arabic
mirrors the open window without rebuilding it.

Mind the ordering: GTK sets the default direction during initialization and
overwrites whatever was there, so a call made before `Application.run()` is
thrown away. Apply it from the activation handler, before the first window is
built, and again on every language change:

```swift
app.onActivate {
    applyTextDirection(forLanguage: selectedLanguageCode)
    // ... build the window
}
```

Keep a subtree unmirrored — a code view, a file path, an LTR-only diagram:

```swift
pathLabel.forceLeftToRight()
codeBlock.forceLeftToRight()
```

Leave everything else inheriting, which is the default;
``Widget/followDefaultTextDirection()`` puts a subtree back.

Prefer these methods over assigning ``Widget/textDirection`` directly. An app
that imports a second C module pulling in `gtk/gtk.h` — GtkSourceView and
libspelling both do — sees two distinct Swift types named `GtkTextDirection`
and cannot name the enum case at all, so the argument-free methods are the
only form it can call.

### Reviewing an app for RTL

Most GTK code is already correct. The things that are not:

- **Physical CSS.** `margin-left`, `padding-right`, `border-left` are not
  mirrored. Use `margin-inline-start` and friends, or symmetric values.
- **Non-mirrored glyphs.** `→` and `←` have no `Bidi_Mirrored` property and
  stay put. Prefer `›`/`‹`, or pick the arrow from the direction.
- **Hard-coded pixel offsets** measured from the left edge.
- **Icons with baked-in direction** that are semantic rather than
  navigational: `format-justify-left-symbolic` should *not* mirror, because
  it means "align left", not "align to the start".

`halign`, `marginStart`/`marginEnd` and `xalign` need no changes: GTK4 has no
left/right variants of the first two, and mirrors the third.

## Topics

### Looking up translations

- ``localized(_:)``
- ``localizedWithContext(_:_:)``
- ``nlocalized(_:_:count:)``
- ``nlocalizedWithContext(_:_:_:count:)``

### Setting up

- ``configureLocalization(domain:localeDirectory:codeset:)``
- ``catalogueLanguages(in:domain:)``
- ``systemLocaleDirectory``
- ``bindTextDomain(_:to:)``
- ``bindTextDomainCodeset(_:to:)``
- ``setTextDomain(_:)``
- ``setDefaultTextDomain(_:)``

### Changing language at runtime

- ``setLanguage(_:localeCandidates:)``
- ``currentLanguage``
- ``canChangeLanguageAtRuntime``
- ``currentMessagesLocale()``
- ``setMessagesLocale(_:)``

### Reading direction

- ``defaultTextDirection``
- ``applyTextDirection(forLanguage:)``
- ``isRightToLeft(language:)``
- ``Widget/accessibleLabel``
- ``Widget/forceLeftToRight()``
- ``Widget/forceRightToLeft()``
- ``Widget/followDefaultTextDirection()``
