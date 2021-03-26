//
//  MessagesViewController.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 04.03.2021.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController {
    
    var channelID: String
    
    struct MessageModel {
        let content: String
        let created: Date
        let senderId: String
        let senderName: String
    }
    
    var messagesArray: [MessageModel] = []
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        return tableView
    }()

    private let cellId = String(describing: MessageTableViewCell.self)

    init(chatTitle: String, channelID: String) {
        self.channelID = channelID
        super.init(nibName: nil, bundle: nil)
        title = chatTitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        setupFirebase()
        setupTableView()

    }
    
    private func setupFirebase() {
        let db = Firestore.firestore()
        let reference = db.collection("channels")
        
        let messageRef = reference.document(channelID).collection("messages")
        
        messageRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let messages = querySnapshot else { return }
                
                for message in messages.documents {
                    let newMessage = MessageModel(content: message["content"] as? String ?? "none",
                                                  created: self.convertTimeStampToDate(stamp: message["created"] as? Timestamp ?? Timestamp()),
                                             senderId: message["senderId"] as? String ?? "none",
                                             senderName: message["senderName"] as? String ?? "none")
                    
                    self.messagesArray.append(newMessage)
                    
                }
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                    print(self.messagesArray)

                    }
            }
            self.tableView.reloadData()
            print(self.messagesArray)
        }
    }
    
    private func convertTimeStampToDate(stamp: Timestamp) -> Date {
        return stamp.dateValue()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }

        let message = messagesArray[indexPath.row].content
        let date = messagesArray[indexPath.row].created
        let senderID = messagesArray[indexPath.row].senderId
        let senderName = messagesArray[indexPath.row].senderName

        cell.configure(with: .init(content: message, created: date, senderId: senderID, senderName: senderName))

        return cell

    }

}
