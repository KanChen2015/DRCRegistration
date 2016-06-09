//
//  DRRSignUpStep2.swift
//  DRCRegistrationKit
//
//  Created by Kan Chen on 6/8/16.
//  Copyright © 2016 drchrono. All rights reserved.
//

import UIKit

class DRRSignUpStep2: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var stateTextField: CustomTextField!
    @IBOutlet weak var specialtyTextField: CustomTextField!
    @IBOutlet weak var jobTitleTextField: CustomTextField!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var viewModel: DRRSignUpViewModel!
    private let popoverTableController = UITableViewController(style: .Plain)
    private let step3SegueId = "gotoStepThree"
    enum SelectionScope {
        case State
        case Specialty
        case JobTitle
        case None
    }
    var currentEditingScope: SelectionScope = .None
    override func viewDidLoad() {
        super.viewDidLoad()
        inputContainerView.addBorderForInputContainerStyle()
        popoverTableController.tableView.delegate = self
        popoverTableController.tableView.dataSource = self
        popoverTableController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        popoverTableController.modalPresentationStyle = .Popover
        popoverTableController.preferredContentSize = CGSize(width: 300, height: 450)

    }

    @IBAction func nextButtonClicked(sender: AnyObject) {
        var parameters: [String: AnyObject] = [:]
        parameters[kDRRSignupStateKey] = stateTextField.text
        parameters[kDRRSignupSpecialtyKey] = specialtyTextField.text
        parameters[kDRRSignupJobTitleKey] = jobTitleTextField.text
        spinner.startAnimating()
        viewModel.signupStep2WithInfo(parameters) { (success, errorMsg) in
            dispatch_async(dispatch_get_main_queue()) {
                self.spinner.stopAnimating()
                if success {
                    self.performSegueWithIdentifier(self.step3SegueId, sender: self)
                } else {
                    let alert = UIAlertController(title: nil, message: errorMsg, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: false, completion: nil)
                }
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        view.endEditing(true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == step3SegueId {
            (segue.destinationViewController as? DRRSignUpStep3)?.viewModel = viewModel
        }
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        switch textField {
        case stateTextField: currentEditingScope = .State
        case specialtyTextField: currentEditingScope = .Specialty
        case jobTitleTextField: currentEditingScope = .JobTitle
        default: return true
        }
        popoverTableController.popoverPresentationController?.delegate = self
        popoverTableController.popoverPresentationController?.permittedArrowDirections = .Left
        popoverTableController.popoverPresentationController?.sourceView = textField
        let xOrigin: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 150 : 1
        popoverTableController.popoverPresentationController?.sourceRect = CGRect(x: xOrigin, y: textField.bounds.size.height / 2, width: 1, height: 1)
        popoverTableController.tableView.reloadData()
        presentViewController(popoverTableController, animated: false, completion: nil)
        return false
    }

}

extension DRRSignUpStep2: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentEditingScope {
        case .State: return viewModel.stateChoices.count
        case .Specialty: return viewModel.specialtyChoices.count
        case .JobTitle: return viewModel.jobTitleChoices.count
        case .None: return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        switch currentEditingScope {
        case .State: cell.textLabel?.text = viewModel.stateChoices[indexPath.row]
        case .Specialty: cell.textLabel?.text = viewModel.specialtyChoices[indexPath.row]
        case .JobTitle: cell.textLabel?.text = viewModel.jobTitleChoices[indexPath.row]
        case .None: cell.textLabel?.text = nil
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch currentEditingScope {
        case .State: stateTextField.text = viewModel.stateChoices[indexPath.row]
        case .Specialty: specialtyTextField.text = viewModel.specialtyChoices[indexPath.row]
        case .JobTitle: jobTitleTextField.text = viewModel.jobTitleChoices[indexPath.row]
        case .None: return
        }
        popoverTableController.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension DRRSignUpStep2: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
