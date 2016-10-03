//
//  ViewController.swift
//  Trax
//
//  Created by Kris Rajendren on Oct/2/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class GPXViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //let url = Stanford_Vacation_URL
    
    var gpxURL: NSURL? {
        didSet {
            clearWaypoints()
            if let url = gpxURL {
                GPX.parse(url: url) { gpx in
                    if gpx != nil {
                        self.addWaypoints(waypoints: gpx!.waypoints)
                    }
                }
            }
        }
    }
    
    private func clearWaypoints() {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    private func addWaypoints(waypoints: [GPX.Waypoint]) {
        mapView.addAnnotations(waypoints)
        mapView.showAnnotations(waypoints, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.AnnotationViewReuseIdentifier)
        if let view = view {
            view.annotation = annotation
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.AnnotationViewReuseIdentifier)
            view.canShowCallout = true
        }
        view.leftCalloutAccessoryView = nil
        if let waypoint = annotation as? GPX.Waypoint {
            if waypoint.thumbnailURL != nil {
                view.leftCalloutAccessoryView = UIButton(frame: Constants.LeftCalloutFrame)
            }
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let thumbnailImageButton = view.leftCalloutAccessoryView as? UIButton,
            let url = (view.annotation as? GPX.Waypoint)?.thumbnailURL,
            let imageData = NSData(contentsOf: url as URL), // blocks main queue
            let image = UIImage(data: imageData as Data) {
                thumbnailImageButton.setImage(image, for: .normal)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .satellite
            mapView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gpxURL = NSURL(string: Stanford_Vacation_URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            performSegue(withIdentifier: Constants.ShowImagesSegue, sender: view)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination.contentViewController
        let annotationView = sender as? MKAnnotationView
        let waypoint = annotationView?.annotation as? GPX.Waypoint
        
        if segue.identifier == Constants.ShowImagesSegue {
        
        }
    }
    
    // MARK: Constants
    
    private struct Constants {
        static let LeftCalloutFrame = CGRect(x: 0, y: 0, width: 59, height: 59)
        static let AnnotationViewReuseIdentifier = "waypoint"
        static let ShowImagesSegue = "Show Image"
        static let EditUserWaypoint = "Edit Waypoint"
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}

