//
//  HomeViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 18/08/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var topViewOutlet: UIView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var postTableView: UITableView!
    
    //MARK: variables
    lazy var viewModel = { HomeViewModel() }()
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
        getPostList()
    }
    
    //MARK: Action
    @IBAction func filterButton(_ sender: UIButton) {
        openFilterPage()
    }
    
    //MARK: initView
    private func initView() {
        initPostCollectionView()
    }
    
    //MARK: init Post Collectionview
    private func initPostCollectionView() {
        postTableView.estimatedRowHeight = 290
        postTableView.rowHeight =  UITableView.automaticDimension
        postTableView.register(HomeTableViewCell.nib(), forCellReuseIdentifier: AppReuseIdentifier.homeTableViewCell)
    }
    
    //MARK: get Post list
    private func getPostList() {
        startIndicatingActivity()
        viewModel.getPostData() { [self] list in
            if list.isEmpty {
                self.singleButtonAlertbox("", AppStringConstant.noPostFound, AppStringConstant.ok ) {
                }
            }
            viewModel.list = []
            viewModel.list.append(contentsOf: list)
            viewModel.listFilter = list
            postTableView.reloadData()
            stopIndicatingActivity()
        }
    }
    
    //MARK: go to post details screen
    func goToPostDetailsScreen(index: Int) {
        guard let postDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.postDetailsViewController) as? PostDetailsViewController else { return }
        postDetailsViewController.firebaseUId = viewModel.listFilter[index].firebaseUID
        self.navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
    
    //MARK: open filter page
    func openFilterPage() {
        guard let sortByViewController = self.storyboard?.instantiateViewController(identifier: AppStoryboradConstant.sortByViewController) as? SortByViewController  else { return }
        sortByViewController.sortByProtocol = self
        present(sortByViewController, animated: true)
    }
    
    //MARK: filter Menu click
    func menuClick(index: Int) {
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: AppStringConstant.edit, style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.editPost(index)
        })
        
        let deleteAction = UIAlertAction(title: AppStringConstant.delete, style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.deleteConfirmationPopup(index: index)
        })
        
        let cancelAction = UIAlertAction(title: AppStringConstant.cancel, style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            
        })
        
        optionMenu.addAction(editAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: Edit Post
    func editPost(_ index:Int) {
        guard let addCoverPhotosAndDetailsViewController = self.tabBarController?.viewControllers?[1] as? AddCoverPhotosAndDetailsViewController  else { return }
        addCoverPhotosAndDetailsViewController.editData = viewModel.list[index]
        addCoverPhotosAndDetailsViewController.isHeaderHidden = true
        self.tabBarController?.selectedIndex = 1
    }
    
    //MARK: delete confirmation popup
    func deleteConfirmationPopup(index: Int) {
        let refreshAlert = UIAlertController(title: AppStringConstant.delete, message: "\(AppStringConstant.areYouSureWantToDelete) \(viewModel.list[index].titleMain) ?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: AppStringConstant.ok, style: .default, handler: { [self] (action: UIAlertAction) in
            self.viewModel.deletePost(firebaseUId: viewModel.list[index].firebaseUID) { [self] result in
                self.singleButtonAlertbox("", "\(viewModel.list[index].titleMain) \(AppStringConstant.postDeleteSuccessfully)", AppStringConstant.ok ) {
                    
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: AppStringConstant.cancel, style: .cancel, handler: { (action: UIAlertAction) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
}

//MARK: UI TABLEVIEW DATASOURCE
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listFilter.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppReuseIdentifier.homeTableViewCell, for: indexPath) as? HomeTableViewCell
        let index = indexPath.row
        cell?.actionBlock = {
            //Do whatever you want to do when the button is tapped here
            self.goToPostDetailsScreen(index: index )
        }
        cell?.configure(viewModel.listFilter[index].coverImage, title: viewModel.listFilter[index].titleMain, address: viewModel.listFilter[index].locationMain.address, date: viewModel.listFilter[index].dateMain,index: index)
        cell?.menuProtocol = self
        
        return cell!
    }
}

//MARK: UI SEARCH BAR DELEGATE
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.listFilter = []
        if searchText == "" {
            viewModel.listFilter = viewModel.list
        } else {
            for word in viewModel.list {
                if word.titleMain.uppercased().contains(searchText.uppercased()) {
                    viewModel.listFilter.append(word)
                }
            }
        }
        postTableView.reloadData()
    }
}

//MARK: Sort By Protocol
extension HomeViewController: SortByProtocol {
    func aToZ() {
        viewModel.listFilter.sort(by: { $0.titleMain.compare($1.titleMain) == ComparisonResult.orderedDescending})
        postTableView.reloadData()
    }
    
    func zToA() {
        viewModel.listFilter.sort(by: { $0.dateMain.compare($1.dateMain) == ComparisonResult.orderedAscending})
        postTableView.reloadData()
    }
    
    func oldestToNewest() {
        viewModel.listFilter.sort(by: { $0.dateMain.compare($1.dateMain) == ComparisonResult.orderedDescending})
        postTableView.reloadData()
    }
    
    func newestToOldest() {
        viewModel.listFilter.sort(by: { $0.titleMain.compare($1.titleMain) == ComparisonResult.orderedAscending})
        postTableView.reloadData()
    }
}

//MARK: Menu Protocol
extension HomeViewController: MenuProtocol {
    
    func onClickListener(index: Int) {
        self.menuClick(index: index)
    }
}
