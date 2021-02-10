//
//  LoaderFooterView.swift
//  HakayaOnline
//
//  Created by Nikita Ozerian on 11.06.2020.
//  Copyright © 2020 Cleveroad Inc. All rights reserved.
//

import UIKit

final class LoaderFooterView: UIView {

    // MARK: - Outlets
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: screenWidth / 2 - defaultLoaderSize.width / 2,
                                                                      y: offset,
                                                                      width: defaultLoaderSize.width,
                                                                      height: defaultLoaderSize.height))
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        return activityIndicator
    }()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: CGRect(x: .zero, y: .zero, width: screenWidth, height: defaultLoaderSize.height + offset * 2))
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        addSubview(activityIndicator)
    }
    
    // MARK: - Helper methods
    
    func setAnimating(_ isAnimating: Bool) {
        DispatchQueue.main.async {
            if isAnimating {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
