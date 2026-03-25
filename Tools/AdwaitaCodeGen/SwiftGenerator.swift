import Foundation

// MARK: - Deprecated classes to skip

let deprecatedClasses: Set<String> = [
    "AboutWindow", "Flap", "Leaflet", "MessageDialog",
    "PreferencesWindow", "Squeezer",
]

// Classes that are hand-written (Phase 1) — skip generation
let handWrittenClasses: Set<String> = [
    "Application", "ApplicationWindow",
    "HeaderBar", "ToolbarView", "StatusPage",
]

// MARK: - Opaque (final) C types — from G_DECLARE_FINAL_TYPE in headers

/// These types have opaque C structs and must use OpaquePointer in Swift.
let opaqueTypes: Set<String> = [
    "AdwAboutDialog", "AdwAboutWindow", "AdwAvatar", "AdwBanner",
    "AdwBottomSheet", "AdwBreakpoint", "AdwButtonContent", "AdwButtonRow",
    "AdwCarousel", "AdwCarouselIndicatorDots", "AdwCarouselIndicatorLines",
    "AdwClamp", "AdwClampLayout", "AdwClampScrollable",
    "AdwEnumListItem", "AdwEnumListModel",
    "AdwFlap", "AdwHeaderBar", "AdwInlineViewSwitcher",
    "AdwLayout", "AdwLayoutSlot", "AdwLeaflet", "AdwLeafletPage",
    "AdwMultiLayoutView", "AdwNavigationSplitView", "AdwNavigationView",
    "AdwOverlaySplitView", "AdwPasswordEntryRow",
    "AdwShortcutLabel", "AdwShortcutsDialog", "AdwShortcutsItem", "AdwShortcutsSection",
    "AdwSpinRow", "AdwSpinner", "AdwSpinnerPaintable", "AdwSplitButton",
    "AdwSqueezer", "AdwSqueezerPage",
    "AdwStatusPage", "AdwStyleManager", "AdwSwipeTracker",
    "AdwSwitchRow", "AdwTabBar", "AdwTabButton", "AdwTabOverview",
    "AdwTabPage", "AdwTabView", "AdwToast", "AdwToastOverlay",
    "AdwToggle", "AdwToggleGroup", "AdwToolbarView",
    "AdwViewStack", "AdwViewStackPage", "AdwViewStackPages",
    "AdwViewSwitcher", "AdwViewSwitcherBar", "AdwViewSwitcherTitle",
    "AdwWindowTitle", "AdwWrapBox", "AdwWrapLayout",
    // GDK_DECLARE_INTERNAL_TYPE (also opaque)
    "AdwAnimationTarget", "AdwCallbackAnimationTarget",
    "AdwPropertyAnimationTarget", "AdwSpringAnimation", "AdwTimedAnimation",
    "AdwNoneAnimationTarget",
]

func isOpaqueType(_ cType: String) -> Bool {
    opaqueTypes.contains(cType)
}

// MARK: - Type Mapping

/// Maps GIR type names to Swift types
func swiftType(for girType: GIRType, nullable: Bool) -> String {
    let base = swiftBaseType(for: girType)
    if nullable && base != "Bool" && base != "Int32" && base != "UInt32" && base != "Double" && base != "Float" {
        return "\(base)?"
    }
    return base
}

func swiftBaseType(for girType: GIRType) -> String {
    switch girType.name {
    case "none": return "Void"
    case "utf8", "filename": return "String"
    case "gboolean": return "Bool"
    case "gint", "int": return "Int32"
    case "guint", "unsigned": return "UInt32"
    case "gint64": return "Int64"
    case "guint64": return "UInt64"
    case "gfloat", "float": return "Float"
    case "gdouble", "double": return "Double"
    case "gpointer": return "UnsafeMutableRawPointer"
    case "GType": return "GType"
    default:
        // GObject types
        if girType.name.hasPrefix("Gtk.") {
            return girType.name.replacingOccurrences(of: "Gtk.", with: "")
        }
        if girType.name.hasPrefix("Gio.") {
            return girType.name.replacingOccurrences(of: "Gio.", with: "")
        }
        if girType.name.hasPrefix("Gdk.") {
            return girType.name.replacingOccurrences(of: "Gdk.", with: "")
        }
        return girType.name
    }
}

/// Whether the parameter type is a "widget" type that should use our Widget wrapper
func isWidgetType(_ girType: GIRType) -> Bool {
    girType.name == "Gtk.Widget" || girType.cType.hasSuffix("GtkWidget*")
}

