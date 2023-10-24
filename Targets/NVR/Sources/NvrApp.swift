import SwiftUI
import AppsFlyerLib
import AppTrackingTransparency

@main
struct NvrApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
    @StateObject var purchase: PurchaseManager = .init()
    @StateObject var questions: PacksManager = .init()
    @StateObject var notifications: NotificationManager = .init()
    @StateObject var stories: StorySDKManager = .init()
    
    @State private var showingPaywall = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Rectangle().fill(Gradient.rose)
                    .ignoresSafeArea()
                PacksScreen()
                    .overlay { NotificationView() }
                    .opacity(needsAppOnboarding ? 0.0 : 1.0 )
                    .fullScreenCover(isPresented: $needsAppOnboarding) {
                        StoriesScreen(isOnboarding: true).onDisappear {
                            needsAppOnboarding = false
                            showingPaywall.toggle()
                        }
                    }
                    .environmentObject(purchase)
                    .environmentObject(questions)
                    .environmentObject(notifications)
                    .environmentObject(stories)
                    .environment(\.colorScheme, .dark)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                        AppsFlyerLib.shared().start()
                        
                        if !needsAppOnboarding {
                            ATTrackingManager.requestTrackingAuthorization { _ in }
                        }
                    }
                    .fullScreenCover(isPresented: $showingPaywall) {
                        PaywallScreen()
                            .environmentObject(purchase)
                            .environmentObject(notifications)
                            .onDisappear {
                                ATTrackingManager.requestTrackingAuthorization { _ in }
                            }
                    }
            }
        }
    }
}
