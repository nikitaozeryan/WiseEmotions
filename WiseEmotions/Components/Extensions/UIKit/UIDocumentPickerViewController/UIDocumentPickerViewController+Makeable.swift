//
//  UIDocumentPickerViewController+Makeable.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit
import CoreServices

extension UIDocumentPickerViewController: Makeable {
    static func make() -> UIDocumentPickerViewController {
        UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .open)
    }
}
