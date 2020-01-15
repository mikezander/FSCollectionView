//
//  UsersViewController.swift
//  FlightSafety-CollectionView
//
//  Created by Michael Alexander on 1/15/20.
//  Copyright © 2020 Michael Alexander. All rights reserved.
//
import UIKit

class UsersViewController: UICollectionViewController {
 
    var users = [User]()
    let cellId = "userCellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupCollectionView()
        fetchUsers()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = UIColor.black
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInsetReference = .fromSafeArea

        let columns: CGFloat = 3
        let spacing: CGFloat = (columns - 1) * layout.minimumLineSpacing // for 3 columns there will be 2 spaces of 10 (default minimum spacing)
        let width = (view.frame.size.width - spacing) / columns
        layout.itemSize = CGSize(width: width, height: width)
    }

    private func fetchUsers() {
        FlightSafety.shared.fetchUsers {  (error, users) in
            if let error = error {
                print("Failed to fetch users:", error) // handle error with alert
                return
            }
            
            guard var users = users else { return }
            self.removeUsersContainingC(users: &users)
            self.sortUsersAlphabetically(users: &users)
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
     private func removeUsersContainingC(users: inout [User]) {
        users = users.filter { !$0.name.lowercased().contains("c") }
    }

     private func sortUsersAlphabetically(users: inout [User]){
        users = users.sorted { $0.name < $1.name }
    }
    
    private func deleteUser(indexPath: IndexPath) {
        self.collectionView.deleteItems(at: [indexPath])
        self.users.remove(at: indexPath.row)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete User", message: nil, preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.deleteUser(indexPath: indexPath)
        }
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
