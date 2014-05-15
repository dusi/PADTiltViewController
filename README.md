# PADTiltViewController
PADTiltViewController adds device tilt capability to one directional scroll views on iOS.

![PADTiltViewController](https://github.com/dusi/PADTiltViewController/blob/master/Resources/PADTiltViewControllerExample.gif?raw=true)

Link to video: [Youtube](http://youtu.be/7ReIp3V3qV4)

## Installation
PADTiltViewController is available on [CocoaPods](http://cocoapods.org). Just add the following line to your project Podfile:

```ruby
pod 'PADTiltViewController'
```

Alternatively, you can manually add the files into your Xcode project.

## Usage
PADTiltViewController uses `CoreMotion` framework to detect tilt gesture.

Start by subclassing `PADTiltCollectionViewController`, `PADTiltScrollViewController` or `PADTiltTableViewController` based on your application design.
```objective-c
#import <PADTiltViewController/PADTiltViewController.h>

@interface PADTiltTableViewControllerExample : PADTiltTableViewController

@end
```

### Motion manager
Your application should create only a single instance of the `CMMotionManager` class. Multiple instances of this class can affect the rate at which an application receives data from the accelerometer and gyroscope.

Set `pad_motionManager` property to reference this instance (ideally in viewDidLoad).
```objective-c
- (void)viewDidLoad {
  [super viewDidLoad];

  self.pad_motionManager = [(PADAppDelegate *)[[UIApplication sharedApplication] delegate] motionManager];
}
```

### Scroll view
`PADTiltScrollViewController` requires you to manually provide an instance of `UIScrollView`, `UITableView` or `UICollectionView` and assign it to `scrollView` property. You can do this either programmatically or using storyboard/xib file.
```objective-c
- (void)viewDidLoad {
  [super viewDidLoad];

  self.scrollView = self.collectionView;
}
```

### Tilt direction
Optionally you can also set the preferred tilt direction.
```objective-c
// Horizontal collection view
self.pad_tiltDirection = PADTiltDirectionHorizontal;
```

### Start & Stop
Start tilt updates by calling `pad_startReceivingTiltUpdates`.
```objective-c
- (void)startReceivingTiltUpdates {
  [self pad_startReceivingTiltUpdates];

  // Custom logic goes here
}
```

Stop tilt updates by calling `pad_stopReceivingTiltUpdates`.
```objective-c
- (void)stopReceivingTiltUpdates {
  [self pad_stopReceivingTiltUpdates];

  // Custom logic goes here
}
```

There's also an example project. In the example, you can tilt vertical table views and a horizontal collection view.

## Best practices
* Due to the fact that motion sensors cause higher battery drain, always disable tilt when not needed.
* Do not combine gestural with tilt driven scrolling.
* Make users aware of the fact that tilt is enabled using a proper UI (you can take inspiration from the example project).

## How it works

PADTiltViewController uses `PADTiltAdditions` category on `UIViewController` in conjunction with associated objects to extend the behavior of `UIViewController`, `UICollectionViewController` and `UITableViewController`.

## Contributing
See the CONTRIBUTING.md file for how to help out.

## License
PADTiltViewController is released under a MIT License. See LICENSE file for details.
