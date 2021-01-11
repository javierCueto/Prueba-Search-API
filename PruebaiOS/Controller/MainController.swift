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
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: -  Lifecycle
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
        configureSearchBar()
    }
    
    // MARK: -  helpers
    func configureCollection(){
        collectionView.register(MainCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .systemGroupedBackground
    }
    
    func configureSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
}

extension MainController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print("here")
    }
    
    
}


// MARK: -  UICollectionViewDataSource
extension MainController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
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
