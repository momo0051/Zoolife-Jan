//
//  TimeFormatter.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 03/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import Foundation

class TimeFormatHelper {
    static func timeAgoString(date: Date) -> String {
        let secondsInterval = Date().timeIntervalSince(date).rounded()
        if (secondsInterval < 10) {
            if appLanguage == "en" {
                return "now"
            } else {
                return "الان"
            }
        }
        if (secondsInterval < 60) {
            if appLanguage == "en" {
                return "Before " + convertEngNumToArabicNum(num: String(Int(secondsInterval))) + " a second"
            } else {
                return "قبل " + convertEngNumToArabicNum(num: String(Int(secondsInterval))) + " ثانية"
            }
        }
        let minutes = (secondsInterval / 60).rounded()
        if (minutes < 60) {
            if appLanguage == "en" {
                return "Before " + convertEngNumToArabicNum(num: String(Int(minutes))) + " minutes ago"
            } else {
                return "قبل " + convertEngNumToArabicNum(num: String(Int(minutes))) + " دقيقة"
            }
            
        }
        let hours = (minutes / 60).rounded()
        if (hours < 24) {
            if appLanguage == "en" {
                return "Before " +  convertEngNumToArabicNum(num: String(Int(hours))) + " hours ago"
            } else {
                return "قبل " +  convertEngNumToArabicNum(num: String(Int(hours))) + " ساعة"
            }
        }
        var days = (hours / 60).rounded()
        if (days < 30) {
            if days == 0 {
                days = 1
            }
            if appLanguage == "en" {
                return "Before " +  convertEngNumToArabicNum(num: String(Int(days))) + " days ago"
            } else {
                return "قبل " +  convertEngNumToArabicNum(num: String(Int(days))) + " يوم"
            }
        }
        var months = (days / 30).rounded()
        if (months < 12) {
            if months == 0 {
                months = 1
            }
            if appLanguage == "en" {
                return "Before " +  convertEngNumToArabicNum(num: String(Int(months))) + " months ago"
            } else {
                return "قبل " +  convertEngNumToArabicNum(num: String(Int(months))) + " شهر"
            }
        }
        let years = (months / 12).rounded()
        if appLanguage == "en" {
            return "Before " + convertEngNumToArabicNum(num: String(Int(years))) + " years ago"
        } else {
            return "قبل " +  convertEngNumToArabicNum(num: String(Int(years))) + " عام"
        }
    }

    static func string(for date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    static func chatString(for date: Date) -> String {
        let calendar = NSCalendar.current
        if calendar.isDateInToday(date) {
            return self.string(for: date, format: "HH:mm")
        }
        return self.string(for: date, format: "MMM dd")
    }
}


func convertEngNumToArabicNum(num: String)->String {
        let format = NumberFormatter()
        if appLanguage == "en" {
            format.locale = Locale(identifier: "en")
        } else {
            format.locale = Locale(identifier: "ar_SA")
        }
        let number =   format.number(from: num)
        let faNumber = format.string(from: number!)
        return faNumber!
}
