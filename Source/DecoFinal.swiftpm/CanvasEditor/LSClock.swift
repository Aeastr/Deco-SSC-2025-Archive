//
//  LSClock.swift
//  Deco
//
//  Created by Aether on 04/02/2025.
//

import SwiftUI

struct LSClock: View {
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        return formatter
    }
    
    var large: Bool = false
    
    var body: some View {
        TimelineView(.everyMinute) { context in
            let currentDate = context.date
            VStack(spacing: -9) {
                Text(dateFormatter.string(from: currentDate))
                    .font(.system(size: 20, weight: .semibold, design: .default))
                
                Text(timeFormatter.string(from: currentDate))
                    .font(.system(size: large ? 150 : 100, weight: .semibold, design: .default))
                    .kerning(-1.5)
            }
            .padding(.top, large ? 75 : 10)
            .foregroundStyle(.white)
        }
        .allowsHitTesting(false)
        .dynamicTypeSize(.large)
    }
}
