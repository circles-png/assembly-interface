import XCTest

@testable import AssemblyInterface
final class AssemblyInterfaceTests: XCTestCase {
  func testSerialise() throws {
    let bytes: [UInt8] = [0, 0, 0, 0, 1, 97, 0, 1, 1, 1, 98, 0, 2, 2, 1, 99, 0, 3]
    let timetable = try AssemblyTimetable.serialise(bytes: bytes)
    XCTAssertEqual(timetable.version, [0, 0, 0])
    XCTAssertEqual(timetable.bells.count, 3)
    XCTAssertEqual(timetable.bells[0]!, [Bell(name: "a", time: 1)])
    XCTAssertEqual(timetable.bells[1]!, [Bell(name: "b", time: 2)])
    XCTAssertEqual(timetable.bells[2]!, [Bell(name: "c", time: 3)])
  }
}
