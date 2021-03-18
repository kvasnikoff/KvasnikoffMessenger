//
//  ViewController.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 16.02.2021.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let profilePhoto: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor(red: 228/255.0, green: 230/255.0, blue: 66/255.0, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let initialsPhotoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.text = "MD"
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.text = "Marina Dudarenko"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "UX/UI designer, web designer \n Moscow, Russia"
        label.numberOfLines = 0
        return label
    }()
    
    private let editButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        return button
    }()
    
    init() {
        print("Init before super.init: \(editButton.frame)") //nil нету, все ок
        super.init(nibName: nil, bundle: nil)
        print("Init after super.init: \(editButton.frame)") //nil нету, все ок
        
    }
    
    required init?(coder: NSCoder) {
        print("Required Init: \(editButton.frame)") //не вызывается
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        printLog(log: "\(#function)")
        print("viewDidLoad before SetupUI: \(editButton.frame)") //размеры не рассчитались
        setupUI()
    }
    
    private func setupUI() {
        
        title = "My Profile"
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        
        self.view.backgroundColor = .white
        view.addSubview(profilePhoto)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(editButton)
        view.addSubview(initialsPhotoLabel)
        
        let rightButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = rightButton
     //   self.navigationItem.prefersLargeTitles = true // разобраться с несимметричной rightbarbutton
       
        profilePhoto.frame = CGRect(x: 0, y: 0, width: screenWidth/2.3, height: screenWidth/2.3)
        profilePhoto.layer.cornerRadius = (profilePhoto.frame.size.width) / 2 // circle
        profilePhoto.clipsToBounds = true
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: screenWidth/15)
        
        descriptionLabel.font = .systemFont(ofSize: screenWidth/20)
        
        initialsPhotoLabel.font = UIFont.boldSystemFont(ofSize: screenWidth/5)
        
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        initialsPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profilePhoto.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: screenWidth/2.3),
            profilePhoto.heightAnchor.constraint(equalToConstant: screenWidth/2.3),
            
            nameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            editButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: screenWidth/1.5),
            
            initialsPhotoLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            initialsPhotoLabel.centerXAnchor.constraint(equalTo: profilePhoto.centerXAnchor),
            

                                        
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editButtonTapped))
        editButton.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func rightBarButtonTapped () {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func editButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) -> Void in
                self.camera()
            }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: UIAlertAction.Style.default, handler: { (alert: UIAlertAction!) -> Void in
                self.photoLibrary()
            }))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        actionSheet.pruneNegativeWidthConstraints() // устраняем ошибку Apple с констрейнтой в AlertViewController
        

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func camera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("No camera found")
            return
        }
        
        myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)

    }

    private func photoLibrary() {

        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = .photoLibrary

        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        profilePhoto.image = selectedImage
        initialsPhotoLabel.isHidden = true
        
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLog(log: "\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewVillAppear: \(editButton.frame)") // до этого во ViewDidLoad все расчитали, поэтому теперь все правильно выводится
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        printLog(log: "\(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        printLog(log: "\(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printLog(log: "\(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        printLog(log: "\(#function)")
    }


}

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
