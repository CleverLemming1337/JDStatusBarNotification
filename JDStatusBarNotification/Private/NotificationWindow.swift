//
//  NotificationWindow.swift
//  JDStatusBarNotification
//
//  Created by Markus on 11/12/23.
//  Copyright © 2023 Markus. All rights reserved.
//

import Foundation

protocol NotificationWindowDelegate: NSObject {
  func didDismissStatusBar()
}

public class NotificationWindow: UIWindow, JDSBNotificationViewControllerDelegate {
  let statusBarViewController: JDSBNotificationViewController
  weak var delegate: NotificationWindowDelegate?

  init(style: StatusBarNotificationStyle,
       windowScene: UIWindowScene?,
       statusBarViewController: JDSBNotificationViewController,
       delegate: NotificationWindowDelegate)
  {
    // attempt to infer window scene
    if windowScene == nil {
      windowScene = UIApplication.shared.jdsb_mainApplicationWindowIgnoringWindow(nil)?.windowScene
    }

    if let windowScene {
      super.init(windowScene: windowScene)
    } else {
      super.init(frame: UIScreen.main.bounds)
    }

    self.delegate = delegate
    let statusBarViewController = JDSBNotificationViewController()
    statusBarViewController.delegate = self
    statusBarViewController.jdsb_window = self
    self.rootViewController = statusBarViewController
    self.statusBarViewController = statusBarViewController

    self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.backgroundColor = .clear
    self.isUserInteractionEnabled = true
    self.windowLevel = .statusBar
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - JDSBNotificationViewControllerDelegate

  func didDismissStatusBar() {
    delegate?.didDismissStatusBar()
  }

  // MARK: - HitTest

  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let topBar = statusBarViewController.statusBarView
    if let topBar, topBar.userInteractionEnabled {
      return topBar.hitTest(convert(point, to: topBar), with: event)
    }
    return nil;
  }
}
