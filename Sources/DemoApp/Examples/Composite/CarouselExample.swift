import Adwaita
import CAdwaita

@MainActor
struct CarouselExample: DemoExample {
    let name = "Carousel"
    let id = "carousel"
    let category: ExampleCategory = .composite

    let sourceCode = """
    let carousel = Carousel()
    carousel.allowMouseDrag = true
    carousel.spacing = 12

    // Add pages
    let page1 = StatusPage()
    page1.title = "Welcome"
    page1.iconName = "start-here-symbolic"
    page1.description = "Swipe to explore"
    carousel.append(page1)

    let page2 = StatusPage()
    page2.title = "Features"
    page2.iconName = "applications-science-symbolic"
    carousel.append(page2)

    let page3 = StatusPage()
    page3.title = "Get Started"
    page3.iconName = "emblem-ok-symbolic"
    carousel.append(page3)

    // Indicator dots
    let dots = CarouselIndicatorDots()
    dots.carousel = carousel.opaquePointer
    """

    func buildWidget() -> Widget {
        let carousel = Carousel()
        carousel.allowMouseDrag = true
        carousel.spacing = 12

        // Page 1
        let page1 = StatusPage()
        page1.title = "Welcome"
        page1.iconName = "start-here-symbolic"
        page1.description = "Swipe left or drag to explore the carousel pages"
        carousel.append(page1)

        // Page 2
        let page2 = StatusPage()
        page2.title = "Features"
        page2.iconName = "applications-science-symbolic"
        page2.description = "Build native GNOME apps using Swift"
        carousel.append(page2)

        // Page 3
        let page3 = StatusPage()
        page3.title = "Customize"
        page3.iconName = "preferences-system-symbolic"
        page3.description = "Tailor every detail to your needs"
        carousel.append(page3)

        // Page 4
        let page4 = StatusPage()
        page4.title = "Get Started"
        page4.iconName = "emblem-ok-symbolic"
        page4.description = "You are all set!"
        carousel.append(page4)

        // Indicator dots
        let dots = CarouselIndicatorDots()
        dots.carousel = carousel.opaquePointer

        // Navigation buttons
        let prevBtn = Button(iconName: "go-previous-symbolic")
        prevBtn.addCSSClass("flat")
        prevBtn.onClicked { [carousel] in
            let pos = carousel.position
            if pos > 0 {
                let target = UInt32(max(0, Int(pos) - 1))
                let targetPage = carousel.getNthPage(target)
                carousel.scrollTo(targetPage, animate: true)
            }
        }

        let nextBtn = Button(iconName: "go-next-symbolic")
        nextBtn.addCSSClass("flat")
        nextBtn.onClicked { [carousel] in
            let pos = carousel.position
            let n = carousel.nPages
            if UInt32(pos) < n - 1 {
                let target = UInt32(min(Int(pos) + 1, Int(n) - 1))
                let targetPage = carousel.getNthPage(target)
                carousel.scrollTo(targetPage, animate: true)
            }
        }

        let navBox = Box(orientation: GTK_ORIENTATION_HORIZONTAL, spacing: 12)
        navBox.halign = GTK_ALIGN_CENTER
        navBox.append(prevBtn)
        navBox.append(dots)
        navBox.append(nextBtn)

        let outerBox = Box(orientation: GTK_ORIENTATION_VERTICAL, spacing: 0)
        carousel.vexpand = true
        outerBox.append(carousel)
        navBox.setMargins(12)
        outerBox.append(navBox)

        return outerBox
    }
}
