//
//  OperationDataManager.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 19.03.2021.
//

import UIKit

class OperationDataManager: DataManagerProtocol {
    
    private let nameFile = "name.txt"
    private let descriptionFile = "description.txt"
    private let imageFile = "image.png"
    private var vc: ProfileViewController
    
    var name: String?
    var description: String?
    var image: UIImage?
    
    init(vc: ProfileViewController) {
        self.vc = vc
    }
    
    func write() {
        vc.setupActivityIndicator()
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let nameURL = dir.appendingPathComponent(self.nameFile)
            let descriptionURL = dir.appendingPathComponent(self.descriptionFile)
            let imageURL = dir.appendingPathComponent(self.imageFile)
            let operationQueue = OperationQueue()
            let operation = writeOperation(vc: vc)
            operation.nameURL = nameURL
            operation.descriptionURL = descriptionURL
            operation.imageURL = imageURL
            operation.nameString = name
            operation.descriptionString = description
            operation.image = image
            operationQueue.addOperation(operation)
            vc.activityIndicator.removeFromSuperview()
        }
    }
    
    func read() {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let nameURL = dir.appendingPathComponent(self.nameFile)
            let descriptionURL = dir.appendingPathComponent(self.descriptionFile)
            let imageURL = dir.appendingPathComponent(self.imageFile)
            let operationQueue = OperationQueue()
            let operation = readOperation(vc: vc)
            operation.nameURL = nameURL
            operation.descriptionURL = descriptionURL
            operation.imageURL = imageURL
            operationQueue.addOperation(operation)
        }
        
    }
    
}

class writeOperation: Operation {
    
    var nameURL: URL?
    var descriptionURL: URL?
    var imageURL: URL?
    
    var nameString: String?
    var descriptionString: String?
    var image: UIImage?
    
    private var vc: ProfileViewController
    
    init(vc: ProfileViewController) {
        self.vc = vc
    }
    
    override func main() {
        do {
            if let nameURL = nameURL {
                try nameString?.write(to: nameURL, atomically: false, encoding: .utf8)
            }
            
            if let descriptionURL = descriptionURL {
                try descriptionString?.write(to: descriptionURL, atomically: false, encoding: .utf8)
            }
            
            if let imageURL = imageURL {
                try image?.pngData()?.write(to: imageURL)
            }
            OperationQueue.main.addOperation {
                self.vc.alertOK()
            }
        } catch {
            OperationQueue.main.addOperation {
                self.vc.alertError()
            }
        }
        
    }
}

class readOperation: Operation {
    var nameURL: URL?
    var descriptionURL: URL?
    var imageURL: URL?
    
    var vc: ProfileViewController
    
    init(vc: ProfileViewController) {
        self.vc = vc
    }
    override func main() {
        do {
            guard let nameURL = nameURL,
                  let descriptionURL = descriptionURL,
                  let imageURL = imageURL else { return }
            
            let nameString = try String(contentsOf: nameURL, encoding: .utf8)
            let descriptionString = try String(contentsOf: descriptionURL, encoding: .utf8)
            let imageData = try Data(contentsOf: imageURL)
            let image = UIImage(data: imageData)
            
            OperationQueue.main.addOperation {
                self.vc.nameTextField.text = nameString
                self.vc.descriptionTextField.text = descriptionString
                self.vc.profilePhoto.image = image
                
                self.vc.nameString = nameString
                self.vc.descriptionString = descriptionString
                self.vc.image = image ?? UIImage()
                self.vc.activityIndicator.removeFromSuperview()
            }
            
        } catch {
            print("error write operation")
        }
        
    }
}
