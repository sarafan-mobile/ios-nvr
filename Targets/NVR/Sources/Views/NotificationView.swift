//
//  NotificationView.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 07.08.2023.
//  Copyright © 2023 Softeam Apps. All rights reserved.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var manager: NotificationManager
    @State private var offsets: [String: CGFloat] = [:]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(manager.notifcations, id: \.id) { notification in
                    HStack {
                        VStack(alignment: .leading, spacing: 7) {
                            Text(notification.title)
                                .font(.montserrat(size: 15, weight: .bold))
                                .foregroundColor(NVRAsset.Assets.dark.swiftUIColor)
                            Text(notification.info)
                                .font(.montserrat(size: 14, weight: .medium))
                                .foregroundColor(NVRAsset.Assets.rose.swiftUIColor)
                        }
                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient.light)
                    )
                    .shadow(color: .black.opacity(0.16), radius: 3.5, x: 0, y: 4)
                    .offset(x: offsets[notification.id] ?? 0)
                    
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let translation = gesture.translation.width
                                offsets[notification.id] = translation
                            }
                            .onEnded { gesture in
                                guard let offset = offsets[notification.id] else { return }
                                if abs(offset) > (geometry.size.width / 3) {
                                    manager.dismiss(id: notification.id)
                                } else {
                                    offsets[notification.id] = nil
                                }
                            }
                    )
                    
                    .transition(.move(edge: .top))
                    .animation(.default)
                }
                Spacer()
            }.padding(.horizontal, 16)
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
            .environmentObject(PreviewManagers.notifications)
    }
}
