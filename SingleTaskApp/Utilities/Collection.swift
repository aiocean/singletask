import SwiftUI
extension Collection {
    /**
     Returns a infinite sequence with unique random elements from the collection.
     Elements will only repeat after all elements have been seen.
     This can be useful for slideshows and music playlists where you want to ensure that the elements are better spread out.
     If the collection only has a single element, that element will be repeated forever.
     If the collection is empty, it will never return any elements.
     ```
     let sequence = [1, 2, 3, 4].infiniteUniformRandomSequence()
     for element in sequence.prefix(3) {
     print(element)
     }
     //=> 3
     //=> 1
     //=> 2
     let iterator = sequence.makeIterator()
     iterator.next()
     //=> 4
     iterator.next()
     //=> 1
     ```
     */
    func infiniteUniformRandomSequence() -> AnySequence<Element> {
        guard !isEmpty else {
            return [].eraseToAnySequence()
        }
        
        return AnySequence { () -> AnyIterator in
            guard count > 1 else {
                return AnyIterator { first }
            }
            
            var currentIndices = [Index]()
            var previousIndex: Index?
            
            return AnyIterator {
                if currentIndices.isEmpty {
                    currentIndices = indices.shuffled()
                    
                    // Ensure there are no duplicate elements on the edges.
                    if currentIndices.last == previousIndex {
                        currentIndices = currentIndices.reversed()
                    }
                }
                
                let index = currentIndices.popLast()! // It cannot be nil.
                previousIndex = index
                return self[index]
            }
        }
    }
}

extension Sequence {
    func eraseToAnySequence() -> AnySequence<Element> { .init(self) }
}

extension Sequence {
    /**
     Convert a sequence to a dictionary by mapping over the values and using the returned key as the key and the current sequence element as value.
     ```
     [1, 2, 3].toDictionary { $0 }
     //=> [1: 1, 2: 2, 3: 3]
     ```
     */
    func toDictionary<Key: Hashable>(withKey pickKey: (Element) -> Key) -> [Key: Element] {
        var dictionary = [Key: Element]()
        for element in self {
            dictionary[pickKey(element)] = element
        }
        return dictionary
    }
    
    /**
     Convert a sequence to a dictionary by mapping over the elements and returning a key/value tuple representing the new dictionary element.
     ```
     [(1, "a"), (2, "b")].toDictionary { ($1, $0) }
     //=> ["a": 1, "b": 2]
     ```
     */
    func toDictionary<Key: Hashable, Value>(withKey pickKeyValue: (Element) -> (Key, Value)) -> [Key: Value] {
        var dictionary = [Key: Value]()
        for element in self {
            let newElement = pickKeyValue(element)
            dictionary[newElement.0] = newElement.1
        }
        return dictionary
    }
    
    /**
     Same as the above but supports returning optional values.
     ```
     [(1, "a"), (nil, "b")].toDictionary { ($1, $0) }
     //=> ["a": 1, "b": nil]
     ```
     */
    func toDictionary<Key: Hashable, Value>(withKey pickKeyValue: (Element) -> (Key, Value?)) -> [Key: Value?] {
        var dictionary = [Key: Value?]()
        for element in self {
            let newElement = pickKeyValue(element)
            dictionary[newElement.0] = newElement.1
        }
        return dictionary
    }
}


extension Dictionary {
    func compactValues<T>() -> [Key: T] where Value == T? {
        // TODO: Make this `compactMapValues(\.self)` when https://github.com/apple/swift/issues/55343 is fixed.
        compactMapValues { $0 }
    }
}
