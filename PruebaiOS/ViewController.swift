//
//  ViewController.swift
//  ProyectoBase
//
//  Created by Osvaldo González on 19/10/20.
//  Copyright © 2020 Osvaldo. All rights reserved.
//

import UIKit
import DropDown

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!

    //search bar
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 20, height: 20))
    
    var productos: [DataProducts] = [] //productos
    var search = "" //variable para busqueda
    var historial : [String] = [] //historial
    
    //permite mostrar el historial
    var dropButton = DropDown()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Buscar producto"
        searchBar.delegate = self
        
        //incrsutamos el search bar en el navigation
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        //llamanos a al servicio de los productos sin parametro de busuqeda
        self.startLoading()
        DispatchQueue.main.async {
            self.listarProductos(busqueda: "")
        }
        
        //configuracon del dropdown
        dropButton.anchorView = searchBar
        dropButton.bottomOffset = CGPoint(x: 0, y:50)
        dropButton.backgroundColor = .white
        dropButton.direction = .bottom
        
        
        
        //se ejecuta cuando se selecciona un item de dropdown
        dropButton.selectionAction = { (index: Int, item: String) in
            
            self.startLoading()
            DispatchQueue.main.async {
                self.listarProductos(busqueda: item)
            }
        }
        
    }
    
    //permite traer los productos desde el servicio
    func listarProductos(busqueda: String){
       
        let token = "adb8204d-d574-4394-8c1a-53226a40876e"
        let apiUrl = "https://00672285.us-south.apigw.appdomain.cloud/demo-gapsi/search?&query=\(busqueda)"
              
             let url = URL(string: apiUrl)
             var request = URLRequest(url: url!)
             request.httpMethod = "GET"
             request.setValue("application/json", forHTTPHeaderField:"Content-Type")
             request.setValue(token, forHTTPHeaderField:"X-IBM-Client-Id")
              
              URLSession.shared.dataTask(with: request) { (data, response, error) in
 
                  if let data = data{
                    
                      do {
                        
                        let datos = try JSONDecoder().decode(Resp.self, from: data)
                        self.productos = datos.items
                        
                        DispatchQueue.main.async {
                           self.stopLoading()
                           self.collectionView.reloadData()
                        }
                          
                      }catch(let error){

                          DispatchQueue.main.async {
                            self.stopLoading()
                            print("error", error.localizedDescription)
                          }
                      }
            
                  }
          
              }.resume()
    }
    
    //filtra la busqueda
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let dt = UserDefaults.standard.array(forKey: "historial")
        self.historial = dt == nil ? [] : dt as! [String]
        dropButton.dataSource = historial
        dropButton.show()
        
        if !searchText.isEmpty {
            self.search = searchText
        }else{
            dropButton.hide()
        }
    
    }

    //se ejecuta la busqueda hasta que presiona el boton buscar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dropButton.hide()
       
        let dt = UserDefaults.standard.array(forKey: "historial")
        self.historial = dt == nil ? [] : dt as! [String]
        
        if !search.isEmpty {
            self.startLoading()
            DispatchQueue.main.async {
                self.listarProductos(busqueda: self.search)
                self.historial.append(self.search)
                UserDefaults.standard.set( self.historial, forKey: "historial")
            }
        }
    }
    
    


}

//se muestra los datos de los productos mediante un CollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.productos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductsCell
        
        ///configuracion del estilo de la celda.....
           cell.layer.cornerRadius = 8
           cell.layer.borderWidth = 0.2
           cell.layer.borderColor = UIColor.lightGray.cgColor

           cell.layer.backgroundColor = UIColor.white.cgColor
           cell.layer.shadowColor = UIColor.gray.cgColor
           cell.layer.shadowOffset = CGSize(width: 0.5, height: 0.8)
           cell.layer.shadowRadius = 1.0
           cell.layer.shadowOpacity = 0.5
           cell.layer.masksToBounds = true
        
        let product = self.productos[indexPath.row]
         
        guard let imageURL = URL(string: product.image) else { return cell}
        guard let imageData = try? Data(contentsOf: imageURL) else { return cell}

       
        
        cell.imageProduct.image = UIImage(data: imageData)
        cell.nameProduct.text = product.title
        cell.priceProduct.text = String(format: "%.2f", product.price)
        
       
        
        
        return cell
    }
}

//permite mostrar el indicador de que se estan cargando los datos
extension UIViewController{
    //activity indicator
    static let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func startLoading() {
        let activityIndicator = UIViewController.activityIndicator
        activityIndicator.center = self.view.center
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.black
        DispatchQueue.main.async {
            self.view.addSubview(activityIndicator)
        }
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
    }

    func stopLoading() {
        let activityIndicator = UIViewController.activityIndicator
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        self.view.isUserInteractionEnabled = true
      }
}
