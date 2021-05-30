//
//  CalendarViewModel.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/24.
//

import Foundation

protocol CalendarViewModelDelegate: class {
    func calendarView(_ viewModel: CalendarViewModel, setCalendar year: Int, month: Int, dayOfMonth: Int, firstDay: Int)
    func calendarView(_ viewModel: CalendarViewModel, didSelectDate date: Date)
}

class CalendarViewModel {
    
    enum buttonType {
        case next
        case last
    }
    
    weak var delegate: CalendarViewModelDelegate?
    
    private var currentYear = Calendar.current.component(.year, from: Date())
    private var currentMonth = Calendar.current.component(.month, from: Date())
    
    // Get 月的天數
    private var numberOfMonth: Int {
        let component = DateComponents(year: currentYear, month: currentMonth)
        guard let date = Calendar.current.date(from: component) else {
            fatalError("numberOfMonth")
        }
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        return range?.count ?? 0
    }
    
    // Get 每個月的第一天是禮拜幾
    private var whatDayInIt: Int {
        let component = DateComponents(year: currentYear, month: currentMonth)
        guard let date = Calendar.current.date(from: component) else {
            fatalError("whatDayInIt")
        }
        return Calendar.current.component(.weekday, from: date)
    }
    
    init(delegate: CalendarViewModelDelegate) {
        self.delegate = delegate
    }
    
    public func initCalendar() {
        delegate?.calendarView(self, setCalendar: currentYear, month: currentMonth, dayOfMonth: numberOfMonth, firstDay: whatDayInIt)
    }
    
    public func didTappedNextOLastMontButton(_ type: buttonType) {
        switch type {
        case .next:
            currentMonth += 1
        case .last:
            currentMonth -= 1
        }
        
        if currentMonth == 13 {
            currentYear += 1
            currentMonth = 1
        }
        else if currentMonth == 0 {
            currentYear -= 1
            currentMonth = 12
        }
        
        // Update title label
        delegate?.calendarView(self, setCalendar: currentYear, month: currentMonth, dayOfMonth: numberOfMonth, firstDay: whatDayInIt)
    }
    
    public func didSelectedDay(day: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: "\(currentYear)-\(currentMonth)-\(day)") else {
            return
        }
        
        delegate?.calendarView(self, didSelectDate: date)
    }
}


