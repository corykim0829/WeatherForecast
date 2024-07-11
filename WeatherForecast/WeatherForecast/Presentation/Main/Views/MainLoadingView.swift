//
//  MainLoadingView.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import UIKit
import SnapKit

final class MainLoadingView: UIView {
  
  lazy var indicatorView: UIActivityIndicatorView = {
    let indicatorView = UIActivityIndicatorView(style: .large)
    indicatorView.color = .white
    indicatorView.startAnimating()
    return indicatorView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    configure()
  }
  
}

extension MainLoadingView {
  private func configure() {
    backgroundColor = .clear
    layout()
  }
  
  private func layout() {
    addSubview(indicatorView)
    indicatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
