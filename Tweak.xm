/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/
@interface SpringBoard
	-(NSArray *)_rootViewControllers;
@end

//We are hooking into the SpringBoard class
%hook SpringBoard

//This will be the function we are modifying
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//Run the orignal code that is in this function
	%orig;
	//Insert Alert Popup using your Objective C knowledge (please note that if you draw the alert before %orig it will happen before the function excutes and if you run it after the %orig it will run after.)
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                               message:@"This is an alert."
                               preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
	[alert addAction:defaultAction];
	//[self presentViewController:alert animated:YES completion:nil];
	[[self _rootViewControllers][0] presentViewController:alert animated:YES completion:nil];
}

%end