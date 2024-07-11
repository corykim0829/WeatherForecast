//
//  SearchViewModel.swift
//  WeatherForecast
//
//  Created by Cory Kim on 7/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

final class SearchViewModel {
  
  let fetchCityListUseCase: FetchCityListUseCase
  
  var cities = BehaviorRelay<[City]>(value: [])
  
  init(fetchCityListUseCase: FetchCityListUseCase = FetchCityListUseCase()) {
    self.fetchCityListUseCase = fetchCityListUseCase
    
    let cities = self.fetchCityListUseCase.fetchCityList()
    self.cities.accept(cities)
  }
  
}
