//
//  TimeBlockView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/19.
//

import SwiftUI

struct TimeBlockView: View {
    var value: String
    var unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "#1F2937"))
            Text(unit)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#4B5563"))
        }
        .frame(width: 70, height: 70)
        .background(Color(hex: "#FFD700"))
        .cornerRadius(12)
    }
}
