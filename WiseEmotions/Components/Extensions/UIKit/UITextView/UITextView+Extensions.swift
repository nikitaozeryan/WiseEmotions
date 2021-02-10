//
//  UITextView+Extensions.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension UITextView {
    func shouldChangeCharacters(in range: NSRange, replacementString string: String, limit: Int) -> Bool {
        (text as NSString?)?.replacingCharacters(in: range, with: string).count ?? 0 < limit
    }
}
