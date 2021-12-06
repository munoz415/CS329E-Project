//
//  Event.swift
//  Volly

import Foundation

public class Event {
    var name: String
    var date: String
    var hours: Double
    var eventLatitude: Double
    var eventLongitude: Double
    var description: String
    var eventID: String
    
    //init vars as empty strings
    init() {
        name = ""
        date = ""
        hours = 0.0
        eventLatitude = 0.0
        eventLongitude = 0.0
        description = ""
        eventID = ""
    }
    
    //init vars with passed in variables
    init(name: String, date: String, hours: Double, eventLatitude: Double, eventLongitude: Double, description: String, eventID: String) {
        self.name = name
        self.date = date
        self.hours = hours
        self.eventLatitude = eventLatitude
        self.eventLongitude = eventLongitude
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
    
    func setLatitude(newLatitude: Double) {
        eventLatitude = newLatitude
    }
    
    func setLongitude(newLongitude: Double) {
        eventLongitude = newLongitude
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
        } else if(description == "") {
            return "description."
        } else {
            return ""
        }
    }
    
    func toString() -> String {
        return "Name: \(name)\nDate: \(date)\nHours: \(hours)\nDescription: \(description)"
    }
}
