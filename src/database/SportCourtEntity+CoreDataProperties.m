//
//  SportCourtEntity+CoreDataProperties.m
//  localsports
//
//  Created by Antonio Díaz Arroyo on 31/1/18.
//  Copyright © 2018 cice. All rights reserved.
//
//

#import "SportCourtEntity+CoreDataProperties.h"

@implementation SportCourtEntity (CoreDataProperties)

+ (NSFetchRequest<SportCourtEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SportCourtEntity"];
}

@dynamic centerAddress;
@dynamic centerName;
@dynamic courtName;
@dynamic idServer;
@dynamic matches;

@end
