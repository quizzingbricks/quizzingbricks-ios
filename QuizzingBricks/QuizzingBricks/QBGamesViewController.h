//
//  QBGamesViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-22.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBCommunicationManager.h"

@interface QBGamesViewController : UITableViewController <QBLobbyComDelegate, QBGameComDelegate>

@property (strong, nonatomic) NSArray *lobbies;
@property (strong, nonatomic) NSArray *games;

@end
