//
//  LunchappApp.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 11/11/25.
//

import SwiftUI

@main
struct ListonicApp: App {
    @StateObject private var storage = StorageService.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storage)
                .onAppear {
                    NotificationService.shared.requestAuthorization()
                }
        }
    }
}

// AppDelegate para manejar notificaciones
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
}

