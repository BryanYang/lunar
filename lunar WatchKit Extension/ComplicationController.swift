//
//  ComplicationController.swift
//  lunar WatchKit Extension
//
//  Created by Bryan Yang on 2019/8/11.
//  Copyright © 2019 Bryan Yang. All rights reserved.
//

import ClockKit

struct Day {
   var name = ""
   var days = 0
}
struct CWFiscalDate {
    // 在这里定义结构体
    var date: Date
    var preDay = Day()
    var nextDay = Day()
}

extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}

struct Date24: Identifiable {
    var id: String
    var name = ""
    var date = ""
    
    init( _ name: String, _ date:String) {
        self.name = name
        self.date = date
        self.id = date
   }
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    func templateModularSmallForData(_ data: CWFiscalDate) -> CLKComplicationTemplateModularSmallColumnsText {
        let template = CLKComplicationTemplateModularSmallColumnsText()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: data.preDay.name)
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: data.nextDay.name)
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: String(data.preDay.days))
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: String(data.nextDay.days))
        return template
    }
    
    func templateModularLargeForData(_ data: CWFiscalDate) -> CLKComplicationTemplateModularLargeColumns {
        let template = CLKComplicationTemplateModularLargeColumns()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: data.preDay.name)
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: data.nextDay.name)
        template.row3Column1TextProvider = CLKSimpleTextProvider(text: "")
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: String(data.preDay.days))
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: String(data.nextDay.days))
        template.row3Column2TextProvider = CLKSimpleTextProvider(text: "")
        return template
    }
    
    func timelineEntryForData(_ data: CWFiscalDate, complication: CLKComplication) -> CLKComplicationTimelineEntry? {
       var template: CLKComplicationTemplate?
       switch complication.family {
       case .modularSmall:
           template = self.templateModularSmallForData(data)
       case .modularLarge:
           template = self.templateModularLargeForData(data)
       default:
           template = nil
       }
        if template == nil {
            return nil
        }
       return CLKComplicationTimelineEntry(date: data.date, complicationTemplate: template!)
    }
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        var data = CWFiscalDate(date: Date())
        let currentDate = Date();
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyyMMdd"
        
        var index = 0
        repeat {
            let item = dates[index]
            let next = dates[index + 1]
            let itemDate = myFormatter.date(from: item.date)
            let nextDate = myFormatter.date(from: next.date)
            if( currentDate > itemDate! && currentDate < nextDate! ){
                data.preDay.name = item.name
                data.preDay.days = itemDate!.daysBetweenDate(toDate: currentDate)
                data.nextDay.name = next.name
                data.nextDay.days = currentDate.daysBetweenDate(toDate: nextDate!)
                break
            }
            index = index + 1
        } while index < dates.count
        handler(self.timelineEntryForData(data, complication: complication))
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    func placeholderTemplateModularSmall() -> CLKComplicationTemplateModularSmallColumnsText {
        let template = CLKComplicationTemplateModularSmallColumnsText()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: "PR")
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: "WK")
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
        return template
    }
    
    func placeholderTemplateModularLarge() -> CLKComplicationTemplateModularLargeColumns {
        let template = CLKComplicationTemplateModularLargeColumns()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: "YEAR")
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: "PERIOD")
        template.row3Column1TextProvider = CLKSimpleTextProvider(text: "WEEK")
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: "--")
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: "--")
        template.row3Column2TextProvider = CLKSimpleTextProvider(text: "--")
        return template
    }
    
    func placeholderTemplateCircularSmallRing() -> CLKComplicationTemplateCircularSmallRingText {
           let template = CLKComplicationTemplateCircularSmallRingText()
           template.textProvider = CLKSimpleTextProvider(text: "--")
           template.fillFraction = 1.0
           template.ringStyle = .closed
           return template
       }
    
    func getPlaceholder(for complication: CLKComplication) -> CLKComplicationTemplate {
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularSmall:
            template = self.placeholderTemplateModularSmall()
        case .modularLarge:
            template = self.placeholderTemplateModularLarge()
        case .circularSmall:
            template = self.placeholderTemplateCircularSmallRing()
        default:
            template = nil
        }
        return template!
    }
    
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        // handler(nil)
        let template = self.getPlaceholder(for: complication)
        handler(template)
    }
    
}
