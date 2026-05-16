//
//  nervio_widgetLiveActivity.swift
//  nervio.widget
//
//  Created by Florin Sima on 15/05/2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct nervio_widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct nervio_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: nervio_widgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension nervio_widgetAttributes {
    fileprivate static var preview: nervio_widgetAttributes {
        nervio_widgetAttributes(name: "World")
    }
}

extension nervio_widgetAttributes.ContentState {
    fileprivate static var smiley: nervio_widgetAttributes.ContentState {
        nervio_widgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: nervio_widgetAttributes.ContentState {
         nervio_widgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: nervio_widgetAttributes.preview) {
   nervio_widgetLiveActivity()
} contentStates: {
    nervio_widgetAttributes.ContentState.smiley
    nervio_widgetAttributes.ContentState.starEyes
}
