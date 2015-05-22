//
//  TimeInformationController.m
//  AccountManagement
//
//  Created by 李大爷 on 14/12/18.
//  Copyright (c) 2014年 李大爷. All rights reserved.
//

#import "TimeInformationController.h"

@interface TimeInformationController ()

@end

@implementation TimeInformationController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo=indexPath.row;
    NSString *identifier;
    if(rowNo==0)
        identifier=@"dateItem";
    else if(rowNo==1)
        identifier=@"earnItem";
    else if (rowNo==2)
        identifier=@"spendItem";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (IBAction)closeTimeInformation:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
