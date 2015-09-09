//
//  Created by Kamil Jaworski on 16.07.2013.
//  kamil.jaworski@gmail.com
//


#import "PLXDemoViewController.h"
#import "PLXDemoView.h"

@implementation PLXDemoViewController {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView {
    self.view = [[PLXDemoView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
//    self.view.backgroundColor = [UIColor greenColor];
}

@end
