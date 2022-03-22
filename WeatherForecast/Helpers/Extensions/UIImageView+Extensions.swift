//
//  UIImageView+Extensions.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 22/03/2022.
//

import UIKit

extension UIImageView {

 public func setImage(with url: URL, PlaceHolderImage:UIImage) {

        if self.image == nil{
              self.image = PlaceHolderImage
        }

        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error ?? "Failed loading image from url")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()
    }
}
