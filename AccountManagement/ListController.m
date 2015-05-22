//
//  ListController.m
//  AccountManagement
//
//  Created by 李大爷 on 15/1/11.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "ListController.h"

@interface ListController ()

@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowNo=indexPath.row;
    NSString *identifier;
    switch (rowNo)
    {
        case 0:
            identifier=@"monthCell";
            break;
        case 1:
            identifier=@"earnCellWithDate";
            break;
        case 2:
            identifier=@"spendCellWithDate";
            break;
        case 3:
            identifier=@"earnCell";
            break;
        case 4:
            identifier=@"spendCell";
            break;
        default:
            break;
    }
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    UILabel *date=(UILabel *)[cell viewWithTag:1];
    UILabel *week=(UILabel *)[cell viewWithTag:2];
    UIImageView *classificationIcon=(UIImageView *)[cell viewWithTag:3];
    UILabel *classification=(UILabel *)[cell viewWithTag:4];
    UILabel *money=(UILabel *)[cell viewWithTag:5];
    date.text=@"12-22";
    week.text=@"Monday";
    classificationIcon.image=[UIImage imageNamed:@"icon_qtsr_xykhk"];
    classification.text=@"Entertainment";
    money.text=@"1464.00";
    return cell;
}

@end
