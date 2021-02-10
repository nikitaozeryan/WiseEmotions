//
//  ActivityView.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.06.2020.
//

import UIKit

final class ActivityView: UIView {
    
    // MARK: - Views
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
    
    // MARK: - Properties
    
    var isAnimating: Bool {
        get { activityIndicator.isAnimating }
        set { newValue ? activityIndicator.startAnimating() : activityIndicator.stopAnimating() }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    
    private func commonInit() {
        addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.color = .black
        backgroundColor = UIColor.white.withAlphaComponent(0.75)
    }
}
