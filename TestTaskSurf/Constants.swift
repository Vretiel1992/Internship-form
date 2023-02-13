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
        static let sendRequest = "Отправить заявку"
        static let internshipInSurf = "Стажировка в Surf"
        static let workOnRealTasks = "Работай над реальными задачами под руководством опытного наставника и получи возможность стать частью команды мечты. "
        static let getAScholarship = "Получай стипендию, выстраивай удобный график, работай на современном железе. "
        static let doYouWantToJoinUs = "Хочешь к нам?"
        static let empty = ""
        static let directionCell = "directionCell"
        static let sectionHeader = "sectionHeader"
    }

    enum Fonts {
        static let SFProDisplay14Regular = UIFont(name: "SFProDisplay-Regular", size: 14) ?? .systemFont(ofSize: 14)
        static let SFProDisplay14Medium = UIFont(name: "SFProDisplay-Medium", size: 14) ?? .systemFont(ofSize: 14)
        static let SFProDisplay16Medium = UIFont(name: "SFProDisplay-Medium", size: 16) ?? .systemFont(ofSize: 16)
        static let SFProDisplay24Bold = UIFont(name: "SFProDisplay-Bold", size: 24) ?? .systemFont(ofSize: 24)
    }

    enum Images {
        static let mainImage = UIImage(named: "mainBackgroundImage")
    }
}
