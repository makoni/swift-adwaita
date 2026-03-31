/// Type-safe icon names for standard Adwaita/GNOME symbolic icons.
///
/// Use these with ``Image/init(icon:)`` and icon-accepting properties
/// instead of raw strings. For icons not listed here, use the
/// string-based overloads or ``custom(_:)``.
public enum IconName: Sendable, Equatable {

    // MARK: - Navigation

    case goNext
    case goPrevious
    case goUp
    case goDown
    case goHome

    // MARK: - Actions

    case editCopy
    case editCut
    case editPaste
    case editDelete
    case editUndo
    case editRedo
    case editFind
    case editSelectAll
    case documentNew
    case documentOpen
    case documentSave
    case documentSaveAs
    case documentEdit
    case documentPrint
    case documentProperties

    // MARK: - Media

    case mediaPlaybackStart
    case mediaPlaybackPause
    case mediaPlaybackStop
    case mediaSkipForward
    case mediaSkipBackward
    case mediaRecord

    // MARK: - View

    case viewRefresh
    case viewReveal
    case viewFullscreen
    case viewGrid
    case viewList

    // MARK: - Window

    case windowNew
    case windowClose

    // MARK: - System & Apps

    case applicationExit
    case applicationsScience
    case applicationXExecutable
    case systemSearch
    case systemRun
    case helpAbout

    // MARK: - Status & Emblems

    case dialogInformation
    case dialogWarning
    case dialogError
    case dialogQuestion
    case dialogPassword
    case emblemOk
    case emblemImportant
    case emblemFavorite
    case emblemSystem
    case emblemDefault

    // MARK: - Devices & Hardware

    case networkWireless
    case networkWired
    case bluetooth
    case computerLaptop
    case audioVolumeHigh
    case audioVolumeMedium
    case audioVolumeLow
    case audioVolumeMuted
    case displayBrightness
    case batteryFull
    case printer

    // MARK: - Content Types

    case folderOpen
    case folder
    case userHome
    case userTrash

    // MARK: - Weather

    case weatherClear
    case weatherOvercast
    case weatherFewClouds

    // MARK: - Common UI

    case listAdd
    case listRemove
    case sendTo
    case mailSend
    case starFilled
    case starOutline
    case heartFilled
    case heartOutline
    case bookmarkNew
    case tabNew
    case code
    case terminalApp
    case preferences
    case securityHigh
    case avatarDefault
    case startHere

    // MARK: - Adwaita Specific

    case sidebarShow
    case openMenu
    case viewMore

    // MARK: - Custom

    case custom(String)

    /// The icon name string (with `-symbolic` suffix).
    public var name: String {
        switch self {
        case .goNext: "go-next-symbolic"
        case .goPrevious: "go-previous-symbolic"
        case .goUp: "go-up-symbolic"
        case .goDown: "go-down-symbolic"
        case .goHome: "go-home-symbolic"
        case .editCopy: "edit-copy-symbolic"
        case .editCut: "edit-cut-symbolic"
        case .editPaste: "edit-paste-symbolic"
        case .editDelete: "edit-delete-symbolic"
        case .editUndo: "edit-undo-symbolic"
        case .editRedo: "edit-redo-symbolic"
        case .editFind: "edit-find-symbolic"
        case .editSelectAll: "edit-select-all-symbolic"
        case .documentNew: "document-new-symbolic"
        case .documentOpen: "document-open-symbolic"
        case .documentSave: "document-save-symbolic"
        case .documentSaveAs: "document-save-as-symbolic"
        case .documentEdit: "document-edit-symbolic"
        case .documentPrint: "document-print-symbolic"
        case .documentProperties: "document-properties-symbolic"
        case .mediaPlaybackStart: "media-playback-start-symbolic"
        case .mediaPlaybackPause: "media-playback-pause-symbolic"
        case .mediaPlaybackStop: "media-playback-stop-symbolic"
        case .mediaSkipForward: "media-skip-forward-symbolic"
        case .mediaSkipBackward: "media-skip-backward-symbolic"
        case .mediaRecord: "media-record-symbolic"
        case .viewRefresh: "view-refresh-symbolic"
        case .viewReveal: "view-reveal-symbolic"
        case .viewFullscreen: "view-fullscreen-symbolic"
        case .viewGrid: "view-grid-symbolic"
        case .viewList: "view-list-symbolic"
        case .windowNew: "window-new-symbolic"
        case .windowClose: "window-close-symbolic"
        case .applicationExit: "application-exit-symbolic"
        case .applicationsScience: "applications-science-symbolic"
        case .applicationXExecutable: "application-x-executable-symbolic"
        case .systemSearch: "system-search-symbolic"
        case .systemRun: "system-run-symbolic"
        case .helpAbout: "help-about-symbolic"
        case .dialogInformation: "dialog-information-symbolic"
        case .dialogWarning: "dialog-warning-symbolic"
        case .dialogError: "dialog-error-symbolic"
        case .dialogQuestion: "dialog-question-symbolic"
        case .dialogPassword: "dialog-password-symbolic"
        case .emblemOk: "emblem-ok-symbolic"
        case .emblemImportant: "emblem-important-symbolic"
        case .emblemFavorite: "emblem-favorite-symbolic"
        case .emblemSystem: "emblem-system-symbolic"
        case .emblemDefault: "emblem-default-symbolic"
        case .networkWireless: "network-wireless-symbolic"
        case .networkWired: "network-wired-symbolic"
        case .bluetooth: "bluetooth-symbolic"
        case .computerLaptop: "computer-laptop-symbolic"
        case .audioVolumeHigh: "audio-volume-high-symbolic"
        case .audioVolumeMedium: "audio-volume-medium-symbolic"
        case .audioVolumeLow: "audio-volume-low-symbolic"
        case .audioVolumeMuted: "audio-volume-muted-symbolic"
        case .displayBrightness: "display-brightness-symbolic"
        case .batteryFull: "battery-full-symbolic"
        case .printer: "printer-symbolic"
        case .folderOpen: "folder-open-symbolic"
        case .folder: "folder-symbolic"
        case .userHome: "user-home-symbolic"
        case .userTrash: "user-trash-symbolic"
        case .weatherClear: "weather-clear-symbolic"
        case .weatherOvercast: "weather-overcast-symbolic"
        case .weatherFewClouds: "weather-few-clouds-symbolic"
        case .listAdd: "list-add-symbolic"
        case .listRemove: "list-remove-symbolic"
        case .sendTo: "send-to-symbolic"
        case .mailSend: "mail-send-symbolic"
        case .starFilled: "starred-symbolic"
        case .starOutline: "non-starred-symbolic"
        case .heartFilled: "emblem-favorite-symbolic"
        case .heartOutline: "heart-outline-thick-symbolic"
        case .bookmarkNew: "bookmark-new-symbolic"
        case .tabNew: "tab-new-symbolic"
        case .code: "text-editor-symbolic"
        case .terminalApp: "utilities-terminal-symbolic"
        case .preferences: "preferences-other-symbolic"
        case .securityHigh: "security-high-symbolic"
        case .avatarDefault: "avatar-default-symbolic"
        case .startHere: "start-here-symbolic"
        case .sidebarShow: "sidebar-show-symbolic"
        case .openMenu: "open-menu-symbolic"
        case .viewMore: "view-more-symbolic"
        case let .custom(name): name
        }
    }
}
