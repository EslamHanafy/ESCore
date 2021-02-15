// StdlibDeprecated.swift - Copyright 2020 SwifterSwift

private func optionalCompareAscending<T: Comparable>(path1: T?, path2: T?) -> Bool {
    guard let path1 = path1, let path2 = path2 else { return false }
    return path1 < path2
}

private func optionalCompareDescending<T: Comparable>(path1: T?, path2: T?) -> Bool {
    guard let path1 = path1, let path2 = path2 else { return false }
    return path1 > path2
}

public extension Sequence {
    /// SwifterSwift: Returns an array containing the results of mapping the given key path over the sequence’s elements.
    ///
    /// - Parameter keyPath: Key path to map.
    /// - Returns: An array containing the results of mapping.
    @available(*, deprecated, message: "Please use map() with a key path instead.")
    func map<T>(by keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }

    /// SwifterSwift: Returns an array containing the non-nil results of mapping the given key path over the sequence’s elements.
    ///
    /// - Parameter keyPath: Key path to map.
    /// - Returns: An array containing the non-nil results of mapping.
    @available(*, deprecated, message: "Please use compactMap() with a key path instead.")
    func compactMap<T>(by keyPath: KeyPath<Element, T?>) -> [T] {
        return compactMap { $0[keyPath: keyPath] }
    }

    /// SwifterSwift: Returns an array containing the results of filtering the sequence’s elements by a boolean key path.
    ///
    /// - Parameter keyPath: Boolean key path. If it's value is `true` the element will be added to result.
    /// - Returns: An array containing filtered elements.
    @available(*, deprecated, message: "Please use filter() with a key path instead.")
    func filter(by keyPath: KeyPath<Element, Bool>) -> [Element] {
        return filter { $0[keyPath: keyPath] }
    }

    /// SwifterSwift: Get last element that satisfies a conditon.
    ///
    ///        [2, 2, 4, 7].last(where: {$0 % 2 == 0}) -> 4
    ///
    /// - Parameter condition: condition to evaluate each element against.
    /// - Returns: the last element in the array matching the specified condition. (optional)
    @available(*, deprecated, message: "For an unordered sequence using `last` instead of `first` is equal.")
    func last(where condition: (Element) throws -> Bool) rethrows -> Element? {
        for element in reversed() {
            if try condition(element) { return element }
        }
        return nil
    }
}
