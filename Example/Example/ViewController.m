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

- (IBAction)didBackButtonTouch:(JTHamburgerButton *)sender
{
    if(sender.currentMode == JTHamburgerButtonModeHamburger){
        [sender setCurrentMode:JTHamburgerButtonModeArrow withAnimation:.3];
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
