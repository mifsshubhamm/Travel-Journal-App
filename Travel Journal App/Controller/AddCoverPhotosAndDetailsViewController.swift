//
//  AddPhotoViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 18/08/23.
//

import UIKit
import PhotosUI

class AddCoverPhotosAndDetailsViewController: PhotoHelper {
    
    //MARK: Outlet
    @IBOutlet weak var coverPageOutlet: UILabel!
    @IBOutlet weak var coverImageOutlet: UIImageView!
    @IBOutlet weak var titleOutel: PaddingTextField!
    @IBOutlet weak var dateOutlet: PaddingTextField!
    @IBOutlet weak var locationOutlet: PaddingTextField!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionViewHeigth: NSLayoutConstraint!
    
    //MARK: Variables
    lazy var viewModel = { AddCoverPhotosAndDetailsViewModel() }()
    private var editPhotoIndex = -1
    var isHeaderHidden = true
    var isNavigatePhotoScreen = false
    var editData: AddCoverPhotosAndDetailsModel?
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isNavigatePhotoScreen == false {
            removeData()
        }
        if isHeaderHidden {
            hideNavigationBar()
        } else {
            showNavigationBar()
        }
        setEditDataOnUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isNavigatePhotoScreen == false {
            editData = nil
            viewModel.editData = nil
        }
    }
    
    //MARK: Action
    @IBAction func doneButton(_ sender: UIButton) {
        viewModel.validation(viewModel.selectedCoverImage, title: titleOutel.text, dateOutlet.text, location: locationOutlet.text, viewModel.list) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_) :
                    var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                    DispatchQueue.global(qos: .utility).async { [self] in
                        backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: AppStringConstant.finishDoingthistask, expirationHandler: {
                            UIApplication.shared.endBackgroundTask(backgroundTaskID)
                            backgroundTaskID = UIBackgroundTaskIdentifier.invalid
                        })
                        do {
                            if NetworkMonitor.shared.isConnected {
                                self.viewModel.editData = editData
                                self.startIndicatingActivity()
                                self.viewModel.setImage() { result in
                                    DispatchQueue.main.async { [self] in
                                        self.stopIndicatingActivity()
                                        switch result {
                                        case .success(_) :
                                            if editData == nil {
                                                self.singleButtonAlertbox("", AppStringConstant.postAddedSuccessfully, AppStringConstant.ok ){
                                                    self.tabBarController?.selectedIndex = 0
                                                }
                                            } else {
                                                self.singleButtonAlertbox("", AppStringConstant.postUpdatedSuccessfully, AppStringConstant.ok ){ [self] in
                                                    if isHeaderHidden {
                                                        self.tabBarController?.selectedIndex = 0
                                                    } else {
                                                        self.navigationController?.popViewController(animated: true)
                                                    }
                                                }
                                            }
                                            break
                                        case .failure(let error) :
                                            self.singleButtonAlertbox(AppStringConstant.error, error.errorDescription, AppStringConstant.ok ) {
                                            }
                                            break
                                        }
                                    }
                                    
                                }
                            } 
                        }
                        UIApplication.shared.endBackgroundTask(backgroundTaskID)
                        backgroundTaskID = UIBackgroundTaskIdentifier.invalid
                        
                    }
                    break
                case .failure(let error) :
                    self.singleButtonAlertbox(AppStringConstant.error, error.errorDescription, AppStringConstant.ok ) {
                    }
                    break
                }
            }
        }
    }
    
    //MARK: initView
    private func initView() {
        coverImageOutlet.radius(20)
        coverPageOutlet.radius(20)
        coverImage()
        titleOutel.textFieldBackgourndView()
        dateOutlet.textFieldBackgourndView()
        locationOutlet.textFieldBackgourndView()
        initKeyborad()
        initPhotoCollectionView()
    }
    
    //MARK: init Photo collectionview
    private func initPhotoCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = getPhotoCollectionItemSize()
        photoCollectionView.collectionViewLayout = layout
        photoCollectionView.register(PhotoCollectionViewCell.nib(), forCellWithReuseIdentifier: AppReuseIdentifier.photoCollectionViewCell)
        setCollectionViewHeight()
    }
    
    //MARK: set edit data on ui
    private func setEditDataOnUI() {
        if editData != nil {
            coverImageOutlet.downloaded(from: editData?.coverImage ?? "")
            viewModel.tempCoverImage = editData?.coverImage ?? ""
            titleOutel.text = editData?.titleMain
            dateOutlet.text = editData?.dateMain
            locationOutlet.text = editData?.locationMain.address
            viewModel.gMSMapModel = editData?.locationMain
            viewModel.list = []
            for element in editData?.list ?? Array() {
                var subElementTemList = Array<ImageItemModel>()
                for subElement in element.imagelist {
                    subElementTemList.append(ImageItemModel(imageItem: nil, imageUrl: subElement))
                }
                viewModel.list.append(AddPhotosAndDetailModel(title: element.title, date: element.date, description: element.description ,imagelist: subElementTemList))
            }
            setCollectionViewHeight()
            photoCollectionView.reloadData()
        }
    }
    
    //MARK: cover image
    private func coverImage () {
        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
        coverImageOutlet.isUserInteractionEnabled = true
        coverImageOutlet.addGestureRecognizer(cameraTap)
    }
    
    @objc func cameraTapped() {
        imagePickerProtocal = self
        isNavigatePhotoScreen = true
        askPermission(isMultiSelection: false)
    }
    
    //MARK: get photo collection item size
    func getPhotoCollectionItemSize() -> CGSize {
        return CGSize(width: ( self.photoCollectionView.frame.size.width - 20 )/3,height:( self.photoCollectionView.frame.size.width - 20 )/3)
    }
    
    //MARK: go to gms map screen
    func goToGMSMapScreen() {
        guard let gMSMapViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.gMSMapViewController) as? GMSMapViewController else { return }
        gMSMapViewController.gMSProtocol = self
        gMSMapViewController.gMSMapModel = viewModel.gMSMapModel ?? GMSMapModel(country: "", locality: "", subLocality: "", thoroughfare: "", subThoroughfare: "", postalCode: "", address: "", latitude: 0.0, longitude: 0.0)
        isNavigatePhotoScreen = true
        self.navigationController?.pushViewController(gMSMapViewController, animated: true)
    }
    
    //MARK: go to add photos and detail viewcontroller
    func goToAddPhotosAndDetailViewController(index: Int) {
        guard let addPhotosAndDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: AppStoryboradConstant.addPhotosAndDetailViewController) as? AddPhotosAndDetailViewController else { return }
        addPhotosAndDetailViewController.addPhotosAndDetailProtocal = self
        if index == 0 {
            addPhotosAndDetailViewController.data = nil
        } else {
            addPhotosAndDetailViewController.data = viewModel.list[index-1]
        }
        isNavigatePhotoScreen = true
        self.navigationController?.pushViewController(addPhotosAndDetailViewController, animated: true)
    }
    
    //MARK: set collectionview height
    func setCollectionViewHeight() {
        let cellCount = viewModel.list.count + 1
        let lineCount: Int = Int(ceil(Double(cellCount)/3.0))
        let lineHeight = getPhotoCollectionItemSize().height + 10
        photoCollectionViewHeigth.constant = CGFloat(lineCount) * lineHeight
    }
    
    //MARK: remove data
    private func removeData() {
        editPhotoIndex = -1
        coverImageOutlet.image = nil
        titleOutel.text = ""
        dateOutlet.text = ""
        locationOutlet.text = ""
        photoCollectionView.reloadData()
        viewModel.removeAllDataFromViewModel()
    }
    
}

