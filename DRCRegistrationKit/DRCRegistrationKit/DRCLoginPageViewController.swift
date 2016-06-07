//
//  DRCLoginPageViewController.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/6/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

class DRCLoginPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    weak var loginDelegate: DRCLoginViewControllerDelegate?
    let imageResources = [
        "panel_phone_ipadehr_front",
        "panel_phone_medicalbilling_front",
        "panel_phone_onpatient_front"
    ]
    private var cachedViewController: [UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        for imageResource in imageResources {
            if let page = storyboard?.instantiateViewControllerWithIdentifier("welcomePage") as? DRCWelcomePage {
                page.image = UIImage(named: imageResource,
                                     inBundle: NSBundle(forClass: DRCLoginPageViewController.classForCoder()),
                                     compatibleWithTraitCollection: nil)
                cachedViewController.append(page)
            }
        }
        if let loginController = storyboard?.instantiateViewControllerWithIdentifier("login") as? DRCLoginViewController {
            loginController.delegate = loginDelegate
            cachedViewController.append(loginController)
        }
        let firstViewController = cachedViewController[0]
        setViewControllers([firstViewController], direction: .Forward, animated: false, completion: nil)
        dataSource = self
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    // MARK: - PageViewController DataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = cachedViewController.indexOf(viewController) else { return nil }
        if currentIndex == 0 { return nil }
        return cachedViewController[currentIndex - 1]
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = cachedViewController.indexOf(viewController) else { return nil }
        if currentIndex == cachedViewController.count - 1 { return nil }
        return cachedViewController[currentIndex + 1]
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return cachedViewController.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
