//
//  NotificationManager.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 09.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI

struct NotifcationContent {
    var id: String
    var title: String
    var info: String
    
    init(title: String, info: String) {
        self.id = UUID().uuidString
        self.title = title
        self.info = info
    }
}

final class NotificationManager: ObservableObject {
    @Published var notifcations: [NotifcationContent] = []
    let displayTime: TimeInterval = 2
    
    init() {}
    
    func show(title: String, info: String) {
        let notification = NotifcationContent(title: title, info: info)
        notifcations.append(notification)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + displayTime) { [weak self] in
            self?.dismiss(id: notification.id)
        }
    }
    
    func error(_ error: Error) {
        show(title: NVRStrings.error, info: error.localizedDescription)
    }
    
    func dismiss(id: String) {
        notifcations = notifcations.filter { $0.id != id }
    }
}
