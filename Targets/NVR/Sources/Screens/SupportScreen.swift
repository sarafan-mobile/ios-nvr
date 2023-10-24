//
//  SupportScreen.swift
//  NVR
//
//  Created by Aleksei Cherepanov on 14.08.2023.
//  Copyright © 2023 Softeam OOO. All rights reserved.
//

import SwiftUI
import MessageUI
import ApphudSDK

struct SupportScreen: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    static let recipient = Constants.supportEmail
    static let subject = "Support NVR"
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailCompose = MFMailComposeViewController()
        mailCompose.setToRecipients([Self.recipient])
        mailCompose.setSubject(Self.subject)
        mailCompose.setMessageBody(Self.makeBody(), isHTML: false)
        mailCompose.mailComposeDelegate = context.coordinator
        return mailCompose
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // Update the view controller.
    }
    
    private static func makeBody() -> String {
        let dict = Bundle.main.infoDictionary ?? [:]
        let version = dict["CFBundleShortVersionString"] as? String
        let build = dict[kCFBundleVersionKey as String] as? String
        
        return """
        \n\n\n\n
        === Don't Edit ===
        Language: \(Locale.current.identifier)
        Country: \(Locale.current.region?.identifier ?? "UNKNOWN")
        Device: \(deviceIdentifier())
        Device ID: \(UIDevice.current.identifierForVendor!.uuidString)
        App Version: \([version, build].compactMap { $0 }.joined(separator: "-"))
        iOS Version: \(UIDevice.current.systemVersion)
        User ID: \(Apphud.userID())
        """
    }
    
    private static func deviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    static func createEmailUrl() -> URL {
        let subjectEncoded = Self.subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = makeBody().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(recipient)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(recipient)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(recipient)?subject=\(subjectEncoded)&body=\(bodyEncoded)")!
        
        if let gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        return defaultUrl
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: SupportScreen
        
        init(_ parent: SupportScreen) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer { parent.dismiss() }
            
            guard error == nil else {
                parent.result = .failure(error!)
                return
            }
            
            parent.result = .success(result)
        }
    }
}
