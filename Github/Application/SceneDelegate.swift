//
//  SceneDelegate.swift
//  Github
//
//  Created by Alley Pereira on 23/03/22.
// swiftlint:disable vertical_parameter_alignment

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	let rootController = CustomTabBarController()

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
			     options connectionOptions: UIScene.ConnectionOptions) {

		guard let windowScene = (scene as? UIWindowScene) else { return }
        // MARK: Study and try to understand if we can use the window property rather than the config below
        let window = UIWindow(windowScene: windowScene)
		window.rootViewController = rootController
		window.makeKeyAndVisible()
		self.window = window
	}

	func sceneDidDisconnect(_ scene: UIScene) {}

	func sceneDidBecomeActive(_ scene: UIScene) {}

	func sceneWillResignActive(_ scene: UIScene) {}

	func sceneWillEnterForeground(_ scene: UIScene) {}

	func sceneDidEnterBackground(_ scene: UIScene) {

		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}
}