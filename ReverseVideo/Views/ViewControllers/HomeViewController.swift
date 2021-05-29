//
//  ViewController.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 08/02/2021.
//

import UIKit
import MobileCoreServices


class HomeViewController: UIViewController {

    // MARK: - Properties
    var videoUrl: URL?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK - IBActions
    @IBAction func selectVideo() {
        presentImagePicker(editingEnabled: false, sourceType: .photoLibrary)
    }
    
    @IBAction func recordVideo() {
        presentImagePicker(editingEnabled: false, sourceType: .camera)
    }
    
    // MARK: - Private Methods
    func presentImagePicker(editingEnabled: Bool, sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.videoQuality = .typeHigh
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentEditorVC(with videoURL: URL) {
        guard let editorVC = storyboard?.instantiateViewController(withIdentifier: EditorViewController.identifier) as? EditorViewController else {
            return
        }
        
        editorVC.videoUrl = videoURL
        editorVC.modalPresentationStyle = .overFullScreen
        present(editorVC, animated: false)
    }
}

// MARK: - Extentions
extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let  url = info[.mediaURL] as? URL else {
            return
        }
        
        videoUrl = url
        picker.dismiss(animated: true) {
            self.presentEditorVC(with: url)
        }
    }
}

extension HomeViewController: UINavigationControllerDelegate {
}


