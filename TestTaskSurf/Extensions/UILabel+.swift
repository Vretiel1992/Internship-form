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
            self.attributedText = NSMutableAttributedString(
                string: title,
                attributes: [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: textColor,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ])
        }
}
