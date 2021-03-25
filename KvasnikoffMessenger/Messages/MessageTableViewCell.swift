//
//  MessageTableViewCell.swift
//  KvasnikoffMessenger
//
//  Created by Peter Kvasnikov on 04.03.2021.
//

import UIKit

protocol MessageCellConfiguration {
    var text: String {get set} // в тз стоит Optional, но пустые сообщения же нельзя отправлять
}

class MessageTableViewCell: UITableViewCell {
    
    struct MessageCellModel: MessageCellConfiguration {
        var text: String // пустые сообщения отправлть нельзя, поэтому без nil
        var isIncoming: Bool
    }
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraints: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        let screenWidthSize = UIScreen.main.bounds.size.width
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bubbleView)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: screenWidthSize * 3 / 4 - 16),
            
            bubbleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            bubbleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            bubbleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8),
            bubbleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8)
        ])
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        trailingConstraints = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        
        self.isUserInteractionEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: MessageCellModel) {
        messageLabel.text = model.text
        
        if model.isIncoming {
            bubbleView.backgroundColor = UIColor(red: 232 / 255.0, green: 232 / 255.0, blue: 234 / 255.0, alpha: 1.00)
            messageLabel.textColor = .black
        } else {
            bubbleView.backgroundColor = UIColor(red: 22 / 255.0, green: 133 / 255.0, blue: 247 / 255.0, alpha: 1.00)
            messageLabel.textColor = .white
        }
        
        if model.isIncoming {
          leadingConstraint?.isActive = true
          trailingConstraints?.isActive = false
        } else {
          leadingConstraint?.isActive = false
          trailingConstraints?.isActive = true
        }
    }

}
