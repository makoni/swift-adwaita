import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

// MARK: - GIR Data Model

struct GIRNamespace {
    let name: String
    let version: String
    let cIdentifierPrefix: String
    let cSymbolPrefix: String
    var classes: [GIRClass] = []
    var enumerations: [GIREnum] = []
    var bitfields: [GIRBitfield] = []
}

struct GIRClass {
    let name: String
    let cType: String
    let cSymbolPrefix: String
    let parent: String?
    let isFinal: Bool
    let isDeprecated: Bool
    let version: String?
    var doc: String?
    var constructors: [GIRFunction] = []
    var methods: [GIRFunction] = []
    var properties: [GIRProperty] = []
    var signals: [GIRSignal] = []
    var implements: [String] = []
}

struct GIRFunction {
    let name: String
    let cIdentifier: String
    let isDeprecated: Bool
    let version: String?
    let returnValue: GIRReturnValue
    var parameters: [GIRParameter] = []
    // For methods linked to properties
    let getProperty: String?
    let setProperty: String?
}

struct GIRReturnValue {
    let transferOwnership: String
    let nullable: Bool
    let type: GIRType
}

struct GIRType {
    let name: String
    let cType: String
    let isArray: Bool

    init(name: String, cType: String, isArray: Bool = false) {
        self.name = name
        self.cType = cType
        self.isArray = isArray
    }
}

struct GIRParameter {
    let name: String
    let transferOwnership: String
    let nullable: Bool
    let type: GIRType
}

struct GIRProperty {
    let name: String
    let writable: Bool
    let isDeprecated: Bool
    let version: String?
    let transferOwnership: String
    let type: GIRType
    let getter: String?
    let setter: String?
}

struct GIRSignal {
    let name: String
    let isDeprecated: Bool
    let version: String?
    let returnType: GIRType
    var parameters: [GIRParameter] = []
}

struct GIREnum {
    let name: String
    let cType: String
    let version: String?
    let isDeprecated: Bool
    var members: [GIREnumMember] = []
}

struct GIREnumMember {
    let name: String
    let value: String
    let cIdentifier: String
}

struct GIRBitfield {
    let name: String
    let cType: String
    let version: String?
    var members: [GIREnumMember] = []
}

// MARK: - XML Parser Delegate

class GIRParser: NSObject, XMLParserDelegate {
    private(set) var namespace = GIRNamespace(
        name: "", version: "", cIdentifierPrefix: "", cSymbolPrefix: ""
    )

    // Parser state
    private var elementStack: [String] = []
    private var currentClass: GIRClass?
    private var currentFunction: GIRFunction?
    private var currentParameters: [GIRParameter] = []
    private var currentReturnValue: GIRReturnValue?
    private var currentProperty: GIRProperty?
    private var currentSignal: GIRSignal?
    private var currentEnum: GIREnum?
    private var currentBitfield: GIRBitfield?
    private var currentType: GIRType?

    // Temp storage for building types
    private var pendingTypeName: String?
    private var pendingTypeCType: String?
    private var pendingParamName: String?
    private var pendingParamTransfer: String?
    private var pendingParamNullable: Bool = false
    private var pendingReturnTransfer: String?
    private var pendingReturnNullable: Bool = false
    private var inInstanceParameter = false
    private var inArray = false
    private var pendingArrayCType: String?
    private var inDoc = false
    private var docBuffer = ""

    func parse(url: URL) -> GIRNamespace? {
        guard let parser = XMLParser(contentsOf: url) else { return nil }
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        guard parser.parse() else {
            print("Parse error: \(parser.parserError?.localizedDescription ?? "unknown")")
            return nil
        }
        return namespace
    }

