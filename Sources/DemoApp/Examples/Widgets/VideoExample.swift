import Adwaita

@MainActor
struct VideoExample: DemoExample {
    let name = "Video"
    let id = "video"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Video from file
    let video = Video(filename: "/path/to/video.mp4")
    video.autoplay = true
    video.loop = true

    // Or set file later
    let video2 = Video()
    video2.setFilename("/path/to/video.mp4")

    // Media controls for a stream
    let controls = MediaControls()
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group1 = PreferencesGroup()
        group1.title = "Video Widget"
        group1.description = "GtkVideo can play video files with built-in controls"

        let video = Video()
        video.autoplay = false
        video.loop = true
        video.setSizeRequest(width: -1, height: 240)

        group1.add(video)

        let pathEntry = Entry()
        pathEntry.text = ""
        pathEntry.placeholderText = "Enter video file path..."
        pathEntry.hexpand = true
        pathEntry.setMargins(8)

        let loadBtn = Button(label: "Load")
        loadBtn.addCSSClass("suggested-action")
        loadBtn.onClicked { [pathEntry, video] in
            let path = pathEntry.text
            if !path.isEmpty {
                video.setFilename(path)
            }
        }

        let loadRow = Box(orientation: .horizontal, spacing: 8)
        loadRow.setMargins(8)
        loadRow.append(pathEntry)
        loadRow.append(loadBtn)
        group1.add(loadRow)

        box.append(group1)

        // Properties
        let group2 = PreferencesGroup()
        group2.title = "Properties"

        let autoplayRow = ActionRow()
        autoplayRow.title = "Autoplay"
        autoplayRow.subtitle = "Start playing automatically when loaded"
        let autoSwitch = Switch()
        autoSwitch.active = false
        autoSwitch.valign = .center
        autoSwitch.onActiveChanged { [video, autoSwitch] in
            video.autoplay = autoSwitch.active
        }
        autoplayRow.addSuffix(autoSwitch)
        autoplayRow.activatableWidget = autoSwitch
        group2.add(autoplayRow)

        let loopRow = ActionRow()
        loopRow.title = "Loop"
        loopRow.subtitle = "Repeat video when it finishes"
        let loopSwitch = Switch()
        loopSwitch.active = true
        loopSwitch.valign = .center
        loopSwitch.onActiveChanged { [video, loopSwitch] in
            video.loop = loopSwitch.active
        }
        loopRow.addSuffix(loopSwitch)
        loopRow.activatableWidget = loopSwitch
        group2.add(loopRow)

        box.append(group2)

        return box.scrollableClamped()
    }
}
