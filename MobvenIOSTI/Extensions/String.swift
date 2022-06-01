//
//  String.swift
//  MobvenIOSTI
//
//  Created by Rasid Ramazanov on 21.09.2020.
//  Copyright © 2020 Mobven. All rights reserved.
//

import Foundation

extension String {
    
    func formatDate(with format: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        guard let date = dateFormatter.date(from: self) else { return nil }
        
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
}
