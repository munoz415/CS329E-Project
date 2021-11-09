//
//  MapViewController.swift
//  Volly
//
//  Created by Michael on 11/8/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.showsUserLocation = true
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
        
        // add annotiation of current location to map
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                                       longitude: userLocation.coordinate.longitude)
        annotation.title = "" // name of event
        annotation.subtitle = "" // number of hours
        mapView.addAnnotation(annotation)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
