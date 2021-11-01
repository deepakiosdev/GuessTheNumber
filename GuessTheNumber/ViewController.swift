//
//  ViewController.swift
//  GuessTheNumber
//
//  Created by Dipak Pandey 13 on 05/10/21.
//

import UIKit

let PROFIT_MULTIPLIER = 5
let LOSS_MULTIPLIER  = 1
let START_NUMBER_RANGE = 1
let END_NUMBER_RANGE = 20

let GAME_TOTAL_AMOUNT_KEY = "game total amount key"

class ViewController: UIViewController {

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblRandomNumber: UILabel!
    @IBOutlet weak var lblSelectNumberInstruction: UILabel!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnWrong: UIButton!
    @IBOutlet weak var btnGenerateNumber: UIButton!
    @IBOutlet weak var txfAmount: UITextField!
    
    var totalAmount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblSelectNumberInstruction.text = "Select any number in between \(START_NUMBER_RANGE) to \(END_NUMBER_RANGE)"
        fetchAndUpdateTotalAmount()
    }

    @IBAction func resetButtonAction(_ sender: UIButton) {
        performReset()
    }
    
    @IBAction func genrateNumberAction(_ sender: Any) {
        genrateRandomNumber()
        enableDisableButtons(isEnable: true)
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        calculateTotalAmount(isRightGuess: true)
        enableDisableButtons(isEnable: false)
    }
    
    @IBAction func wrongButtonAction(_ sender: Any) {
        calculateTotalAmount(isRightGuess: false)
        enableDisableButtons(isEnable: false)
    }
    
    func enableDisableButtons(isEnable: Bool) {
        btnRight.isEnabled = isEnable
        btnWrong.isEnabled = isEnable
        btnGenerateNumber.isEnabled = !isEnable
    }

}

extension ViewController {
    
    func genrateRandomNumber() {
        let num = (START_NUMBER_RANGE...END_NUMBER_RANGE).randomElement()! //1 to 20
        lblRandomNumber.text = "\(num)"
    }
    
    func performReset() {
        totalAmount =  0
        saveAndUpdateTotalAmountUI()
    }
    
    func saveAndUpdateTotalAmountUI() {
        saveTotalAmount()
        updateTotalAmountUI()
    }
    
    func calculateTotalAmount(isRightGuess: Bool) {
        
        let multiplyFactor = isRightGuess ? PROFIT_MULTIPLIER : -1 * LOSS_MULTIPLIER
        var bet = txfAmount.text
        if bet == nil || bet!.isEmpty {
            bet = "1"
        }
        let betAmt = Int(bet!)!
        totalAmount = totalAmount + (betAmt * multiplyFactor)
        saveAndUpdateTotalAmountUI()
    }
    
    func updateTotalAmountUI() {
        lblTotal.text = "Balance:  \(totalAmount)"
    }
    
    func saveTotalAmount() {
        UserDefaults.standard.set(totalAmount, forKey: GAME_TOTAL_AMOUNT_KEY)
    }

    func fetchAndUpdateTotalAmount() {
        if let total = UserDefaults.standard.value(forKey: GAME_TOTAL_AMOUNT_KEY) as? Int {
            self.totalAmount = total
            updateTotalAmountUI()
        }
    }
    
    
    
}


extension UIViewController: UITextFieldDelegate {
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
}
