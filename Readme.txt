Troy Barrett
COMS-3101 Final Project

MamaBs Note Taking App

Known issues

- All tests including mail, photo and constraints were tested on an iPhone 5S running iOS 7.1. The project is set up using 7.1 as the
Deployment Target and there are 2 warnings because of this. 

- Applications using Launch Screen Files and targetting iOS 7.1 and earlier need to also include a Launch Image in an Asset Catalog.

- Main.storyboard: warning: Attribute Unavailable: Automatic Preferred Max Layout Width is not available on iOS versions prior to 8.0


- Emailing sometimes results in blank email. Added error handling for nil objects but still sometimes appears

- Taking a photo sometimes causes a NSLog message "Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates."

- Icon courtesy of https://c2.staticflickr.com/8/7156/6482774715_dc94b51043_z.jpg
