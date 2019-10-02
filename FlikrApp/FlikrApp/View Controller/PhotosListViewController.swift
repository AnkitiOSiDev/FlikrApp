//
//  ViewController.swift
//  FlikrApp
//
//  Created by Ankit Shrivastava on 16/05/19.
//  Copyright © 2019 Ankit Shrivastava. All rights reserved.
//

import UIKit

class PhotosListViewController: UIViewController {
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblPhotos: UITableView!
    var viewModel : PhotoListViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PhotoListViewModel(delegate: self)
        setupTextField()
        setupTableView()
    }
    
// MARK: - View Setup
    func setupTableView(){
        tblPhotos.register(PhotosListTableViewCell.nib, forCellReuseIdentifier: PhotosListTableViewCell.identifier)
        tblPhotos.dataSource = self
        tblPhotos.delegate = self
        tblPhotos.estimatedRowHeight = 80.0
        tblPhotos.rowHeight = UITableView.automaticDimension
    }
    
    func setupTextField() {
        txtSearch.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension PhotosListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photosModel?.photos.photo.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: PhotosListTableViewCell.identifier, for: indexPath) as? PhotosListTableViewCell{
            cell.objPhoto = viewModel.photosModel?.photos.photo[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    
}

// MARK: - UITableViewDelegate
extension PhotosListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objPhoto = viewModel.photosModel?.photos.photo[indexPath.row] {
            let controller = Utility.getPhotoDetailsController()
            controller.photo = objPhoto
            present(controller, animated: true)
        }
        
    }
}

// MARK: - PhotoListDelegate
extension PhotosListViewController : PhotoListDelegate {
    func dateFetched() {
        DispatchQueue.main.async {
            self.tblPhotos.reloadData()
        }
    }
}

// MARK: - UITextFieldDelegate
extension PhotosListViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count > 0 else{
            return false
        }
        viewModel.photosModel = nil
        tblPhotos.reloadData()
        viewModel.getPhotos(text: text)
        self.view.endEditing(true)
        return true
    }
}
