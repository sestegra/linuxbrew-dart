# Dart for Homebrew

This is the unofficial [Dart][] tap for [linuxbrew][].

Ubuntu users can use these formulae to easily install and update Dart SDK and
Dartium. Both dev and stable channels are supported.

## Initial setup

If you don't have linuxbrew, install it from their [homepage][linuxbrew].

Then, add this tap:

```
brew tap reyerstudio/linuxbrew-dart https://github.com/reyerstudio/linuxbrew-dart
```

## Installing

To install the Dart SDK:

```
brew install dart
```

Tip: Once installed, brew will print the path to the Dart SDK. Use this path to configure Dart support
in your IDE (like WebStorm).

For web developers, we highly recommend Dartium and content shell:

```
brew install dart --with-dartium --with-content-shell
```

## Dev Releases

To install dev channel releases, instead of the stable ones, add a `--devel`
flag after the brew commands:

```shell
brew install dart --devel
```

## Updating

Simply run:

```
brew update
brew upgrade dart
```

[linuxbrew]: http://linuxbrew.sh/
[dart]: https://www.dartlang.org
