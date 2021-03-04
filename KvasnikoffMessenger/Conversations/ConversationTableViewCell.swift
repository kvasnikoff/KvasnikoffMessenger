//
//  ConversationTableViewCell.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 03.03.2021.
//

import UIKit

//TODO:  сортировка массива по датам, вставить аватарки

protocol conversationCellConfiguration {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}

class ConversationTableViewCell: UITableViewCell {
    
    struct conversationCellModel: conversationCellConfiguration {
        var name: String?
        var message: String?
        var date: Date?
        var online: Bool
        var hasUnreadMessages: Bool
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.text = ""
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .darkGray
        label.text = ""
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.text = ""
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let contentViewWidth = contentView.bounds.size.width
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(messageLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal) //лейбл со временем всегда показывается полностью, лейбл с именем идет до лебла со временем, а потом троеточие
        
            NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            
            
            timeLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            
            messageLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 6),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -12),
        ])
        
        let nameLabelFont = contentViewWidth/19
        let timeLabelFontSize = contentViewWidth/20
        let messageLabelFontSize = contentViewWidth/21
        
        nameLabel.font = .boldSystemFont(ofSize: nameLabelFont)
        timeLabel.font = .systemFont(ofSize: timeLabelFontSize)
        messageLabel.font = .systemFont(ofSize: messageLabelFontSize)
        
        accessoryType = .disclosureIndicator
    }
    
    func stringFromDate(date: Date) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        var dateString = ""
        
        if calendar.isDateInToday(date) == true {
            dateFormatter.dateFormat = "HH:mm"
            dateString = dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "dd MMM"
            dateString = dateFormatter.string(from: date)
        }
        return dateString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configure(with model: conversationCellModel) {
        nameLabel.text = model.name ?? "Unknown Name (Nil)"
        
        if let date = model.date {
            timeLabel.text = stringFromDate(date: date)
        } else { // везде прописал обратные else, а то без них reusable ячейки неправильно работают
            timeLabel.text = ""
        }
    
        let contentViewWidth = contentView.bounds.size.width
        
        if model.message == nil {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "AmericanTypewriter-CondensedLight", size: contentViewWidth/21)
        } else {
            messageLabel.text = model.message
            messageLabel.font = .systemFont(ofSize: contentViewWidth/21)
        }
        
        if model.online == true {
            contentView.superview?.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 173/255.0, alpha: 1)
        } else {
            contentView.superview?.backgroundColor = .white
        }
        
        if model.hasUnreadMessages == true {
            messageLabel.font = .boldSystemFont(ofSize: contentViewWidth/21)
            messageLabel.textColor = .black
        } else {
            messageLabel.textColor = .darkGray
        }
        

        

    }

}
