import Adwaita

enum ExampleCategory {
    case composite
    case widgets
}

@MainActor
protocol DemoExample {
    var name: String { get }
    var id: String { get }
    var category: ExampleCategory { get }
    var sourceCode: String { get }
    func buildWidget() -> Widget
}

@MainActor
let allExamples: [any DemoExample] = [
    // Composite layouts
    PreferencesExample(),
    StatusPageExample(),
    ToolbarExample(),
    ListRowsExample(),
    TabViewExample(),
    CarouselExample(),
    BottomSheetExample(),
    PanedExample(),
    NotebookExample(),
    NavigationViewExample(),
    ViewSwitcherExample(),
    StyleManagerExample(),
    AboutDialogExample(),
    AnimationExample(),
    BreakpointExample(),
    // Individual widgets
    ButtonExample(),
    EntryExample(),
    SwitchExample(),
    SpinRowExample(),
    LabelExample(),
    AvatarExample(),
    BannerExample(),
    SpinnerExample(),
    RevealerExample(),
    ToastExample(),
    AlertDialogExample(),
    ProgressBarExample(),
    ScaleExample(),
    GridExample(),
    DropDownExample(),
    ExpanderExample(),
    ColorPickerExample(),
    FontPickerExample(),
    FrameExample(),
    CalendarExample(),
    DrawingAreaExample(),
    TextViewExample(),
    FlowBoxExample(),
    OverlayExample(),
    EmojiChooserExample(),
    LevelBarExample(),
    PictureExample(),
    SeparatorExample(),
    SearchBarExample(),
    SplitButtonExample(),
    CheckButtonExample(),
    ComboRowExample(),
    ExpanderRowExample(),
    ButtonRowExample(),
    PasswordEntryExample(),
    ToggleGroupExample(),
    WrapBoxExample(),
    ActionBarExample(),
]
