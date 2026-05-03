import DemoAppLib

// Thin executable wrapper. All the gallery setup lives in DemoAppLib so the
// same code is reachable from the `swift run DemoApp` Linux path, the
// `examples/macos/DemoApp` Xcode example bundle, and any other embedder.
runDemoApp()
