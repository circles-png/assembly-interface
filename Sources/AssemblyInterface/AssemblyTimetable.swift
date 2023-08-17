import Foundation

struct Bell {
  var name: String
  var time: UInt16
}

extension Bell: Equatable {
  static func == (lhs: Bell, rhs: Bell) -> Bool {
    return lhs.name == rhs.name && lhs.time == rhs.time
  }
}

public struct AssemblyTimetable {
  var version: [UInt8]
  var bells: [UInt8: [Bell]]

  public static func serialise(bytes: [UInt8]) throws -> AssemblyTimetable {
    var bytes = bytes.makeIterator().makePeekableIterator()
    let version = [bytes.next()!, bytes.next()!, bytes.next()!]
    var bells = [UInt8: [Bell]]()
    while bytes.peek() != nil {
      let id = bytes.next()!
      let nameLength = bytes.next()!
      var nameCharacters = [Character]()
      for _ in 0..<nameLength {
        nameCharacters.append(Character(UnicodeScalar(bytes.next()!)))
      }
      let name = String(nameCharacters)
      let time = UInt16(
        bigEndian: Data([bytes.next()!, bytes.next()!]).withUnsafeBytes { buffer -> UInt16 in
          buffer.load(as: UInt16.self)
        })
      bells[id] = [Bell(name: name, time: time)]
    }

    return AssemblyTimetable(version: version, bells: bells)
  }
}

struct PeekableIterator<Iterator: IteratorProtocol>: IteratorProtocol {
  typealias Element = Iterator.Element

  private var iterator: Iterator
  private var nextElement: Element?

  init(_ iterator: Iterator) {
    self.iterator = iterator
  }

  mutating func peek() -> Element? {
    if nextElement == nil {
      nextElement = iterator.next()
    }
    return nextElement
  }

  mutating func next() -> Element? {
    guard let result = nextElement else {
      return iterator.next()
    }
    nextElement = nil
    return result
  }
}

protocol PeekableProtocol<Element> {
  associatedtype Element

  mutating func peek() -> Self.Element?
}

extension Sequence {
  func makePeekableIterator() -> PeekableIterator<Self.Iterator> {
    return .init(makeIterator())
  }
}
