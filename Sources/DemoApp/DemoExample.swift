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
    /// If true, the example opens in a separate window via a "Try It" button.
    var opensInWindow: Bool { get }
    func buildWidget() -> Widget
}

extension DemoExample {
    var opensInWindow: Bool {
        false
    }
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
    NavigationSplitViewExample(),
    OverlaySplitViewExample(),
    DialogExample(),
    PreferencesDialogExample(),
    SpringAnimationExample(),
    MenuExample(),
    MenuBarExample(),
    MultiWindowExample(),
    CustomCSSExample(),
    DataBindingExample(),
    KeyboardShortcutsExample(),
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
    ShortcutExample(),
    ClipboardExample(),
    FileDialogExample(),
    DragDropExample(),
    GestureExample(),
    CssProviderExample(),
    VideoExample(),
    StackSwitcherExample(),
    ListViewExample(),
    GridViewExample(),
    ColumnViewExample(),
    TreeListExample(),
    FilterSortExample()
]
