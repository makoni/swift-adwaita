import CAdwaita
import GObjectSupport

/// A calendar widget for selecting dates.
///
/// Wraps `GtkCalendar`.
@MainActor
public final class Calendar: Widget {
    /// Creates a new calendar widget showing today's date.
    public init() {
        let ptr = gtk_calendar_new()!
        super.init(raw: UnsafeMutableRawPointer(ptr))
    }

    required internal init(raw pointer: UnsafeMutableRawPointer) {
        super.init(raw: pointer)
    }

    /// The selected year.
    public var year: Int {
        get { Int(gtk_calendar_get_year(opaquePointer)) }
        set {
            let dt = g_date_time_new_local(Int32(newValue), Int32(month), Int32(day), 0, 0, 0)
            gtk_calendar_select_day(opaquePointer, dt)
        }
    }

    /// The selected month (1–12).
    public var month: Int {
        get { Int(gtk_calendar_get_month(opaquePointer)) + 1 }
        set {
            let dt = g_date_time_new_local(Int32(year), Int32(newValue), Int32(day), 0, 0, 0)
            gtk_calendar_select_day(opaquePointer, dt)
        }
    }

    /// The selected day of the month (1–31).
    public var day: Int {
        get { Int(gtk_calendar_get_day(opaquePointer)) }
        set {
            let dt = g_date_time_new_local(Int32(year), Int32(month), Int32(newValue), 0, 0, 0)
            gtk_calendar_select_day(opaquePointer, dt)
        }
    }

    /// Whether the calendar shows day names.
    public var showDayNames: Bool {
        get { gtk_calendar_get_show_day_names(opaquePointer) != 0 }
        set { gtk_calendar_set_show_day_names(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the calendar shows heading (month and year).
    public var showHeading: Bool {
        get { gtk_calendar_get_show_heading(opaquePointer) != 0 }
        set { gtk_calendar_set_show_heading(opaquePointer, newValue ? 1 : 0) }
    }

    /// Whether the calendar shows week numbers.
    public var showWeekNumbers: Bool {
        get { gtk_calendar_get_show_week_numbers(opaquePointer) != 0 }
        set { gtk_calendar_set_show_week_numbers(opaquePointer, newValue ? 1 : 0) }
    }

    /// Marks the given day of the month.
    public func markDay(_ day: Int) {
        gtk_calendar_mark_day(opaquePointer, UInt32(day))
    }

    /// Unmarks the given day of the month.
    public func unmarkDay(_ day: Int) {
        gtk_calendar_unmark_day(opaquePointer, UInt32(day))
    }

    /// Whether a given day is marked.
    public func dayIsMarked(_ day: Int) -> Bool {
        gtk_calendar_get_day_is_marked(opaquePointer, UInt32(day)) != 0
    }

    /// Clears all marks.
    public func clearMarks() {
        gtk_calendar_clear_marks(opaquePointer)
    }

    /// Connects to the `day-selected` signal.
    @discardableResult
    public func onDaySelected(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .daySelected, handler: handler)
    }

    /// Connects to the `prev-month` signal.
    @discardableResult
    public func onPrevMonth(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .prevMonth, handler: handler)
    }

    /// Connects to the `next-month` signal.
    @discardableResult
    public func onNextMonth(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .nextMonth, handler: handler)
    }

    /// Connects to the `prev-year` signal.
    @discardableResult
    public func onPrevYear(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .prevYear, handler: handler)
    }

    /// Connects to the `next-year` signal.
    @discardableResult
    public func onNextYear(_ handler: @escaping @MainActor () -> Void) -> SignalConnection {
        SignalHelper.connect(self, signal: .nextYear, handler: handler)
    }
}
