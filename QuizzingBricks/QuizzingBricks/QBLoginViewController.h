//
//  QBLoginViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-20.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBLoginViewController : UIViewController

- (IBAction)logout:(UIStoryboardSegue *)segue;
- (IBAction)loginButton:(id)sender;

@end
