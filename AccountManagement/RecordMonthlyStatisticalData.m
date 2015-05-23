//
//  RecordMonthlyStatisticalData.m
//  AccountManagement
//
//  Created by 李大爷 on 15/5/23.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "RecordMonthlyStatisticalData.h"

@implementation RecordMonthlyStatisticalData

@synthesize date;
@synthesize spend;
@synthesize earn;

-(id)initWithDate:(NSDate *)_date
         andMoney:(double)money {
    self=[super init];
    self.date=_date;
    if(money>0) {
        self.earn=money;
        self.spend=0;
    }else{
        self.earn=0;
        self.spend=-money;
    }
    return self;
}

@end
