//
//  «FILENAME»
//  «PROJECTNAME»
//
//  Created by «FULLUSERNAME» on «DATE».
//  Copyright «YEAR» «ORGANIZATIONNAME». All rights reserved.
//

#import "CrudViewController.h"

@interface DetailedCrudViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSManagedObject* managedObject;
    IBOutlet CrudViewController *listViewController;
}

@property (nonatomic, retain) NSManagedObject *managedObject;

@end