/// Whether the type is a known Adwaita class
func isAdwClass(_ name: String, classes: [GIRClass]) -> Bool {
    classes.contains { $0.name == name }
}

/// Whether a class is "final" (opaque struct) and needs OpaquePointer
func classIsFinal(_ name: String, classes: [GIRClass]) -> Bool {
    classes.first { $0.name == name }?.isFinal ?? false
}

/// Convert snake_case to camelCase
func snakeToCamel(_ snake: String) -> String {
    let parts = snake.split(separator: "_")
    guard let first = parts.first else { return snake }
    let rest = parts.dropFirst().map { $0.prefix(1).uppercased() + $0.dropFirst() }
    return String(first) + rest.joined()
}

/// Convert snake_case to PascalCase
func snakeToPascal(_ snake: String) -> String {
    snake.split(separator: "_").map { $0.prefix(1).uppercased() + $0.dropFirst() }.joined()
}

/// Determine the parent Swift class for an Adw class
func resolveParent(_ cls: GIRClass, allClasses: [GIRClass]) -> String {
    guard let parent = cls.parent else { return "GObjectRef" }
    // Check if parent is an Adw class
    if allClasses.contains(where: { $0.name == parent }) {
        return parent
    }
    // GTK parent mapping
    switch parent {
    case "Gtk.Widget", "Widget": return "Widget"
    case "Gtk.Window", "Window": return "GtkWindow"
    case "Gtk.ApplicationWindow", "ApplicationWindow": return "ApplicationWindow"
    case "Gtk.Application", "Application": return "Application"
    case "Gtk.ListBoxRow", "ListBoxRow": return "ListBoxRow"
    case "Gtk.LayoutManager", "LayoutManager": return "LayoutManager"
    case "Gtk.Editable", "Editable": return "Widget"
    case "GObject.Object": return "GObjectRef"
    default: return "Widget"
    }
}

// MARK: - Intermediate GTK base classes we need

/// These are GTK base classes that Adw classes inherit from.
/// We need minimal wrappers for them to build the inheritance chain.
struct IntermediateClass {
    let swiftName: String
    let parentSwift: String
    let cType: String
    let isOpaque: Bool
}

func findNeededIntermediates(_ classes: [GIRClass]) -> [IntermediateClass] {
    var needed: Set<String> = []
    for cls in classes where !cls.isDeprecated && !deprecatedClasses.contains(cls.name) {
        guard let parent = cls.parent else { continue }
        switch parent {
        case "Gtk.ListBoxRow", "ListBoxRow":
            needed.insert("ListBoxRow")
        case "Gtk.LayoutManager", "LayoutManager":
            needed.insert("LayoutManager")
        case "Gtk.Window", "Window":
            needed.insert("GtkWindow")
        default: break
        }
    }
    var result: [IntermediateClass] = []
    if needed.contains("GtkWindow") {
        result.append(IntermediateClass(
            swiftName: "GtkWindow", parentSwift: "Widget",
            cType: "GtkWindow", isOpaque: false
        ))
    }
    if needed.contains("ListBoxRow") {
        result.append(IntermediateClass(
            swiftName: "ListBoxRow", parentSwift: "Widget",
            cType: "GtkListBoxRow", isOpaque: false
        ))
    }
    if needed.contains("LayoutManager") {
        result.append(IntermediateClass(
            swiftName: "LayoutManager", parentSwift: "GObjectRef",
            cType: "GtkLayoutManager", isOpaque: false
        ))
    }
    return result
}

// MARK: - Code Generation

class SwiftGenerator {
    let namespace: GIRNamespace
    let outputDir: String
    private var currentClass: GIRClass?

    init(namespace: GIRNamespace, outputDir: String) {
        self.namespace = namespace
        self.outputDir = outputDir
    }

    /// Set of class names that have subclasses — these cannot be `final`
    private lazy var classesWithSubclasses: Set<String> = {
        var result: Set<String> = []
        for cls in namespace.classes where !cls.isDeprecated && !deprecatedClasses.contains(cls.name) {
            if let parent = cls.parent {
                result.insert(parent)
                // Also normalize Adw names
                if !parent.contains(".") {
                    result.insert(parent)
                }
            }
        }
        return result
    }()

    /// Set of class names that define a no-arg init
    private lazy var classesWithNoArgInit: Set<String> = {
        var result: Set<String> = []
        for cls in namespace.classes where !cls.isDeprecated && !deprecatedClasses.contains(cls.name) {
            if cls.constructors.contains(where: { $0.name == "new" && $0.parameters.isEmpty && !$0.isDeprecated }) {
                result.insert(cls.name)
            }
        }
        return result
    }()