//MARK: UI CollectionView Delegate
extension AddCoverPhotosAndDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        editPhotoIndex = index
        self.goToAddPhotosAndDetailViewController(index: index)
    }
}

//MARK: UI CollectionView DataSource
extension AddCoverPhotosAndDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.list.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppReuseIdentifier.photoCollectionViewCell, for: indexPath) as! PhotoCollectionViewCell
        cell.menuProtocol = self
        let index = indexPath.row
        if index == 0 {
            cell.configure(with: ImageItemModel ( imageItem: UIImage(systemName: AppImageNameConstant.plus) ?? UIImage.add, imageUrl: nil), isCrossHide: true, index: index)
        } else {
            cell.configure(with: viewModel.list[index - 1].imagelist[0], isCrossHide: false, index: index)
        }
        return cell
    }
}

//MARK: UI CollectionView DelegateFlowLayout
extension AddCoverPhotosAndDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getPhotoCollectionItemSize()
    }
    
}

//MARK: Image Picker Protocal
extension AddCoverPhotosAndDetailsViewController: ImagePickerProtocal {
    
    func getImage(_ image: UIImage?, _ imageList: Array<UIImage>?) {
        isNavigatePhotoScreen = false
        if image != nil {
            DispatchQueue.main.async {
                self.viewModel.selectedCoverImage = image
                self.coverImageOutlet.image = image
            }
        }
    }
}

//MARK: UI TextField Delegate
extension AddCoverPhotosAndDetailsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateOutlet {
            openDataPicker()
        } else if textField == locationOutlet {
            locationOutlet.resignFirstResponder()
            self.goToGMSMapScreen()
        }
    }
    
    func openDataPicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.maximumDate = Date()
        dateOutlet.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  44))
        let cancelBtn = UIBarButtonItem(title: AppStringConstant.cancel, style: .plain, target: self, action: #selector(self.cancelButtonClick))
        let doneBtn = UIBarButtonItem(title: AppStringConstant.done, style: .done, target: self, action: #selector(self.doneButtonClick))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelBtn,flexSpace,doneBtn], animated: true)
        dateOutlet.inputAccessoryView = toolbar
    }
    
    @objc func cancelButtonClick() {
        dateOutlet.resignFirstResponder()
    }
    
    @objc func doneButtonClick() {
        if let datePicker = dateOutlet.inputView as? UIDatePicker {
            let dateFormtter = DateFormatter()
            dateFormtter.dateStyle = .medium
            dateOutlet.text = dateFormtter.string(from: datePicker.date)
            dateOutlet.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.titleOutel:
            self.titleOutel.resignFirstResponder()
        default:
            self.titleOutel.resignFirstResponder()
        }
    }
}

//MARK: Add Photos And Detail Protocol
extension AddCoverPhotosAndDetailsViewController: AddPhotosAndDetailProtocol {
    
    func getData(_ data: AddPhotosAndDetailModel) {
        isNavigatePhotoScreen = false
        if editPhotoIndex == 0 {
            viewModel.list.append(data)
        } else {
            viewModel.list[editPhotoIndex - 1] = data
        }
        setCollectionViewHeight()
        photoCollectionView.reloadData()
        
    }
}

//MARK: GMS Map Protocol
extension AddCoverPhotosAndDetailsViewController: GMSMapProtocol {
    
    func getGMSMapData(data: GMSMapModel) {
        isNavigatePhotoScreen = false
        viewModel.gMSMapModel = data
        locationOutlet.text = data.address
    }
}

//MARK: Menu Protocol
extension AddCoverPhotosAndDetailsViewController: MenuProtocol {
    
    func onClickListener(index: Int) {
        viewModel.list.remove(at: index - 1)
        photoCollectionView.reloadData()
    }
}
