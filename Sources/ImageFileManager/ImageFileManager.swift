import Foundation

public struct ImageFileManager {
    
    public init() {}
    private let mainFolder = "ImageManager"
    
    private var directoryPath: URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      let folderDirectoryURL = paths.first!.appendingPathComponent(mainFolder)
        return folderDirectoryURL
    }
    
    private func directoryPath(createIfNeeded: Bool) -> URL {
        if createIfNeeded {
            do {
              try FileManager.default.createDirectory(at: directoryPath,
                                                      withIntermediateDirectories: true,
                                                      attributes: nil)
            } catch {
                  print("Couldn't create directory \(error.localizedDescription)")
            }
        }
        return directoryPath
    }
    
    private func albumDirectoryPath(album: String, createIfNeeded: Bool) -> URL? {
        let albumDirectoryURL = directoryPath(createIfNeeded: createIfNeeded).appendingPathComponent(album, isDirectory: true)
        if createIfNeeded {
            do {
                try FileManager.default.createDirectory(at: albumDirectoryURL,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print("Couldn't create directory \(error.localizedDescription)")
            }
        }
        return albumDirectoryURL
    }
    
    private func dataDirectoryPath(album: String? = nil, with id: String, createIfNeeded: Bool) -> URL? {
        guard !id.isEmpty else { return nil }
        if let album = album {
            return albumDirectoryPath(album: album, createIfNeeded: createIfNeeded)?.appendingPathComponent(id)
        } else {
            return directoryPath(createIfNeeded: createIfNeeded).appendingPathComponent(id)
        }
    }
    
    public func saveImage(data: Data?, album: String? = nil, id: String?) -> URL? {
        guard let data = data, let id = id, let dataPath = dataDirectoryPath(album: album, with: id, createIfNeeded: true) else { return nil }
        do {
            try data.write(to: dataPath)
        } catch {
            print("Couldn't write to save file: " + error.localizedDescription)
        }
        return dataPath
    }
    
    public func loadImage(album: String? = nil, id: String?) -> Data? {
        guard let id = id, let dataPath = dataDirectoryPath(album: album, with: id, createIfNeeded: false) else { return nil }
        return try? Data(contentsOf: dataPath)
    }
    
    //MARK: Delete
    public func deleteAll() {
        do {
            try FileManager.default.removeItem(at: directoryPath(createIfNeeded: false))
        } catch {
            print("Error Deleting Folder. " + error.localizedDescription)
        }
    }
    
    public func delete(album: String) {
        guard let albumPath = albumDirectoryPath(album: album, createIfNeeded: false) else { return }
        do {
            try FileManager.default.removeItem(at: albumPath)
        } catch {
            print("Error Deleting Folder. " + error.localizedDescription)
        }
    }
    
    public func deleteImage(album: String? = nil, id: String?) {
        guard let id = id, let dataPath = dataDirectoryPath(album: album, with: id, createIfNeeded: false) else { return }
        do {
            try FileManager.default.removeItem(at: dataPath)
        } catch {
            print("Error Deleting Folder. " + error.localizedDescription)
        }
    }
}
