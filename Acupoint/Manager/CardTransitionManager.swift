import UIKit

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame: CGRect?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? HomeVC,
              let toViewController = transitionContext.viewController(forKey: .to) as? CommonVC,
              let selectedCell = fromViewController.collectionView.cellForItem(at: fromViewController.collectionView.indexPathsForSelectedItems!.first!) as? HomeCollectionViewCell
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        toViewController.view.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        toViewController.view.alpha = 0
        containerView.addSubview(toViewController.view)
        
        let snapshot = selectedCell.mainVw.snapshotView(afterScreenUpdates: false)
        snapshot?.frame = originFrame ?? .zero
        snapshot?.center = containerView.center
        containerView.addSubview(snapshot!)
        
        selectedCell.mainVw.isHidden = true
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshot?.frame = toViewController.imageView.frame
            toViewController.view.alpha = 1
        }, completion: { _ in
            selectedCell.mainVw.isHidden = false
            snapshot?.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
