//
//  ViewController.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 16.02.2021.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let profilePhoto: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor(red: 228 / 255.0, green: 230 / 255.0, blue: 66 / 255.0, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let initialsPhotoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.text = "MD"
        return label
    }()
    
    //    private let nameLabel: UILabel = {
    //        let label = UILabel()
    //        label.textAlignment = .natural
    //        label.text = "Marina Dudarenko"
    //        return label
    //    }()
    //
    //    private let descriptionLabel: UILabel = {
    //        let label = UILabel()
    //        label.textAlignment = .center
    //        label.text = "UX/UI designer, web designer \n Moscow, Russia"
    //        label.numberOfLines = 0
    //        return label
    //    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 246 / 255.0, green: 246 / 255.0, blue: 246 / 255.0, alpha: 1)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 246 / 255.0, green: 246 / 255.0, blue: 246 / 255.0, alpha: 1)
        button.setTitle("Cencel", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let saveGCDButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 246 / 255.0, green: 246 / 255.0, blue: 246 / 255.0, alpha: 1)
        button.setTitle("Save GCD", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let saveOperationsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 246 / 255.0, green: 246 / 255.0, blue: 246 / 255.0, alpha: 1)
        button.setTitle("Save Operations", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no
        tf.placeholder = "Name"
        return tf
    }()
    
    let descriptionTextField: UITextField = { // поменять на  UITextView
        let tf = UITextField()
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocorrectionType = .no
        tf.placeholder = "Bio"
        return tf
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var GCD = GCDDataManager(vc: self)
    lazy var Operation = OperationDataManager(vc: self)
    
    private var isGCD = false
    private var isEdit = false
    
    var nameString = ""
    var descriptionString = ""
    var image = UIImage()
    
    init() {
        print("Init before super.init: \(editButton.frame)") // nil нету, все ок
        super.init(nibName: nil, bundle: nil)
        print("Init after super.init: \(editButton.frame)") // nil нету, все ок
        
    }
    
    required init?(coder: NSCoder) {
        print("Required Init: \(editButton.frame)") // не вызывается
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printLog(log: "\(#function)")
        print("viewDidLoad before SetupUI: \(editButton.frame)") // размеры не рассчитались
        setupUI()
    }
    
    private func setupUI() {
        
        title = "My Profile"
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        
        self.view.backgroundColor = .white
        view.addSubview(profilePhoto)
        view.addSubview(nameTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(initialsPhotoLabel)
        
        let rightButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = rightButton
        //   self.navigationItem.prefersLargeTitles = true // разобраться с несимметричной rightbarbutton
        
        profilePhoto.frame = CGRect(x: 0, y: 0, width: screenWidth / 2.3, height: screenWidth / 2.3)
        profilePhoto.layer.cornerRadius = (profilePhoto.frame.size.width) / 2 // circle
        profilePhoto.clipsToBounds = true
        
        // nameLabel.font = UIFont.boldSystemFont(ofSize: screenWidth/15)
        
        //   descriptionLabel.font = .systemFont(ofSize: screenWidth/20)
        
        initialsPhotoLabel.font = UIFont.boldSystemFont(ofSize: screenWidth / 5)
        
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        initialsPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            profilePhoto.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            profilePhoto.widthAnchor.constraint(equalToConstant: screenWidth / 2.3),
            profilePhoto.heightAnchor.constraint(equalToConstant: screenWidth / 2.3),
            
            nameTextField.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: screenWidth / 1.2),
            
            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            descriptionTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            descriptionTextField.widthAnchor.constraint(equalToConstant: screenWidth / 1.2),
            
            initialsPhotoLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            initialsPhotoLabel.centerXAnchor.constraint(equalTo: profilePhoto.centerXAnchor)
            
        ])
        
        setupEditButton()
        
        profilePhoto.isUserInteractionEnabled = true
        let profilePhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profilePhotoTapped))
        profilePhoto.addGestureRecognizer(profilePhotoTapGestureRecognizer)
        
        //    GCD.read()
        Operation.read()
    }
    
    private func setupEditButton() {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        view.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        editButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: screenWidth / 1.5).isActive = true
        let editButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editButtonTapped))
        editButton.addGestureRecognizer(editButtonTapGestureRecognizer)
    }
    
    private func setupSaveButtons() {
        
        editButton.removeFromSuperview()
        
        let bottomStackView = UIStackView(arrangedSubviews: [saveGCDButton, saveOperationsButton])
        let stackView = UIStackView(arrangedSubviews: [cancelButton, bottomStackView])
        stackView.tag = 100
        bottomStackView.axis = .horizontal
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        bottomStackView.distribution = .fillEqually
        bottomStackView.setCustomSpacing(10, after: saveGCDButton)
        stackView.setCustomSpacing(10, after: cancelButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(greaterThanOrEqualTo: descriptionTextField.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        let cancelTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelActionFunc))
        cancelButton.addGestureRecognizer(cancelTapGestureRecognizer)
        
        let saveGCDTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GCDButtonActionFunc))
        saveGCDButton.addGestureRecognizer(saveGCDTapGestureRecognizer)
        
        let OperationTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OperationButtonActionFunc))
        saveOperationsButton.addGestureRecognizer(OperationTapGestureRecognizer)
    }
    
    @objc func cancelActionFunc() {
        removeSaveButtons()
    }
    
    @objc private func GCDButtonActionFunc() {
        isGCD = true
        buttonBlock()
        GCD.name = nameTextField.text
        GCD.description = descriptionTextField.text
        GCD.image = profilePhoto.image
        GCD.write()
        nameTextField.isUserInteractionEnabled = false
        descriptionTextField.isUserInteractionEnabled = false
        isEdit = false
        GCD.read()
        removeSaveButtons()
    }
    
    @objc private func OperationButtonActionFunc() {
        isGCD = false
        buttonBlock()
        Operation.name = nameTextField.text
        Operation.description = descriptionTextField.text
        Operation.image = profilePhoto.image
        activityIndicator.removeFromSuperview()
        Operation.write()
        nameTextField.isUserInteractionEnabled = false
        descriptionTextField.isUserInteractionEnabled = false
        isEdit = false
        Operation.read()
        removeSaveButtons()
    }
    
    private func removeSaveButtons() {
        if let stackView = view.viewWithTag(100) {
            stackView.removeFromSuperview()
        }
        setupEditButton()
    }
    
    @objc private func rightBarButtonTapped () {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func profilePhotoTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: UIAlertAction.Style.default, handler: { (_: UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        actionSheet.pruneNegativeWidthConstraints() // устраняем ошибку Apple с констрейнтой в AlertViewController
        
        self.present(actionSheet, animated: true, completion: nil)
        setupSaveButtons()
    }
    
    @objc private func editButtonTapped() {
        setupSaveButtons()
        
        nameTextField.isUserInteractionEnabled = true
        descriptionTextField.isUserInteractionEnabled = true
        nameTextField.becomeFirstResponder()
        isEdit = true
        
    }
    
    func setupActivityIndicator() {
        let screenWidthSize = UIScreen.main.bounds.size.width
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidthSize / 2).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    func buttonBlock() {
        saveGCDButton.isUserInteractionEnabled = false
        saveOperationsButton.isUserInteractionEnabled = false
        saveGCDButton.isHighlighted = true
        saveOperationsButton.isHighlighted = true
    }
    
    func buttonUnblock() {
        saveGCDButton.isUserInteractionEnabled = true
        saveOperationsButton.isUserInteractionEnabled = true
        saveGCDButton.isHighlighted = false
        saveOperationsButton.isHighlighted = false
    }
    
    private func camera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("No camera found")
            return
        }
        
        myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    private func photoLibrary() {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        
        profilePhoto.image = selectedImage
        initialsPhotoLabel.isHidden = true
        checkEditing()
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        descriptionTextField.resignFirstResponder()
        checkEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        checkEditing()
        return true
    }
    
    func checkEditing() {
        
        guard let name = nameTextField.text,
              let description = descriptionTextField.text,
              let imag = profilePhoto.image else { return }
        
        if isEdit == true, nameString == name, descriptionString == description, image == imag {
            buttonBlock()
            print(1)
            print(nameString)
            print(image)
            print(imag)
        } else if isEdit == true {
            print(2)
            buttonUnblock()
        } else {
            print(3)
            buttonBlock()
        }
    }
    
    func alertOK() {
        let alert = UIAlertController(title: "Данные сохранены", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        checkEditing()
    }
    
    func alertError() {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let repeatAction = UIAlertAction(title: "Повторить", style: .default, handler: { _ in
            if self.isGCD {
                self.GCDButtonActionFunc()
                self.checkEditing()
            } else {
                self.OperationButtonActionFunc()
                self.checkEditing()
            }
        })
        alert.addAction(cancelAction)
        alert.addAction(repeatAction)
        present(alert, animated: true, completion: nil)
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
