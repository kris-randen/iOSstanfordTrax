//
//  EditWaypointViewController.swift
//  Trax
//
//  Created by Kris Rajendren on Oct/4/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import UIKit

class EditWaypointViewController: UIViewController, UITextFieldDelegate
{
    var waypointToEdit: EditableWaypoint? { didSet { updateUI() } }
    
    private func updateUI() {
        nameTextField?.text = waypointToEdit?.name
        infoTextField?.text = waypointToEdit?.info
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        nameTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startListeningToTextFields()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopListeningToTextFields()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        
    }
    
    private func stopListeningToTextFields() {
        if let observer = nameTextFieldObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = infoTextFieldObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private var nameTextFieldObserver: NSObjectProtocol?
    private var infoTextFieldObserver: NSObjectProtocol?
    
    private func startListeningToTextFields() {
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        nameTextFieldObserver = center.addObserver(forName: Notification.Name.UITextFieldTextDidChange, object: nameTextField, queue: queue)
        { notification in
            if let waypoint = self.waypointToEdit {
                waypoint.name = self.nameTextField.text
            }
        }
        
        infoTextFieldObserver = center.addObserver(forName: Notification.Name.UITextFieldTextDidChange, object: infoTextField, queue: queue)
        { notification in
            if let waypoint = self.waypointToEdit {
                waypoint.info = self.infoTextField.text
            }
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField! { didSet { nameTextField.delegate = self } }
    @IBOutlet weak var infoTextField: UITextField! { didSet { infoTextField.delegate = self } }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private struct Constants {
        static let TextChanged = "textChanged:"
    }

}
