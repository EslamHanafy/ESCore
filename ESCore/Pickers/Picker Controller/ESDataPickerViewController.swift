//
//  ESDataPickerViewController.swift
//  ESCore
//
//  Created by Eslam Hanafy on 1/4/20.
//  Copyright © 2020 Eslam. All rights reserved.
//

import UIKit

open class ESDataPickerViewController: UITableViewController {
    public var searchController: UISearchController?
    public var preferredSection: ESDataPickerPreferredSection?
    public var screenTitle: String = ""
    public var style: ESDataPickerStyle = ESDataPickerStyle()
    public var onSelectItem: ((_ item: ESDataPickerItemType) -> Void)?
    
    private var searchResults = [ESDataPickerItemType]()
    private var isSearchMode = false
    private var sectionsTitles = [String]()
    private var items = [String: [ESDataPickerItemType]]()
    private var selectedItem: ESDataPickerItemType?
    
    private var hasPreferredSection: Bool {
        return preferredSection != nil
    }
    
    
    public init(with dataSource: DPDataSource, and style: ESDataPickerStyle = ESDataPickerStyle()) {
        self.items = dataSource.items
        self.preferredSection = dataSource.preferredSection
        self.screenTitle = dataSource.screenTitle
        self.style = style
        
        super.init(style: .grouped)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        prepareTableItems()
        prepareNavItem()
        prepareSearchBar()
    }
    
    
    open func show(from controller: UIViewController? = currentController) {
        guard let controller = controller else { return }
        let navigation = UINavigationController(rootViewController: self)
        controller.present(navigation, animated: true)
        self.tableView.reloadData()
    }
    
    open func selectedItem<T: ESDataPickerItemType>(type: T.Type, _ handler: @escaping (_ item: T) -> Void) {
        self.onSelectItem = { item in
            handler(item as! T)
        }
    }
}

//MARK: - Helpers
private extension ESDataPickerViewController {
    func prepareTableItems()  {
        self.tableView.register(ESDataPickerTableViewCell.self, forCellReuseIdentifier: "Cell")
        sectionsTitles = items.keys.sorted()
        
        if let section = preferredSection {
            sectionsTitles.insert(section.title, at: sectionsTitles.startIndex)
            items[section.title] = section.items
        }
        
        tableView.sectionIndexBackgroundColor = .clear
        tableView.sectionIndexTrackingBackgroundColor = .clear
    }
    
    func prepareNavItem() {
        navigationItem.title = screenTitle
        let closeButton = UIBarButtonItem(title: "close".selfLocalized, style: .done, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
    }
    
    func prepareSearchBar() {
        searchController = UISearchController(searchResultsController:  nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.definesPresentationContext = true
        searchController?.searchBar.delegate = self
        searchController?.delegate = self

        navigationItem.titleView = searchController?.searchBar
    }
    
    @objc func close() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Table View Delegate And Data Source
extension ESDataPickerViewController {
    open override func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchMode ? 1 : sectionsTitles.count
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? searchResults.count : items[sectionsTitles[section]]!.count
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ESDataPickerTableViewCell
        
        let item = isSearchMode ? searchResults[indexPath.row]
        : items[sectionsTitles[indexPath.section]]![indexPath.row]
        
        cell.configure(with: item, and: style, isSelected: selectedItem?.title == item.title)
        
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchMode ? nil : sectionsTitles[section]
    }
    
    open override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSearchMode || !style.showSectionIndexTitles {
            return nil
        } else {
            if hasPreferredSection {
                return Array<String>(sectionsTitles.dropFirst())
            }
            return sectionsTitles
        }
    }
    
    open override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionsTitles.firstIndex(of: title)!
    }
    
    open override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = style.sectionTitleFont
            header.textLabel?.textColor = style.sectionTitleTextColor
        }
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = isSearchMode ? searchResults[indexPath.row]
            : items[sectionsTitles[indexPath.section]]![indexPath.row]

        searchController?.dismiss(animated: false, completion: nil)
        selectedItem = item
        
        navigationController?.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.onSelectItem?(item)
        })
    }
}

// MARK:- UISearchResultsUpdating
extension ESDataPickerViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        isSearchMode = false
        if let text = searchController.searchBar.text, text.count > 0 {
            isSearchMode = true
            searchResults.removeAll()
            
            let data = Array(items.values.joined())
            
            searchResults.append(contentsOf: data.filter({
                let name = $0.title.lowercased()
                let query = text.lowercased()
                return name.contains(query)
            }))
        }
        tableView.reloadData()
    }
}

// MARK:- UISearchBarDelegate
extension ESDataPickerViewController: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Hide the back/left navigationItem button
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Show the back/left navigationItem button
        prepareNavItem()
        navigationItem.hidesBackButton = false
    }
}

// MARK:- UISearchControllerDelegate
extension ESDataPickerViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
}
