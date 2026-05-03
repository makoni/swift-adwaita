// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

// On macOS, swift-testing's per-test autorelease-pool transitions corrupt
// memory after `gtk_init()` runs (Quartz CFRunLoop integration writes into
// pages that swift-testing has already drained). The XCTest mirror in
// `macOS/VariantXCTests.swift` exercises the same logic on Apple platforms.
#if !os(macOS)
import Testing
@testable import Adwaita
import CAdwaita

@Suite(.serialized)
struct VariantTests {

    // MARK: - GLibError Tests

    @Test @MainActor func glibErrorCreation() throws {
        ensureAdwInit()
        // Create a GError manually using g_error_new_literal
        let quark = g_quark_from_string("test-error-domain")
        let gerror = try #require(g_error_new_literal(quark, 42, "Something went wrong"))
        let error = GLibError(consuming: gerror)
        // The GError has been freed by the initializer

        #expect(error.domain == quark)
        #expect(error.code == 42)
        #expect(error.message == "Something went wrong")
        #expect(error.description == "Something went wrong")
    }

    @Test @MainActor func glibErrorConformsToSwiftError() throws {
        ensureAdwInit()
        let quark = g_quark_from_string("test-domain")
        let gerror = try #require(g_error_new_literal(quark, 1, "test error"))
        let error: any Error = GLibError(consuming: gerror)
        #expect(error is GLibError)
        let glibError = try #require(error as? GLibError)
        #expect(glibError.code == 1)
        #expect(glibError.message == "test error")
    }

    // MARK: - Variant Tests

    @Test @MainActor func variantStringRoundtrip() {
        ensureAdwInit()
        let v = Variant.string("hello world")
        #expect(v.stringValue == "hello world")
        #expect(v.typeString == "s")
        #expect(v.isOfType("s") == true)
        #expect(v.isOfType("i") == false)
    }

    @Test @MainActor func variantInt32Roundtrip() {
        ensureAdwInit()
        let v = Variant.int32(42)
        #expect(v.int32Value == 42)
        #expect(v.typeString == "i")
        #expect(v.isOfType("i") == true)
    }

    @Test @MainActor func variantInt32Negative() {
        ensureAdwInit()
        let v = Variant.int32(-100)
        #expect(v.int32Value == -100)
    }

    @Test @MainActor func variantInt64Roundtrip() {
        ensureAdwInit()
        let v = Variant.int64(Int64(Int32.max) + 1)
        #expect(v.int64Value == Int64(Int32.max) + 1)
        #expect(v.typeString == "x")
        #expect(v.isOfType("x") == true)
    }

    @Test @MainActor func variantDoubleRoundtrip() {
        ensureAdwInit()
        let v = Variant.double(3.14)
        #expect(v.doubleValue == 3.14)
        #expect(v.typeString == "d")
        #expect(v.isOfType("d") == true)
    }

    @Test @MainActor func variantBooleanRoundtrip() {
        ensureAdwInit()
        let vTrue = Variant.boolean(true)
        #expect(vTrue.boolValue == true)
        #expect(vTrue.typeString == "b")

        let vFalse = Variant.boolean(false)
        #expect(vFalse.boolValue == false)
    }

    @Test @MainActor func variantStringValueReturnsNilForNonString() {
        ensureAdwInit()
        let v = Variant.int32(42)
        #expect(v.stringValue == nil)
    }

    @Test @MainActor func variantBorrowing() {
        ensureAdwInit()
        let v1 = Variant.string("shared")
        let v2 = Variant(borrowing: v1.pointer)
        #expect(v2.stringValue == "shared")
    }

    // MARK: - SimpleAction with Parameter Tests

    @Test @MainActor func simpleActionWithParameterType() {
        ensureAdwInit()
        var received: String?
        let action = SimpleAction(name: "test-param", parameterType: "s") { variant in
            received = variant.stringValue
        }
        // Activate the action with a string parameter
        g_action_activate(OpaquePointer(action.pointer), g_variant_new_string("hello"))
        #expect(received == "hello")
    }

    @Test @MainActor func simpleActionStateful() {
        ensureAdwInit()
        let action = SimpleAction(name: "toggle", state: .boolean(false)) {
            // no-op handler
        }
        // Check initial state
        let initialState = action.state
        #expect(initialState != nil)
        #expect(initialState?.boolValue == false)

        // Change state
        action.state = .boolean(true)
        #expect(action.state?.boolValue == true)
    }

    @Test @MainActor func simpleActionStatefulToggle() {
        ensureAdwInit()
        var activateCount = 0
        let action = SimpleAction(name: "bold", state: .boolean(false)) {
            activateCount += 1
        }
        // Activate the action
        g_action_activate(OpaquePointer(action.pointer), nil)
        #expect(activateCount == 1)
        // Manually toggle state (as a real handler would do)
        let current = action.state?.boolValue ?? false
        action.state = .boolean(!current)
        #expect(action.state?.boolValue == true)
    }

    @Test @MainActor func simpleActionStatefulWithStringState() {
        ensureAdwInit()
        let action = SimpleAction(name: "color", state: .string("red")) {
            // no-op
        }
        #expect(action.state?.stringValue == "red")
        action.state = .string("blue")
        #expect(action.state?.stringValue == "blue")
    }

    // MARK: - GMenuItemRef Variant Attribute Tests

    @Test @MainActor func menuItemSetVariantAttribute() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Test", action: "app.test")
        // Should not crash
        item.setAttribute("custom-attr", variant: .string("value"))
        item.setTargetValue(.string("target-value"))
    }

}
#endif
