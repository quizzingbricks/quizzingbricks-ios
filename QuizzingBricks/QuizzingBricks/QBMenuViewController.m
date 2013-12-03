//
//  QBMenuViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-20.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBMenuViewController.h"
#import "QBLobbyViewController.h"
#import "QBCreateGameSizeViewController.h"
#import "QBCommunicationManager.h"
#import "QBDataManager.h"
#import "QBLobby.h"

@interface QBMenuViewController ()

@end

@implementation QBMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad Menu");

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    if ([[segue identifier] isEqualToString:@"CancelCreate"]) {
        [self dismissViewControllerAnimated: YES completion:NULL];
        NSLog(@"cancelCreateDismiss");
    }
}

- (IBAction)createLobby:(UIStoryboardSegue *)segue
{
    NSLog(@"createLobby");
    if ([[segue identifier] isEqualToString:@"CreateLobby"]) {
        NSLog(@"CrateLobby segue!");
        QBCreateGameSizeViewController *sVC = [segue sourceViewController];
        
        QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
        cm.lobbyDelegate = self;
        QBDataManager *dm = [QBDataManager sharedManager];
        [cm createLobbyWithToken:dm.token size:(int)sVC.gameSize];
        
    }
}

- (void)lobbies:(NSArray *) lobbyList
{
    for (int i = 0; i < [lobbyList count]; i++)
    {
        NSLog(@"l_id: %ld", (long)[[lobbyList objectAtIndex:i] integerValue]);
    }
    NSLog(@"Menu: lobbies recieved");
}

- (void)getLobbiesFailed
{
    NSLog(@"Menu: lobbies failed");
}

- (void)createdLobby:(QBLobby *)l
{
    /*
    NSLog(@"l_id: %ld", [l_id integerValue]);
    QBCreateGameViewController *createGameViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateGameViewController"];
    createGameViewController.gameSize = [size intValue];
    createGameViewController.lobbyID = [l_id stringValue];
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.navigationController pushViewController:createGameViewController animated:YES];
                   });
    */
    
    NSLog(@"Meny: createdLobby lobbySize:%ld",(long)l.size);
    QBLobbyViewController *lobbyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LobbyViewController"];
    lobbyVC.lobby = l;
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.navigationController pushViewController:lobbyVC animated:YES];
                   });
}
- (void)createLobbyFailed{
    
}

- (void)lobby:(QBLobby *)l
{
    
}
- (void)getLobbyFailed
{
    
}

- (void)inviteFriendSucceded
{
    
}

- (void)inviteFriendFailed
{
    
}

- (void)acceptInviteSucceeded
{
    
}

- (void)acceptInviteFailed
{
    
}

- (void)startGameSucceeded
{
    
}

- (void)startGameFailed
{
    
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
*/

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
