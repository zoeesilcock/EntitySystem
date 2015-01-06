//
//  System.m
//  EntitySystem
//
//  Created by Zoee Silcock on 04/09/14.
//

#import "System.h"

@implementation System

- (id)initWithEntityManager:(EntityManager *)entityManager {
    if ((self = [super init])) {
        self.entityManager = entityManager;
    }
    return self;
}

- (void)update:(float)dt {
    
}

@end