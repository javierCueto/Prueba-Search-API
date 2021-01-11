//
//  MainController.swift
//  Prueba-Search-API
//
//  Created by Javier Cueto on 11/01/21.
//  Copyright © 2021 Osvaldo. All rights reserved.
//

import UIKit

class MainController: UICollectionViewController  {
    // MARK: -  Properties
    private let reuseIdentifier = "mainCellID"
    private let tableCellID = "mainTableCellID"
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private var products = [Product]() {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
          
        }
    }
    
    // MARK: -  Lifecycle
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        configureCollection()
        configureSearchBar()
        configureTableView()
        fetchProducts()
    }
    
    // MARK: -  helpers
    func configureCollection(){
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemGroupedBackground
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            let heigth = view.frame.height - keyboardHeight
            tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: heigth)
        }
    }
    
    func configureSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellID)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
    }
    
    // MARK: -  API
    func fetchProducts(){
        ProductsService.fetchProducts { (result, error) in
            if let error = error{
                print(error)
                return
            }
            self.products = result.items
        }
    }
    
}


// MARK: -  tables datasource and delegate

extension MainController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath)
        cell.textLabel?.text = "here"
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
    }
    
}
extension MainController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print("cllick")
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        print(searchText)
    }
    
    
}

extension MainController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //print("start editin",searchBar.text)
        }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            
            print("cancel here")
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0)
            //searchBar.text = nil
            //searchBar.showsCancelButton = false

            // Remove focus from the search bar.
            //searchBar.endEditing(true)

            // Perform any necessary work.  E.g., repopulating a table view
            // if the search bar performs filtering.
        }
}

// MARK: -  UICollectionViewDataSource
extension MainController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return products.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCell
        cell.viewModel = ProductCellViewModel(product: products[indexPath.row])
        return cell
    }
}

extension MainController: UISearchControllerDelegate {
   // edit
}

// MARK: -  UICollectionViewDelegateFlowLayout
extension MainController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
  func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 60 ) / 2
        
        return CGSize(width: width, height: width + 30)
    }
    
    
}
