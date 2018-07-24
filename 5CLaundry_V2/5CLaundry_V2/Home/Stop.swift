//
//  Stop.swift
//  5CLaundry_V2
//
//  Created by Ethan Hardacre on 5/25/18.
//  Copyright © 2018 Ethan Hardacre. All rights reserved.
//

import UIKit

class Stop: NSObject {
    
    var place = ""
    var start_hour = 0
    var start_min = 0
    var end_hour = 0
    var end_min = 0

    init(place: String, start: String, end: String) {
        self.place = place
        var start_split = start.split(separator: ".")
        var end_split = end.split(separator: ".")
        start_hour = Int(String(start_split[0]))!
        start_min = Int(String(start_split[1]))!
        end_hour = Int(String(end_split[0]))!
        end_min = Int(String(end_split[1]))!
    }
    
    func get_start_hour() -> Int {
        return start_hour
    }
    
    func get_start_min() -> Int {
        return start_min
    }
    
    func get_end_hour() -> Int {
        return start_hour
    }
    
    func get_end_min() -> Int {
        return end_min
    }
    
    func compare(hour: Int, min: Int) -> Int{
        if hour == start_hour && hour == end_hour{
            if min < start_min {
                return -1
            }else if min > end_min{
                return 1
            }else{
                return 0
            }
        }else if hour == start_hour && hour != end_hour{
            if min > start_min {
                return 0
            }else{
                return -1
            }
        }else if hour == end_hour && hour != start_hour{
            if min < end_min {
                return 0
            }else{
                return 1
            }
        }else if hour > end_hour {
            return 1
        }
        return -1
    }
    
    
}
