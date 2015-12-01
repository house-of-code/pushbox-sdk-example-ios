//
//  InboxTableViewController.m
//  PushBoxSDKExample
//
//  Created by Gert Lavsen on 01/12/15.
//  Copyright © 2015 House of Code. All rights reserved.
//

#import "InboxTableViewController.h"
#import <HoCPushBoxSDK.h>
#import <HoCPushMessage.h>
@interface InboxTableViewController ()
@property (nonatomic, strong) NSArray *inbox;
@end

@implementation InboxTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[HoCPushBoxSDK sharedInstance] logEvent:@"inbox opened"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[HoCPushBoxSDK sharedInstance] storedMessagesWithCompletionHandler:^(NSArray *messages) {
        
        self.inbox = messages;
        NSLog(@"Did get %@", messages);
        dispatch_queue_t mainThreadQueue = dispatch_get_main_queue();
        dispatch_async(mainThreadQueue, ^{
            
            [self.tableView reloadData]; // Update table UI
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX(1, self.inbox.count);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.inbox && self.inbox.count > 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
        UILabel *title = (UILabel *)[cell viewWithTag:1];
        UILabel *subTitle = (UILabel *)[cell viewWithTag:2];
        UIView *indicator = [cell viewWithTag:3];
        indicator.layer.cornerRadius = 8;
        indicator.layer.masksToBounds = YES;
        HoCPushMessage *message = [self.inbox objectAtIndex:indexPath.row];
        if (message.interactionDate)
        {
            indicator.hidden = YES;
        }
        else
        {
            indicator.hidden = NO;
        }
        title.text = message.title;
        subTitle.text = message.message;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"NoMessagesCell" forIndexPath:indexPath];
    }
    
    return cell;
}
@end