    /// Check if any ancestor has a no-arg init
    private func ancestorHasNoArgInit(_ cls: GIRClass) -> Bool {
        guard let parentName = cls.parent else { return false }
        // GTK/GObject base classes don't define no-arg init (Widget, GtkWindow, etc.)
        if parentName.hasPrefix("Gtk.") || parentName.hasPrefix("GObject.") {
            return false
        }
        // Check Adw parent classes
        if let parentCls = namespace.classes.first(where: { $0.name == parentName }) {
            if parentCls.constructors.contains(where: { $0.name == "new" && $0.parameters.isEmpty && !$0.isDeprecated }) {
                return true
            }
            return ancestorHasNoArgInit(parentCls)
        }
        return false
    }

    func generate() throws {
        let fm = FileManager.default
        try fm.createDirectory(atPath: outputDir, withIntermediateDirectories: true)

        // Generate intermediate GTK base classes
        let intermediates = findNeededIntermediates(namespace.classes)
        for inter in intermediates {
            try generateIntermediate(inter)
        }

        // Generate class wrappers
        for cls in namespace.classes {
            guard !cls.isDeprecated,
                  !deprecatedClasses.contains(cls.name),
                  !handWrittenClasses.contains(cls.name) else { continue }
            try generateClass(cls)
        }

        print("Generated \(namespace.classes.filter { !$0.isDeprecated && !deprecatedClasses.contains($0.name) && !handWrittenClasses.contains($0.name) }.count) class wrappers")
    }

    // MARK: - Intermediate Class Generation

    private func generateIntermediate(_ inter: IntermediateClass) throws {
        let out = """
        // Auto-generated intermediate GTK class wrapper
        import CAdwaita
        import GObjectSupport

        /// Minimal wrapper for \(inter.cType).
        @MainActor
        open class \(inter.swiftName): \(inter.parentSwift) {}

        """
        let path = "\(outputDir)/\(inter.swiftName).swift"
        try out.write(toFile: path, atomically: true, encoding: .utf8)
    }

    // MARK: - Class Generation

    private func generateClass(_ cls: GIRClass) throws {
        currentClass = cls
        let parentSwift = resolveParent(cls, allClasses: namespace.classes)
        let className = cls.name

        var out = """
        // Auto-generated from Adw-1.gir — do not edit
        import CAdwaita
        import GObjectSupport

        """

        // Class declaration
        let isOpaque = isOpaqueType(cls.cType)
        let hasSubclasses = classesWithSubclasses.contains(cls.name)
        // Doc comment from GIR
        if let doc = cls.doc {
            out += formatDocComment(doc)
        } else {
            out += "/// Wraps `\(cls.cType)`.\n"
        }
        if let version = cls.version {
            out += availableAnnotation(version)
        }
        out += "@MainActor\n"
        if isOpaque && !hasSubclasses {
            out += "public final class \(className): \(parentSwift) {\n"
        } else {
            out += "open class \(className): \(parentSwift) {\n"
        }

        // Always provide init(raw:) so subclasses can call super.init(raw:)
        // and factory methods can construct instances.
        let hasCustomInit = cls.constructors.contains { !$0.isDeprecated && !hasUnsupportedParams($0.parameters) }
        if hasCustomInit {
            out += "\n    /// Internal raw-pointer initializer.\n"
            out += "    override internal init(raw pointer: UnsafeMutableRawPointer) {\n"
            out += "        super.init(raw: pointer)\n"
            out += "    }\n"
        }

        // Constructor(s)
        for ctor in cls.constructors where !ctor.isDeprecated {
            out += generateConstructor(ctor, className: className, isFinal: cls.isFinal)
        }

        // Properties via getter/setter methods
        let propertyPairs = buildPropertyPairs(cls)
        for pair in propertyPairs {
            out += generateProperty(pair, cls: cls)
        }

        // Non-property methods
        let propertyMethodIds = Set(propertyPairs.flatMap { [$0.getter?.cIdentifier, $0.setter?.cIdentifier].compactMap { $0 } })
        let constructorIds = Set(cls.constructors.map { $0.cIdentifier })

        for method in cls.methods where !method.isDeprecated {
            guard !propertyMethodIds.contains(method.cIdentifier),
                  !constructorIds.contains(method.cIdentifier) else { continue }
            out += generateMethod(method, cls: cls)
        }

        // Signals
        for signal in cls.signals where !signal.isDeprecated {
            out += generateSignalMethod(signal, cls: cls)
        }

        out += "}\n"

        let path = "\(outputDir)/\(className).swift"
        try out.write(toFile: path, atomically: true, encoding: .utf8)
    }

