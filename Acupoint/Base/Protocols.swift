import UIKit

protocol NameSelectionDelegate: AnyObject {
    
    var selectedNameByCell: String { get set }

    func getNameByIndex(_ index: Int)
}

protocol CurrentPageUpdatable: AnyObject {
        
    var currentPage: Int { get set }
    
}

extension CurrentPageUpdatable {
    
    func updateCurrentPage(collectionView: UICollectionView) {
        let centerPoint = CGPoint(x: collectionView.frame.size.width / 2 + collectionView.contentOffset.x,
                                  y: collectionView.frame.size.height / 2 + collectionView.contentOffset.y)
        
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            self.currentPage = indexPath.item
        }
    }
    
    func collectionViewLayoutFromProtocol(collectionView: UICollectionView) -> UICollectionViewLayout {
        let galleryItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                    heightDimension: .fractionalHeight(1.0)))
        galleryItem.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        let galleryGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),heightDimension: .fractionalHeight(1)),
                                                              subitems: [galleryItem])
        
        let gallerySection = NSCollectionLayoutSection(group: galleryGroup)
        gallerySection.orthogonalScrollingBehavior = .groupPagingCentered

        gallerySection.visibleItemsInvalidationHandler = { [weak self] _, _, _ in
            self?.updateCurrentPage(collectionView: collectionView)

            collectionView.visibleCells.forEach { cell in
                if let cell = cell as? InfoCollectionViewCell {
                    let indexPath = collectionView.indexPath(for: cell)
                    if indexPath?.item == self?.currentPage {
                        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                            cell.transform = CGAffineTransform.identity
                        }, completion: nil)
                    } else {
                        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        }, completion: nil)
                    }
                }
            }
        
        }
        
        let layout = UICollectionViewCompositionalLayout(section: gallerySection)
        return layout
    }
}

protocol CanChangeCellSizeAnimate: AnyObject {
    var collectionView: UICollectionView { get
    }
    func dismissAnimate()
}

extension CanChangeCellSizeAnimate {
    func dismissAnimate() {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) {
            UIView.animate(withDuration: 0.4, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [], animations: {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = CGAffineTransform.identity
                }
            })
        }
    }
}
