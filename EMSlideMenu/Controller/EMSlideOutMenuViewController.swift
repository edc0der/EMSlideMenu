//
//  EMSlideMenuViewController.swift
//  EMSlideMenu
//
//  Created by Eduard Moya on 5/12/18.
//  Copyright © 2018 Eduard Moya. All rights reserved.
//

import UIKit

fileprivate let defaultOffset: CGFloat = 80.0

//MARK:- Slide out Menu
class EMSlideMenuViewController: UIViewController {
    //MARK:- Enums
    enum SlideMenuState {
        case bothCollapsed
        case leftPanelExpanded
        case rightPanelExpanded
    }
    enum SlideMenuSide {
        case left
        case right
        case both
        case none
    }

    //MARK:- Properties
    //MARK:- Panels
    private var navCenter: UINavigationController!
    private var vcCenterPanel: UIViewController!
    private var vcLeftPanel: UIViewController? {
        didSet {
            if availablePanel == .none {
                availablePanel = .left
            } else if availablePanel == .right {
                availablePanel = .both
            }
        }
    }
    private var vcRightPanel: UIViewController? {
        didSet {
            if availablePanel == .none {
                availablePanel = .right
            } else if availablePanel == .left {
                availablePanel = .both
            }
        }
    }
    //MARK:-
    private var tapGesture: UITapGestureRecognizer?

    //MARK:- Computed properties
    private var sidePanelTargetWidth: CGFloat {
        return view.bounds.width - defaultOffset
    }
    private var currentState: SlideMenuState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    private var availablePanel: SlideMenuSide = .left
    private var leftPanelIsAvailable: Bool {
        return (availablePanel == .left || availablePanel == .both)
    }
    private var rightPanelIsAvailable: Bool {
        return (availablePanel == .right || availablePanel == .both)
    }
    private var leftPanelIsPresent: Bool {
        if let vcLeftPanel = vcLeftPanel, vcLeftPanel.view.isDescendant(of: self.view) {
            return true
        }
        return false
    }
    private var rightPanelIsPresent: Bool {
        if let vcRightPanel = vcRightPanel, vcRightPanel.view.isDescendant(of: self.view) {
            return true
        }
        return false
    }
    //Prevents side menu to be displayed when a ViewController's been pushed over the main view controller
    private var shouldAllowPanGestureOnTopViewController: Bool {
        if let topViewController = navCenter.topViewController {
            return topViewController == vcCenterPanel
        }
        return false
    }

    //MARK:- ViewController initialization
    init() {
        super.init(nibName: nil, bundle: nil) //no need for xib file
        view.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- ViewController delegate methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        collapseSidePanels()
    }
}

