//
//  MainMapView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/10/24.
//

import UIKit
import MapKit
import SnapKit

final class MainMapView: UIView {
  
  enum Metric {
    enum ContainerView {
      static let topBottom: CGFloat = 8
      static let leadingTrailing: CGFloat = 16
    }
  }
  
  lazy var containerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12
    view.clipsToBounds = true
    view.backgroundColor = .darkGray
    return view
  }()
  
  private let defaultCity = City(name: "Asan", country: "KR", coord: .init(lat: 36.783611, lon: 127.004173))
  
  lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    let coords = CLLocationCoordinate2D(latitude: defaultCity.coord.lat, longitude: defaultCity.coord.lon)
    let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    let region = MKCoordinateRegion(center: coords, span: span)
    mapView.setRegion(region, animated: false)
    mapView.layer.cornerRadius = 4
    return mapView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
  func update(city: City) {
    let cityCoordinate = CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon)
    
    removeAllAnnotation()
    addCityAnnotation(coordinate: cityCoordinate)
    moveTo(coordinate: cityCoordinate)
  }
  
  private func removeAllAnnotation() {
    let allAnnotations = mapView.annotations
    mapView.removeAnnotations(allAnnotations)
  }
  
  private func addCityAnnotation(coordinate: CLLocationCoordinate2D) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    mapView.addAnnotation(annotation)
  }
  
  private func moveTo(coordinate: CLLocationCoordinate2D) {
    let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    mapView.setRegion(region, animated: false)
  }
  
}

extension MainMapView {
  private func configure() {
    layout()
    
    update(city: defaultCity)
  }
  
  private func layout() {
    addSubview(containerView)
    containerView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(Metric.ContainerView.topBottom)
      $0.leading.trailing.equalToSuperview().inset(Metric.ContainerView.leadingTrailing)
    }
    
    containerView.addSubview(mapView)
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(12)
      $0.height.equalTo(mapView.snp.width)
    }
  }
  
}
