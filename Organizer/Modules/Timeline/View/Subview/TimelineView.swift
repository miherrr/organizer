//
//  TimelineView.swift
//  Organizer
//
//  Created by mac on 18.08.2018.
//  Copyright © 2018 Mikhail Babushkin. All rights reserved.
//

import UIKit

@IBDesignable
class TimelineView: UIView {
    // MARK: - Public vars
    /**
     Сюда передается массив данных для отображения на таймлайне
    */
    var data: [TimelineModel] = [] {
        didSet {
            lineWidthConstraint.isActive = data.isEmpty
            
            for (index, item) in data.enumerated() {
                addEventToTimeline(model: item, at: index)
            }
        }
    }
    /**
     Вызывается, когда тапаем по событию на таймлайне
    */
    var onSelectEvent: ((_ event: TimelineModel) -> Void)?
    
    // MARK: - Private static vars
    private static let lineHeight: CGFloat = 5
    private static let maxEventWidth: CGFloat = 300
    // события разной длины. Эта константа указывает, сколько точек будет приходиться на час события
    private static let pointPerHout: CGFloat = 10
    
    // MARK: - Private vars
    private let eventsSpacing: CGFloat = 15

    private var lineWidthConstraint: NSLayoutConstraint!
    private var container: UIView!
    private var eventsStackView: UIStackView!
    
    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Private methods
    private func commonInit() {
        addSubviews()
    }
    
    private func addSubviews() {
        container = UIView(frame: .zero)
        addSubview(container.prepareForAutoLayout())
        container.pinEdgesToSuperviewEdges()
        lineWidthConstraint = container.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
        lineWidthConstraint.isActive = true
        
        let grayline = UIView()
        container.addSubview(grayline.prepareForAutoLayout())
        grayline.leadingAnchor ~= leadingAnchor
        grayline.trailingAnchor ~= trailingAnchor
        grayline.bottomAnchor ~= bottomAnchor
        grayline.heightAnchor ~= TimelineView.lineHeight
        grayline.layer.cornerRadius = TimelineView.lineHeight / 2
        grayline.backgroundColor = .lightGray
        
        eventsStackView = UIStackView(frame: .zero)
        container.addSubview(eventsStackView.prepareForAutoLayout())
        eventsStackView.pinEdgesToSuperviewEdges()
        eventsStackView.axis = .horizontal
        eventsStackView.distribution = .equalSpacing
        eventsStackView.spacing = eventsSpacing
    }
    
    private func addEventToTimeline(model: TimelineModel, at index: Int) {
        let eventView = TimelineEventView(data: model)
        eventView.tag = index
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(eventTapped(_:)))
        eventView.addGestureRecognizer(gestureRecognizer)
        eventsStackView.addArrangedSubview(eventView.prepareForAutoLayout())
    }
    
    @objc private func eventTapped(_ sender: UITapGestureRecognizer) {
        guard let index = sender.view?.tag else {
            return
        }
        onSelectEvent?(data[index])
        print("event at index \(index) tapped")
    }
    
    @IBDesignable
    class TimelineEventView: UIView {
        private let data: TimelineModel
        private var durationInHours: Double {
            return data.end.timeIntervalSince(data.start) / 3600.0
        }
        
        init(data: TimelineModel) {
            self.data = data
            super.init(frame: .zero)
            isUserInteractionEnabled = true
            addSubviews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func addSubviews() {
            let label = UILabel()
            addSubview(label.prepareForAutoLayout())
            label.topAnchor ~= topAnchor
            label.leadingAnchor ~= leadingAnchor + 8
            label.trailingAnchor ~= trailingAnchor - 8
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = data.title
            
            let line = UIView()
            addSubview(line.prepareForAutoLayout())
            line.bottomAnchor ~= bottomAnchor
            line.heightAnchor ~= TimelineView.lineHeight
            line.widthAnchor.constraint(lessThanOrEqualToConstant: TimelineView.maxEventWidth).isActive = true
            line.leadingAnchor ~= leadingAnchor
            line.trailingAnchor ~= trailingAnchor
            let desiredWidthConstraint = line.widthAnchor.constraint(equalToConstant: CGFloat(durationInHours) * TimelineView.pointPerHout)
            desiredWidthConstraint.priority = UILayoutPriority(rawValue: 749)
            desiredWidthConstraint.isActive = true
            line.backgroundColor = data.type.color
            line.layer.cornerRadius = TimelineView.lineHeight / 2
            
            line.topAnchor ~= label.bottomAnchor + 8
        }
    }
}
