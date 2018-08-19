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
    private let eventsSpacing: CGFloat = 15
    // события разной длины. Эта константа указывает, сколько точек будет приходиться на час события
    private static let pointPerHout: CGFloat = 10
    
    // MARK: - Private vars
    private var selectedEventId: Int?
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
        grayline.trailingAnchor ~= trailingAnchor;
        // TODO: - такая магическая установка позиции - нехорошо. Надо исправить и получать позицию цветовой полосы динамически.
        grayline.bottomAnchor ~= centerYAnchor + 17.6
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
        select(eventId: data[index].id)
    }
    
    // MARK: - Public methods
    func select(eventId: Int) {
        //делаем unselect старого
        if let currentSelectedId = selectedEventId,
            let currentIndex = data.index(where: { item -> Bool in item.id == currentSelectedId }),
            let eventView = eventsStackView.arrangedSubviews[currentIndex] as? TimelineEventView {
            eventView.select(true)
        }
        //выделяем новое
        if let newIndex = data.index(where: { item -> Bool in item.id == eventId }),
            let eventView = eventsStackView.arrangedSubviews[newIndex] as? TimelineEventView {
            eventView.select()
            selectedEventId = eventId
            onSelectEvent?(data[newIndex])
        }
        
    }
    
    @IBDesignable
    class TimelineEventView: UIView {
        private let data: TimelineModel
        private var line: UIView!
        private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            return formatter
        }
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
            let titleLabel = UILabel()
            addSubview(titleLabel.prepareForAutoLayout())
            titleLabel.topAnchor ~= topAnchor
            titleLabel.leadingAnchor ~= leadingAnchor + 8
            titleLabel.trailingAnchor ~= trailingAnchor - 8
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.text = data.title
            titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 740), for: .vertical)
            
            let startDatelabel = UILabel()
            addSubview(startDatelabel.prepareForAutoLayout())
            startDatelabel.bottomAnchor ~= bottomAnchor
            startDatelabel.leadingAnchor ~= leadingAnchor
            startDatelabel.font = UIFont.systemFont(ofSize: 12)
            startDatelabel.text = dateFormatter.string(from: data.start)
            startDatelabel.setContentHuggingPriority(UILayoutPriority(rawValue: 741), for: .vertical)
            
            let endDateLabel = UILabel()
            addSubview(endDateLabel.prepareForAutoLayout())
            endDateLabel.trailingAnchor ~= trailingAnchor
            endDateLabel.topAnchor ~= titleLabel.bottomAnchor + 8
            endDateLabel.font = UIFont.systemFont(ofSize: 12)
            endDateLabel.text = dateFormatter.string(from: data.end)
            endDateLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 742), for: .vertical)
            
            line = UIView()
            addSubview(line.prepareForAutoLayout())
            line.heightAnchor ~= TimelineView.lineHeight
            line.widthAnchor.constraint(lessThanOrEqualToConstant: TimelineView.maxEventWidth).isActive = true
            line.leadingAnchor ~= leadingAnchor
            line.trailingAnchor ~= trailingAnchor
            let desiredWidthConstraint = line.widthAnchor.constraint(equalToConstant: CGFloat(durationInHours) * TimelineView.pointPerHout)
            desiredWidthConstraint.priority = UILayoutPriority(rawValue: 749)
            desiredWidthConstraint.isActive = true
            line.backgroundColor = data.type.color
            line.layer.cornerRadius = TimelineView.lineHeight / 2
            
            line.topAnchor ~= endDateLabel.bottomAnchor + 8
            startDatelabel.topAnchor ~= line.bottomAnchor + 8
        }
        
        func select(_ unselect: Bool = false) {
            let scaleTransform = CGAffineTransform(scaleX: 1, y: 2)
            UIView.animate(withDuration: 0.2, animations: {
                self.line.transform = unselect ? .identity : scaleTransform
            }, completion: nil)
        }
    }
}