    // MARK: - Constructor Generation

    private func generateConstructor(_ ctor: GIRFunction, className: String, isFinal: Bool) -> String {
        // Skip constructors with unsupported parameter types
        guard !hasUnsupportedParams(ctor.parameters) else { return "" }
        var out = ""
        let params = ctor.parameters

        // Build parameter list
        let swiftParams = params.map { p -> String in
            let label = swiftParamLabel(p.name)
            let type = swiftParamType(p)
            return "\(label): \(type)"
        }
        let paramList = swiftParams.joined(separator: ", ")

        out += "\n    /// Creates a new `\(className)`.\n"
        // Non-"new" constructors use a named factory pattern
        if ctor.name != "new" {
            let factoryName = snakeToCamel(ctor.name)
            out += "    public static func \(factoryName)(\(paramList)) -> \(className) {\n"
            let args = params.map { cArgFromSwift($0) }
            let argList = args.joined(separator: ", ")
            out += "        let ptr = \(ctor.cIdentifier)(\(argList))!\n"
            out += "        return \(className)(raw: UnsafeMutableRawPointer(ptr))\n"
            out += "    }\n"
        } else {
            // Check if parent already defines init() with same signature — need override
            let needsOverride = params.isEmpty && ancestorHasNoArgInit(currentClass!)
            let overrideStr = needsOverride ? "override " : ""
            out += "    \(overrideStr)public init(\(paramList)) {\n"
            let args = params.map { cArgFromSwift($0) }
            let argList = args.joined(separator: ", ")
            out += "        let ptr = \(ctor.cIdentifier)(\(argList))!\n"
            out += "        super.init(raw: UnsafeMutableRawPointer(ptr))\n"
            out += "    }\n"
        }

        return out
    }

    // MARK: - Property Generation

    struct PropertyPair {
        let name: String
        let swiftName: String
        let getter: GIRFunction?
        let setter: GIRFunction?
        let type: GIRType
        let nullable: Bool
        let version: String?
    }

    private func buildPropertyPairs(_ cls: GIRClass) -> [PropertyPair] {
        var pairs: [PropertyPair] = []
        var processed: Set<String> = []

        // Match getters and setters by property name
        for method in cls.methods where !method.isDeprecated {
            if let propName = method.getProperty, !processed.contains(propName) {
                processed.insert(propName)
                let setter = cls.methods.first { $0.setProperty == propName && !$0.isDeprecated }
                let swiftName = snakeToCamel(propName.replacingOccurrences(of: "-", with: "_"))
                let propVersion = cls.properties.first(where: { $0.name == propName })?.version
                pairs.append(PropertyPair(
                    name: propName,
                    swiftName: swiftName,
                    getter: method,
                    setter: setter,
                    type: method.returnValue.type,
                    nullable: method.returnValue.nullable,
                    version: propVersion
                ))
            }
        }

        return pairs
    }

    private func generateProperty(_ pair: PropertyPair, cls: GIRClass) -> String {
        // Skip array properties
        if pair.type.isArray { return "" }
        let swiftRetType = swiftReturnType(pair.type, nullable: pair.nullable)
        guard let typeName = swiftRetType, typeName != "__UNSUPPORTED__" else { return "" }
        // Also skip if setter has unsupported params
        if let setter = pair.setter, hasUnsupportedParams(setter.parameters) { return "" }
        // Skip if setter parameter is an array type
        if let setter = pair.setter, setter.parameters.contains(where: { $0.type.isArray }) { return "" }

        var out = "\n"

        // Determine if we need OpaquePointer for this class
        let selfArg = isOpaqueType(cls.cType) ? "opaquePointer" : "castedPointer() as UnsafeMutablePointer<\(cls.cType)>"

        let versionComment = pair.version.flatMap { $0 != "1.0" ? "    /// - Since: libadwaita \($0)\n" : nil } ?? ""

        if pair.getter != nil && pair.setter != nil {
            out += "    /// The `\(pair.name)` property.\n"
            out += versionComment
            out += "    public var \(pair.swiftName): \(typeName) {\n"
            out += "        get { \(generateGetterBody(pair.getter!, selfArg: selfArg, type: pair.type, nullable: pair.nullable)) }\n"
            out += "        set { \(generateSetterBody(pair.setter!, selfArg: selfArg, type: pair.type, nullable: pair.nullable)) }\n"
            out += "    }\n"
        } else if let getter = pair.getter {
            out += "    /// The `\(pair.name)` property (read-only).\n"
            out += versionComment
            out += "    public var \(pair.swiftName): \(typeName) {\n"
            out += "        \(generateGetterBody(getter, selfArg: selfArg, type: pair.type, nullable: pair.nullable))\n"
            out += "    }\n"
        }

        return out
    }

