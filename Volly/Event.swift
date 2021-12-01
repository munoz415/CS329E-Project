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
    var eventID: String
    
    //init vars as empty strings
    init() {
        name = ""
        date = ""
        hours = 0.0
        location = ""
        description = ""
        eventID = ""
    }
    
    //init vars with passed in variables
    init(name: String, date: String, hours: Double, location: String, description: String, eventID: String) {
        self.name = name
        self.date = date
        self.hours = hours
        self.location = location
        self.description = description
        self.eventID = eventID
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
    
    func setEventID(newEventID: String) {
        eventID = newEventID
    }
    
    func fullEvent() -> String {
        if(name == "") {
            return "name."
        } else if(date == "") {
            return "date."
        } else if(hours == 0.0) {
            return "hours."
        } else if(location == "") {
            return "location."
        } else if(description == "") {
            return "description."
        } else {
            return ""
        }
    }
    
    func toString() -> String {
        return "Name: \(name)\nDate: \(date)\nHours: \(hours)\nLocation: \(location)\nDescription: \(description)"
    }
}
