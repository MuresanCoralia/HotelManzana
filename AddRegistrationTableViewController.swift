//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Wolfpack Digital on 02.08.2021.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate
{

    func selectRoomTypeTableViewController(_ controller:
           SelectRoomTypeTableViewController, didSelect roomType: RoomType)
    {
        self.roomType = roomType
        updateRoomType()
    }
  
    
    var registration: Registration?
    {
        guard let roomType = roomType else { return nil }
    
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
    
        return Registration(firstName: firstName,
                            lastName: lastName,
                            emailAddress: email,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            numberOfAdults: numberOfAdults,
                            numberOfChildren: numberOfChildren,
                            wifi: hasWifi,
                            roomType: roomType)
    }


    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsStepper: UIStepper!
    
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet var wifiSwitch: UISwitch!
    
    @IBOutlet var roomTypeLabel: UILabel!
  
    
    var roomType: RoomType?
    
    func updateRoomType()
    {
        if let roomType = roomType
        {
            roomTypeLabel.text = roomType.name
        } else
        {
            roomTypeLabel.text = "Not Set"
        }
    }

   
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    
    var isCheckInDatePickerVisible: Bool = false
    {
        didSet
        {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false
    {
        didSet
        {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    
    func updateNumberOfGuests()
    {
        numberOfAdultsLabel.text =
           "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text =
           "\(Int(numberOfChildrenStepper.value))"
    }
    
    /*
    override func tableView(_ tableView: UITableView,
       heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath
        {
            case checkInDatePickerCellIndexPath where
                    isCheckInDatePickerVisible == false:
                return 0
            case checkOutDatePickerCellIndexPath where
                    isCheckOutDatePickerVisible == false:
                return 0
            default:
                return UITableView.automaticDimension
        }
    }
 */
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    
        if indexPath == checkInDateLabelCellIndexPath &&
               isCheckOutDatePickerVisible == false
        {
                // check-in label selected, check-out picker is not
                  // visible, toggle check-in picker
                isCheckInDatePickerVisible.toggle()
        } else if indexPath == checkOutDateLabelCellIndexPath &&
               isCheckInDatePickerVisible == false
        {
                // check-out label selected, check-in picker is not
                  // visible, toggle check-out picker
                isCheckOutDatePickerVisible.toggle()
        } else if indexPath == checkInDateLabelCellIndexPath ||
               indexPath == checkOutDateLabelCellIndexPath
        {
                // either label was selected, previous conditions failed
                  // meaning at least one picker is visible, toggle both
                isCheckInDatePickerVisible.toggle()
                isCheckOutDatePickerVisible.toggle()
        } else
        {
            return
        }
    
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        
        updateDateViews()
        
        updateNumberOfGuests()
        
        updateRoomType()
    }
    
    var dateFormatter: DateFormatter =
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
    
        return dateFormatter
    }()
    
    func updateDateViews()
    {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding:
           .day, value: 1, to: checkInDatePicker.date)

        checkInDateLabel.text = dateFormatter.string(from:
           checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from:
           checkOutDatePicker.date)
    }
    
    
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController?
    {
        let selectRoomTypeController =
               SelectRoomTypeTableViewController(coder: coder)
            selectRoomTypeController?.delegate = self
            selectRoomTypeController?.roomType = roomType
        
        return selectRoomTypeController
    }
    
    @IBAction func cancelButtonTapped()
    {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func datePickerValueChanged(_ sender: UIDatePicker)
    {
        updateDateViews()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper)
    {
        updateNumberOfGuests()
    }

    @IBAction func wifiSwitchChanged(_ sender: UISwitch)
    {
        //implemented later
    }

    // MARK: - Table view data source



    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
