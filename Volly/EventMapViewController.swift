//
//  EventMapViewController.swift
//  Volly

import UIKit
import MapKit

class EventMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    //index of event in list of events
    var index = 0
    
    //delegate for othervc
    var delegate: UIViewController!
    
    //get list of events from other vc
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: event.eventLatitude, longitude: event.eventLongitude)
        annotation.title = event.name
        mapView.addAnnotation(annotation)
        
        let center = annotation.coordinate
        let NSDistance = 1000.0 //meters
        let EWDistance = 1000.0 //meters
        
        // Specify the region the map should display
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: NSDistance,
                                        longitudinalMeters: EWDistance)
        // commit the region
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = Theme.theme.background
    }
}
