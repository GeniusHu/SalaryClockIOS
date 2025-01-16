//
//  UserInfoCard.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation
import SwiftUI

struct UserInfoCard: View {
    var userSettings: UserSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(NSLocalizedString("dashboard.current_time", comment: "")): \(Date().formattedTime())")
            Text("\(NSLocalizedString("dashboard.join_date", comment: "")): \(userSettings.joinDate)")
            Text("\(NSLocalizedString("dashboard.monthly_salary", comment: "")): \(userSettings.monthlySalary, specifier: "%.2f")")
        }
        .padding()
        .background(Color.primary.opacity(0.1))
        .cornerRadius(10)
    }
}

struct UserInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoCard(userSettings: UserSettings())
    }
}
