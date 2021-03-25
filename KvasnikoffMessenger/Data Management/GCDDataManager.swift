//
//  GCDDataManager.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 19.03.2021.
//

import UIKit

protocol DataManagerProtocol {
    func write()
    func read()
}

class GCDDataManager: DataManagerProtocol { // добавить нормальную инкапсуляцию для всего
    
    init(vc: ProfileViewController) {
        self.vc = vc
    }
    
    private var serialQueue = DispatchQueue(label: "serial")
    
    private var test1 = "Marina Dudarenko"
    private var test2 = "UX/UI designer, web-designer Moscow, Russia"
    
    private let vc: ProfileViewController
    var name: String?
    var description: String?
    var image: UIImage?
    
    private let nameFile = "name.txt"
    private let descriptionFile = "description.txt"
    private let imageFile = "image.png"
    
    func write() {
        vc.setupActivityIndicator()
        serialQueue.asyncAfter(deadline: .now(), execute: {
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let nameURL = dir.appendingPathComponent(self.nameFile)
                let descriptionURL = dir.appendingPathComponent(self.descriptionFile)
                let imageURL = dir.appendingPathComponent(self.imageFile)
                do {
                    if let name = self.name {
                        try name.write(to: nameURL, atomically: false, encoding: .utf8)
                    }
                    
                    if let description = self.description {
                        try description.write(to: descriptionURL, atomically: false, encoding: .utf8)
                    }
                    
                    if let image = self.image {
                        try image.pngData()?.write(to: imageURL)
                    }
                    
                    DispatchQueue.main.async {
                        self.vc.activityIndicator.removeFromSuperview()
                        self.vc.alertOK()
                        
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.vc.activityIndicator.removeFromSuperview()
                        self.vc.alertError()
                    }
                }
            }
            
        })
        
    }
    
    func read() {
        serialQueue.asyncAfter(deadline: .now(), execute: {
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let nameURL = dir.appendingPathComponent(self.nameFile)
                let descriptionURL = dir.appendingPathComponent(self.descriptionFile)
                let imageURL = dir.appendingPathComponent(self.imageFile)
                do {
                    let name = try String(contentsOf: nameURL, encoding: .utf8)
                    let description = try String(contentsOf: descriptionURL, encoding: .utf8)
                    let imageData = try Data(contentsOf: imageURL)
                    let image = UIImage(data: imageData)
                    
                    DispatchQueue.main.async {
                        self.vc.nameTextField.text = name
                        self.vc.descriptionTextField.text = description
                        self.vc.profilePhoto.image = image
                        
                        self.vc.nameString = name
                        self.vc.descriptionString = description
                        self.vc.image = image ?? UIImage()
                    }
                    
                } catch {
                    print("error read")
                    print(error)
                }
                
            }
        })
        
    }
    
}
