// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2026 Sergey Armodin

public extension String {
    /// Returns the UTF-8 byte offset for a string index, matching Pango's
    /// start/end index units.
    func pangoByteOffset(of index: Index) -> Int {
        guard let utf8Index = index.samePosition(in: utf8) else {
            preconditionFailure("String index must reference this string and a UTF-8 code point boundary")
        }
        return utf8.distance(from: utf8.startIndex, to: utf8Index)
    }

    /// Returns the UTF-8 byte range for a Swift string range, matching
    /// Pango's start/end index units.
    func pangoByteRange(for range: Range<Index>) -> Range<Int> {
        pangoByteOffset(of: range.lowerBound) ..< pangoByteOffset(of: range.upperBound)
    }
}
