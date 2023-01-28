//
//  SceneDelegate.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 06.12.2022.
//

import UIKit
import WidgetKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let navigationController = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        WidgetCenter.shared.reloadAllTimelines()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let navigationController = window?.rootViewController as? UINavigationController
        guard let urlString = URLContexts.first?.url.absoluteString else { return }
        guard let index = Int(urlString) else { return }
        let indexPath = IndexPath(row: index, section: 1)
        if let mainVC = navigationController?.topViewController as? MainViewController {
            mainVC.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            mainVC.router?.routeToDetailsVC()
        } else if let detailsVC = navigationController?.topViewController as? DetailsViewController {
            if detailsVC.router?.dataStore?.weather?.id != index {
                navigationController?.popToRootViewController(animated: false)
                guard let mainVC = navigationController?.topViewController as? MainViewController else { return }
                mainVC.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                mainVC.router?.routeToDetailsVC()
            }
        }
    }
}