//MARK:- View setup
extension EMSlideMenuViewController {
    static func create(mainView: UIViewController, availableSideMenu: SlideMenuSide) -> EMSlideMenuViewController {
        let slideVC = EMSlideMenuViewController()

        //Configure center view
        slideVC.vcCenterPanel = mainView
        slideVC.navCenter = UINavigationController(rootViewController: slideVC.vcCenterPanel)
        slideVC.view.addSubview(slideVC.navCenter.view)
        slideVC.addChildViewController(slideVC.navCenter)
        slideVC.navCenter.didMove(toParentViewController: slideVC)

        //configure gesture
        let panGesture = UIPanGestureRecognizer(target: slideVC, action: #selector(EMSlideMenuViewController.handlePanGesture(_:)))
        slideVC.navCenter.view.addGestureRecognizer(panGesture)

        //configure available side menu
        slideVC.availablePanel = availableSideMenu

        switch availableSideMenu {
            case .left:
                slideVC.addLeftBarButton(title: "Left")
            case .right:
                slideVC.addRightBarButton(title: "Right")
            case .both:
                slideVC.addLeftBarButton(title: "Left")
                slideVC.addRightBarButton(title: "Right")
            default:
                break
        }

        return slideVC
    }

    private func addChildSidePanelViewController(_ sidePanelVC: UIViewController) -> Void {
        view.insertSubview(sidePanelVC.view, at: 0)
        addChildViewController(sidePanelVC)
        sidePanelVC.didMove(toParentViewController: self)
    }

    func frameForSidePanel(onSide side: SlideMenuSide) -> CGRect {
        guard side != .none && side != .both else { return .zero }

        if side == .left {
            return CGRect(x: 0.0, y: 0.0, width: sidePanelTargetWidth, height: navCenter.view.bounds.height)
        }
        return CGRect(x: defaultOffset, y: 0.0, width: sidePanelTargetWidth, height: navCenter.view.bounds.height)
    }

    private func getSidePanel(forSide side: SlideMenuSide) -> UIViewController? {
        guard side != .none && side != .both else { return nil }

        if side == .left {
            return vcLeftPanel
        }
        return vcRightPanel
    }

    private func createSidePanel(forSide side: SlideMenuSide) -> UIViewController? {
        guard side != .none && side != .both else { return nil }

        //Change to "if side == .left {...} else" if a different side menu for each side is needed
        //Configure panel properties here (i.e: add delegate)
        let sidePanel: SideMenuViewController = SideMenuViewController.loadFromNib()
        sidePanel.delegate = self

        return sidePanel
    }

    private func setSidePanel(sidePanel: UIViewController, forSide side: SlideMenuSide) -> Void {
        guard side != .none && side != .both else { return }

        if side == .left {
            vcLeftPanel = sidePanel
            removeRightPanelViewController()
        } else {
            vcRightPanel = sidePanel
            removeLeftPanelViewController()
        }
        addChildSidePanelViewController(sidePanel)
    }

    private func addSidePanel(side: SlideMenuSide) -> Void {
        guard side != .none && side != .both else { return }

        if let sidePanel = getSidePanel(forSide: side) ?? createSidePanel(forSide: side) {
            if sidePanel.view.frame.width != sidePanelTargetWidth {
                sidePanel.view.frame = frameForSidePanel(onSide: side)
            }
            setSidePanel(sidePanel: sidePanel, forSide: side)
        }
    }

    private func addLeftPanelViewController() -> Void {
        addSidePanel(side: .left)
    }

    private func addRightPanelViewController() -> Void {
        addSidePanel(side: .right)
    }

    private func removeLeftPanelViewController() -> Void {
        vcLeftPanel?.view.removeFromSuperview()
    }

    private func removeRightPanelViewController() -> Void {
        vcRightPanel?.view.removeFromSuperview()
    }
}

//MARK:- Setup navigation items and actions
extension EMSlideMenuViewController {
    private func addLeftBarButton(image: UIImage?) -> Void {
        let btnBarItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleLeftPanel))
        vcCenterPanel.navigationItem.leftBarButtonItem = btnBarItem
    }

    private func addLeftBarButton(title: String?) -> Void {
        let btnBarItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(toggleLeftPanel))
        vcCenterPanel.navigationItem.leftBarButtonItem = btnBarItem
    }

    private func addRightBarButton(image: UIImage?) -> Void {
        let btnBarItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleRightPanel))
        vcCenterPanel.navigationItem.rightBarButtonItem = btnBarItem
    }

    private func addRightBarButton(title: String?) -> Void {
        let btnBarItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(toggleRightPanel))
        vcCenterPanel.navigationItem.rightBarButtonItem = btnBarItem
    }
}

//MARK:- Setup slide out menu
extension EMSlideMenuViewController: EMSlideMenuViewControllerDelegate {
    typealias SuccessClosure = ((Bool) -> Void)

    @objc func toggleLeftPanel() {
        guard leftPanelIsAvailable else { return }
        let notExpanded = currentState != .leftPanelExpanded

        if notExpanded {
            addLeftPanelViewController()
        }
        animateLeftPanel(shouldExpand: notExpanded)
    }

    @objc func toggleRightPanel() {
        guard rightPanelIsAvailable else { return }
        let notExpanded = currentState != .rightPanelExpanded

        if notExpanded {
            addRightPanelViewController()
        }
        animateRightPanel(shouldExpand: notExpanded)
    }

    func collapseSidePanels() {
        switch currentState {
            case .leftPanelExpanded:
                toggleLeftPanel()
            case .rightPanelExpanded:
                toggleRightPanel()
            default:
                break
        }
    }
}

