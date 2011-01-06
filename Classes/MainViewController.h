//
//  MainViewController.h
//  ttrack
//
//  Created by Christian Hofstaedtler on 06.01.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {

	IBOutlet UILabel* alertLabel;
	IBOutlet UILabel* stateLabel;
	IBOutlet UISwitch* workSwitch;
	IBOutlet UIImageView* alertImageView;

}

- (IBAction)showInfo:(id)sender;

@end
