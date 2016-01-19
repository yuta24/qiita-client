//
//  ItemsViewController.swift
//  qiita-client
//
//  Created by yuta24 on 2016/01/17.
//  Copyright © 2016年 Yu Tawata. All rights reserved.
//

import UIKit

class ItemsDelegate: NSObject, UITableViewDelegate {

}

class ItemsDataSource<T>: NSObject, UITableViewDataSource {

    typealias Section       = [T]
    typealias ConfigureCell = (cell: UITableViewCell, item: T) -> Void

    var sections: [Section]

    private
    let identifier: String

    private
    let configure: ConfigureCell

    init(sections: [Section], identifier: String, configure: ConfigureCell) {
        self.sections = sections
        self.identifier = identifier
        self.configure = configure
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)

        configure(cell: cell, item: sections[indexPath.section][indexPath.row])

        return cell
    }

}

class ItemsViewController: UIViewController {

    @IBOutlet
    var tableView: UITableView!

    var delegate: ItemsDelegate!
    var dataSource: ItemsDataSource<Item>!

    override
    func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let sections: [ItemsDataSource<Item>.Section] = [
            []
        ]

        delegate    = ItemsDelegate()
        dataSource  = ItemsDataSource(sections: sections, identifier: ItemViewCell.identifier, configure: { cell, item in
            // TODO: 実装
            if let customCell = cell as? ItemViewCell {
                customCell.textLabel?.text = item.title
            }
        })
        refreshWithItems([])

        setup()
    }

    override
    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override
    func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        DataStore.sharedInstance.getItems(handler: { [unowned self] result in
            switch result {
            case .Success(let items):
                self.refreshWithItems(items)
                break
            case .Failure(_):
                break
            }
            })
    }

    private
    func setup() {
        navigationItem.title = "Feed"

        tableView.dataSource    = dataSource
        tableView.delegate      = delegate

        tableView.registerNib(UINib(nibName: "ItemViewCell", bundle: nil), forCellReuseIdentifier: ItemViewCell.identifier)
    }

    private
    func refreshWithItems(items: [Item]) {
        dataSource.sections = [
            items
        ]

        tableView.reloadData()
    }

}
