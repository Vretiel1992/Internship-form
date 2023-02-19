//
//  InternshipSection.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 10.02.2023.
//

import Foundation

struct InternshipSection: Hashable {
    let id: Int
    let title: String
    let subTitle: String
    var items: [Direction]

    static let internshipSections: [InternshipSection] = [
        InternshipSection(
            id: 0,
            title: "Стажировка в Surf",
            subTitle: "Работай над реальными задачами под руководством опытного наставника и получи возможность стать частью команды мечты. ",
            items: [
                Direction(title: "iOS"),
                Direction(title: "Android"),
                Direction(title: "Design"),
                Direction(title: "Flutter"),
                Direction(title: "QA"),
                Direction(title: "PM"),
                Direction(title: "Backend "),
                Direction(title: "Frontend"),
                Direction(title: "ML")
            ]),
        InternshipSection(
            id: 1,
            title: "",
            subTitle: "Получай стипендию, выстраивай удобный график, работай на современном железе. ",
            items: [
                Direction(title: "iOS"),
                Direction(title: "Android"),
                Direction(title: "Design"),
                Direction(title: "Flutter"),
                Direction(title: "QA"),
                Direction(title: "PM"),
                Direction(title: "Backend "),
                Direction(title: "Frontend"),
                Direction(title: "ML")
            ])
    ]
}
