// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if os(macOS)
import XCTest
@testable import Adwaita
import CAdwaita
import Foundation

final class ImageLoadingXCTests: XCTestCase {

    // MARK: - Fixtures

    /// 2x2 animated GIF with two frames, embedded as bytes to avoid external fixtures.
    private static let animatedGIFBytes: [UInt8] = [
        0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x02, 0x00, 0x02, 0x00, 0x81, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x21, 0xFF, 0x0B, 0x4E, 0x45, 0x54, 0x53,
        0x43, 0x41, 0x50, 0x45, 0x32, 0x2E, 0x30, 0x03, 0x01, 0x00, 0x00, 0x00, 0x21, 0xF9, 0x04, 0x00,
        0x0A, 0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x00, 0x00, 0x08, 0x07,
        0x00, 0x01, 0x04, 0x10, 0x30, 0x20, 0x20, 0x00, 0x21, 0xF9, 0x04, 0x01, 0x0A, 0x00, 0x04, 0x00,
        0x2C, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x00, 0x81, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00,
        0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x08, 0x07, 0x00, 0x07, 0x08, 0x08, 0x00, 0x20, 0x20, 0x00,
        0x3B
    ]

    /// 2x2 single-frame GIF (static).
    private static let staticGIFBytes: [UInt8] = [
        0x47, 0x49, 0x46, 0x38, 0x37, 0x61, 0x02, 0x00, 0x02, 0x00, 0x81, 0x00, 0x00, 0x00, 0x00, 0x00,
        0xFF, 0x00, 0x00, 0x00, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0x2C, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00,
        0x02, 0x00, 0x00, 0x08, 0x07, 0x00, 0x01, 0x04, 0x10, 0x30, 0x20, 0x20, 0x00, 0x3B
    ]

    @MainActor
    private static func writeFixture(_ bytes: [UInt8], suffix: String) -> URL {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent("swift-adwaita-tests-\(UUID().uuidString)\(suffix)")
        try? Data(bytes).write(to: temp, options: .atomic)
        return temp
    }

