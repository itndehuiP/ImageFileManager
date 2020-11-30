import XCTest
@testable import ImageFileManager


struct DataMock: Codable {
    var name: String
    var value: Int
}

final class ImageFileManagerTests: XCTestCase {
    
    let imageManager = ImageFileManager()
    
    func testSaveWithoutFolder() {
        let mock = DataMock(name: "TestA", value: 0)
        let data = try? JSONEncoder().encode(mock)
        XCTAssertNotNil(data)
        let url = imageManager.saveImage(data: data, id: "TestA")
        XCTAssertNotNil(url)
    }
    
    func testLoadWithoutFolder() {
        let mock = DataMock(name: "TestB", value: 0)
        let data = try? JSONEncoder().encode(mock)
        let mockQ = try! JSONDecoder().decode(DataMock.self, from: data!)
        XCTAssertEqual(mockQ.name, "TestB")
        XCTAssertNotNil(data)
        let url = imageManager.saveImage(data: data, id: "TestB")
        XCTAssertNotNil(url)
        let dataF = imageManager.loadImage(id: "TestB")
        XCTAssertNotNil(dataF)
        let mockR = try! JSONDecoder().decode(DataMock.self, from: dataF!)
        XCTAssertEqual(mockR.name, "TestB")
    }
    
    func testDeleteWithoutFolder() {
        let mock = DataMock(name: "TestC", value: 0)
        let data = try? JSONEncoder().encode(mock)
        XCTAssertNotNil(data)
        let url = imageManager.saveImage(data: data, id: "TestC")
        XCTAssertNotNil(url)
        let dataF = imageManager.loadImage(id: "TestC")
        XCTAssertNotNil(dataF)
        imageManager.deleteImage(id: "TestC")
        let dataA = imageManager.loadImage(id: "TestC")
        XCTAssertNil(dataA)
    }
    
    func testSaveWithFolder() {
        let mock = DataMock(name: "TestFolder", value: 0)
        let data = try? JSONEncoder().encode(mock)
        XCTAssertNotNil(data)
        let url = imageManager.saveImage(data: data, album: "AlbumFolder", id: "Test")
        XCTAssertNotNil(url)
    }
    
    func testLoadWithFolder() {
        let mock = DataMock(name: "Test", value: 0)
        let data = try? JSONEncoder().encode(mock)
        XCTAssertNotNil(data)
        let url = imageManager.saveImage(data: data, album: "AlbumFolderA", id: "Test")
        XCTAssertNotNil(url)
        let dataLoaded = imageManager.loadImage(album: "AlbumFolderA", id: "Test")
        XCTAssertNotNil(dataLoaded)
    }
    
    func testDeleteWithFolder() {
        let mock = DataMock(name: "Test", value: 0)
        let data = try? JSONEncoder().encode(mock)
        XCTAssertNotNil(data)
        let url = imageManager.saveImage(data: data, album: "AlbumFolderB", id: "Test")
        XCTAssertNotNil(url)
        var dataLoaded = imageManager.loadImage(album: "AlbumFolderB", id: "Test")
        XCTAssertNotNil(dataLoaded)
        imageManager.deleteImage(album: "AlbumFolderB", id: "Test")
        dataLoaded = imageManager.loadImage(album: "AlbumFolderB", id: "Test")
        XCTAssertNil(dataLoaded)
    }
    
    func testDeleteAlbumFolder() {
        let mock = DataMock(name: "Test", value: 0)
        let data = try? JSONEncoder().encode(mock)
        XCTAssertNotNil(data)
        let url = imageManager.saveImage(data: data, album: "AlbumFolderC", id: "Test")
        XCTAssertNotNil(url)
        var dataLoaded = imageManager.loadImage(album: "AlbumFolderC", id: "Test")
        XCTAssertNotNil(dataLoaded)
        imageManager.delete(album: "AlbumFolderC")
        dataLoaded = imageManager.loadImage(album: "AlbumFolderC", id: "Test")
        XCTAssertNil(dataLoaded)
    }
//    //MARK: Important
//    func testRemoveTestFolder() {
//        imageManager.deleteAll()
//    }

    static var allTests = [
        ("testSaveWithoutFolder", testSaveWithoutFolder),
    ]
}
