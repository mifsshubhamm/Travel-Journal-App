//
//  AddPhotosAndDetailViewController.swift
//  Travel Journal App
//
//  Created by Shubham Shrivastava on 27/08/23.
//

import UIKit

class AddPhotosAndDetailViewController: PhotoHelper {
    
    //MARK: Outlet
    @IBOutlet weak var addPhotoCollectionView: UICollectionView!
    @IBOutlet weak var titleTextFieldOutlet: PaddingTextField!
    @IBOutlet weak var dateTextFieldOutlet: PaddingTextField!
    @IBOutlet weak var descriptionTextFieldOutlet: PaddingTextField!
    @IBOutlet weak var addPhotoCollectionHeight: NSLayoutConstraint!
    
    //MARK: Variables
    private var imageList = Array<ImageItemModel>()
    var addPhotosAndDetailProtocal: AddPhotosAndDetailProtocol?
    var data: AddPhotosAndDetailModel?
    
    //MARK: lifecycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showNavigationBar()
    }
    
    //MARK: Action
    @IBAction func nextButton(_ sender: UIButton) {
        if titleTextFieldOutlet.text.isNilorEmpty() {
            self.singleButtonAlertbox(AppStringConstant.error, AppStringConstant.pleaseEnterTitle, AppStringConstant.ok ) {
            }
        } else if dateTextFieldOutlet.text.isNilorEmpty() {
            self.singleButtonAlertbox(AppStringConstant.error, AppStringConstant.pleaseSelectDate, AppStringConstant.ok ) {
            }
        } else if descriptionTextFieldOutlet.text.isNilorEmpty() {
            self.singleButtonAlertbox(AppStringConstant.error, AppStringConstant.pleaseEnterDescription, AppStringConstant.ok ) {
            }
        } else if imageList.isEmpty {
            self.singleButtonAlertbox(AppStringConstant.error, AppStringConstant.pleaseSelectAtleastPhoto, AppStringConstant.ok ) {
            }
        } else {
            let data = AddPhotosAndDetailModel(title: titleTextFieldOutlet.text ?? "", date: dateTextFieldOutlet.text ?? "", description: descriptionTextFieldOutlet.text ?? "", imagelist: imageList)
            addPhotosAndDetailProtocal?.getData(data)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: initView
    func initView() {
        setDataOnUi()
        titleTextFieldOutlet.textFieldBackgourndView()
        dateTextFieldOutlet.textFieldBackgourndView()
        descriptionTextFieldOutlet.textFieldBackgourndView()
        initAddPhotoCollection()
        initKeyborad()
    }
    
    //MARK: init Add Photo Collection
    func initAddPhotoCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = getPhotoCollectionItemSize()
        addPhotoCollectionView.collectionViewLayout = layout
        addPhotoCollectionView.register(PhotoCollectionViewCell.nib(), forCellWithReuseIdentifier: AppReuseIdentifier.photoCollectionViewCell)
        setCollectionViewHeight()
    }
    
    //MARK: set Data On Ui
    func setDataOnUi() {
        titleTextFieldOutlet.text = data?.title
        dateTextFieldOutlet.text = data?.date
        descriptionTextFieldOutlet.text = data?.description
        imageList = data?.imagelist ?? Array()
    }
    
    //MARK: get PhotoCollection Item Size
    func getPhotoCollectionItemSize() -> CGSize {
        return CGSize(width: ( self.addPhotoCollectionView.frame.size.width - 20 )/3,height:( self.addPhotoCollectionView.frame.size.width - 20 )/3)
    }
    
    //MARK: set CollectionView Height
    func setCollectionViewHeight() {
        let cellCount = imageList.count + 1
        let lineCount: Int = Int(ceil(Double(cellCount)/3.0))
        let lineHeight = getPhotoCollectionItemSize().height + 10
        addPhotoCollectionHeight.constant = CGFloat(lineCount) * lineHeight
    }
    
    //MARK: click On Image Picker
    func clickOnImagePicker() {
        imagePickerProtocal = self
        askPermission(isMultiSelection: true)
    }
}

//MARK: UI CollectionView Delegate
extension AddPhotosAndDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.clickOnImagePicker()
        }
    }
}

//MARK: UI CollectionView DataSource
extension AddPhotosAndDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppReuseIdentifier.photoCollectionViewCell, for: indexPath) as! PhotoCollectionViewCell
        cell.menuProtocol = self
        let index = indexPath.row
        if index == 0 {
            cell.configure(with: ImageItemModel ( imageItem: UIImage(systemName: AppImageNameConstant.plus) ?? UIImage.add, imageUrl: nil), isCrossHide: true, index: index)
        } else {
            cell.configure(with: imageList[index - 1], isCrossHide: false, index: index)
        }
        return cell
    }
}

//MARK: UI CollectionView Delegate FlowLayout
extension AddPhotosAndDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getPhotoCollectionItemSize()
    }
    
}

//MARK: Image Picker Protocal
extension AddPhotosAndDetailViewController: ImagePickerProtocal {
    
    func getImage(_ image: UIImage?, _ imageList: Array<UIImage>?) {
        if image != nil {
            self.imageList.append(ImageItemModel(imageItem:  image, imageUrl: ""))
        } else if imageList != nil {
            for imageElment in imageList! {
                self.imageList.append(ImageItemModel(imageItem:  imageElment, imageUrl: ""))
            }
        }
        DispatchQueue.main.async {
            self.addPhotoCollectionView.reloadData()
            self.setCollectionViewHeight()
        }
    }
}

//MARK: UI TextField Delegate
extension AddPhotosAndDetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == dateTextFieldOutlet {
            openDataPicker()
        }
    }
    
    func openDataPicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        datePicker.maximumDate = Date()
        dateTextFieldOutlet.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:  44))
        
        let cancelBtn = UIBarButtonItem(title: AppStringConstant.cancel, style: .plain, target: self, action: #selector(self.cancelButtonClick))
        
        let doneBtn = UIBarButtonItem(title: AppStringConstant.done, style: .done, target: self, action: #selector(self.doneButtonClick))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelBtn,flexSpace,doneBtn], animated: true)
        dateTextFieldOutlet.inputAccessoryView = toolbar
    }
    
    @objc func cancelButtonClick() {
        dateTextFieldOutlet.resignFirstResponder()
    }
    
    @objc func doneButtonClick() {
        if let datePicker = dateTextFieldOutlet.inputView as? UIDatePicker {
            let dateFormtter = DateFormatter()
            dateFormtter.dateStyle = .medium
            dateTextFieldOutlet.text = dateFormtter.string(from: datePicker.date)
            dateTextFieldOutlet.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.titleTextFieldOutlet:
            self.descriptionTextFieldOutlet.becomeFirstResponder()
        case self.descriptionTextFieldOutlet:
            self.descriptionTextFieldOutlet.resignFirstResponder()
        default:
            self.descriptionTextFieldOutlet.resignFirstResponder()
        }
    }
}

//MARK: Menu Protocol
extension AddPhotosAndDetailViewController: MenuProtocol {
    
    func onClickListener(index: Int) {
        imageList.remove(at: index - 1)
        addPhotoCollectionView.reloadData()
    }
}
