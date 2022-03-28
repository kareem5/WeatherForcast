//
//  UIImageView+Extensions.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 22/03/2022.
//

import UIKit
import Combine

enum ImageLoadingError: Error {
    case failedParsingToUImage
}
extension UIImageView {

 public func setImage(with url: URL, PlaceHolderImage:UIImage) {

        if self.image == nil{
              self.image = PlaceHolderImage
        }
     
     var subscriptions = Set<AnyCancellable>()
     let publisher =  URLSession.shared.dataTaskPublisher(for: url)
         .subscribe(on: DispatchQueue(label: "downloadingImage"))
         .tryMap({ element -> UIImage in
             guard let image = UIImage(data: element.data) else {
                 throw ImageLoadingError.failedParsingToUImage
             }
             return image
         })
         .eraseToAnyPublisher()
     
     publisher
         .receive(on: DispatchQueue.main)
         .sink { completion in
         if case .failure(let error) = completion {
             print("error: \(error)")
         }
         } receiveValue: { [unowned self] image in
             self.image = image
         }.store(in: &subscriptions)
    }
}
