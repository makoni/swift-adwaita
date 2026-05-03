// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

import Adwaita

@MainActor
struct StackSwitcherExample: DemoExample {
    let name = "Stack Switcher"
    let id = "stackswitcher"
    let category: ExampleCategory = .widgets

    let sourceCode = """
    let stack = Stack()
    stack.transitionType = .slideLeftRight

    stack.addTitled(page1, name: "page1", title: "Page 1")
    stack.addTitled(page2, name: "page2", title: "Page 2")

    let switcher = StackSwitcher()
    switcher.stack = stack
    """

    func buildWidget() -> Widget {
        let box = Box(orientation: .vertical, spacing: 24)
        box.setMargins(24)

        let group = PreferencesGroup()
        group.title = "Stack Switcher"
        group.description = "A button row that switches between Stack pages"

        // Create stack with pages
        let stack = Stack()
        stack.transitionType = .slideLeftRight
        stack.transitionDuration = 300

        let page1 = StatusPage()
        page1.iconName = "user-home-symbolic"
        page1.title = "Home"
        page1.description = "This is the home page"
        stack.addTitled(page1, name: "home", title: "Home")

        let page2 = StatusPage()
        page2.iconName = "preferences-other-symbolic"
        page2.title = "Settings"
        page2.description = "This is the settings page"
        stack.addTitled(page2, name: "settings", title: "Settings")

        let page3 = StatusPage()
        page3.iconName = "help-about-symbolic"
        page3.title = "About"
        page3.description = "This is the about page"
        stack.addTitled(page3, name: "about", title: "About")

        // Stack switcher
        let switcher = StackSwitcher()
        switcher.stack = stack
        switcher.halign = .center

        group.add(switcher)
        group.add(stack)

        box.append(group)

        return box.scrollableClamped()
    }
}
