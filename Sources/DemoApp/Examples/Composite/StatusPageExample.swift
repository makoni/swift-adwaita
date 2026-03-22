import Adwaita
import CAdwaita

@MainActor
struct StatusPageExample: DemoExample {
    let name = "Status Page"
    let id = "statuspage"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let statusPage = StatusPage()
    statusPage.iconName = "application-x-executable-symbolic"
    statusPage.title = "Welcome to swift-adwaita"
    statusPage.description = "Build beautiful GTK4 apps with Swift"

    let getStartedBtn = Button(label: "Get Started")
    getStartedBtn.addCSSClass("suggested-action")
    getStartedBtn.addCSSClass("pill")
    getStartedBtn.halign = .center
    getStartedBtn.onClicked {
        statusPage.title = "Let's Go!"
        statusPage.iconName = "emblem-ok-symbolic"
    }
    statusPage.child = getStartedBtn
    """

    func buildWidget() -> Widget {
        let statusPage = StatusPage()
        statusPage.iconName = "application-x-executable-symbolic"
        statusPage.title = "Welcome to swift-adwaita"
        statusPage.description = "Build beautiful GTK4 apps with Swift"

        let getStartedBtn = Button(label: "Get Started")
        getStartedBtn.addCSSClass("suggested-action")
        getStartedBtn.addCSSClass("pill")
        getStartedBtn.halign = .center

        getStartedBtn.onClicked { [statusPage] in
            statusPage.title = "Let's Go!"
            statusPage.iconName = "emblem-ok-symbolic"
        }

        statusPage.child = getStartedBtn
        return statusPage
    }
}
