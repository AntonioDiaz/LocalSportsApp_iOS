//
//  MatchEntity+CoreDataProperties.m
//  localsports
//
//  Created by Antonio Díaz Arroyo on 31/1/18.
//  Copyright © 2018 cice. All rights reserved.
//
//

#import "MatchEntity+CoreDataProperties.h"

@implementation MatchEntity (CoreDataProperties)

+ (NSFetchRequest<MatchEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MatchEntity"];
}

@dynamic date;
@dynamic idServer;
@dynamic lastUpdate;
@dynamic scoreLocal;
@dynamic scoreVisitor;
@dynamic state;
@dynamic teamLocal;
@dynamic teamVisitor;
@dynamic week;
@dynamic weekName;
@dynamic competition;
@dynamic court;

@end
