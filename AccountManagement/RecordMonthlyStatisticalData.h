//
//  RecordMonthlyStatisticalData.h
//  AccountManagement
//
//  Created by 李大爷 on 15/5/23.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordMonthlyStatisticalData : NSObject

@property (nonatomic,retain) NSDate *date;
@property (nonatomic) double spend;
@property (nonatomic) double earn;

-(id)initWithDate:(NSDate *)date
         andMoney:(double)money;
@end
