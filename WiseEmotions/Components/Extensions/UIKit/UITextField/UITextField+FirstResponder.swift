//
//  UITextField+FirstResponder.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension Array where Element: UITextField {
    @discardableResult
    func designateAsFirstResponderNext(after current: UITextField) -> Bool {
        guard let index = (self as [UITextField]).firstIndex(of: current), current != last else { return current.resignFirstResponder() }
        return (self as [UITextField])[index + 1].becomeFirstResponder()
    }
    
    func getNextTextField(after current: UITextField) -> UITextField {
        guard let index = (self as [UITextField]).firstIndex(of: current), current != last else { return current }
        return (self as [UITextField])[index + 1]
    }
}
