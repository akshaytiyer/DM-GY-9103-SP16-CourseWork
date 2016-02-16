//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Akshay Iyer on 2/15/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate
{
    
    var mapView: MKMapView!
    
    var counter = 0, flag = 0
    
    var locationManager: CLLocationManager!
    
    override func loadView() {
        //Create a map view
        mapView = MKMapView()
        
        //Set it as *the* view of this view controller
        view = mapView
        
        let segmentedControl
                = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint
            = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        
        let leadingConstraint
            = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint
            = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
    }
    
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }


    override func viewDidLoad() {
           super.viewDidLoad()
           let button   = UIButton(type: UIButtonType.System) as UIButton
           button.frame = CGRectMake(20, 100, 100, 50)
           button.backgroundColor = UIColor.whiteColor()
           button.setTitle("My Location", forState: UIControlState.Normal)
           button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
           let button1   = UIButton(type: UIButtonType.System) as UIButton
           button1.frame = CGRectMake(20, 60, 100, 50)
           button1.backgroundColor = UIColor.whiteColor()
           button1.setTitle("Switch", forState: UIControlState.Normal)
           button1.addTarget(self, action: "switchingAction:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(button)
            self.view.addSubview(button1)
            }
    
    func switchingAction(sender:UIButton!)
    {
        flag = 1
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        print(counter)
        counter = counter+1
    }
    
    func buttonAction(sender:UIButton!)
    {
        flag = 0
        print("Button tapped")
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        print("MapViewController loaded its view.")
        

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        var lattitudevariable: Double, longitudevariable: Double
        if flag == 1
        {
            if counter%3 == 0 {
                lattitudevariable = location.coordinate.latitude
                longitudevariable = location.coordinate.longitude
            }
            else if counter%3 == 1 {
                lattitudevariable = 18.9750
                longitudevariable = 72.8258
            }
            else if counter%3 == 2 {
                lattitudevariable = 51.5072
                longitudevariable = 0.1275
            }
            else
            {
                lattitudevariable = 0
                longitudevariable = 0
            }

        }
        else
        {
          lattitudevariable = location.coordinate.latitude
          longitudevariable = location.coordinate.longitude
        }
        let center = CLLocationCoordinate2D(latitude: lattitudevariable, longitude:longitudevariable)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let homepointer = MKPointAnnotation()
        homepointer.coordinate = center
        homepointer.title = "Home"
        homepointer.subtitle = "My Location"
        self.mapView.addAnnotation(homepointer)
        self.mapView.setRegion(region, animated: true)
    }
}
