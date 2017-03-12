//
//  ExploreViewController.swift
//  Instagram
//
//  Created by Thomas Zhu on 3/9/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import ParseUI

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let themeGreen = UIColor(red: 80/255,
                                 green: 229/255,
                                 blue: 162/255,
                                 alpha: 1)
        
        let statusBarBackgroundView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        statusBarBackgroundView.tintColor = themeGreen
        self.view.addSubview(statusBarBackgroundView)
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = themeGreen
            navigationBar.tintColor = UIColor.white
            
            let height = navigationBar.frame.height
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 215 * (height * 0.75) / 58, height: height * 0.75))
            imageView.contentMode = .scaleAspectFit
            
            let image = UIImage(named: "instagram_text")
            imageView.image = image
            
            navigationItem.titleView = imageView
            navigationItem.titleView?.alpha = 0.0
            
            UIView.animate(withDuration: 2.0,
                           delay: 0.0,
                           options: .curveEaseOut,
                           animations: { self.navigationItem.titleView?.alpha = 1.0 },
                           completion: nil
            )
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 1
            layout.minimumLineSpacing = 1
            return layout
        }()
        
        loadPosts()
    }
    
    private func loadPosts() {
        Post.getMostRecentPosts(numberOfPosts: 20) { pfObjects in
            self.posts = pfObjects.map { pfObject in return Post(pfObject: pfObject) }
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCell", for: indexPath) as? PostCell {
            let post = posts[indexPath.row]
            
            if let authorId = post.authorId {
                User.getUserData(userId: authorId) { pfObject in
                    let user = User(pfObject: pfObject)
                    DispatchQueue.main.async {
                        cell.userProfileImageView.file = user.userProfileImageFile
                        cell.userProfileImageView.loadInBackground()
                        cell.userProfileImageView.userId = user.id
                        
                        cell.usernameLabel.text = user.username
                    }
                }
            }
            
            cell.postImageView.file = post.media
            cell.postImageView.loadInBackground()
            
            if let creationTime = post.creationTime {
                let postDateFormatter: DateFormatter = {
                    let f = DateFormatter()
                    f.dateFormat = "MMM d, yyyy hh:mm"
                    return f
                }()
                cell.creationTimeLabel.text = postDateFormatter.string(from: Date(timeIntervalSinceReferenceDate: creationTime))
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 1.0
        let numberOfCellPerRow: CGFloat = 2
        
        let width: CGFloat = collectionView.bounds.width
        return CGSize(width: width / numberOfCellPerRow - (numberOfCellPerRow - 1) * spacing,
                      height: width / numberOfCellPerRow - (numberOfCellPerRow - 1) * spacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
}