    private func generateGetterBody(_ getter: GIRFunction, selfArg: String, type: GIRType, nullable: Bool) -> String {
        let call = "\(getter.cIdentifier)(\(selfArg))"
        return convertReturnToSwift(call: call, type: type, nullable: nullable)
    }

    private func generateSetterBody(_ setter: GIRFunction, selfArg: String, type: GIRType, nullable: Bool = false) -> String {
        let param = setter.parameters.first!
        let arg = convertSwiftToC("newValue", type: type, paramType: param.type, nullable: nullable)
        return "\(setter.cIdentifier)(\(selfArg), \(arg))"
    }

    // MARK: - Method Generation

    private func generateMethod(_ method: GIRFunction, cls: GIRClass) -> String {
        // Skip virtual methods duplicating regular methods
        guard !method.name.starts(with: "get_type") else { return "" }
        // Skip methods with unsupported parameter types
        guard !hasUnsupportedParams(method.parameters) else { return "" }
        // Skip methods with unsupported return types
        let retCheck = swiftReturnType(method.returnValue.type, nullable: method.returnValue.nullable)
        if retCheck == "__UNSUPPORTED__" { return "" }

        let retType = swiftReturnType(method.returnValue.type, nullable: method.returnValue.nullable)
        let returnsVoid = method.returnValue.type.name == "none"
        let returnTypeStr = returnsVoid ? "" : " -> \(retType ?? "OpaquePointer")"

        let swiftName = snakeToCamel(method.name)

        // Build parameters
        let params = method.parameters
        let swiftParams = params.enumerated().map { i, p -> String in
            let label = i == 0 ? "_ " : ""
            let paramName = swiftParamLabel(p.name)
            let type = swiftParamType(p)
            return "\(label)\(paramName): \(type)"
        }
        let paramList = swiftParams.joined(separator: ", ")

        var out = "\n    /// Calls `\(method.cIdentifier)`.\n"
        if method.returnValue.type.name != "none" && method.returnValue.type.name != "gboolean" {
            out += "    @discardableResult\n"
        }
        out += "    public func \(swiftName)(\(paramList))\(returnTypeStr) {\n"

        // Self argument
        let selfArg = isOpaqueType(cls.cType) ? "opaquePointer" : "castedPointer() as UnsafeMutablePointer<\(cls.cType)>"

        // Build C call arguments
        let cArgs = params.map { cArgFromSwift($0) }
        let allArgs = ([selfArg] + cArgs).joined(separator: ", ")
        let call = "\(method.cIdentifier)(\(allArgs))"

        if returnsVoid {
            out += "        \(call)\n"
        } else {
            let converted = convertReturnToSwift(
                call: call,
                type: method.returnValue.type,
                nullable: method.returnValue.nullable
            )
            out += "        return \(converted)\n"
        }

        out += "    }\n"
        return out
    }

    // MARK: - Signal Generation

    /// Map a signal parameter's GIR type to its Swift type name for signal handlers.
    private func signalParamSwiftType(_ param: GIRParameter) -> String? {
        switch param.type.name {
        case "utf8", "filename": return "String"
        case "gboolean": return "Bool"
        case "gint", "int": return "Int32"
        case "guint", "unsigned": return "UInt32"
        case "gfloat", "float": return "Float"
        case "gdouble", "double": return "Double"
        default:
            // Adw enum types — look up the C type from the namespace
            if let enumDef = namespace.enumerations.first(where: { $0.name == param.type.name }) {
                return enumDef.cType
            }
            // GObject.Value → UnsafePointer<GValue>
            if param.type.name == "GObject.Value" { return "UnsafePointer<GValue>" }
            // Pointer types → OpaquePointer
            if param.type.cType.hasSuffix("*") {
                return "OpaquePointer"
            }
            // Adw class types in signal params (no c:type in GIR signals)
            if namespace.classes.contains(where: { $0.name == param.type.name }) {
                return "OpaquePointer"
            }
            return nil
        }
    }

