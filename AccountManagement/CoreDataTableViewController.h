//
//  CoreDataTableViewController.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/6.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoManager.h"

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultController;

-(void)performFetch;

@end
