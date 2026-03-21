import Adwaita
import CAdwaita

@MainActor
func showCodeDialog(sourceCode: String, title: String, parent: Widget) {
    let dialog = Dialog()
    dialog.title = "Source: \(title)"
    dialog.contentWidth = 700
    dialog.contentHeight = 500

    let codeLabel = Label(sourceCode)
    codeLabel.selectable = true
    codeLabel.wrap = false
    codeLabel.xalign = 0
    codeLabel.addCSSClass("monospace")
    codeLabel.setMargins(12)

    let scrolled = ScrolledWindow()
    scrolled.child = codeLabel
    scrolled.setPolicy(horizontal: GTK_POLICY_AUTOMATIC, vertical: GTK_POLICY_AUTOMATIC)

    let headerBar = HeaderBar()
    let toolbar = ToolbarView()
    toolbar.addTopBar(headerBar)
    toolbar.content = scrolled

    dialog.child = toolbar
    dialog.present(parent)
}
