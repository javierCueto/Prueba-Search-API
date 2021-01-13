//
//  MainController.swift
//  Prueba-Search-API
//
//  Created by Javier Cueto on 11/01/21.
//  Copyright © 2021 Osvaldo. All rights reserved.
//

import UIKit

class MainController: UIViewController  {
    // MARK: -  Properties
    private let reuseIdentifier = "mainCellID"
    private let tableCellID = "mainTableCellID"
    private let searchController = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private lazy var viewWidth = view.frame.width
    private lazy var viewHeight = view.frame.height
    private lazy var collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: viewWidth , height: viewHeight), collectionViewLayout: UICollectionViewFlowLayout())
    private var products = [Product]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    private var productHistory = [String]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var filterProductHistory = [String]()
    var textSearh: String = ""
    var isChildController = false
    
    private var inSearchMode: Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    
    // MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurareNotifications()
        configureCollection()
        configureSearchBar()
        configureTableView()
        fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.alpha = 0
        searchController.searchBar.text = textSearh
        fetchProductHistory()
    }
    
    // MARK: -  helpers
    func configureCollection(){
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.tableView.alpha = 1
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
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
        
        searchController.searchBar.text = textSearh
        
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.alpha = 0
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableCellID)
        tableView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        view.addSubview(tableView)
    }
    
    func configurareNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: -  API
    func fetchProducts(){
        let toSearch = searchController.searchBar.text ?? ""
        shouldPresentLoadingView(true)
        ProductsService.fetchProducts(toSearch: toSearch) { (result, error) in
            if let error = error{
                print(error)
                return
            }
            self.products = result.items
            self.shouldPresentLoadingView(false)
        }
    }
    
    func fetchProductHistory(){
        ProductsService.getProductHistory { (productHistory) in
            self.productHistory = productHistory
        }
    }
    
    func goToSearh(toSearch: String){
        let controller = MainController()
        controller.textSearh = toSearch
        controller.isChildController = true
        self.navigationController?.pushViewController(controller, animated: true)
        
        
        if !isChildController {
            self.searchController.searchBar.text = ""
        }
       
    }
    
}


// MARK: -  tables datasource and delegate

extension MainController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Historial"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterProductHistory.count : productHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellID, for: indexPath)
        cell.textLabel?.text =  inSearchMode ? filterProductHistory[indexPath.row] : productHistory[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "clock")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toSearchText = inSearchMode ? filterProductHistory[indexPath.row] : productHistory[indexPath.row]
        goToSearh(toSearch: toSearchText)
    }
    
}
extension MainController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filterProductHistory = productHistory.filter({
            $0.contains(searchText) || $0.lowercased().contains(searchText)
        })
        self.tableView.reloadData()
    }
    
    
}

extension MainController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //print("start editin",searchBar.text)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text else {return}
        productHistory.insert(searchText, at: 0)
        ProductsService.setProductHistory(history: productHistory) { (true) in
            self.goToSearh(toSearch: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("cancel here")
        UIView.animate(withDuration: 0.47) {
            self.tableView.alpha = 0
        }
        
    }
}

// MARK: -  UICollectionViewDataSource
extension MainController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return products.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCell
        cell.viewModel = ProductCellViewModel(product: products[indexPath.row])
        return cell
    }
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
