//
//  UILabel+.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 11.02.2023.
//

import UIKit

extension UILabel {
    func setupConfigure(
        title: String,
        lineHeightMultiple: CGFloat,
        maximumLineHeight: CGFloat,
        lineBreakMode: NSLineBreakMode,
        alignment: NSTextAlignment,
        numberOfLines: Int,
        font: UIFont,
        textColor: UIColor) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
            paragraphStyle.maximumLineHeight = maximumLineHeight
            paragraphStyle.lineBreakMode = lineBreakMode
            paragraphStyle.alignment = alignment
            self.numberOfLines = numberOfLines
            self.font = font
            self.textColor = textColor
            self.attributedText = NSAttributedString(
                string: title,
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ])
        }
}
