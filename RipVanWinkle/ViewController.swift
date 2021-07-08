//
//  ViewController.swift
//  RipVanWinkle
//
//  Created by Jason on 7/8/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var shows: [Show] = [
        Show(title: "30 Rock", network: "NBC", status: .favorite),
        Show(title: "The Good Place", network: "NBC", status: .favorite),
        Show(title: "Ted Lasso", network: "Apple TV+", status: .watched),
        Show(title: "Superman & Lois", network: "The CW", status: .watching),
        Show(title: "The Flash", network: "The CW", status: .watching),
        Show(title: "Mythic Quest", network: "Apple TV+", status: .watched),
        Show(title: "Arrow", network: "The CW", status: .watched),
        Show(title: "Star Trek: Picard", network: "Paramount+", status: .watched)
    ]
    
    lazy var dataSource = UITableViewDiffableDataSource<Status, Show.ID>(tableView: tableView) { [unowned self] tableView, indexPath, showIdentifier in
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let show = self.shows.filter({ $0.id == showIdentifier }).first!
        cell.textLabel?.text = show.title
        cell.detailTextLabel?.text = show.network
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        updateSnapshot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [unowned self] in 
            if let index = shows.firstIndex(where: { $0.title == "Ted Lasso" }) {
                shows[index].status = .favorite
            }
            updateSnapshot()
        }
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Status, Show.ID>()
        
        snapshot.appendSections(Status.allCases)
        snapshot.appendItems(shows.filter({ $0.status == .favorite }).map(\.id), toSection: .favorite)
        snapshot.appendItems(shows.filter({ $0.status == .watching }).map(\.id), toSection: .watching)
        snapshot.appendItems(shows.filter({ $0.status == .watched }).map(\.id), toSection: .watched)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

struct Show: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let network: String
    var status: Status
}

enum Status: Hashable, CaseIterable {
    case favorite, watching, watched
}
