//
//  NounsApp.swift
//  Nouns
//
//  Created by Mohammed Ibrahim on 2021-09-28.
//

import SwiftUI
import UIComponents
import Services

struct NounComposerKey: EnvironmentKey {
  static var defaultValue: NounComposer = AppCore.shared.nounComposer
}

extension EnvironmentValues {
  
  // TODO: clean up environment values
  var nounComposer: NounComposer {
    get { self[NounComposerKey.self] }
    set { self[NounComposerKey.self] = newValue }
  }
}

@main
struct NounsApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  private var nounComposer = AppCore.shared.nounComposer
  
  let bottomSheetManager = BottomSheetManager()
  
  init() {
    UIComponents.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      RouterView()
        .environmentObject(bottomSheetManager)
        .environment(\.nounComposer, nounComposer)
        .preferredColorScheme(.light)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    application.registerForRemoteNotifications()
    return true
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    AppCore.shared.messaging.appDidReceiveNotification(userInfo)
    completionHandler(.noData)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    AppCore.shared.messaging.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
  }
}
