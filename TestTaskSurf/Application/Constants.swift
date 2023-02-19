//
//  Constants.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 10.02.2023.
//

import UIKit

enum Constants {
    enum Colors {
        static let darkColor = #colorLiteral(red: 0.2511924207, green: 0.2511924207, blue: 0.2511924207, alpha: 1)
        static let lightGrayColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
        static let grayColor = #colorLiteral(red: 0.5882352941, green: 0.5843137255, blue: 0.6078431373, alpha: 1)
    }

    enum Text {
        static let firstSectionHeaderTitle = "Стажировка в Surf"
        static let firstSectionHeaderSubtitle = "Работай над реальными задачами под руководством опытного наставника и получи возможность стать частью команды мечты. "
        static let secondSectionHeaderSubtitle = "Получай стипендию, выстраивай удобный график, работай на современном железе. "
        static let bottomLabelTitle = "Хочешь к нам?"
        static let bottomButtonTitle = "Отправить заявку"
        static let empty = ""
        static let directionCellIdentifier = "directionCell"
        static let sectionHeaderIdentifier = "sectionHeader"
        static let alertTitle = "Поздравляем!"
        static let alertMessage = "Ваша заявка успешно отправлена!"
        static let alertClose = "Закрыть"
    }

    enum Fonts {
        static let SFProDisplay14Regular = UIFont(name: "SFProDisplay-Regular", size: 14) ?? .systemFont(ofSize: 14)
        static let SFProDisplay14Medium = UIFont(name: "SFProDisplay-Medium", size: 14) ?? .systemFont(ofSize: 14)
        static let SFProDisplay16Medium = UIFont(name: "SFProDisplay-Medium", size: 16) ?? .systemFont(ofSize: 16)
        static let SFProDisplay24Bold = UIFont(name: "SFProDisplay-Bold", size: 24) ?? .systemFont(ofSize: 24)
    }

    enum Images {
        static let mainBackgroundImage = UIImage(named: "mainBackgroundImage")
    }

    enum Layout {
        static let titleLabelItemLeftAndRight: CGFloat = 24
        static let titleLabelItemTopAndBot: CGFloat = 12
        static let aspectRatioToHeight: CGFloat = 1.6373
        static let bottomMainViewHeight: CGFloat = 510
        static let collectionViewHeight: CGFloat = 336
        static let collectionViewLeftAndRight: CGFloat = 20
        static let collectionViewTop: CGFloat = 24
        static let bottomStackViewHeight: CGFloat = 60
        static let bottomStackViewLeftAndRight: CGFloat = 20
        static let bottomStackViewBot: CGFloat = 58
        static let bottomLabelWidth: CGFloat = 92
        static let bottomButtonWidth: CGFloat = 219
        static let interSpacing: CGFloat = 12
        static let itemWidth: CGFloat = 70
        static let itemHeight: CGFloat = 1
        static let firstSectionGroupWidth: CGFloat = 630
        static let firstSectionGroupHeight: CGFloat = 44
        static let secondSectionGroupWidth: CGFloat = 400
        static let secondSectionGroupHeight: CGFloat = 44
        static let secondSectionNestedGroupWidth: CGFloat = 400
        static let secondSectionNestedGroupHeight: CGFloat = 100
        static let headerWidth: CGFloat = 1
        static let headerHeight: CGFloat = 104
    }

    enum EdgeInsets {
        static let firstSection = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
        static let secondSection = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0)
    }
}
