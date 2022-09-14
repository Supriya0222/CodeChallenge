//
//  NasaListViewController.swift
//  CodeChallenge
//
//  Created by Supriya Rajkoomar on 14/09/2022.
//

import UIKit

class NasaListViewController: UIViewController {
    
    @IBOutlet weak var nasaFeedTableView: UITableView!
    
    var loader : UIActivityIndicatorView?
    var loaded = false
    var viewModel : FeedViewModel = FeedViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
        setupTableView()
        
        //Add activity indicator to view while loading content
        loader = addLoader(ToMainView: view)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "The Milky Way"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadFeed()
        
    }
    
}


extension NasaListViewController {
    
    //Method to remove activity indicator
    fileprivate func removeLoader(){
        if let loader = loader{
            loader.removeFromSuperview()
        }
    }
    
    fileprivate func setupTableView(){
        nasaFeedTableView.delegate = self
        nasaFeedTableView.dataSource = self
        nasaFeedTableView.rowHeight = UITableView.automaticDimension
        nasaFeedTableView.estimatedRowHeight = 113
        nasaFeedTableView.register(UINib.init(nibName: "NasaFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "NasaFeedTableViewCell")
    }
    
    fileprivate func loadFeed() {
        //Check if data already retrieved and load from db if so.
        if loaded{
            viewModel.feeds = DBManager.shared.fetchAllItems()
            DispatchQueue.main.async {
                self.removeLoader()
                self.nasaFeedTableView.reloadSections(IndexSet(integersIn: 0...0), with: .automatic)
            }
        }else{
            viewModel.requestCall(completed: { (success, errorMessage) in
                if success{
                    DispatchQueue.main.async {
                        self.loaded = true
                        self.removeLoader()
                        self.nasaFeedTableView.reloadSections(IndexSet(integersIn: 0...0), with: .automatic)
                    }
                }else{
                    if let errorMessage = errorMessage{
                        DispatchQueue.main.async {
                            self.removeLoader()
                            
                            AlertViewUtility.showAlertWithTitle(self, tintColor: nil, title: "Error", message: errorMessage, cancelButtonTitle: "Retry", completion: { [self] (finished) in
                                
                                //Add activity indicator to view while loading content
                                loader = addLoader(ToMainView: view)

                                self.loadFeed()
                            })
                        }
                    }
                }

            })
        }

    }

}


//MARK:- Table view datasource function

extension NasaListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NasaFeedTableViewCell", for: indexPath) as! NasaFeedTableViewCell
        cell.item =  viewModel.feeds[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
}


//MARK:- Table view function

extension NasaListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let nav = navigationController{
            let articleDetailsScreen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            articleDetailsScreen.itemModel = viewModel.feeds[indexPath.row]
            
            nav.pushViewController(articleDetailsScreen, animated: true)
        }
    }
    
    
}
