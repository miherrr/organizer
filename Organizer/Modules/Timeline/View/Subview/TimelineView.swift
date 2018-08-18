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
    /**
     Сюда передается массив данных для отображения на таймлайне
    */
    var data: [TimelineViewModel] = [] {
        didSet {
            if !data.isEmpty {
                lineWidthConstraint.isActive = false
                for item in data {
                    addEventToTimeline(model: item)
                }
            }
        }
    }
    /**
     Вызывается, когда тапаем по событию на таймлайне
    */
    var didSelectEvent: ((_ event: TimelineViewModel) -> Void)?
    
    private static let lineHeight: CGFloat = 5
    private static let maxEventWidth: CGFloat = 300
    // события разной длины. Эта константа указывает, сколько точек будет приходиться на час события
    private static let pointPerHout: CGFloat = 10
    private let eventsSpacing: CGFloat = 15
    private var lineWidthConstraint: NSLayoutConstraint!
    private var line: UIView!
    private var eventsStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubviews()
    }
    
    private func addSubviews() {
        line = UIView(frame: .zero)
        addSubview(line.prepareForAutoLayout())
        line.leadingAnchor ~= leadingAnchor
        line.trailingAnchor ~= trailingAnchor
        line.heightAnchor ~= TimelineView.lineHeight
        line.bottomAnchor ~= bottomAnchor
        lineWidthConstraint = line.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 32)
        lineWidthConstraint.isActive = true
        
        line.layer.cornerRadius = TimelineView.lineHeight / 2
        line.backgroundColor = UIColor.lightGray
        line.clipsToBounds = true
        
        eventsStackView = UIStackView(frame: .zero)
        line.addSubview(eventsStackView.prepareForAutoLayout())
        eventsStackView.pinEdgesToSuperviewEdges()
        eventsStackView.axis = .horizontal
        eventsStackView.distribution = .equalSpacing
        eventsStackView.spacing = eventsSpacing
    }
    
    private func addEventToTimeline(model: TimelineViewModel) {
        let eventView = TimelineEventView(data: model, color: .green)
        eventsStackView.addArrangedSubview(eventView)
    }
    
    @IBDesignable
    class TimelineEventView: UIView {
        private let data: TimelineViewModel
        private let fillColor: UIColor
        private var durationInHours: Double {
            return data.end.timeIntervalSince(data.start) / 3600.0
        }
        
        init(data: TimelineViewModel, color: UIColor) {
            self.data = data
            self.fillColor = color
            super.init(frame: .zero)
            addSubviews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func addSubviews() {
            let label = UILabel()
            addSubview(label.prepareForAutoLayout())
            label.topAnchor ~= topAnchor
            label.leadingAnchor ~= leadingAnchor
            label.trailingAnchor ~= trailingAnchor
            label.text = data.title
            
            let line = UIView()
            addSubview(line.prepareForAutoLayout())
            line.heightAnchor ~= TimelineView.lineHeight
            line.widthAnchor.constraint(lessThanOrEqualToConstant: TimelineView.maxEventWidth).isActive = true
            line.leadingAnchor ~= leadingAnchor
            line.trailingAnchor ~= trailingAnchor
            let desiredWidthConstraint = line.widthAnchor.constraint(equalToConstant: CGFloat(durationInHours) * TimelineView.pointPerHout)
            desiredWidthConstraint.priority = UILayoutPriority(rawValue: 751)
            desiredWidthConstraint.isActive = true
            line.backgroundColor = fillColor
            line.layer.cornerRadius = TimelineView.lineHeight / 2
            
            line.topAnchor ~= label.bottomAnchor + 8
        }
    }
}
