import Foundation

public struct ImageFileManager {
    
    public init() {}
    private let mainFolder = "ImageManager"
    /// Creates the main directory path.
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
                let description = "Couldn't create main directory \(error.localizedDescription)"
                print("Image File Manager [Info]: \(description)")
            }
        }
        return directoryPath
    }
    /**
     Consults the corresponding path, using the album received.
     - Parameters:
     - album: The name of the directory consultated,
     - createIfNeeded: Bool value indicating whether the directory should be created if it doesn't exists.
     - returns: An optional URL, the corresponding URL if the consult was succesfull, and nil if it wasn't.
     */
    private func albumDirectoryPath(album: String, createIfNeeded: Bool) -> URL? {
        let albumDirectoryURL = directoryPath(createIfNeeded: createIfNeeded).appendingPathComponent(album, isDirectory: true)
        if createIfNeeded {
            do {
                try FileManager.default.createDirectory(at: albumDirectoryURL,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                let description = "Couldn't create album directory \(error.localizedDescription)"
                print("Image File Manager [Info]: \(description)")
            }
        }
        return albumDirectoryURL
    }
    /**
     Consults the corresponding path, using the album and id received.
     - Parameters:
     - album: The name of the directory consultated
     - id: The path component of the diretory consultated.
     - createIfNeeded: Bool value indicating whether the directory should be created if it doesn't exists.
     - returns: An optional URL, the corresponding URL if the consult was succesfull, and nil if it wasn't.
     */
    private func dataDirectoryPath(album: String? = nil, with id: String, createIfNeeded: Bool) -> URL? {
        guard !id.isEmpty else { return nil }
        if let album = album {
            return albumDirectoryPath(album: album, createIfNeeded: createIfNeeded)?.appendingPathComponent(id)
        } else {
            return directoryPath(createIfNeeded: createIfNeeded).appendingPathComponent(id)
        }
    }
    /**
     Saves the received data in the corrsponding path, using the album and id passed.
     - Parameters:
     - data: The data to save.
     - album: The name of the folder where data should be saved.
     - id: The name under which the data should be saved.
     - returns: An optional URL, the corresponding URL if the saving was succesfull, and nil if it wasn't.
     */
    public func saveImage(data: Data?, album: String? = nil, id: String?) -> URL? {
        guard let data = data, let id = id, let dataPath = dataDirectoryPath(album: album, with: id, createIfNeeded: true) else { return nil }
        do {
            try data.write(to: dataPath)
        } catch {
            let description = "Couldn't complete writing with id: \(id). \(error.localizedDescription)"
            print("Image File Manager [Info]: \(description)")
        }
        return dataPath
    }
    /**
     Retrieves the data saved in the album passed under the id name.
     - Parameters:
     - album: The path of the directory where the data should be found.
     - id: The name under which the data its saved.
     - returns: The data found with the given parameters.
     */
    public func loadImage(album: String? = nil, id: String?) -> Data? {
        guard let id = id, let dataPath = dataDirectoryPath(album: album, with: id, createIfNeeded: false) else { return nil }
        return try? Data(contentsOf: dataPath)
    }
    
    //MARK: Delete
    /**
     Deletes the main folder with all the data that it contains.
     - note: It deletes all the data saved using this manager.
     */
    public func deleteAll() {
        if fileExists(path: directoryPath(createIfNeeded: false).absoluteString) {
            do {
                try FileManager.default.removeItem(at: directoryPath(createIfNeeded: false))
            } catch {
                let description = "Failed to delete main folder. \(error.localizedDescription)"
                print("Image File Manager [Info]: \(description)")
            }
        }
    }
    /**
     Deletes the directory with "album" name.
     */
    public func delete(album: String) {
        guard let albumPath = albumDirectoryPath(album: album, createIfNeeded: false),
              fileExists(path: albumPath.absoluteString) else { return }
        do {
            try FileManager.default.removeItem(at: albumPath)
        } catch {
            let description = "Failed to delete album folder: \(album). \(error.localizedDescription)"
            print("Image File Manager [Info]: \(description)")
        }
    }
    /**
     Deletes the data in the directory "album" identified under id name.
     - album: The path of the directory where the data should be found.
     - id: The name under which the data its saved.
     */
    public func deleteImage(album: String? = nil, id: String?) {
        guard let id = id, let dataPath = dataDirectoryPath(album: album, with: id, createIfNeeded: false),
              fileExists(path: dataPath.absoluteString) else { return }
        do {
            try FileManager.default.removeItem(at: dataPath)
        } catch {
            let description = "Failed to delete file with id: \(id). \(error.localizedDescription)"
            print("Image File Manager [Info]: \(description)")
        }
    }
    
    private func fileExists(path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
}
