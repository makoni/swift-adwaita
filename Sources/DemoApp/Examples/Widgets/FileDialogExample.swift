import Adwaita

@MainActor
struct FileDialogExample: DemoExample {
    let name = "File Dialog"
    let id = "filedialog"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let dialog = FileDialog()
    dialog.title = "Open a File"

    // Set file filters
    dialog.setFilters([
        FileFilter(name: "Swift files", suffixes: ["swift"]),
        FileFilter(name: "All files", patterns: ["*"]),
    ])

    // Open
    dialog.open(parent: widget) { path in
        if let path {
            print("Selected: \\(path)")
        }
    }

    // Save
    dialog.initialName = "untitled.swift"
    dialog.save(parent: widget) { path in
        if let path { print("Save to: \\(path)") }
    }

    // Select folder
    dialog.selectFolder(parent: widget) { path in
        if let path { print("Folder: \\(path)") }
    }
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let resultLabel = Label("No file selected")
        resultLabel.addCSSClass("monospace")
        resultLabel.wrap = true
        resultLabel.xalign = 0
        resultLabel.setMargins(12)

        let resultFrame = Frame()
        resultFrame.child = resultLabel

        let resultGroup = PreferencesGroup()
        resultGroup.title = "Result"
        resultGroup.add(resultFrame)

        // Open file
        let openGroup = PreferencesGroup()
        openGroup.title = "Open File"
        openGroup.description = "Select a file from the filesystem"

        let openBtn = Button(label: "Open File...")
        openBtn.addCSSClass("suggested-action")
        openBtn.addCSSClass("pill")
        openBtn.halign = .center
        openBtn.onClicked { [resultLabel, box] in
            let dialog = FileDialog()
            dialog.title = "Open a File"
            dialog.setFilters([
                FileFilter(name: "Swift files", suffixes: ["swift"]),
                FileFilter(name: "Text files", suffixes: ["txt", "md"]),
                FileFilter(name: "All files", patterns: ["*"])
            ])
            dialog.open(parent: box.root) { path in
                resultLabel.text = path ?? "Cancelled"
            }
        }
        openGroup.add(openBtn)

        // Save file
        let saveGroup = PreferencesGroup()
        saveGroup.title = "Save File"
        saveGroup.description = "Choose where to save a file"

        let saveBtn = Button(label: "Save File...")
        saveBtn.addCSSClass("pill")
        saveBtn.halign = .center
        saveBtn.onClicked { [resultLabel, box] in
            let dialog = FileDialog()
            dialog.title = "Save File"
            dialog.initialName = "untitled.swift"
            dialog.save(parent: box.root) { path in
                resultLabel.text = path ?? "Cancelled"
            }
        }
        saveGroup.add(saveBtn)

        // Select folder
        let folderGroup = PreferencesGroup()
        folderGroup.title = "Select Folder"
        folderGroup.description = "Choose a directory"

        let folderBtn = Button(label: "Select Folder...")
        folderBtn.addCSSClass("pill")
        folderBtn.halign = .center
        folderBtn.onClicked { [resultLabel, box] in
            let dialog = FileDialog()
            dialog.title = "Select Folder"
            dialog.selectFolder(parent: box.root) { path in
                resultLabel.text = path ?? "Cancelled"
            }
        }
        folderGroup.add(folderBtn)

        box.append(openGroup)
        box.append(saveGroup)
        box.append(folderGroup)
        box.append(resultGroup)

        return box.scrollableClamped()
    }
}
