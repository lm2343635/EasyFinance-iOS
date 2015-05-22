//
//  DaoTemplate.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/26.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "DaoTemplate.h"

@implementation DaoTemplate

-(id)init {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self=[super init];
    _delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    _cdh=[_delegate cdh];
    return self;
}

-(NSManagedObject *)getByPredicate:(NSString *)predicate
                    withEntityName:(NSString *)entityName {
    if(DEBUG==1&&DAO_DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSFetchRequest *request=[[NSFetchRequest alloc] initWithEntityName:entityName];
    request.predicate=[NSPredicate predicateWithFormat:predicate];
    request.fetchBatchSize=15;
    NSError *error=nil;
    NSArray *objects=[self.cdh.context executeFetchRequest:request error:&error];
    if(error)
        NSLog(@"Error in searching user: %@",error);
    if(objects.count>0)
        return [objects objectAtIndex:0];
    return nil;
}

@end
