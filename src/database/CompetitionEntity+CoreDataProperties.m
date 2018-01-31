//
//  CompetitionEntity+CoreDataProperties.m
//  localsports
//
//  Created by Antonio Díaz Arroyo on 31/1/18.
//  Copyright © 2018 cice. All rights reserved.
//
//

#import "CompetitionEntity+CoreDataProperties.h"

@implementation CompetitionEntity (CoreDataProperties)

+ (NSFetchRequest<CompetitionEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CompetitionEntity"];
}

@dynamic category;
@dynamic categoryOrder;
@dynamic idCompetitionServer;
@dynamic isFavorite;
@dynamic lastUpdateApp;
@dynamic lastUpdateServer;
@dynamic name;
@dynamic sport;
@dynamic classification;
@dynamic matches;

@end
