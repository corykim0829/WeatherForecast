//
//  UIStackView+RemoveAllArrangedSubviews.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import UIKit

extension UIStackView {
  
  func removeAllArrangedSubviews() {
    
    let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
      self.removeArrangedSubview(subview)
      return allSubviews + [subview]
    }
    
    NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
    
    removedSubviews.forEach({ $0.removeFromSuperview() })
  }
}
