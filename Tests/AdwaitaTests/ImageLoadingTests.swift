// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

#if !os(macOS)
#if swift(>=6.3)
import Testing
@testable import Adwaita
import CAdwaita
import Foundation

extension SerializedLifecycleSuites {
    @Suite(.serialized)
    struct ImageLoadingTests {

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
        private static func writePNGFixture(
            width: Int32 = 8,
            height: Int32 = 6,
            hasAlpha: Bool = true
        ) -> URL? {
            guard let pixbuf = gdk_pixbuf_new(
                GDK_COLORSPACE_RGB,
                hasAlpha ? 1 : 0,
                8,
                width,
                height
            ) else {
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

        @Test @MainActor func textureLoadAsyncFromPNGReturnsCorrectSize() async throws {
            ensureAdwInit()
            guard let url = Self.writePNGFixture(width: 8, height: 6) else {
                Issue.record("Failed to write PNG fixture")
                return
            }
            defer { try? FileManager.default.removeItem(at: url) }

            let texture = try await Texture.load(from: url)
            #expect(texture.width == 8)
            #expect(texture.height == 6)
        }

        @Test @MainActor func textureLoadAsyncFromMissingFileThrowsDecodeFailed() async {
            ensureAdwInit()
            let missing = FileManager.default.temporaryDirectory
                .appendingPathComponent("does-not-exist-\(UUID().uuidString).png")
            await #expect(throws: ImageDecodingError.self) {
                _ = try await Texture.load(from: missing)
            }
        }

        @Test @MainActor func textureLoadAsyncFromInvalidBytesThrows() async {
            ensureAdwInit()
            let url = Self.writeFixture([0x00, 0x01, 0x02, 0x03], suffix: ".png")
            defer { try? FileManager.default.removeItem(at: url) }
            await #expect(throws: ImageDecodingError.self) {
                _ = try await Texture.load(from: url)
            }
        }

        @Test @MainActor func textureLoadSynchronouslyFromPNGReturnsCorrectSize() throws {
            ensureAdwInit()
            guard let url = Self.writePNGFixture(width: 5, height: 4) else {
                Issue.record("Failed to write PNG fixture")
                return
            }
            defer { try? FileManager.default.removeItem(at: url) }

            let texture = try Texture.loadSynchronously(from: url)
            #expect(texture.width == 5)
            #expect(texture.height == 4)
        }

        @Test @MainActor func textureLoadSynchronouslyFromMissingFileThrows() {
            ensureAdwInit()
            let missing = FileManager.default.temporaryDirectory
                .appendingPathComponent("does-not-exist-\(UUID().uuidString).png")
            #expect(throws: ImageDecodingError.self) {
                _ = try Texture.loadSynchronously(from: missing)
            }
        }