    // MARK: - XMLParserDelegate

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName: String?,
                attributes: [String: String]) {
        elementStack.append(elementName)

        switch elementName {
        case "namespace":
            namespace = GIRNamespace(
                name: attributes["name"] ?? "",
                version: attributes["version"] ?? "",
                cIdentifierPrefix: attributes["c:identifier-prefixes"] ?? "",
                cSymbolPrefix: attributes["c:symbol-prefixes"] ?? ""
            )

        case "class":
            guard parentElement == "namespace" else { break }
            currentClass = GIRClass(
                name: attributes["name"] ?? "",
                cType: attributes["c:type"] ?? "",
                cSymbolPrefix: attributes["c:symbol-prefix"] ?? "",
                parent: attributes["parent"],
                isFinal: attributes["final"] == "1",
                isDeprecated: attributes["deprecated"] == "1",
                version: attributes["version"]
            )

        case "implements":
            if let name = attributes["name"] {
                currentClass?.implements.append(name)
            }

        case "constructor":
            guard currentClass != nil else { break }
            startFunction(attributes, isConstructor: true)

        case "method":
            guard currentClass != nil else { break }
            startFunction(attributes, isConstructor: false)

        case "return-value":
            pendingReturnTransfer = attributes["transfer-ownership"] ?? "none"
            pendingReturnNullable = attributes["nullable"] == "1"

        case "instance-parameter":
            inInstanceParameter = true

        case "parameter":
            guard !inInstanceParameter else { break }
            pendingParamName = attributes["name"]
            pendingParamTransfer = attributes["transfer-ownership"] ?? "none"
            pendingParamNullable = attributes["nullable"] == "1" || attributes["allow-none"] == "1"

        case "array":
            inArray = true
            pendingArrayCType = attributes["c:type"]

        case "type":
            pendingTypeName = attributes["name"]
            pendingTypeCType = attributes["c:type"]

        case "property":
            guard currentClass != nil else { break }
            currentProperty = GIRProperty(
                name: attributes["name"] ?? "",
                writable: attributes["writable"] == "1",
                isDeprecated: attributes["deprecated"] == "1",
                version: attributes["version"],
                transferOwnership: attributes["transfer-ownership"] ?? "none",
                type: GIRType(name: "", cType: ""),
                getter: attributes["getter"],
                setter: attributes["setter"]
            )

        case "glib:signal":
            guard currentClass != nil else { break }
            currentSignal = GIRSignal(
                name: attributes["name"] ?? "",
                isDeprecated: attributes["deprecated"] == "1",
                version: attributes["version"],
                returnType: GIRType(name: "none", cType: "void")
            )

        case "enumeration":
            guard parentElement == "namespace" else { break }
            currentEnum = GIREnum(
                name: attributes["name"] ?? "",
                cType: attributes["c:type"] ?? "",
                version: attributes["version"],
                isDeprecated: attributes["deprecated"] == "1"
            )

        case "bitfield":
            guard parentElement == "namespace" else { break }
            currentBitfield = GIRBitfield(
                name: attributes["name"] ?? "",
                cType: attributes["c:type"] ?? "",
                version: attributes["version"]
            )

        case "member":
            let member = GIREnumMember(
                name: attributes["name"] ?? "",
                value: attributes["value"] ?? "0",
                cIdentifier: attributes["c:identifier"] ?? ""
            )
            if currentEnum != nil {
                currentEnum?.members.append(member)
            } else if currentBitfield != nil {
                currentBitfield?.members.append(member)
            }

        case "doc":
            inDoc = true
            docBuffer = ""

        default:
            break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if inDoc {
            docBuffer += string
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName: String?) {
        defer { elementStack.removeLast() }

        switch elementName {
        case "class":
            guard parentElement == "namespace" else { break }
            if let cls = currentClass {
                namespace.classes.append(cls)
            }
            currentClass = nil

        case "constructor", "method":
            if var fn = currentFunction {
                fn.parameters = currentParameters
                if elementName == "constructor" {
                    currentClass?.constructors.append(fn)
                } else {
                    currentClass?.methods.append(fn)
                }
            }
            currentFunction = nil
            currentParameters = []
            currentReturnValue = nil

        case "return-value":
            let typeName = pendingTypeName ?? "none"
            let typeCType = pendingArrayCType ?? pendingTypeCType ?? "void"
            let isArr = inArray
            currentReturnValue = GIRReturnValue(
                transferOwnership: pendingReturnTransfer ?? "none",
                nullable: pendingReturnNullable,
                type: GIRType(name: typeName, cType: typeCType, isArray: isArr)
            )
            inArray = false
            pendingArrayCType = nil
            if currentFunction != nil {
                currentFunction = GIRFunction(
                    name: currentFunction!.name,
                    cIdentifier: currentFunction!.cIdentifier,
                    isDeprecated: currentFunction!.isDeprecated,
                    version: currentFunction!.version,
                    returnValue: currentReturnValue!,
                    parameters: currentFunction!.parameters,
                    getProperty: currentFunction!.getProperty,
                    setProperty: currentFunction!.setProperty
                )
            }
            if currentSignal != nil, typeName != "none" {
                currentSignal = GIRSignal(
                    name: currentSignal!.name,
                    isDeprecated: currentSignal!.isDeprecated,
                    version: currentSignal!.version,
                    returnType: GIRType(name: typeName, cType: typeCType)
                )
            }
            pendingTypeName = nil
            pendingTypeCType = nil
            pendingReturnTransfer = nil
            pendingReturnNullable = false

        case "instance-parameter":
            inInstanceParameter = false
            pendingTypeName = nil
            pendingTypeCType = nil

        case "parameter":
            guard !inInstanceParameter else { break }
            if let name = pendingParamName {
                let paramCType = pendingArrayCType ?? pendingTypeCType ?? ""
                let isArr = inArray
                let param = GIRParameter(
                    name: name,
                    transferOwnership: pendingParamTransfer ?? "none",
                    nullable: pendingParamNullable,
                    type: GIRType(
                        name: pendingTypeName ?? "",
                        cType: paramCType,
                        isArray: isArr
                    )
                )
                inArray = false
                pendingArrayCType = nil
                if currentSignal != nil {
                    currentSignal?.parameters.append(param)
                } else {
                    currentParameters.append(param)
                }
            }
            pendingParamName = nil
            pendingParamTransfer = nil
            pendingParamNullable = false
            pendingTypeName = nil
            pendingTypeCType = nil

        case "doc":
            let trimmed = docBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
            // Assign doc to the nearest enclosing element that supports it
            if currentFunction == nil && currentProperty == nil && currentSignal == nil && currentClass != nil {
                currentClass?.doc = trimmed
            }
            inDoc = false
            docBuffer = ""

        case "array":
            // Array flag is consumed by the enclosing return-value/parameter end handler
            break

        case "type":
            // Type was already captured in didStart via pending fields
            break

        case "property":
            if var prop = currentProperty {
                prop = GIRProperty(
                    name: prop.name,
                    writable: prop.writable,
                    isDeprecated: prop.isDeprecated,
                    version: prop.version,
                    transferOwnership: prop.transferOwnership,
                    type: GIRType(
                        name: pendingTypeName ?? "",
                        cType: pendingTypeCType ?? ""
                    ),
                    getter: prop.getter,
                    setter: prop.setter
                )
                currentClass?.properties.append(prop)
            }
            currentProperty = nil
            pendingTypeName = nil
            pendingTypeCType = nil

        case "glib:signal":
            if let signal = currentSignal {
                currentClass?.signals.append(signal)
            }
            currentSignal = nil

        case "enumeration":
            if let en = currentEnum {
                namespace.enumerations.append(en)
            }
            currentEnum = nil

        case "bitfield":
            if let bf = currentBitfield {
                namespace.bitfields.append(bf)
            }
            currentBitfield = nil

        default:
            break
        }
    }

    // MARK: - Helpers

    private var parentElement: String? {
        guard elementStack.count >= 2 else { return nil }
        return elementStack[elementStack.count - 2]
    }

    private func startFunction(_ attributes: [String: String], isConstructor: Bool) {
        let returnPlaceholder = GIRReturnValue(
            transferOwnership: "none",
            nullable: false,
            type: GIRType(name: "none", cType: "void")
        )
        currentFunction = GIRFunction(
            name: attributes["name"] ?? "",
            cIdentifier: attributes["c:identifier"] ?? "",
            isDeprecated: attributes["deprecated"] == "1",
            version: attributes["version"],
            returnValue: returnPlaceholder,
            getProperty: attributes["glib:get-property"],
            setProperty: attributes["glib:set-property"]
        )
        currentParameters = []
    }
}