    /// Determine which SignalHelper.connectXxx method to use for a signal's parameter signature.
    private func signalConnectMethod(_ params: [GIRParameter]) -> String? {
        if params.isEmpty { return "connect" }
        if params.count == 1 {
            switch params[0].type.name {
            case "utf8", "filename": return "connectString"
            case "guint", "unsigned": return "connectUInt"
            case "gint", "int": return "connectInt"
            case "gdouble", "double": return "connectDouble"
            case "gboolean": return "connectBool"
            default:
                if namespace.enumerations.contains(where: { $0.name == params[0].type.name }) {
                    return "connectEnum"
                }
                if params[0].type.cType.hasSuffix("*") {
                    if params[0].type.name == "GObject.Value" { return nil }
                    return "connectPointer"
                }
                // Adw class types (signal params without c:type)
                if namespace.classes.contains(where: { $0.name == params[0].type.name }) {
                    return "connectPointer"
                }
                return nil
            }
        }
        if params.count == 2 {
            let t0 = params[0].type.name
            let t1 = params[1].type.name
            let p0IsPointer = params[0].type.cType.hasSuffix("*") ||
                namespace.classes.contains(where: { $0.name == t0 })
            if (t0 == "gdouble" || t0 == "double") && (t1 == "gdouble" || t1 == "double") {
                return "connectDoubleDouble"
            }
            if p0IsPointer && (t1 == "gint" || t1 == "int") {
                if t0 == "GObject.Value" { return nil }
                return "connectPointerInt"
            }
            // (Pointer, GObject.Value) with return type
            if p0IsPointer && t1 == "GObject.Value" {
                return "__pointerGValue__"
            }
        }
        return nil
    }

    private func generateSignalMethod(_ signal: GIRSignal, cls: GIRClass) -> String {
        let swiftName = "on" + snakeToPascal(signal.name.replacingOccurrences(of: "-", with: "_"))

        guard let connectMethod = signalConnectMethod(signal.parameters) else {
            return "\n    // TODO: Signal `\(signal.name)` — unsupported parameter types\n\n"
        }

        // Special case: (Pointer, GValue) signals with return values
        if connectMethod == "__pointerGValue__" {
            return generatePointerGValueSignal(signal, swiftName: swiftName)
        }

        // Build Swift parameter types for the handler closure
        let paramTypes = signal.parameters.compactMap { signalParamSwiftType($0) }
        guard paramTypes.count == signal.parameters.count else {
            return "\n    // TODO: Signal `\(signal.name)` — unsupported parameter types\n\n"
        }

        let closureType: String
        if paramTypes.isEmpty {
            closureType = "@escaping @MainActor () -> Void"
        } else {
            let typeList = paramTypes.joined(separator: ", ")
            closureType = paramTypes.count == 1
                ? "@escaping @MainActor (\(typeList)) -> Void"
                : "@escaping @MainActor (\(typeList)) -> Void"
        }

        var out = "\n    /// Emitted when the `\(signal.name)` signal is fired.\n"
        out += "    ///\n"
        out += "    /// - Parameter handler: Called when the signal is emitted.\n"
        out += "    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.\n"
        out += "    @discardableResult\n"
        out += "    public func \(swiftName)(_ handler: \(closureType)) -> SignalConnection {\n"
        out += "        SignalHelper.\(connectMethod)(self, signal: \"\(signal.name)\", handler: handler)\n"
        out += "    }\n"

        return out
    }

    /// Generates a signal method for (OpaquePointer, GValue) → Bool or GdkDragAction signals.
    private func generatePointerGValueSignal(_ signal: GIRSignal, swiftName: String) -> String {
        let returnTypeName = signal.returnType.name

        let helperMethod: String
        let swiftReturnType: String

        if returnTypeName == "gboolean" {
            helperMethod = "connectPointerGValueReturnBool"
            swiftReturnType = "Bool"
        } else if returnTypeName == "Gdk.DragAction" {
            helperMethod = "connectPointerGValueReturnGdkDragAction"
            swiftReturnType = "GdkDragAction"
        } else {
            return "\n    // TODO: Signal `\(signal.name)` — unsupported return type `\(returnTypeName)` for pointer+GValue signal\n\n"
        }

        var out = "\n    /// Emitted when the `\(signal.name)` signal is fired.\n"
        out += "    ///\n"
        out += "    /// - Parameter handler: Called when the signal is emitted.\n"
        out += "    /// - Returns: A ``SignalConnection`` that can be used to disconnect the handler.\n"
        out += "    @discardableResult\n"
        out += "    public func \(swiftName)(_ handler: @escaping @MainActor (OpaquePointer, UnsafePointer<GValue>) -> \(swiftReturnType)) -> SignalConnection {\n"
        out += "        SignalHelper.\(helperMethod)(self, signal: \"\(signal.name)\", handler: handler)\n"
        out += "    }\n"

        return out
    }

    // MARK: - Type Conversion Helpers

