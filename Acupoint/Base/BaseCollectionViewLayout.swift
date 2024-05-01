import UIKit

class CollectionViewLayoutFactory {
    static func createLayout() -> UICollectionViewLayout {
        let galleryItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                    heightDimension: .fractionalHeight(1.0)))
        galleryItem.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let galleryGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),heightDimension: .fractionalHeight(1)),
                                                              subitems: [galleryItem])
                                                        
        let gallerySection = NSCollectionLayoutSection(group: galleryGroup)
        gallerySection.orthogonalScrollingBehavior = .groupPagingCentered
      
        let layout = UICollectionViewCompositionalLayout(section: gallerySection)
        return layout
    }
}