    @MainActor
    private static func writePNGFixture(width: Int32 = 8, height: Int32 = 6) -> URL? {
        guard let pixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, 1, 8, width, height) else {
            return nil
        }
        defer { g_object_unref(UnsafeMutableRawPointer(pixbuf)) }
        gdk_pixbuf_fill(pixbuf, 0x4080_FFFF)

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("swift-adwaita-tests-\(UUID().uuidString).png")
        var error: UnsafeMutablePointer<GError>?
        let saved = gdk_pixbuf_savev(pixbuf, url.path, "png", nil, nil, &error)
        if let error {
            g_error_free(error)
        }
        return saved != 0 ? url : nil
    }

    // MARK: - Texture.load(from:)

    @MainActor func test_textureLoadAsyncFromPNGReturnsCorrectSize() async throws {
        ensureAdwInit()
        guard let url = Self.writePNGFixture(width: 8, height: 6) else {
            XCTFail("Failed to write PNG fixture")
            return
        }
        defer { try? FileManager.default.removeItem(at: url) }

        let texture = try await Texture.load(from: url)
        XCTAssertTrue(texture.width == 8)
        XCTAssertTrue(texture.height == 6)
    }

    @MainActor func test_textureLoadAsyncFromMissingFileThrowsDecodeFailed() async {
        ensureAdwInit()
        let missing = FileManager.default.temporaryDirectory
            .appendingPathComponent("does-not-exist-\(UUID().uuidString).png")
        do {
            _ = try await Texture.load(from: missing)
            XCTFail("Expected ImageDecodingError")
        } catch is ImageDecodingError {
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    @MainActor func test_textureLoadAsyncFromInvalidBytesThrows() async {
        ensureAdwInit()
        let url = Self.writeFixture([0x00, 0x01, 0x02, 0x03], suffix: ".png")
        defer { try? FileManager.default.removeItem(at: url) }
        do {
            _ = try await Texture.load(from: url)
            XCTFail("Expected ImageDecodingError")
        } catch is ImageDecodingError {
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    @MainActor func test_textureLoadSynchronouslyFromPNGReturnsCorrectSize() throws {
        ensureAdwInit()
        guard let url = Self.writePNGFixture(width: 5, height: 4) else {
            XCTFail("Failed to write PNG fixture")
            return
        }
        defer { try? FileManager.default.removeItem(at: url) }

        let texture = try Texture.loadSynchronously(from: url)
        XCTAssertTrue(texture.width == 5)
        XCTAssertTrue(texture.height == 4)
    }

    @MainActor func test_textureLoadSynchronouslyFromMissingFileThrows() {
        ensureAdwInit()
        let missing = FileManager.default.temporaryDirectory
            .appendingPathComponent("does-not-exist-\(UUID().uuidString).png")
        XCTAssertThrowsError(try Texture.loadSynchronously(from: missing)) { error in
            XCTAssertTrue(error is ImageDecodingError)
        }
    }

    @MainActor func test_textureLoadSynchronouslyFromInvalidBytesThrows() {
        ensureAdwInit()
        let url = Self.writeFixture([0x00, 0x01, 0x02, 0x03], suffix: ".png")
        defer { try? FileManager.default.removeItem(at: url) }
        XCTAssertThrowsError(try Texture.loadSynchronously(from: url)) { error in
            XCTAssertTrue(error is ImageDecodingError)
        }
    }

    // MARK: - Picture.intrinsicSize

    @MainActor func test_pictureIntrinsicSizeIsNilWhenEmpty() {
        ensureAdwInit()
        let picture = Adwaita.Picture()
        XCTAssertNil(picture.intrinsicSize)
    }

    @MainActor func test_pictureIntrinsicSizeReflectsLoadedTexture() async throws {
        ensureAdwInit()
        guard let url = Self.writePNGFixture(width: 12, height: 9) else {
            XCTFail("Failed to write PNG fixture")
            return
        }
        defer { try? FileManager.default.removeItem(at: url) }

        let picture = Adwaita.Picture()
        let texture = try await Texture.load(from: url)
        picture.setPaintable(texture)

        XCTAssertTrue(picture.intrinsicSize == Picture.IntrinsicSize(width: 12, height: 9))
    }

    // MARK: - AnimatedImagePlayer

    @MainActor func test_animatedImagePlayerReturnsNilForStaticImage() throws {
        ensureAdwInit()
        let url = Self.writeFixture(Self.staticGIFBytes, suffix: ".gif")
        defer { try? FileManager.default.removeItem(at: url) }

        let picture = Adwaita.Picture()
        let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
        XCTAssertNil(player)
    }

    @MainActor func test_animatedImagePlayerInitialisesForAnimatedGIF() throws {
        ensureAdwInit()
        let url = Self.writeFixture(Self.animatedGIFBytes, suffix: ".gif")
        defer { try? FileManager.default.removeItem(at: url) }

        let picture = Adwaita.Picture()
        let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
        try XCTUnwrap(player != nil)
        XCTAssertTrue(player?.metadata == AnimatedImagePlayer.Metadata(width: 2, height: 2))
        XCTAssertTrue(player?.isPlaying == false)
    }

    @MainActor func test_animatedImagePlayerStartStopTogglesIsPlaying() throws {
        ensureAdwInit()
        let url = Self.writeFixture(Self.animatedGIFBytes, suffix: ".gif")
        defer { try? FileManager.default.removeItem(at: url) }

        let picture = Adwaita.Picture()
        let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
        try XCTUnwrap(player != nil)

        player?.start()
        XCTAssertTrue(player?.isPlaying == true)
        player?.stop()
        XCTAssertTrue(player?.isPlaying == false)
    }

    @MainActor func test_animatedImagePlayerThrowsForInvalidFile() {
        ensureAdwInit()
        let url = Self.writeFixture([0xFF, 0xFE, 0xFD, 0xFC], suffix: ".gif")
        defer { try? FileManager.default.removeItem(at: url) }

        let picture = Adwaita.Picture()
        XCTAssertThrowsError(try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)) { error in
            XCTAssertTrue(error is ImageDecodingError)
        }
    }

    @MainActor func test_animatedImagePlayerSetsFirstFramePaintable() throws {
        ensureAdwInit()
        let url = Self.writeFixture(Self.animatedGIFBytes, suffix: ".gif")
        defer { try? FileManager.default.removeItem(at: url) }

        let picture = Adwaita.Picture()
        XCTAssertNil(picture.intrinsicSize)

        let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
        try XCTUnwrap(player != nil)
        XCTAssertTrue(picture.intrinsicSize?.width == 2)
        XCTAssertTrue(picture.intrinsicSize?.height == 2)
    }

    @MainActor func test_animatedImagePlayerAdvanceFrameChangesPaintable() throws {
        ensureAdwInit()
        let url = Self.writeFixture(Self.animatedGIFBytes, suffix: ".gif")
        defer { try? FileManager.default.removeItem(at: url) }

        let picture = Adwaita.Picture()
        let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
        try XCTUnwrap(player != nil)

        let firstPaintable = gtk_picture_get_paintable(OpaquePointer(picture.pointer))
        XCTAssertNotNil(firstPaintable)

        player?.advanceFrame()

        let secondPaintable = gtk_picture_get_paintable(OpaquePointer(picture.pointer))
        XCTAssertNotNil(secondPaintable)
        XCTAssertTrue(firstPaintable != secondPaintable)
    }
}
#endif
