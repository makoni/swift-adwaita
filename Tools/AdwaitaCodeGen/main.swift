// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Foundation

let girPath = "/usr/share/gir-1.0/Adw-1.gir"
let outputDir = "Sources/Adwaita/Generated"

// Parse GIR
let parser = GIRParser()
guard let namespace = parser.parse(url: URL(fileURLWithPath: girPath)) else {
    print("ERROR: Failed to parse \(girPath)")
    exit(1)
}

print("Parsed namespace: \(namespace.name) \(namespace.version)")
print("  Classes: \(namespace.classes.count)")
print("  Enumerations: \(namespace.enumerations.count)")
print("  Bitfields: \(namespace.bitfields.count)")

// Count non-deprecated
let active = namespace.classes.filter { !$0.isDeprecated && !deprecatedClasses.contains($0.name) && !handWrittenClasses.contains($0.name) }
print("  Active classes to generate: \(active.count)")

// Generate
let generator = SwiftGenerator(namespace: namespace, outputDir: outputDir)
do {
    try generator.generate()
    print("Code generation complete.")
} catch {
    print("ERROR: \(error)")
    exit(1)
}
