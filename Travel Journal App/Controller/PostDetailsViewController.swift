//
//  PostDetailsViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 28/08/23.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    //MARK: Outlet
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleOutlet: UILabel!
    @IBOutlet weak var addressOutlet: UILabel!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var postTitleCollectionVieew: UICollectionView!
    @IBOutlet weak var backgourndView: UIView!
    @IBOutlet weak var subTitleOutlet: UILabel!
    @IBOutlet weak var subDescriptionOutLet: UILabel!
    @IBOutlet weak var subDateOutlet: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    //MARK: Variables
    private lazy var viewModel = { HomeViewModel() }()
    var firebaseUId: String = ""
    private var selectedTitlePosition = 0
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initPostCollectionView()
        initPhotoCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationBar()
        setdata()
    }
    
    //MARK: Action
    @IBAction func editPostButton(_ sender: UIButton) {
        menuClick()
    }
    
    //MARK: init Post CollectionView
    private func initPostCollectionView() {
        postTitleCollectionVieew.register(PostTitleCollectionViewCell.nib(), forCellWithReuseIdentifier: AppReuseIdentifier.postTitleCollectionViewCell)
        postTitleCollectionVieew.radius(16)
    }
    
    //MARK: init Photo CollectionView
    private func initPhotoCollectionView() {
        photoCollectionView.register(PostPhotoCollectionViewCell.nib(), forCellWithReuseIdentifier: AppReuseIdentifier.postPhotoCollectionViewCell)
    }
    
    //MARK: set Data
    private func setdata() {
        selectedTitlePosition = 0
        viewModel.getParticularPostData(firebaseUid: firebaseUId) { [self] mData in
            viewModel.data = mData
            coverImage.downloaded(from: viewModel.data?.coverImage ?? "")
            titleOutlet.text = viewModel.data?.titleMain
            addressOutlet.text = viewModel.data?.locationMain.address
            dateOutlet.text = viewModel.data?.dateMain
            backgourndView.topRadius(32)
            setSubData()
        }
    }
    
    //MARK: set SubData
    private func setSubData() {
        subTitleOutlet.text = viewModel.data?.list[selectedTitlePosition].title
        subDescriptionOutLet.text = viewModel.data?.list[selectedTitlePosition].description
        subDateOutlet.text = viewModel.data?.list[selectedTitlePosition].date
        postTitleCollectionVieew.reloadData()
        photoCollectionView.reloadData()
    }
    
    //MARK: get Photo Collection Item Size
    func getPhotoCollectionItemSize() -> CGSize {
        return CGSize(width: ( self.photoCollectionView.frame.size.width - 30 )/3 ,height:( self.photoCollectionView.frame.size.width - 20 )/3)
    }
    
    //MARK: menu Click
    func menuClick() {
        let optionMenu = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: AppStringConstant.edit, style: .default, handler: { [self]
            (alert: UIAlertAction) -> Void in
            guard let addCoverPhotosAndDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.addCoverPhotosAndDetailsViewController) as? AddCoverPhotosAndDetailsViewController else { return }
            addCoverPhotosAndDetailsViewController.editData = viewModel.data
            addCoverPhotosAndDetailsViewController.isHeaderHidden = false
            self.navigationController?.pushViewController(addCoverPhotosAndDetailsViewController, animated: true)
        })
        
        let deleteAction = UIAlertAction(title: AppStringConstant.delete, style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.deleteConfirmationPopup()
        })
        
        let cancelAction = UIAlertAction(title: AppStringConstant.cancel, style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            
        })
        
        optionMenu.addAction(editAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: delete Confirmation Popup
    func deleteConfirmationPopup() {
        let refreshAlert = UIAlertController(title: AppStringConstant.delete, message: "\(AppStringConstant.areYouSureWantToDelete) \(String(describing: viewModel.data?.titleMain ?? "")) ?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: AppStringConstant.ok, style: .default, handler: { [self] (action: UIAlertAction) in
            self.viewModel.deletePost(firebaseUId: viewModel.data?.firebaseUID ?? "") { [self] result in
                self.singleButtonAlertbox(AppStringConstant.error, "\(String(describing: viewModel.data?.titleMain ?? "")) \(AppStringConstant.postDeleteSuccessfully)", AppStringConstant.ok ) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: AppStringConstant.cancel, style: .cancel, handler: { (action: UIAlertAction) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
}

//MARK: UI CollectionView Delegate
extension PostDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == postTitleCollectionVieew {
            selectedTitlePosition = indexPath.row
            collectionView.reloadData()
            setSubData()
            photoCollectionView.reloadData()
        }
        
    }
}

//MARK: UI CollectionView DataSource
extension PostDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == postTitleCollectionVieew {
            return viewModel.data?.list.count ?? 0
        } else {
            return viewModel.data?.list[self.selectedTitlePosition].imagelist.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        if collectionView == postTitleCollectionVieew {
            let temCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppReuseIdentifier.postTitleCollectionViewCell, for: indexPath) as? PostTitleCollectionViewCell
            let index = indexPath.row
            if index == selectedTitlePosition {
                temCell?.configure(viewModel.data?.list[index].title ?? "", true)
            } else {
                temCell?.configure(viewModel.data?.list[index].title ?? "", false)
            }
            cell = temCell
        } else {
            let temCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppReuseIdentifier.postPhotoCollectionViewCell, for: indexPath) as? PostPhotoCollectionViewCell
            temCell?.configure(with: viewModel.data?.list[self.selectedTitlePosition].imagelist[indexPath.row] ?? "")
            cell = temCell
        }
        return cell!
    }
}

//MARK: UI CollectionView Delegate FlowLayout
extension PostDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getPhotoCollectionItemSize()
    }
}
