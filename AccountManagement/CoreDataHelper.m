//
//  CoreDataHelper.m
//  AccountManagement
//
//  Created by 李大爷 on 15/4/24.
//  Copyright (c) 2015年 李大爷. All rights reserved.
//

#import "CoreDataHelper.h"
#import "InternetHelper.h"
#import "SystemInit.h"

@implementation CoreDataHelper {
    AFHTTPRequestOperationManager *manager;
}

#pragma mark - PATHS
- (NSString *)applicationDocumentsDirectory {
    if (DEBUG==1) {
        NSLog(@"Running %@ '%@'", self.class,NSStringFromSelector(_cmd));
    }
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}

- (NSURL *)applicationStoresDirectory {
    if (DEBUG==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSURL *storesDirectory =
    [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]
     URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {
            if (DEBUG==1) {
                NSLog(@"Successfully created Stores directory");}
        }
        else {NSLog(@"FAILED to create Stores directory: %@", error);}
    }
    return storesDirectory;
}

//获取数据文件路径
- (NSURL *)storeURL {
    if (DEBUG==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:StoreFileName];
}

#pragma mark - SETUP
-(id)init{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    self=[super init];
    if(!self)
        return nil;
    _model=[NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator=[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    _context=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    _importContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_importContext performBlockAndWait:^{
        [_importContext setPersistentStoreCoordinator:_coordinator];
        [_importContext setUndoManager:nil];
    }];
    manager=[InternetHelper getRequestOperationManager];
    return self;
}

-(void)loadStore{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if(_store)
        return;
    NSDictionary *options=@{
        NSMigratePersistentStoresAutomaticallyOption:@YES,
        NSInferMappingModelAutomaticallyOption:@YES,
        NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
    };
    NSError *error=nil;
    _store=[_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                      configuration:nil
                                                URL:[self storeURL]
                                            options:options
                                              error:&error];
    if(!_store){
        NSLog(@"Failed to add store. Error: %@",error);
        abort();
    }else{
        if(DEBUG==1)
            NSLog(@"Successfully added store: %@", _store);
    }
}

-(void)setupCoreData{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    [self loadStore];
    [self checkIfDefaultDataNeedsImporting];
}

#pragma mark - SAVING
-(void)saveContext{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if ([_context hasChanges]) {
        NSError *error=nil;
        if([_context save:&error]) {
            if(DEBUG==1)
                NSLog(@"_context saved changes to persistent store.");
        }
        else
            NSLog(@"Failed to save _context : %@",error);
    }else{
        NSLog(@"Skipped _context save, there are no changes.");
    }
}

#pragma - DATA IMPORT
-(BOOL)isDefaultDataAlreadyImportedForStoreWithURL:(NSURL *)url ofType:(NSString *)type{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    NSError *error;
    NSDictionary *dictionary=[NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type URL:url error:&error];
    NSLog(@"%@",dictionary);
    if(error)
        NSLog(@"Error reading persistent store metadata: %@",error.localizedDescription);
    else{
        NSNumber *defaultDataAlreadyImported=[dictionary valueForKey:@"DefaultDataImported"];
        if(![defaultDataAlreadyImported boolValue]){
            NSLog(@"Default Data has not already been imported!");
            return NO;
        }
    }
    if(DEBUG==1)
        NSLog(@"Default Data has already been imported.");
    return YES;
}

- (void)setDefaultDataAsImportedForStore:(NSPersistentStore*)aStore {
    if (DEBUG==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    // get metadata dictionary
    NSMutableDictionary *dictionary =
    [NSMutableDictionary dictionaryWithDictionary:[[aStore metadata] copy]];
    
    if (DEBUG==1) {
        NSLog(@"__Store Metadata BEFORE changes__ \n %@", dictionary);
    }
    
    // edit metadata dictionary
    [dictionary setObject:@YES forKey:@"DefaultDataImported"];
    
    // set metadata dictionary
    [self.coordinator setMetadata:dictionary forPersistentStore:aStore];
    
    if (DEBUG==1) {NSLog(@"__Store Metadata AFTER changes__ \n %@", dictionary);}
}

- (void)checkIfDefaultDataNeedsImporting {
    if (DEBUG==1)
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    if(![self isDefaultDataAlreadyImportedForStoreWithURL:[self storeURL] ofType:NSSQLiteStoreType]){
        NSLog(@"Importing Default Data... ...");
        SystemInit *init=[[SystemInit alloc] init];
        [init createSystemNullItems];
        [init importDefaultDataFromServer];
        [self setDefaultDataAsImportedForStore:_store];
    }else{
        
    }
}

- (void)importFromXML:(NSURL*)url {
    if (DEBUG==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    self.parser.delegate = self;
    
    NSLog(@"**** START PARSE OF %@", url.path);
    [self.parser parse];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SomethingChanged" object:nil];
    NSLog(@"***** END PARSE OF %@", url.path);
}

#pragma mark -DELEGATE: NSXMLParser
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    if(DEBUG==1)
        NSLog(@"Paser Error: %@",parseError.localizedDescription);
}

//从xml中导入Icon数据
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if(DEBUG==1)
        NSLog(@"Running %@ '%@'",self.class,NSStringFromSelector(_cmd));
    if([elementName isEqualToString:@"item"]){
        NSLog(@"Importing Icon(name=%@, type=%@)",[attributeDict objectForKey:@"name"],[attributeDict objectForKey:@"type"]);
        NSManagedObject *icon=[NSEntityDescription insertNewObjectForEntityForName:@"Icon" inManagedObjectContext:_context];
        [icon setValue:[NSNumber numberWithInteger:[[attributeDict objectForKey:@"type"] integerValue]] forKey:@"type"];
        [icon setValue:UIImagePNGRepresentation([UIImage imageNamed:[attributeDict objectForKey:@"name"]]) forKey:@"idata"];
        [self saveContext];
    }
}
@end
