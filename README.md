# EMSlideMenu
Slide menu for iOS in Swift 4

## Why?
This project is based on the tutorial by @raywenderlich on ["How to Create Your Own Slide-Out Navigation Panel in Swift"](https://www.raywenderlich.com/177353/create-slide-navigation-panel-swift).

The tutorial's finished product is good, and it's simple. But it didn't completely fit to what I needed, so I did some adjustments.

## Complicated much?

A notable difference is in the pan gesture recognizer selector which translates the main view controller to reveal the side menu. 

Ray's code is quite straightforward:

    case .changed:
		if let rview = recognizer.view {
			rview.center.x = rview.center.x + recognizer.translation(in: view).x
			recognizer.setTranslation(CGPoint.zero, in: view)
		}

What it does is: it moves the center ViewController to the point where the pan gesture gets to. 

It's simplicity is a **pro**, but it has a couple of **cons**:

 - If the touch is beyond the side menu's width you'll see the background of the container.
 - If you start the pan gesture from left to right and then go back left (in the same gesture) you'll see the left side menu instead of the right because the movement is allowed.
 
So, my solution, at the cost of the simplicity is as follows:
 
    case .changed:
        if let rview = recognizer.view {
            var translation = rview.center.x + recognizer.translation(in: view).x
            let centerX = view.center.x

            let translationWillExposeRightSide = translation < centerX
            let translationWillExposeLeftSide = translation > centerX

            let maxLeftTranslation: CGFloat = centerX + sidePanelTargetWidth
            let maxRightTranslation: CGFloat = centerX - sidePanelTargetWidth

            let shouldShowLeftSide = translationWillExposeLeftSide && (leftPanelIsAvailable && leftPanelIsPresent)
            let shouldShowRightSide = translationWillExposeRightSide && (rightPanelIsAvailable && rightPanelIsPresent)

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

### Break it down

Yes, it does look somewhat overloaded, but let's take it little by little.
 
Instead of setting the translation to _rview_ right away, we take in the variable translation:
 
	var translation = rview.center.x + recognizer.translation(in: view).x

Then, as the _gestureIsFromLeftToRight_ variable doesn't necessarily tell us which side will be exposed, we define variables which tell us just that.

	let translationWillExposeRightSide = translation < centerX
    let translationWillExposeLeftSide = translation > centerX 

We also need to constraint the movement as to not allow it to go over the side panel width. So, we define variables which tell us where that maximum translation occurs.

    let maxLeftTranslation: CGFloat = centerX + sidePanelTargetWidth
    let maxRightTranslation: CGFloat = centerX - sidePanelTargetWidth

Since our side panels are optional, and even if they are not nil, they may be instanced but removed from superview. (Will explain my motives for this later). We need to know not only where the movement is going but if there's a panel there to be shown. And so now we ask "Should the left side be shown?" and "Should the right side be shown?" 

	let shouldShowLeftSide = translationWillExposeLeftSide && leftPanelIsPresent
    let shouldShowRightSide = translationWillExposeRightSide && rightPanelIsPresent

Take into consideration that _leftPanelIsPresent_ and _rightPanelIsPresent_ are computed properties I added to the class to see not only if the left or right panel exists, but if they are a subview of the container class EMSlideMenuViewController.

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

Noooow we get to the part where we use all the booleans we defined (LOL).
We have to know if a translation should (not) occur, so whe ask just that and if so, we say "You know what, just stay there where you are":

    if !shouldShowLeftSide && !shouldShowRightSide {
        translation = view.center.x

If that's not the case, and movement HAS to occur, then we ask if it's from left to right, and if the translation exceeds the maximum translation point, we set the translation to the maximum, if not, we say "Just be yourself, translation. Be yourself."

    if gestureIsFromLeftToRight {
        translation = translation > maxLeftTranslation ? maxLeftTranslation : translation

If the movement is from right to left... ditto:

	translation = translation < maxRightTranslation ? maxRightTranslation : translation

And voila!

## Nillifying the nillifying

In Ray's side menu, removing the side menu would remove it completely, _removeFromSuperview_ AND set to _nil_. I decided I wouldn't do that, just to not have to re-instance it all every time the side menu is opened. (I'll get back to this.. I'll sleep on it)

## That's it

Give the side menu a try, clone, download, fork, add an issue for comments on improvements, etc.