//MARK:- Animations
extension EMSlideMenuViewController {
    private func animateLeftPanel(shouldExpand: Bool) -> Void {
        guard leftPanelIsPresent else { return }

        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(targetPosition: sidePanelTargetWidth) { _ in
                self.addTapGesture()
            }
        } else {
            animateCenterPanelXPosition(targetPosition: 0, completion: { _ in
                self.currentState = .bothCollapsed
                self.removeLeftPanelViewController()
                self.removeTapGesture()
            })
        }
    }

    private func animateRightPanel(shouldExpand: Bool) -> Void {
        guard rightPanelIsPresent else { return }

        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(targetPosition: -sidePanelTargetWidth) { _ in
                self.addTapGesture()
            }
        } else {
            animateCenterPanelXPosition(targetPosition: 0.0, completion: { _ in
                self.currentState = .bothCollapsed
                self.removeRightPanelViewController()
                self.removeTapGesture()
            })
        }
    }

    private func animateCenterPanelXPosition(targetPosition: CGFloat, completion: SuccessClosure? = nil) -> Void {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.navCenter.view.frame.origin.x = targetPosition
        }, completion: completion)
    }

    private func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            navCenter.view.layer.shadowOpacity = 0.8
        } else {
            navCenter.view.layer.shadowOpacity = 0.0
        }
    }

    private func addTapGesture() -> Void {
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))

        if let tapGesture = self.tapGesture {
            self.navCenter.view.addGestureRecognizer(tapGesture)
        }
    }

    private func removeTapGesture() -> Void {
        if let tapGesture = self.tapGesture {
            self.navCenter.view.removeGestureRecognizer(tapGesture)
        }
    }
}

//MARK:- Handle gestures
extension EMSlideMenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc private func handleTapGesture(_ recognizer: UITapGestureRecognizer) -> Void {
        if currentState != .bothCollapsed {
            collapseSidePanels()
        }
    }

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) -> Void {
        guard availablePanel != .none, shouldAllowPanGestureOnTopViewController else {
            collapseSidePanels()
            return
        }
        let velocity = recognizer.velocity(in: self.view).x
        let gestureIsFromLeftToRight = (velocity > 0)

        switch recognizer.state {
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsFromLeftToRight {
                    if leftPanelIsAvailable && !leftPanelIsPresent {
                        addLeftPanelViewController()
                    }
                } else {
                    if rightPanelIsAvailable && !rightPanelIsPresent {
                        addRightPanelViewController()
                    }
                }
                showShadowForCenterViewController(true)
            }
        case .changed:
            if let rview = recognizer.view {
                var translation = rview.center.x + recognizer.translation(in: view).x
                let centerX = view.center.x

                let translationWillExposeRightSide = translation < centerX
                let translationWillExposeLeftSide = translation > centerX

                let maxLeftTranslation: CGFloat = centerX + sidePanelTargetWidth
                let maxRightTranslation: CGFloat = centerX - sidePanelTargetWidth

                let shouldShowLeftSide = translationWillExposeLeftSide && leftPanelIsPresent
                let shouldShowRightSide = translationWillExposeRightSide && rightPanelIsPresent

                if !shouldShowLeftSide && !shouldShowRightSide {
                    translation = view.center.x
                } else {
                    if gestureIsFromLeftToRight {
                        translation = translation > maxLeftTranslation ? maxLeftTranslation : translation
                    } else {
                        translation = translation < maxRightTranslation ? maxRightTranslation : translation
                    }
                }
                rview.center.x = translation
                recognizer.setTranslation(CGPoint.zero, in: view)
            }
        case .ended:
            if leftPanelIsPresent, let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.frame.origin.x > vcLeftPanel!.view.center.x
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            if rightPanelIsPresent, let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.frame.size.width + rview.frame.origin.x < vcRightPanel!.view.center.x
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
}

//MARK:- Side menu delegate
extension EMSlideMenuViewController: SideMenuViewControllerDelegate {
    func didSelectSideMenuOption() {
        collapseSidePanels()
    }
}
