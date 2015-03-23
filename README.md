# JTHamburgerButton

[![CI Status](http://img.shields.io/travis/jonathantribouharet/JTHamburgerButton.svg)](https://travis-ci.org/jonathantribouharet/JTHamburgerButton)
![Version](https://img.shields.io/cocoapods/v/JTHamburgerButton.svg)
![License](https://img.shields.io/cocoapods/l/JTHamburgerButton.svg)
![Platform](https://img.shields.io/cocoapods/p/JTHamburgerButton.svg)

An animated hamburger button for iOS.

## Installation

With [CocoaPods](http://cocoapods.org/), add this line to your Podfile.

    pod 'JTHamburgerButton', '~> 1.0'

## Screenshots

![Example](./Screens/example.gif "Example View")

## Usage

### Basic usage

```objective-c
#import <UIKit/UIKit.h>

#import <JTHamburgerButton.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet JTHamburgerButton *button;

@end
```

```objective-c
#import "ViewController.h"

@implementation ViewController

- (IBAction)didBackButtonTouch:(JTHamburgerButton *)sender
{
    if(sender.currentMode == JTHamburgerButtonModeHamburger){
        [sender setCurrentMode:JTHamburgerButtonModeBack withAnimation:.3];
    }
    else{
        [sender setCurrentMode:JTHamburgerButtonModeHamburger withAnimation:.3];
    }
}

- (IBAction)didCloseButtonTouch:(JTHamburgerButton *)sender
{
    if(sender.currentMode == JTHamburgerButtonModeHamburger){
        [sender setCurrentMode:JTHamburgerButtonModeCross withAnimation:.3];
    }
    else{
        [sender setCurrentMode:JTHamburgerButtonModeHamburger withAnimation:.3];
    }
}

@end
```

The method `setCurrentMode:WithAnimation` animates the transition from one mode to another. There is also `setCurrentMode` which changes the view without transition;

There are three modes:
- JTHamburgerButtonModeHamburger
- JTHamburgerButtonModeBack
- JTHamburgerButtonModeCross

### Customize the design

- `lineHeight`
- `lineWidth`
- `lineSpacing`
- `lineColor`

After the change of one of this properties you have to call `updateAppearance` to update the view.


## Requirements

- iOS 7 or higher
- Automatic Reference Counting (ARC)

## Author

- [Jonathan Tribouharet](https://github.com/jonathantribouharet) ([@johntribouharet](https://twitter.com/johntribouharet))

## License

JTHamburgerButton is released under the MIT license. See the LICENSE file for more info.
