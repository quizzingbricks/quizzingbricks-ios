//
//  QBLobbyViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-12.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBLobbyViewController.h"

#import "QBLobby.h"
#import "QBPlayer.h"
#import "QBInviteFriendViewController.h"
#import "QBDataManager.h"
#import "QBCommunicationManager.h"

@interface QBLobbyViewController ()

@end

@implementation QBLobbyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.lobby = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"LobbyView view did load size:%ld",(long)self.lobby.size);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.lobby == nil) {
        NSLog(@"lobby is nil");
        
        QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
        cm.lobbyDelegate = self;
        QBDataManager *dm = [QBDataManager sharedManager];
        [cm getLobbyWithToken:dm.token lobbyId:self.lobbyID];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lobbies:(NSArray *)lobbyList{
    // Not used
}

- (void)getLobbiesFailed{
     // Not used
}

- (void)lobby:(QBLobby *)l{
    self.lobby = l;
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.tableView reloadData];
                   });
    
}

- (void)getLobbyFailed{
    NSLog(@"getLobby failed");
}

- (void)createdLobby:(QBLobby *)l{
     // Not used
}

- (void)createLobbyFailed{
     // Not used
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        //if owner of lobby only return 0..
        return 2;
    }
    return [self.lobby.players count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"AddFriendCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            // Configure the cell...
            
            return cell;
        }
        
        static NSString *CellIdentifier = @"StartCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"PlayerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    QBPlayer *player = [self.lobby.players objectAtIndex:indexPath.row];
    [cell.textLabel setText:player.userID];
    [cell.detailTextLabel setText:player.email];
    NSLog(@"player status: %@ %@", player.status, player.email);
    if ([player.status isEqualToString:@"accepted"]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Players";
    }
    return @"";
}

- (IBAction)inviteDone:(UIStoryboardSegue *)segue
{
    QBDataManager *dm = [QBDataManager sharedManager];
    QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
    cm.friendsDelegate = self;
    QBInviteFriendViewController *ifvc = segue.sourceViewController;
    //ifvc.invitation
    
    //[cm addFriendWithToken:dm.token email:if.email];
}

- (IBAction)inviteCancel:(UIStoryboardSegue *)segue
{
    // why is this method here.. what was my plan O_ O
}

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
    QBInviteFriendViewController *ifvc = [segue destinationViewController];
    NSMutableArray *inLobby = [[NSMutableArray alloc] init];
    for (QBPlayer *player in self.lobby.players) {
        [inLobby addObject:player.userID];
    }
    ifvc.inLobby = inLobby;
    
}
*/

@end
