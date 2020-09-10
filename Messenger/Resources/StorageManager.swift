//
//  StorageManager.swift
//  Messenger
//
//  Created by Bim on 9/10/20.
//  Copyright © 2020 Jiradet Amornpimonkul. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    
    // Uploads picture to firebase storage and returns completion with url String to download
    
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else {
                //failed
                print("failed to upload data to firebase for picture")
                completion(.failure(storageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { (url, error) in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(storageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    public enum storageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
}
