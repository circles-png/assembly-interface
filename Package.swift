//swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "AssemblyInterface",
  platforms: [.macOS(.v14)],
  products: [
    .library(name: "AssemblyInterface", targets: ["AssemblyInterface"])
  ],
  targets: [
    .target(name: "AssemblyInterface", path: "Sources"),
    .testTarget(name: "AssemblyInterfaceTests", dependencies: ["AssemblyInterface"], path: "Tests"),
  ]
)
