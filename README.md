# Translucent
A Transparent background utility for cropping a transparent images backgrounds to homescreen widgets. Inspired by [Scriptable script](https://gist.github.com/mzeryck/3a97ccd1e059b3afa3c6666d27a496c9)

![Preview](./preview.gif)


## Installation

Add this dependecy to your project with SPM

## Usage

```swift
import Translucent

//Create instances

let bgLight = Wallpaper(/* User wallpaper in UIImage */)
let bgDark = Wallpaper(/* User wallpaper in UIImage */)

//And get backgrounds for widgets

bgLight.widgetBackground(for: /* the position */)
```
