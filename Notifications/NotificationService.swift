//
//  NotificationService.swift
//  Notifications
//
//  Created by cedcoss on 04/12/17.
//  Copyright © 2017 MageNative. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            if let notificationData = request.content.userInfo["data"] as? [String: Any] {
                // Grab the attachment
                if let urlString = notificationData["attachment-url"] as? String, let fileUrl = URL(string: urlString) {
                    // Download the attachment
                    URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                        if let location = location {
                            // Move temporary file to remove .tmp extension
                            let tmpDirectory = NSTemporaryDirectory()
                            let tmpFile = "file://".appending(tmpDirectory).appending(fileUrl.lastPathComponent)
                            let tmpUrl = URL(string: tmpFile)!
                            try! FileManager.default.moveItem(at: location, to: tmpUrl)
                            
                            // Add the attachment to the notification content
                            if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                                //self.bestAttemptContent?.title = urlString
                                bestAttemptContent.attachments = [attachment]
                                contentHandler(self.bestAttemptContent!)
                            }
                        }
                        // Serve the notification content
                        //self.contentHandler!(self.bestAttemptContent!)
                        }.resume()
                }
            }
            
        }
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
