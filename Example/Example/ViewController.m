//
//  ViewController.m
//  Example
//
//  Created by Jonathan Tribouharet
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.crossToArrowButton setCurrentMode:JTHamburgerButtonModeArrow];
}

- (IBAction)didBackButtonTouch:(JTHamburgerButton *)sender
{
    if(sender.currentMode == JTHamburgerButtonModeHamburger){
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeArrow];
    }
    else{
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeHamburger];
    }
}

- (IBAction)didCloseButtonTouch:(JTHamburgerButton *)sender
{
    if(sender.currentMode == JTHamburgerButtonModeHamburger){
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeCross];
    }
    else{
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeHamburger];
    }
}

- (IBAction)didCrossToArrowButtonButtonTouch:(JTHamburgerButton *)sender
{
    if(sender.currentMode == JTHamburgerButtonModeArrow){
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeCross];
    }
    else{
        [sender setCurrentModeWithAnimation:JTHamburgerButtonModeArrow];
    }
}

@end
