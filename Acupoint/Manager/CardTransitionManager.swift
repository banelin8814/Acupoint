import UIKit

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var originFrame: CGRect?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let selectedCell = fromViewController.view.subviews.compactMap({ $0 as? InfoCollectionViewCell }).first
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        guard let expandedViewController = toViewController as? DetailVC else { return }
        expandedViewController.view.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        expandedViewController.view.alpha = 0
        
        containerView.addSubview(expandedViewController.view)
        
        let cellOriginFrame = selectedCell.convert(selectedCell.bounds, to: nil)
        originFrame = cellOriginFrame
        
        let snapshot = selectedCell.snapshotView(afterScreenUpdates: false)
        snapshot?.frame = cellOriginFrame
        containerView.addSubview(snapshot!)
        
        selectedCell.isHidden = true
        
//        DetailVC.acupointNameLabel.text = selectedCell.titleLabel.text
//        DetailVC.introTextView.text = selectedCell.contentLabel.text
//        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshot?.frame = expandedViewController.view.bounds
            expandedViewController.view.alpha = 1
        }, completion: { _ in
            selectedCell.isHidden = false
            snapshot?.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
