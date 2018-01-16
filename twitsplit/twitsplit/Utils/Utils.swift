//
//  Utils.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/13/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import UIKit

class Utils: NSObject {

    // MARK: - Time
    public static func getCurrentTime() -> Double{
        let date = Date.init()
        return date.timeIntervalSince1970 // Get Current Time Stamp from 1970
    }
    
    public static func convertTimefromTimeStamp(_ timeStamp:Double) -> String {
        
        // Get Current Date
        let currentDate = Date.init()
        
        // Get Date init from Time Stamp
        let date = Date.init(timeIntervalSince1970: timeStamp)
        
        // Make Date Formatter with 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        let currentDateString = dateFormatter.string(from: currentDate)
        var dateString = dateFormatter.string(from: date)
        if (dateString == currentDateString) { // Same Date >> will Change to 'Today', if not will keep as ever
            dateString = "Today"
        }
        
        dateFormatter.dateFormat = "hh:mm a"
        let timeString = dateFormatter.string(from: date)
        
        return dateString + ", " + timeString
    }
    
    // MARK: - Split Content
    static func splitContent(_ postContent: String, completion:@escaping ([String],Bool) -> Void) {
        let limit = 50;
        let errorMessage = "The message contains a span of non-whitespace characters longer than \(limit) characters"
        let results = split(postContent, limit: limit)
        let state = !(results.count == 1 && results[0] == errorMessage)
        completion(results, state)
    }
    
    static func split(_ input: String, limit: Int) -> [String] {
        
        // Remove redudant white space and lines
        let components = input.components(separatedBy: .whitespacesAndNewlines)
        let filterMessage = components.filter { !$0.isEmpty }.joined(separator: " ")
        
        // Return message if its length is less than or equal limit
        if (filterMessage.count <= limit) {
            return [filterMessage]
        }
        
        // Calculate total partial
        let totalPartial: Int = (filterMessage.count / limit) + (filterMessage.count % limit > 0 ? 1 : 0)
        
        // Separate sentences into words by remove whitespaces and new lines
        let words = filterMessage.components(separatedBy: .whitespacesAndNewlines)
        
        // Check error, if available words have length that greater than limit
        let errorWords = words.filter { return $0.count > limit }
        
        // Return error if the length is great than limit and contains non-whitespace
        if !errorWords.isEmpty {
            return ["The message contains a span of non-whitespace characters longer than \(limit) characters"]
        }
        
        // Return message
        return conbinePartial(words, totalPartial: totalPartial, limitCharacters: limit)
    }
    
    static func conbinePartial(_ words: [String], totalPartial: Int, limitCharacters: Int) -> [String] {
        
        var results:[String] = []
        var lastCurrentIndex = 0 // Use to keep track the word index when appeding to partial
        
        // Loop by partial step
        for i in 0...totalPartial - 1 {
            
            // Init partial content for every step
            var partial = "\(i + 1)/\(totalPartial) "
            
            // For every step, we append the words, keep track current index and count the length of partial
            // If the partial length is equal or over the limit characters, we stop and move to another partial step
            let nextStepIndex = lastCurrentIndex + (i != 0 && lastCurrentIndex < words.count - 1 ? 1:0)
            for index in nextStepIndex...words.count - 1 {
                
                // Get Item
                let item = words[index]
                
                // Break loop if length is over than limit
                // (+ 1 because the last whitespace before trimming)
                let length = partial.count + item.count + 1
                if (length >= limitCharacters + 1) {
                    break;
                }
                
                // Append word to partial
                partial += item + " "
                
                // Store current index to know the last word
                lastCurrentIndex = index
            }
            
            // Add to results
            results.append(partial.trimmingCharacters(in: .whitespaces))
            
        }
        
        //Applied recursive to re-calculate total partials
        if lastCurrentIndex < words.count - 1 {
            let total = totalPartial + 1
            results = conbinePartial(words, totalPartial: total, limitCharacters: limitCharacters)
        }
        
        return results
    }
    
}
