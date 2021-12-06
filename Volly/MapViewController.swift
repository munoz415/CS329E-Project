//
//  MapViewController.swift
//  Volly

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var delegate: UIViewController!
    var eventName: String!
    var hours: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //recognizer to capture user tap on the map
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }

        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: touchMapCoordinate.latitude,
                                                       longitude: touchMapCoordinate.longitude)
        annotation.title = eventName
        mapView.addAnnotation(annotation)
        
        let otherVC = delegate as! AddEventViewController
        otherVC.plusLocation(newLatitude: annotation.coordinate.latitude, newLongitude: annotation.coordinate.longitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = Theme.theme.background
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userLocation = mapView.userLocation
        
        let center = userLocation.location!.coordinate
        let NSDistance = 2000.0 //meters
        let EWDistance = 2000.0 //meters
        
        // Specify the region the map should display
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: NSDistance,
                                        longitudinalMeters: EWDistance)
        // commit the region
        mapView.setRegion(region, animated: true)
    }
}
