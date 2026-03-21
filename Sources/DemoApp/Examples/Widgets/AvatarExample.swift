import Adwaita
import CAdwaita

@MainActor
struct AvatarExample: DemoExample {
    let name = "Avatar"
    let id = "avatar"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    // Small avatar
    let small = Avatar(size: 32, text: "John Doe", showInitials: true)

    // Medium avatar
    let medium = Avatar(size: 48, text: "Jane Smith", showInitials: true)

    // Large avatar
    let large = Avatar(size: 96, text: "Alice", showInitials: true)

    // Avatar without initials (shows fallback icon)
    let fallback = Avatar(size: 64, text: nil, showInitials: false)
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Avatars"
        group.description = "User avatar display in various sizes"

        let avatarBox = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 24)
        avatarBox.halign = GTK_ALIGN_CENTER
        avatarBox.setMargins(24)

        let small = Avatar(size: 32, text: "AB", showInitials: true)
        small.valign = GTK_ALIGN_CENTER
        avatarBox.append(small)

        let medium = Avatar(size: 48, text: "CD", showInitials: true)
        medium.valign = GTK_ALIGN_CENTER
        avatarBox.append(medium)

        let large = Avatar(size: 64, text: "EF", showInitials: true)
        large.valign = GTK_ALIGN_CENTER
        avatarBox.append(large)

        let xlarge = Avatar(size: 96, text: "GH", showInitials: true)
        xlarge.valign = GTK_ALIGN_CENTER
        avatarBox.append(xlarge)

        let fallback = Avatar(size: 64, text: nil, showInitials: false)
        fallback.valign = GTK_ALIGN_CENTER
        avatarBox.append(fallback)

        group.add(avatarBox)
        box.append(group)

        // Avatars in rows
        let rowGroup = PreferencesGroup()
        rowGroup.title = "Avatars in Rows"

        let users: [(String, String, String)] = [
            ("Alice Wonderland", "AW", "@alice.wonderland"),
            ("Bob Builder", "BB", "@bob.builder"),
            ("Charlie Chaplin", "CC", "@charlie.chaplin"),
        ]
        for (fullName, initials, handle) in users {
            let row = ActionRow()
            row.title = fullName
            row.subtitle = handle
            let avatar = Avatar(size: 36, text: initials, showInitials: true)
            avatar.valign = GTK_ALIGN_CENTER
            row.addPrefix(avatar)
            rowGroup.add(row)
        }

        box.append(rowGroup)

        let clamp = Clamp()
        clamp.maximumSize = 600
        clamp.child = box

        let scrolled = ScrolledWindow()
        scrolled.child = clamp
        return scrolled
    }
}
