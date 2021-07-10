//
//  ShowsViewController.swift
//  RipVanWinkle
//
//  Created by Jason on 7/8/21.
//

import UIKit
import SwiftUI

class ShowsViewController: UIViewController {
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

        var configuration = ShowContentConfiguration(title: show.title,
                                                detail: show.network,
                                                isFavorite: show.status == .favorite)
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 45
        
        updateSnapshot(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [unowned self] in
            if let index = shows.firstIndex(where: { $0.title == "Ted Lasso" }) {
                shows[index].status = .favorite
            }
            updateSnapshot(animated: true)
        }
    }
    
    func updateSnapshot(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Status, Show.ID>()
        
        snapshot.appendSections(Status.allCases)
        snapshot.appendItems(shows.filter({ $0.status == .favorite }).map(\.id), toSection: .favorite)
        snapshot.appendItems(shows.filter({ $0.status == .watching }).map(\.id), toSection: .watching)
        snapshot.appendItems(shows.filter({ $0.status == .watched }).map(\.id), toSection: .watched)
        
        snapshot.reconfigureItems(shows.map(\.id))
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension ShowsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        let section = Status(rawValue: section)!
        
        var configuration = UIListContentConfiguration.prominentInsetGroupedHeader()
        configuration.text = section.title
        header?.contentConfiguration = configuration
        
        return header
    }
}
