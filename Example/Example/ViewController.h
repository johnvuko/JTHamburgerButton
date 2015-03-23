//
//  ViewController.h
//  Example
//
//  Created by Jonathan Tribouharet
//

#import <UIKit/UIKit.h>

#import <JTHamburgerButton.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet JTHamburgerButton *backButton;
@property (weak, nonatomic) IBOutlet JTHamburgerButton *closeButton;

@end

