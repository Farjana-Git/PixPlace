//
//  ViewController.swift
//  CollectionView
//
//  Created by Bjit on 13/12/22.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    var transition: Bool = true
    
    var images: [UIImage] = []
    
//    let sky = ["blue_sky", "yellow_sky", "white_sky", "red_sky", "blue_sky", "yellow_sky", "white_sky", "red_sky", "blue_sky", "yellow_sky", "white_sky", "red_sky", "blue_sky", "yellow_sky", "white_sky", "red_sky", "blue_sky", "yellow_sky", "white_sky", "red_sky", "blue_sky", "yellow_sky", "white_sky", "red_sky", "blue_sky", "yellow_sky", "white_sky", "red_sky", "blue_sky", "yellow_sky", "white_sky", "red_sky", "blue_sky", "yellow_sky", "white_sky", "red_sky", "blue_sky", "yellow_sky", "white_sky", "red_sky"]

    @IBOutlet weak var collectionView: UICollectionView!
    
    let sectionLeftRightPadding: CGFloat = 10
    let interItemSpacing: CGFloat = 20
    
    @IBOutlet weak var gridBtn: UIButton!
    @IBOutlet weak var listBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        //collectionView.collectionViewLayout = list()
        collectionView.collectionViewLayout = grid()
    }
    
    func setLayout(transition: UICollectionViewLayout) {
        
        gridBtn.isUserInteractionEnabled = false
        listBtn.isUserInteractionEnabled = false
        
        collectionView.startInteractiveTransition(to: transition, completion: {[weak self] _, _ in
            guard let self = self else {
                return
            }
            
            self.gridBtn.isUserInteractionEnabled = true
            self.listBtn.isUserInteractionEnabled = true
            
        })
        
        
//        if transition == true {
//            transition = false
//        } else {
//            transition = true
//        }
        
        collectionView.finishInteractiveTransition()
    }
    
    @IBAction func gridBtnMethod(_ sender: Any) {
        setLayout(transition: grid())
    }
    
    
    @IBAction func listBtnMethod(_ sender: Any) {
        
//        listBtn.isUserInteractionEnabled = false
//        gridBtn.isUserInteractionEnabled = false
//
//        collectionView.startInteractiveTransition(to: list(), completion: {[weak self] _, _ in
//            guard let self = self else {
//                return
//            }
//
//            self.listBtn.isUserInteractionEnabled = true
//            self.gridBtn.isUserInteractionEnabled = true
//        })
//
//        collectionView.finishInteractiveTransition()
        setLayout(transition: list())
    }
    
    
    @IBAction func addBtnMethod(_ sender: Any) {
        
        let option = UIAlertController(title: "Select One", message: "", preferredStyle: .actionSheet)

        let showImagePickerAlert = UIAlertAction(title: "Image Picker", style: .default) { (action) in
                self.showImagePicker()
            }

        let showPHPickerAlert = UIAlertAction(title: "PH Picker", style: .default) { (action) in
                self.showPHPicker()
            }

        let showCancel = UIAlertAction(title: "Cancel", style: .cancel)

            option.addAction(showImagePickerAlert)
            option.addAction(showPHPickerAlert)
            option.addAction(showCancel)

            present(option, animated: true, completion: nil)
        
    }
    
        
    func grid() -> UICollectionViewLayout {
    
        let insets = NSDirectionalEdgeInsets(top:3, leading: 3, bottom: 3, trailing: 3)
        
        let itemOneSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        let itemOne = NSCollectionLayoutItem(layoutSize: itemOneSize)
        
        itemOne.contentInsets = insets
        
        let itemTwoSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1))
        let itemTwo = NSCollectionLayoutItem(layoutSize: itemTwoSize)
        
        itemTwo.contentInsets = insets
        
        let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/2))
        
        let outerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: outerGroupSize, subitems: [itemOne, itemTwo])
        
        let section = NSCollectionLayoutSection(group: outerGroup)
        
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return compositionalLayout
    }
        
    
    func list() -> UICollectionViewLayout {
        
       let insets = NSDirectionalEdgeInsets(top:3, leading: 3, bottom: 3, trailing: 3)
       
       let firstItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
       let firstItem = NSCollectionLayoutItem(layoutSize: firstItemSize)
       
       firstItem.contentInsets = insets
       
       let secondItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
       let secondItem = NSCollectionLayoutItem(layoutSize: secondItemSize)
       
       secondItem.contentInsets = insets
       
       let outerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
       
       let outerGroup = NSCollectionLayoutGroup.vertical(layoutSize: outerGroupSize, subitems: [firstItem, firstItem])
       
       let section = NSCollectionLayoutSection(group: outerGroup)
       
       let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
       
       return compositionalLayout
        
    }
    
    func showImagePicker() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func showPHPicker() {
        
        var phPickerConfig = PHPickerConfiguration()
        
        phPickerConfig.selectionLimit = 10
        
        phPickerConfig.filter = .images
        
        let phPicker = PHPickerViewController(configuration: phPickerConfig)
        
        phPicker.delegate = self
        
        present(phPicker, animated: true)
    }
}


extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        
        let actionSheet = UIAlertController(title: "Select One!", message: "", preferredStyle: .actionSheet)
        
        let save = UIAlertAction(title: "Save Picture", style: .default) {(action) in
            
            let fileManager = FileManager.default
            
            guard let documentDirURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            
            let folderURL = documentDirURL.appendingPathComponent("rootfolder")
                .appendingPathComponent("images")
            
            print(folderURL.path)
            
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            }
            catch {
                print(folderURL.path)
            }
            
            let date = Date()
            
            let image = self.images[indexPath.row]
            
            let imageURL = folderURL.appendingPathComponent("image\(date).png")
            
            let imageData = image.pngData()
            
            try? imageData!.write(to: imageURL)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(save)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
  
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let pet = images[indexPath.row]
        
//        cell.imgView.image = UIImage(named: pet)
        cell.imgView.image = pet
        
        return cell
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let numberOfcellsInSection: CGFloat = 3
        let availableWidth = collectionView.bounds.width - (sectionLeftRightPadding * 2) - (interItemSpacing * numberOfcellsInSection - 1)
        
        let cellDimension = availableWidth/numberOfcellsInSection
        
        return CGSize(width: 100, height: 100)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: sectionLeftRightPadding, bottom: 30, right: sectionLeftRightPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 50
    }
}


extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] (image, error) in
                
                guard let self = self else { return }
                
                if let image = image as? UIImage {
                    self.images.append(image)
//                    print(self.images.count)
                    DispatchQueue.main.async {
//                        self.imgView.image = image
                        self.collectionView.reloadData()
                    }
                }
//                print(self.images.count)
            })
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            images.append(originalImage)
            self.collectionView.reloadData()
        }
        
        picker.dismiss(animated: true)
    }
}



