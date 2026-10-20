<div>
  <h1>Deco SSC 2025 Archive <img src="docs/Images/Deco-SSC-2025.png" alt="Original Deco icon" width="96" height="96" align="right"></h1>
  <p>The original Deco: make a wallpaper your own with stickers, photos, and mesh gradients.</p>
  <p><img src="https://img.shields.io/badge/iOS%20%2F%20iPadOS-18.1%2B-000000?logo=apple" alt="iOS / iPadOS 18.1+ manifest target"> <img src="https://img.shields.io/badge/Swift-6.0_tools-F05138?logo=swift&amp;logoColor=white" alt="Swift 6.0 tools"> <img src="https://img.shields.io/badge/Swift-5_language_mode-F05138?logo=swift&amp;logoColor=white" alt="Swift 5 language mode"></p>
</div>

I built Deco in around two weeks for the Swift Student Challenge 2025. The idea was to make wallpaper creation feel playful: pick a background, put some stickers on it, and move things around until it feels like yours.

This repository preserves that first version. I wanted to make the challenge submission available on its own.

**Looking for the current app? [Download Deco 3.0 on the App Store](https://apps.apple.com/app/id6742457882).** Deco has developed into a substantially different app since this submission. This archive contains only the original challenge project, not the source code for Deco 3.0.

## Make a wallpaper

Start with a photo, a color, or a mesh gradient. The gradient editor lets you move points and choose their colors, while Image Playground can supply a background on supported devices.

Add emoji or make a sticker from text, then drag, resize, and rotate it on the canvas. With a photo background, subject separation lets stickers sit behind the subject as well as in front. The included dog photo is part of that demo.

Use **Export** to preview the result and save it to Photos. The canvas lives in memory, so export anything you want to keep before closing the app.

## Open it in Xcode

Open [`Source/DecoFinal.swiftpm`](Source/DecoFinal.swiftpm), select the **Deco** app scheme and an iPhone or iPad destination, then run. On first launch, follow the introduction; **Change** opens the background picker and **Add** opens the stickers.

This is an app playground using `AppleProductTypes`, with executable target `AppModule`. Its manifest uses Swift tools 6.0 and Swift 5 language mode. Use Xcode with an SDK that includes Image Playground, such as Xcode 16.2 or later.

For a physical device, select your own development team in the app settings. The bundle identifier is `world.aethers.Deco.Archive.SSC2025`; change it in `Source/DecoFinal.swiftpm/Package.swift` if needed for your account.

The manifest targets iOS/iPadOS 18.1. Image Playground has additional OS and device requirements, and its background option appears when the system reports support. Saving an export requires permission to add images to Photos.

## The February 2025 snapshot

The app comes from the preserved `DecoFinal.swiftpm.zip`, with file timestamps through 23 February 2025 and a manifest version of 1.0, build 1. It retains the original implementation, including experiments and debug prints.

For this repository, the package sits under `Source/`. Xcode user state and generated thumbnails are omitted, the personal signing team is removed, and the bundle identifier is separate from the original app. The remaining Swift source and bundled assets match the ZIP. The [source notes](SOURCE-NOTES.md) identify the archive and explain the license scope.

## License

Original Deco source is available under [GPLv3](LICENSE), with the attribution term in [SOURCE-NOTES.md](SOURCE-NOTES.md). Artwork and branding have separate terms described there.
