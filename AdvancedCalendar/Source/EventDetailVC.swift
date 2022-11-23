import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
//import EventKitUI
//import EventKit
import JZCalendarWeekView


class EventDetailVC: UIViewController {
    let db = Firestore.firestore()
//    lazy var eventstore: EKEventStore = EKEventStore()
    private let firstDate = Date().add(component: .hour, value: 1)
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)
    
    lazy var event = AllDayEvent(id: "0", title: "One", startDate: firstDate, endDate: firstDate.add(component: .hour, value: 1), location: "Melbourne", isAllDay: false,completed: false)

  
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var calendarWeekView = ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers[0] as! LongPressViewController).calendarWeekView
    var viewModel = ((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers[0] as! LongPressViewController).viewModel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.text = event.title
        location.text = event.location
        startDate.text = event.startDate.formatted()
        endDate.text = event.endDate.formatted()
        
        detail.text = "default notes"
        if event.completed {
            name.textColor = .gray
            name.attributedText = NSAttributedString(string: event.title, attributes: [NSAttributedString.Key.strikethroughStyle: 1])
        }
    }
    

    
    @IBAction func EditEvent(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBAction func deleteEvent(_ sender: UIButton) {
        let curEvent = db.collection("scheduleEvents").document(event.id)
        curEvent.delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        viewModel.reloadData()
        calendarWeekView!.forceReload(reloadEvents: viewModel.eventsByDate)
        
//        print((UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers) // longpresscontroller
        
        
        self.dismiss(animated: true)
//        _ = navigationController?.popViewController(animated: true)
        
    }

    @IBAction func editEvent(_ sender: UIButton) {
        print("edit")
//        ScheduleVC.showEventViewController()
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func markComplete(_ sender: UIButton) {
        let curEvent = db.collection("scheduleEvents").document(event.id)
        curEvent.updateData(["completed":!event.completed]){
            err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
        }
//        _ = navigationController?.popViewController(animated: true)
        
        event.completed = !event.completed

        
        calendarWeekView!.forceReload(reloadEvents: viewModel.eventsByDate)
        
//        calendarWeekView!.refreshWeekView()
        for i in viewModel.events{
            print("\(i.title) -- \(i.completed)")
        }
        self.dismiss(animated: true)
    }
    
//    @IBAction func back(_ sender: UIButton) {
//        self.dismiss(animated: true)
//    }
}
