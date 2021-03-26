//
//  ConversationsListViewController.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 03.03.2021.
//

import UIKit
import Firebase



class ConversationsListViewController: UIViewController {
    
    struct Channel {
        let identifier: String
        let name: String
        let lastMessage: String?
        let lastActivity: Date?
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        return tableView
    }()
    
    private let cellId = String(describing: ConversationTableViewCell.self)
    
    var channels = [Channel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirebase()
        setupNavigationBar()
        setupTableView()
        setupUI()
    }
    
    private func setupFirebase() {
        var db = Firestore.firestore()
        var reference = db.collection("channels")
        
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No documents")
                return
            }
 //           print(documents[0].data())
            self?.channels = documents.map { (queryDocumentSnapshot) -> Channel in
                let data = queryDocumentSnapshot.data()
                
                let identifier = queryDocumentSnapshot.documentID
                let name = data["name"]  as? String ?? ""
                let lastMessage = data["lastMessage"] as? String ?? ""
                let activityTS = data["lastActivity"] as? Timestamp ?? nil
                

                let activity = activityTS?.dateValue() ?? nil
                
                DispatchQueue.main.async{
                    var sortedChannels  = self?.channels.sorted(by: { ($0.lastActivity ?? .distantFuture) > ($1.lastActivity ?? .distantFuture) })
                    if let sortedChannels = sortedChannels {
                        self?.channels = sortedChannels
                    }
                    
                    self?.tableView.reloadData()
//                    print(self?.channels)
                }

                
                return Channel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: activity)
                

            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 80
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: cellId)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Channels"
        var rightButton = UIBarButtonItem()
        if #available(iOS 13.0, *) {
            rightButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        } else {
            rightButton = UIBarButtonItem(image: UIImage(named: "profileIcon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        }
        let newChannelBurButton = UIBarButtonItem(image: UIImage(named: "newMessageIcon"), style: .plain, target: self, action: #selector(newChannelButtonCLicked))
        navigationItem.rightBarButtonItems = [newChannelBurButton, rightButton]
    }
    
    @objc func newChannelButtonCLicked() {
        
        let alertTitle = "Create Channel"
        let alertMessage = "Enter a channel name below."
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addTextField { textField in textField.placeholder = "Name" }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
            if let textFields = alert.textFields, let channelNameTextField = textFields.first {
                if let channelName = channelNameTextField.text, channelName.hasValue { // проверяем на пустую, TODO: добавить отключение кнопки и предупреждение
                    let db = Firestore.firestore()
                    let reference = db.collection("channels")
                    reference.addDocument(data: ["name": channelName])
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        
        present(alert, animated: true)
    }
    
    @objc private func rightBarButtonTapped () {
        let vc = ProfileViewController()
        let navVC = UINavigationController(rootViewController: vc)
        show(navVC, sender: nil)
    }
   
    private func setupUI() {
        self.view.backgroundColor = .white
    }
    
}

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = channels[indexPath.row].name
        let lastMessage = channels[indexPath.row].lastMessage
        let lastActivity = channels[indexPath.row].lastActivity
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: .init(name: name, lastMessage: lastMessage, lastActivity: lastActivity))
        
        tableView.rowHeight = cell.contentView.bounds.size.width / 3.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = channels[indexPath.row].name ?? "Unknown Name (Nil)"
        let channelID = channels[indexPath.row].identifier
            navigationController?.pushViewController(MessagesViewController(chatTitle: name, channelID: channelID), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}


extension String {

    var hasValue: Bool {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedString.isEmpty {
            return false
        } else {
            return true
        }
    }

}
