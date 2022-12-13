import XCTest
@testable import Translucent

final class TranslucentTests: XCTestCase {
    
    let white = Bundle.module.url(forResource: "white", withExtension: "jpeg")!
    
    func testExample() throws {
        let wallpaper = Wallpaper(UIImage(contentsOfFile: white.path)!)
        let cropped = wallpaper.widgetBackground(for: .largeBottom)
        XCTAssertNotNil(cropped)
        print(cropped?.size)
    }
}
