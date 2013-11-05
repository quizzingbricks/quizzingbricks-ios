//
//  QBCommunicationManager.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-05.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBCommunicationManager.h"

@implementation QBCommunicationManager

- (void)loginWithEmail:(NSString *)email password:(NSString *)password
{
    
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.2.6:5000/api/user/login/"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self fetchingFailedWithError:error];
        } else {
            [self receivedJSON:data];
        }
    }];
}

- (void)receivedJSON:(NSData *)objectNotation
{
    NSError *error = nil;
    //NSArray *groups = [GroupBuilder groupsFromJSON:objectNotation error:&error];
    
    if (error != nil) {
        [self fetchingFailedWithError:error];
        
    } else {
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
        if (localError != nil) {
            //*error = localError;
            NSLog(@"error wtf");
        } else {
            NSLog(@"token:%@", [parsedObject objectForKey:@"token"]);
            //save token
            //[self performSegueWithIdentifier:@"loginSegue" sender:self];
            /*dispatch_sync(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
            });*/
            [self.delegate loginToken:[parsedObject objectForKey:@"token"]];
        }
        
    }
}

- (void)fetchingFailedWithError:(NSError *)error
{
    NSLog(@"failed");
    [self.delegate loginFailed];
}

@end
