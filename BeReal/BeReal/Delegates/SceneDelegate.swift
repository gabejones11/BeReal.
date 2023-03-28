//
//  SceneDelegate.swift
//  BeReal
//
//  Created by Gabe Jones on 3/23/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let loginViewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginViewController)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(forName: Notification.Name("login"), object: nil, queue: OperationQueue.main) {[weak self] _ in
            self?.login()
        }
    
    
        NotificationCenter.default.addObserver(forName: Notification.Name("logout"), object: nil, queue: OperationQueue.main) {[weak self] _ in
            self?.logOut()
        }
        
        //check if current user exsists for persisted log in
        if User.current != nil {
            login()
        }
    }
    
    private func login(){
        //Send the user to the feedviewcontroller
        let feedViewController = FeedViewController()
        //Wrap the viewcontroller in a navigationcontroller
        let navigationController = UINavigationController(rootViewController: feedViewController)
        //set the current displayed viewcontroller
        window?.rootViewController = navigationController
    }
    
    private func logOut(){
        //Log out the parse user
        //this will remove the user from the sessions and all future calls will return nill
        User.logout { [weak self] result in
            
            switch result{
            case .success:
                
                //make sure that UI updates are done on main thread when initiad from background thread
                DispatchQueue.main.async {
                    //go back to the login page
                    let loginViewController = LoginViewController()
                    //wrap the view controller in a navigation controller
                    let navigationController = UINavigationController(rootViewController: loginViewController)
                    
                    //set the current displayed view controller
                    self?.window?.rootViewController = navigationController
                }
            case .failure(let error):
                print("Log out error: \(error)")
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