        @Test @MainActor func textureLoadSynchronouslyFromInvalidBytesThrows() {
            ensureAdwInit()
            let url = Self.writeFixture([0x00, 0x01, 0x02, 0x03], suffix: ".png")
            defer { try? FileManager.default.removeItem(at: url) }
            #expect(throws: ImageDecodingError.self) {
                _ = try Texture.loadSynchronously(from: url)
            }
        }

        // MARK: - Picture.intrinsicSize

        @Test @MainActor func pictureIntrinsicSizeIsNilWhenEmpty() {
            ensureAdwInit()
            let picture = Picture()
            #expect(picture.intrinsicSize == nil)
        }

        @Test @MainActor func pictureIntrinsicSizeReflectsLoadedTexture() async throws {
            ensureAdwInit()
            guard let url = Self.writePNGFixture(width: 12, height: 9) else {
                Issue.record("Failed to write PNG fixture")
                return
            }
            defer { try? FileManager.default.removeItem(at: url) }

            let picture = Picture()
            let texture = try await Texture.load(from: url)
            picture.setPaintable(texture)

            #expect(picture.intrinsicSize == Picture.IntrinsicSize(width: 12, height: 9))
        }

        // MARK: - Scaled texture loading

        /// `Texture(filename:maxWidth:maxHeight:)` decodes through the
        /// GdkPixbuf loader pipeline — the path that picks up WebP and
        /// AVIF/HEIF loaders — and then hands the pixels to a memory texture.
        /// The handover is the part worth testing: it replaced the deprecated
        /// `gdk_texture_new_for_pixbuf`, and it has to keep the pixbuf's
        /// buffer alive for as long as the texture reads from it.
        @Test @MainActor func scaledTextureClampsToTheRequestedBox() throws {
            ensureAdwInit()
            guard let url = Self.writePNGFixture(width: 40, height: 20) else {
                Issue.record("Failed to write PNG fixture")
                return
            }
            defer { try? FileManager.default.removeItem(at: url) }

            let texture = try #require(Texture(filename: url.path, maxWidth: 10, maxHeight: 10))
            // Aspect ratio preserved, so the wider side is what binds.
            #expect(texture.width == 10)
            #expect(texture.height == 5)
        }

        /// GdkPixbuf gives three channels without alpha and four with it, so
        /// the initializer picks the memory format from the pixbuf rather than
        /// assuming RGBA. Assuming it would misread every opaque image: the
        /// rows are 25% shorter than the format claims, so the texture would
        /// read past the buffer and skew.
        @Test @MainActor func scaledTextureLoadsBothWithAndWithoutAlpha() throws {
            ensureAdwInit()
            for hasAlpha in [true, false] {
                guard let url = Self.writePNGFixture(width: 8, height: 8, hasAlpha: hasAlpha) else {
                    Issue.record("Failed to write PNG fixture (hasAlpha: \(hasAlpha))")
                    continue
                }
                defer { try? FileManager.default.removeItem(at: url) }

                let texture = try #require(
                    Texture(filename: url.path, maxWidth: 8, maxHeight: 8),
                    "no texture for a PNG with hasAlpha: \(hasAlpha)"
                )
                #expect(texture.width == 8)
                #expect(texture.height == 8)
            }
        }

        @Test @MainActor func scaledTextureReturnsNilForSomethingThatIsNotAnImage() {
            ensureAdwInit()
            let url = Self.writeFixture(Array("not an image".utf8), suffix: ".png")
            defer { try? FileManager.default.removeItem(at: url) }

            #expect(Texture(filename: url.path, maxWidth: 10, maxHeight: 10) == nil)
        }

        // MARK: - AnimatedImagePlayer

        @Test @MainActor func animatedImagePlayerReturnsNilForStaticImage() throws {
            ensureAdwInit()
            let url = Self.writeFixture(Self.staticGIFBytes, suffix: ".gif")
            defer { try? FileManager.default.removeItem(at: url) }

            let picture = Picture()
            let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
            #expect(player == nil)
        }

        @Test @MainActor func animatedImagePlayerInitialisesForAnimatedGIF() throws {
            ensureAdwInit()
            let url = Self.writeFixture(Self.animatedGIFBytes, suffix: ".gif")
            defer { try? FileManager.default.removeItem(at: url) }

            let picture = Picture()
            let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
            try #require(player != nil)
            #expect(player?.metadata == AnimatedImagePlayer.Metadata(width: 2, height: 2))
            #expect(player?.isPlaying == false)
        }

        @Test @MainActor func animatedImagePlayerStartStopTogglesIsPlaying() throws {
            ensureAdwInit()
            let url = Self.writeFixture(Self.animatedGIFBytes, suffix: ".gif")
            defer { try? FileManager.default.removeItem(at: url) }

            let picture = Picture()
            let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
            try #require(player != nil)

            player?.start()
            #expect(player?.isPlaying == true)
            player?.stop()
            #expect(player?.isPlaying == false)
        }

        @Test @MainActor func animatedImagePlayerThrowsForInvalidFile() {
            ensureAdwInit()
            let url = Self.writeFixture([0xFF, 0xFE, 0xFD, 0xFC], suffix: ".gif")
            defer { try? FileManager.default.removeItem(at: url) }

            let picture = Picture()
            #expect(throws: ImageDecodingError.self) {
                _ = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
            }
        }

        @Test @MainActor func animatedImagePlayerSetsFirstFramePaintable() throws {
            ensureAdwInit()
            let url = Self.writeFixture(Self.animatedGIFBytes, suffix: ".gif")
            defer { try? FileManager.default.removeItem(at: url) }

            let picture = Picture()
            #expect(picture.intrinsicSize == nil)

            let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
            try #require(player != nil)
            #expect(picture.intrinsicSize?.width == 2)
            #expect(picture.intrinsicSize?.height == 2)
        }

        @Test @MainActor func animatedImagePlayerAdvanceFrameChangesPaintable() throws {
            ensureAdwInit()
            let url = Self.writeFixture(Self.animatedGIFBytes, suffix: ".gif")
            defer { try? FileManager.default.removeItem(at: url) }

            let picture = Picture()
            let player = try AnimatedImagePlayer(contentsOf: url, displayedBy: picture)
            try #require(player != nil)

            let firstPaintable = gtk_picture_get_paintable(OpaquePointer(picture.pointer))
            #expect(firstPaintable != nil)

            player?.advanceFrame()

            let secondPaintable = gtk_picture_get_paintable(OpaquePointer(picture.pointer))
            #expect(secondPaintable != nil)
            #expect(firstPaintable != secondPaintable)
        }
    }
}
#endif
#endif
