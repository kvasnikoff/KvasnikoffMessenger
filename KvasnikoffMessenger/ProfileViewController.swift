//
//  ViewController.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 16.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profilePhoto: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor(red: 228/255.0, green: 230/255.0, blue: 66/255.0, alpha: 1)
//        imageView.layer.masksToBounds = true
        
      //  thumbsup.image = thumbsup.image?.withRenderingMode(.alwaysTemplate)
     //   thumbsup.tintColor = UIColor.gray
        return imageView
    }()
    
    private let firstLetterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.text = "M"
        return label
    }()
    
    private let secondLetterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.text = "D"
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
    

    //я не знаю что делать, если я имплементирую, то в appdelegate когда я настраиваю вьюконтроллер, он просит у меня coder если я вставляю coder: NSCoder(), то случается краш. А уже почти 03:00 :)))
    
 //   print(editButton.frame) /// но вообще по идее если бы я решил проблему, то так как фрейма пока нет, получим nil при принте
    
    
    // На этом этапе еще нет ни самой view, ни его аутлетов, поэтому приложение крашнется
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        printLog(log: "\(#function)")
        print(editButton.frame)
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        
        self.view.backgroundColor = .white
        view.addSubview(profilePhoto)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(editButton)
        view.addSubview(firstLetterLabel)
        view.addSubview(secondLetterLabel)
        
        profilePhoto.frame = CGRect(x: 0, y: 0, width: screenWidth/2.3, height: screenWidth/2.3)
        profilePhoto.layer.cornerRadius = (profilePhoto.frame.size.width) / 2 // circle
        profilePhoto.clipsToBounds = true
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: screenWidth/15)
        
        descriptionLabel.font = .systemFont(ofSize: screenWidth/20)
        
        firstLetterLabel.font = UIFont.boldSystemFont(ofSize: screenWidth/5)
        secondLetterLabel.font = UIFont.boldSystemFont(ofSize: screenWidth/5)
        
        profilePhoto.translatesAutoresizingMaskIntoConstraints = false
        firstLetterLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLetterLabel.translatesAutoresizingMaskIntoConstraints = false
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
            
            firstLetterLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            firstLetterLabel.trailingAnchor.constraint(equalTo: profilePhoto.centerXAnchor, constant: 8), //вообще лучше constant убрать, но я попытался сделать как в примере, чтобы они сливались
            
            secondLetterLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            secondLetterLabel.leadingAnchor.constraint(equalTo: profilePhoto.centerXAnchor, constant: -8), //вообще лучше constant убрать, но я попытался сделать как в примере, чтобы они сливались
            
            

                                        
        ])
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        printLog(log: "\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(editButton.frame) //геометрия во viewDidLoad еще не установлена, поэтому отличается
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

