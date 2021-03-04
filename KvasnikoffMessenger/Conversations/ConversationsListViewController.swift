//
//  ConversationsListViewController.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 03.03.2021.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    struct ConversationModel: conversationCellConfiguration {
        var name: String?
        var message: String?
        var date: Date?
        var online: Bool
        var hasUnreadMessages: Bool
    }
    private var conversationsArray: [ConversationModel] = [ConversationModel(name: "Oleg Tinkoff", message: "А давайте мы купим этот говнояндекс", date: Date(), online: true, hasUnreadMessages: false), ConversationModel(name: "Оливер Хьюз", message: "Олег Тиньков – наш духовный отец, но банком руковожу я", date: Date(), online: true, hasUnreadMessages: true), ConversationModel(name: "Павел Дуров", message: "Только что попробовал iPhone 12 Pro — какой невероятно корявый кусок железа", date: Date(), online: true, hasUnreadMessages: false), ConversationModel(name: "Аркадий Волож", message: nil, date: nil, online: true, hasUnreadMessages: false), ConversationModel(name: "Очень длинный лейбл Очень Очень Очень", message: "И все же я не смещаю timeLabel :)", date: Date(), online: true, hasUnreadMessages: false), ConversationModel(name: nil, message: "Это очень длинное сообщение очень очень длинное очень очень длинное очень очень очень очень", date: Date(), online: true, hasUnreadMessages: true), ConversationModel(name: "Дата не сегодняшняя", message: "И это не страшно", date: Date(timeIntervalSinceNow: -172800.0), online: true, hasUnreadMessages: false), ConversationModel(name: "Сундар Пичаи", message: nil, date: nil, online: true, hasUnreadMessages: false), ConversationModel(name: "Без сообщения и сл-но даты", message: nil, date: nil, online: true, hasUnreadMessages: false), ConversationModel(name: "Craig Federighi", message: "How cool is that?", date: Date(timeIntervalSinceNow: -182800.0), online: true, hasUnreadMessages: true), ConversationModel(name: nil, message: nil, date: nil, online: false, hasUnreadMessages: false), ConversationModel(name: "Сегодняшнее", message: "Время", date: Date(), online: false, hasUnreadMessages: false), ConversationModel(name: "Проверил", message: "С nil сообщением сюда не пропускают", date: Date(), online: false, hasUnreadMessages: false), ConversationModel(name: "Дата", message: "Вчерашняя", date: Date(timeIntervalSinceNow: -86400), online: false, hasUnreadMessages: false), ConversationModel(name: "Есть", message: "Непрочитанное сообщение", date: Date(), online: false, hasUnreadMessages: true), ConversationModel(name: "Нет", message: "Непрочитанного сообщения", date: Date(), online: false, hasUnreadMessages: false), ConversationModel(name: "Есть", message: "Непрочитанное сообщение", date: Date(), online: false, hasUnreadMessages: true), ConversationModel(name: "Нет", message: "Непрочитанного сообщения", date: Date(), online: false, hasUnreadMessages: false), ConversationModel(name: "Есть", message: "Непрочитанное сообщение", date: Date(), online: false, hasUnreadMessages: true), ConversationModel(name: "Нет", message: "Непрочитанного сообщения", date: Date(), online: false, hasUnreadMessages: false), ConversationModel(name: "Есть", message: "Непрочитанное сообщение", date: Date(), online: false, hasUnreadMessages: true)]
    
    private var onlineNowArray: [ConversationModel] = []
    
    private var notEmptAndNotOnlineConversationArray: [ConversationModel] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        return tableView
    }()
    
    private let cellId = String(describing: ConversationTableViewCell.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        onlineNow()
        setupNavigationBar()
        setupTableView()
        setupUI()
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = "Tinkoff Chat"
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func rightBarButtonTapped () {
        present(ProfileViewController(), animated: true, completion: nil)
    }
   
    private func setupUI() {
        self.view.backgroundColor = .white
    }
    
    private func onlineNow () {
        for conversation in conversationsArray {
            if conversation.online == true { onlineNowArray.append(conversation) }
            else if conversation.message != nil { notEmptAndNotOnlineConversationArray.append(conversation) }
        }
    }

}

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Online" }
        else { return "History" } //section == 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onlineNowArray.count
        }
        else { return notEmptAndNotOnlineConversationArray.count } //section == 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var array = [ConversationModel]()
        
        if indexPath.section == 0 {
            array = onlineNowArray
        } else {
            array = notEmptAndNotOnlineConversationArray
        }
        
        let name = array[indexPath.row].name
        let message = array[indexPath.row].message
        let date = array[indexPath.row].date
        let online = array[indexPath.row].online
        let hasUnreadMessages = array[indexPath.row].hasUnreadMessages
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ConversationTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: .init(name: name, message: message, date: date, online: online, hasUnreadMessages: hasUnreadMessages))
        
        tableView.rowHeight = cell.contentView.bounds.size.width / 3.5
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var array = [ConversationModel]()
        
        if indexPath.section == 0 {
            array = onlineNowArray
        } else {
            array = notEmptAndNotOnlineConversationArray
        }
        
        let name = array[indexPath.row].name ?? "Unknown Name (Nil)"
        navigationController?.pushViewController(MessagesViewController(chatTitle: name), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
}