    private func swiftParamLabel(_ name: String) -> String {
        let swift = snakeToCamel(name)
        // Avoid Swift keywords
        switch swift {
        case "self", "default", "operator", "class", "switch", "case",
             "return", "break", "continue", "import", "in", "for", "while",
             "repeat", "if", "else", "do", "try", "catch", "throw", "throws",
             "true", "false", "nil":
            return "`\(swift)`"
        default:
            return swift
        }
    }

    private func swiftParamType(_ param: GIRParameter) -> String {
        // Array types are unsupported
        if param.type.isArray { return "__UNSUPPORTED__" }

        switch param.type.name {
        case "utf8", "filename":
            return param.nullable ? "String?" : "String"
        case "gboolean":
            return "Bool"
        case "gint", "int":
            return "Int32"
        case "guint", "unsigned":
            return "UInt32"
        case "gint64":
            return "Int64"
        case "guint64":
            return "UInt64"
        case "gfloat", "float":
            return "Float"
        case "gdouble", "double":
            return "Double"
        case "Gtk.Widget":
            return param.nullable ? "Widget?" : "Widget"
        default:
            // Skip va_list, GObject, GParamSpec, GValue pointer types
            let cType = param.type.cType
            if cType.contains("va_list") { return "__UNSUPPORTED__" }
            if cType.contains("GObject*") { return "__UNSUPPORTED__" }
            if cType.contains("GParamSpec*") { return "__UNSUPPORTED__" }
            if cType.contains("GValue*") { return "__UNSUPPORTED__" }
            if cType.contains("GType*") { return "__UNSUPPORTED__" }
            if cType.contains("GMenuModel*") { return "__UNSUPPORTED__" }

            // For pointer types
            if cType.hasSuffix("*") {
                // Check for const char** (arrays of strings), callbacks, etc — unsupported
                if cType.contains("**") {
                    return "__UNSUPPORTED__"
                }
                // Non-Widget GTK/GDK/Gio types — unsupported for now
                if param.type.name.hasPrefix("Gtk.") && param.type.name != "Gtk.Widget" {
                    return "__UNSUPPORTED__"
                }
                if param.type.name.hasPrefix("Gio.") || param.type.name.hasPrefix("Gdk.") {
                    return "__UNSUPPORTED__"
                }
                // Adw types that are opaque → OpaquePointer
                let adwCType = "Adw\(param.type.name)"
                if isOpaqueType(adwCType) || isOpaqueType(cType.replacingOccurrences(of: "*", with: "").trimmingCharacters(in: .whitespaces)) {
                    return param.nullable ? "OpaquePointer?" : "OpaquePointer"
                }
                // Non-opaque Adw types — unsupported for now (need typed pointer)
                if namespace.classes.contains(where: { $0.name == param.type.name }) {
                    return "__UNSUPPORTED__"
                }
                return param.nullable ? "OpaquePointer?" : "OpaquePointer"
            }
            // For enum/value types, use the C type directly
            if cType.isEmpty { return "__UNSUPPORTED__" }
            return cType
        }
    }

    /// Check if a method has any unsupported parameter types
    private func hasUnsupportedParams(_ params: [GIRParameter]) -> Bool {
        params.contains { swiftParamType($0) == "__UNSUPPORTED__" }
    }

    private func cArgFromSwift(_ param: GIRParameter) -> String {
        let name = swiftParamLabel(param.name)
        switch param.type.name {
        case "utf8", "filename":
            return name
        case "gboolean":
            return "\(name) ? 1 : 0"
        case "Gtk.Widget":
            return param.nullable ? "\(name)?.widgetPointer" : "\(name).widgetPointer"
        default:
            return name
        }
    }

    private func swiftReturnType(_ type: GIRType, nullable: Bool) -> String? {
        // Array returns are unsupported
        if type.isArray { return "__UNSUPPORTED__" }

        switch type.name {
        case "none": return nil
        case "utf8", "filename":
            return nullable ? "String?" : "String"
        case "gboolean": return "Bool"
        case "gint", "int": return "Int32"
        case "guint", "unsigned": return "UInt32"
        case "gint64": return "Int64"
        case "guint64": return "UInt64"
        case "gfloat", "float": return "Float"
        case "gdouble", "double": return "Double"
        case "Gtk.Widget":
            return nullable ? "Widget?" : "Widget"
        default:
            let cType = type.cType
            // Skip GObject infrastructure types
            if cType.contains("GObject*") || cType.contains("GParamSpec*") ||
               cType.contains("GValue*") || cType.contains("va_list") {
                return "__UNSUPPORTED__"
            }
            if cType.hasSuffix("*") {
                if cType.contains("**") { return "__UNSUPPORTED__" }
                // Non-Widget GTK/GDK/Gio return types
                if type.name.hasPrefix("Gtk.") || type.name.hasPrefix("Gio.") || type.name.hasPrefix("Gdk.") {
                    return "__UNSUPPORTED__"
                }
                return nullable ? "OpaquePointer?" : "OpaquePointer"
            }
            return cType.isEmpty ? "__UNSUPPORTED__" : cType
        }
    }

