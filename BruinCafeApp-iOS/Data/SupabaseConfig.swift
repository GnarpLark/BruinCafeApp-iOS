//
//  SupabaseConfig.swift
//  BruinCafeApp-iOS
//
//  Created by Eli Feaster on 11/18/26.
//

import Foundation

struct SupabaseConfig {
    static let url = "https://soljrjnkffthzzugufmu.supabase.co"
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNvbGpyam5rZmZ0aHp6dWd1Zm11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk4NzkzNzUsImV4cCI6MjEwNTQ1NTM3NX0.KlHidb7MFawHZQOXYGnORegD19mkavn1476oJ-EiCm4"
    
    static var isConfigured: Bool {
        return !url.isEmpty && !anonKey.isEmpty
    }
}
