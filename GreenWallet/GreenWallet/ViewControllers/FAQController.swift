//
//  FAQController.swift
//  GreenWallet
//
//  Created by Фаддей Гусаров on 05.06.2022.
//

import UIKit

class FAQController: UIViewController {
    
    var faqs: [FAQs] = [FAQs(header: "Как редактировать адрес кошелька", inCells: ["Нужно удерживать контакт в течении 1 секунды и провести пальцем в лево, после этого вы можете удалить, отредактировать, отправить адрес"], expanded: false),
                        FAQs(header: "Как редактировать адрес кошелька", inCells: ["Нужно удерживать контакт в течении 1 секунды и провести пальцем в лево, после этого вы можете удалить, отредактировать, отправить адрес"], expanded: false),
                        FAQs(header: "Как редактировать адрес кошелька", inCells: ["Нужно удерживать контакт в течении 1 секунды и провести пальцем в лево, после этого вы можете удалить, отредактировать, отправить адрес"], expanded: false),
                        FAQs(header: "Как редактировать адрес кошелька", inCells: ["Нужно удерживать контакт в течении 1 секунды и провести пальцем в лево, после этого вы можете удалить, отредактировать, отправить адрес"], expanded: false),
                        FAQs(header: "Как редактировать адрес кошелька", inCells: ["Нужно удерживать контакт в течении 1 секунды и провести пальцем в лево, после этого вы можете удалить, отредактировать, отправить адрес"], expanded: false)]
    @IBOutlet weak var faqsTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mainTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.setTitle(LocalizationManager.share.translate?.result.list.all.back_btn, for: .normal)
        self.mainTitle.text = LocalizationManager.share.translate?.result.list.faq.faq_title
    }
    
    @IBAction func backBButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension FAQController: UITableViewDelegate, UITableViewDataSource, ExpandableHeaderViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return faqs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqs[section].inCells.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell", for: indexPath)
        
        cell.textLabel?.text = faqs[indexPath.section].inCells[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font.withSize(16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if faqs[indexPath.section].expanded {
            return 90
        }
        
        return 0
    }
    

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.button.setImage(UIImage(named: "plus")!, for: .normal)
        header.setup(withTitle: faqs[section].header, section: section, delegate: self)
        header.textLabel?.font.withSize(18)
        return header
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        faqs[section].expanded = !faqs[section].expanded
        
        self.faqsTableView.beginUpdates()
        for row in 0..<faqs[section].inCells.count {
            self.faqsTableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .automatic)
        }
        self.faqsTableView.endUpdates()
    }
    
}

struct FAQs {
    let header: String
    let inCells: [String]
    var expanded: Bool
}