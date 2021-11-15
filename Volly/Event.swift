//
//  Event.swift
//  Volly

import Foundation

public class Event {
    var name: String
    var date: String
    var hours: Double
    var location: String
    var description: String
    
    //init vars as empty strings
    init() {
        name = ""
        date = ""
        hours = 0.0
        location = ""
        description = ""
    }
    
    //init vars with passed in variables
    init(name: String, date: String, hours: Double, location: String, description: String) {
        self.name = name
        self.date = date
        self.hours = hours
        self.location = location
        self.description = description
    }
    
    //set methods to set characteristics to new strings
    func setName(newName: String) {
        name = newName
    }
    
    func setDate(newDate: String) {
        date = newDate
    }
    
    func setHours(newHours: Double) {
        hours = newHours
    }
    
    func setLocation(newLocation: String) {
        location = newLocation
    }
    
    func setDescription(newDescription: String) {
        description = newDescription
    }
}