    private func convertReturnToSwift(call: String, type: GIRType, nullable: Bool) -> String {
        switch type.name {
        case "utf8", "filename":
            if nullable {
                return "(\(call)).map { String(cString: $0) }"
            } else {
                return "String(cString: \(call))"
            }
        case "gboolean":
            return "\(call) != 0"
        case "Gtk.Widget":
            if nullable {
                return "(\(call)).map { Widget(borrowing: UnsafeMutableRawPointer($0)) }"
            } else {
                return "Widget(borrowing: UnsafeMutableRawPointer(\(call)))"
            }
        default:
            // If the C return type is a typed pointer, we may need explicit conversion.
            // - Opaque C types (forward-declared structs) return OpaquePointer! — no conversion needed.
            // - Non-opaque Adw classes return UnsafeMutablePointer<T>! — need OpaquePointer() wrapping.
            if type.cType.hasSuffix("*") && !type.cType.contains("char") {
                let stripped = type.cType.replacingOccurrences(of: "*", with: "")
                    .replacingOccurrences(of: "const", with: "")
                    .trimmingCharacters(in: .whitespaces)
                // Check if the type is a non-opaque Adw class (has a public struct → UnsafeMutablePointer)
                let isNonOpaqueAdwClass = stripped.hasPrefix("Adw") && !isOpaqueType(stripped) &&
                    namespace.classes.contains(where: { $0.cType == stripped })
                if isNonOpaqueAdwClass {
                    if nullable {
                        return "(\(call)).map { OpaquePointer($0) }"
                    } else {
                        return "OpaquePointer(\(call)!)"
                    }
                }
                // All other pointer types (opaque, boxed, interface) are already OpaquePointer
            }
            return call
        }
    }

    private func convertSwiftToC(_ swift: String, type: GIRType, paramType: GIRType, nullable: Bool = false) -> String {
        switch type.name {
        case "utf8", "filename":
            return swift
        case "gboolean":
            return "\(swift) ? 1 : 0"
        case "Gtk.Widget":
            return nullable ? "\(swift)?.widgetPointer" : "\(swift).widgetPointer"
        default:
            return swift
        }
    }

    // MARK: - Documentation & Availability Helpers

    /// Formats a GIR doc string as a Swift doc comment.
    /// Takes the first sentence/paragraph and wraps it as `/// ...`.
    private func formatDocComment(_ doc: String) -> String {
        // Take the first paragraph (up to the first blank line)
        let paragraphs = doc.components(separatedBy: "\n\n")
        let firstPara = paragraphs[0]
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespaces)

        // Clean up backtick references (GIR uses backticks for type refs)
        var cleaned = firstPara

        // Replace `AdwFoo` → `Foo` for Adw types
        let adwPattern = try! NSRegularExpression(pattern: "`Adw(\\w+)`")
        cleaned = adwPattern.stringByReplacingMatches(
            in: cleaned, range: NSRange(cleaned.startIndex..., in: cleaned),
            withTemplate: "`$1`"
        )

        // Replace `GtkFoo` references
        let gtkPattern = try! NSRegularExpression(pattern: "`Gtk(\\w+)`")
        cleaned = gtkPattern.stringByReplacingMatches(
            in: cleaned, range: NSRange(cleaned.startIndex..., in: cleaned),
            withTemplate: "`Gtk$1`"
        )

        // Wrap at ~80 chars
        var lines: [String] = []
        var current = ""
        for word in cleaned.split(separator: " ") {
            if current.isEmpty {
                current = String(word)
            } else if current.count + 1 + word.count > 76 {
                lines.append("/// \(current)")
                current = String(word)
            } else {
                current += " \(word)"
            }
        }
        if !current.isEmpty {
            lines.append("/// \(current)")
        }

        return lines.joined(separator: "\n") + "\n"
    }

    /// Generates a `@available` annotation from a GIR version string.
    private func availableAnnotation(_ version: String) -> String {
        // Only annotate versions > 1.0 (everything before is baseline)
        guard version != "1.0" else { return "" }
        return "/// - Since: libadwaita \(version)\n"
    }
}
