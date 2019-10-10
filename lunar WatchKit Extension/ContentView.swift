//
//  ContentView.swift
//  lunar WatchKit Extension
//
//  Created by Bryan Yang on 2019/8/11.
//  Copyright © 2019 Bryan Yang. All rights reserved.
//

import SwiftUI

let dates: [Date24] = [
    Date24("寒露", "20191008"),
    Date24("霜降", "20191024"),
    Date24("立冬", "20191108"),
    Date24("小❄️", "20191122"),
    Date24("大❄️", "20191207"),
    Date24("冬至", "20191222"),
    // 2020年
    Date24("小寒", "20200106"),
    Date24("大寒", "20200120"),
    Date24("立春", "20200204"),
    Date24("雨水", "20201024"),
    Date24("惊蛰", "20200305"),
    Date24("春分", "20200320"),
    Date24("清明", "20200404"),
    Date24("谷雨", "20200419"),
    Date24("立夏", "20200505"),
    Date24("小满", "20200520"),
    Date24("芒种", "20200605"),
    Date24("夏至", "20200621"),
    Date24("小暑", "20200706"),
    Date24("大暑", "20200722"),
    Date24("立秋", "20200807"),
    Date24("处暑", "20200822"),
    Date24("白露", "20200907"),
    Date24("秋分", "20200922"),
    Date24("寒露", "20201008"),
    Date24("霜降", "20201023"),
    Date24("立冬", "20201107"),
    Date24("小❄️", "20201122"),
    Date24("大❄️", "20201207"),
    Date24("冬至", "20201221"),
];

struct ContentView: View {
  @State var totalClicked: Int = 0
  var body: some View {
    List(dates, id: \.id ) { date in
       HStack {
        Text(date.date)
        Text(date.name)
      }
  
   }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
