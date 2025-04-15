//
//  nooteWidget.swift
//  nooteWidget
//
//  Created by Rahul choudhary on 15/04/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct nooteWidgetEntryView : View {
    var entry: Provider.Entry
    //MARK: - PROPERTIES
    @Environment(\.widgetFamily) var widgetFamily
    
    var fontStyle : Font {
        if widgetFamily == .systemSmall {
            return .system(.footnote,design: .rounded)
        }else{
            return .system(.headline,design: .rounded)
        }
    }
    var body: some View {
//        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//
//            Text("Emoji:")
//            Text(entry.emoji)
//        }
        
        GeometryReader {geometry in
            ZStack{ 
                    
                Image("rocket-small")
                    .resizable()
                    .scaledToFit()
                Image("logo")
                    .resizable()
                    .frame(
                        width: widgetFamily != .systemSmall ? 56 : 36 ,
                        height: widgetFamily != .systemSmall ? 56 : 36
                    )
                    .offset(
                        x:(geometry.size.width / 2 ) - 20,
                        y:(geometry.size.height / -2) + 20
                    )
                    .padding(.top,widgetFamily != .systemSmall ? 32 : 12)
                    .padding(.trailing,widgetFamily != .systemSmall ? 32 : 12)
                HStack {
                    Text("Just Launch It")
                        .foregroundColor(.white)
                        .font(fontStyle)
                        .fontWeight(.bold)
                        .padding(.horizontal,12)
                        .padding(.vertical,4)
                        .background(
                            Color(red:0,green: 0,blue: 0,opacity: 0.5)
                                .blendMode(.overlay)
                        )
                        .clipShape(Capsule())
                    if widgetFamily != .systemSmall {
                        Spacer()
                    }
                }//:Hstack
                .padding()
                .offset(
                    y:(geometry.size.height / 2) - 24
                )
            }//:Zstack

        }//: GeometryReader
    }
}

struct nooteWidget: Widget {
    let kind: String = "nooteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                nooteWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                                        backgroundGradiant
                                    }
            } else {
                nooteWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Noote Launcher")
        .description("This is widget for the Note taking app.")
    }
}

#Preview(as: .systemSmall) {
    nooteWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
