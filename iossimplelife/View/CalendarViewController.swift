//
//  CalendarViewController.swift
//  iossimplelife
//
//  Created by Wei Lun Hsu on 2021/5/24.
//

import UIKit

class CalendarViewController: UIViewController {
    
    static let storyboardName: String = "CalendarViewController"

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var calendarUIView: UIView!
    @IBOutlet weak var dismissUIVIew: UIView!
    
    private var viewModel: CalendarViewModel?
    private var date: Date = Date()
    private var daysOfmonth: Int = 0 // 月的天數
    private var spaceNum: Int = 0 // 需要幾個空白的天數
    private let months: [String] = [
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    ]
    
    var sendDate: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CalendarViewModel(delegate: self)
        viewModel?.initCalendar(date: date)
        setView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: mainCollectionView.width / 7, height: mainCollectionView.width / 7)
        
        mainCollectionView.collectionViewLayout = flowLayout
    }

    private func setView() {
        /// CollectionView
        mainCollectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        /// Button
        forwardButton.addTarget(self, action: #selector(didTappedNextMonth), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTappedLastMonth), for: .touchUpInside)
        dismissUIVIew.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedBackView))
        dismissUIVIew.addGestureRecognizer(tap)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        swipeLeft.direction = .left
        calendarUIView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        swipeRight.direction = .right
        calendarUIView.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown))
        swipeDown.direction = .down
        calendarUIView.addGestureRecognizer(swipeDown)
    }
    
    public func setDate(date: Date) {
        self.date = date
    }
    
    // MARK:- Action
    @objc private func didTappedNextMonth() {
        viewModel?.didTappedNextOLastMontButton(.next)
    }
    
    @objc private func didTappedLastMonth() {
        viewModel?.didTappedNextOLastMontButton(.last)
    }
    
    @objc private func didTappedBackView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTappedCalendarView() {
        print("didTappedView")
    }
    
    @objc private func didSwipeLeft() {
        viewModel?.didTappedNextOLastMontButton(.next)
    }
    
    @objc private func didSwipeRight() {
        viewModel?.didTappedNextOLastMontButton(.last)
    }
    
    @objc private func didSwipeDown() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollection Delegate
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                                  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysOfmonth + spaceNum - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier,
                                                      for: indexPath) as! CalendarCollectionViewCell
        let day = (indexPath.row + 1) - (spaceNum - 1)
        let selectedDay = Calendar.current.component(.day, from: date)
        
        if day > 0 {
            if day == selectedDay {
                cell.configureSelected(with: "\(day)")
            }
            else {
                cell.configure(with: "\(day)")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = (indexPath.row + 1) - (spaceNum - 1)
        viewModel?.didSelectedDay(day: day)  // 給 viewModel 之後回傳處理後的 Date
    }
}

// MARK: - ViewModel Delegate
extension CalendarViewController: CalendarViewModelDelegate {
    
    func calendarView(_ viewModel: CalendarViewModel, setCalendar year: Int, month: Int, dayOfMonth: Int, firstDay: Int) {
        titleLabel.text = "\(year)  \(months[month - 1])"
        self.daysOfmonth = dayOfMonth
        self.spaceNum = firstDay
        
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }
    
    func calendarView(_ viewModel: CalendarViewModel, didSelectDate date: Date) {
        // 處理傳回來後的 Date 給 AddRecordViewController
        sendDate?(date)
    }
}

// MARK: - Calendar CollectionView Cell
class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CalendarCollectionViewCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dayLabel.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = ""
    }
    
    public func configure(with day: String) {
        dayLabel.text = day
    }
    
    public func configureSelected(with day: String) {
        dayLabel.text = day
        dayLabel.backgroundColor = .yellow
        dayLabel.layer.cornerRadius = min(dayLabel.width, dayLabel.height) / 2
        dayLabel.clipsToBounds = true
    }
}
