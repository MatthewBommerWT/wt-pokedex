//
//  PokemonArchiver.swift
//  Pokedex
//
//  Created by Matt Bommer on 3/1/21.
//

import Foundation


enum ArchiverError: Error {
    case failedToCreateURL
}

class Archiver {
    
    private let fileManager: FileManager = FileManager()
    
    func read<T: Decodable>() -> T? {
        do {
            guard let data = try readFile(fileName: String(describing: T.self)) else {
                return nil
            }
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            let values = try unarchiver.decodeTopLevelDecodable(T.self, forKey: NSKeyedArchiveRootObjectKey)
            return values
        } catch {
            print(error)
            return nil
        }
    }
    
    func write<T: Encodable>(_ data: T) {
        do {
            let archiver = NSKeyedArchiver.init(requiringSecureCoding: false)
            try archiver.encodeEncodable(data, forKey: NSKeyedArchiveRootObjectKey)
            archiver.finishEncoding()
            try writeToFile(data: archiver.encodedData, fileName: String(describing: T.self))
        } catch {
            print(error)
        }
    }
    
    private func writeToFile(data: Data, fileName: String) throws {
        guard let url = fileURL(for: fileName) else {
            throw ArchiverError.failedToCreateURL
        }
        try data.write(to: url)
    }
    
    private func readFile(fileName: String) throws -> Data? {
        guard let url = fileURL(for: fileName) else {
            return nil
        }
        return try Data(contentsOf: url)
    }
    
    private func fileURL(for fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
}
