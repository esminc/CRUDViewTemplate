//
//  CrudDetailViewController.h
//  CrudView
//
//  Created by MORITA Hideyuki on 09/04/27.
//  Copyright 2009 Eiwa System Management, Inc. All rights reserved.
//

#import "CrudListViewController.h"

@interface CrudDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSManagedObject* managedObject;
    IBOutlet CrudListViewController *listViewController;
}

@property (nonatomic, retain) NSManagedObject *managedObject;

@end
