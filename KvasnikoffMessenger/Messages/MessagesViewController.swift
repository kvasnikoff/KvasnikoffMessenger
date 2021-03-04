//
//  MessagesViewController.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 04.03.2021.
//

import UIKit

class MessagesViewController: UIViewController {
    
    struct MessageModel: MessageCellConfiguration {
        var text: String
        var isIncoming: Bool
    }
    
    var messagesArray: [MessageModel] = [MessageModel(text: "Привет!", isIncoming: true), MessageModel(text: "Йо, че как?", isIncoming: false), MessageModel(text: "Это тестовое супер длинное сообщение #1, чтобы протестить длину сообщения, не лагает ли при длинном сообщении длина сообщения", isIncoming: true), MessageModel(text: "Ок, понял", isIncoming: false), MessageModel(text: "Это тестовое супер длинное сообщение #2, чтобы протестить длину сообщения, не лагает ли при длинном сообщении длина сообщения", isIncoming: true), MessageModel(text: "Это тестовое супер длинное сообщение #3, чтобы протестить длину сообщения, не лагает ли при длинном сообщении длина сообщения", isIncoming: false), MessageModel(text: "Это тестовое супер длинное сообщение #4, чтобы протестить длину сообщения, не лагает ли при длинном сообщении длина сообщения", isIncoming: true), MessageModel(text: "Это тестовое супер длинное сообщение #5, чтобы протестить длину сообщения, не лагает ли при длинном сообщении длина сообщения", isIncoming: false)]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        return tableView
    }()
    
    private let cellId = String(describing: MessageTableViewCell.self)
    
    init(chatTitle: String) {
        super.init(nibName: nil, bundle: nil)
        title = chatTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        setupTableView()

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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        let message = messagesArray[indexPath.row].text
        let isIncoming = messagesArray[indexPath.row].isIncoming
        
        cell.configure(with: .init(text: message, isIncoming: isIncoming))
        
        return cell
    
    }
    
    
}
