// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
// On macOS, swift-testing's per-test autorelease-pool transitions corrupt
// memory after `gtk_init()` runs (Quartz CFRunLoop integration writes into
// pages that swift-testing has already drained). The XCTest mirror in
// `macOS/VariantXCTests.swift` exercises the same logic on Apple platforms.
import XCTest
@testable import Adwaita
import CAdwaita

final class VariantXCTests: XCTestCase {

    // MARK: - GLibError Tests

    @MainActor func test_glibErrorCreation() throws {
        ensureAdwInit()
        // Create a GError manually using g_error_new_literal
        let quark = g_quark_from_string("test-error-domain")
        let gerror = try XCTUnwrap(g_error_new_literal(quark, 42, "Something went wrong"))
        let error = GLibError(consuming: gerror)
        // The GError has been freed by the initializer

        XCTAssertTrue(error.domain == quark)
        XCTAssertTrue(error.code == 42)
        XCTAssertTrue(error.message == "Something went wrong")
        XCTAssertTrue(error.description == "Something went wrong")
    }

    @MainActor func test_glibErrorConformsToSwiftError() throws {
        ensureAdwInit()
        let quark = g_quark_from_string("test-domain")
        let gerror = try XCTUnwrap(g_error_new_literal(quark, 1, "test error"))
        let error: any Error = GLibError(consuming: gerror)
        XCTAssertTrue(error is GLibError)
        let glibError = try XCTUnwrap(error as? GLibError)
        XCTAssertTrue(glibError.code == 1)
        XCTAssertTrue(glibError.message == "test error")
    }

    // MARK: - Variant Tests

    @MainActor func test_variantStringRoundtrip() {
        ensureAdwInit()
        let v = Variant.string("hello world")
        XCTAssertTrue(v.stringValue == "hello world")
        XCTAssertTrue(v.typeString == "s")
        XCTAssertTrue(v.isOfType("s") == true)
        XCTAssertTrue(v.isOfType("i") == false)
    }

    @MainActor func test_variantInt32Roundtrip() {
        ensureAdwInit()
        let v = Variant.int32(42)
        XCTAssertTrue(v.int32Value == 42)
        XCTAssertTrue(v.typeString == "i")
        XCTAssertTrue(v.isOfType("i") == true)
    }

    @MainActor func test_variantInt32Negative() {
        ensureAdwInit()
        let v = Variant.int32(-100)
        XCTAssertTrue(v.int32Value == -100)
    }

    @MainActor func test_variantInt64Roundtrip() {
        ensureAdwInit()
        let v = Variant.int64(Int64(Int32.max) + 1)
        XCTAssertTrue(v.int64Value == Int64(Int32.max) + 1)
        XCTAssertTrue(v.typeString == "x")
        XCTAssertTrue(v.isOfType("x") == true)
    }

    @MainActor func test_variantDoubleRoundtrip() {
        ensureAdwInit()
        let v = Variant.double(3.14)
        XCTAssertTrue(v.doubleValue == 3.14)
        XCTAssertTrue(v.typeString == "d")
        XCTAssertTrue(v.isOfType("d") == true)
    }

    @MainActor func test_variantBooleanRoundtrip() {
        ensureAdwInit()
        let vTrue = Variant.boolean(true)
        XCTAssertTrue(vTrue.boolValue == true)
        XCTAssertTrue(vTrue.typeString == "b")

        let vFalse = Variant.boolean(false)
        XCTAssertTrue(vFalse.boolValue == false)
    }

    @MainActor func test_variantStringValueReturnsNilForNonString() {
        ensureAdwInit()
        let v = Variant.int32(42)
        XCTAssertNil(v.stringValue)
    }

    @MainActor func test_variantBorrowing() {
        ensureAdwInit()
        let v1 = Variant.string("shared")
        let v2 = Variant(borrowing: v1.pointer)
        XCTAssertTrue(v2.stringValue == "shared")
    }

    // MARK: - SimpleAction with Parameter Tests

    @MainActor func test_simpleActionWithParameterType() {
        ensureAdwInit()
        var received: String?
        let action = SimpleAction(name: "test-param", parameterType: "s") { variant in
            received = variant.stringValue
        }
        // Activate the action with a string parameter
        g_action_activate(OpaquePointer(action.pointer), g_variant_new_string("hello"))
        XCTAssertTrue(received == "hello")
    }

    @MainActor func test_simpleActionStateful() {
        ensureAdwInit()
        let action = SimpleAction(name: "toggle", state: .boolean(false)) {
            // no-op handler
        }
        // Check initial state
        let initialState = action.state
        XCTAssertNotNil(initialState)
        XCTAssertTrue(initialState?.boolValue == false)

        // Change state
        action.state = .boolean(true)
        XCTAssertTrue(action.state?.boolValue == true)
    }

    @MainActor func test_simpleActionStatefulToggle() {
        ensureAdwInit()
        var activateCount = 0
        let action = SimpleAction(name: "bold", state: .boolean(false)) {
            activateCount += 1
        }
        // Activate the action
        g_action_activate(OpaquePointer(action.pointer), nil)
        XCTAssertTrue(activateCount == 1)
        // Manually toggle state (as a real handler would do)
        let current = action.state?.boolValue ?? false
        action.state = .boolean(!current)
        XCTAssertTrue(action.state?.boolValue == true)
    }

    @MainActor func test_simpleActionStatefulWithStringState() {
        ensureAdwInit()
        let action = SimpleAction(name: "color", state: .string("red")) {
            // no-op
        }
        XCTAssertTrue(action.state?.stringValue == "red")
        action.state = .string("blue")
        XCTAssertTrue(action.state?.stringValue == "blue")
    }

    // MARK: - GMenuItemRef Variant Attribute Tests

    @MainActor func test_menuItemSetVariantAttribute() {
        ensureAdwInit()
        let item = GMenuItemRef(label: "Test", action: "app.test")
        // Should not crash
        item.setAttribute("custom-attr", variant: .string("value"))
        item.setTargetValue(.string("target-value"))
    }

}
#endif
