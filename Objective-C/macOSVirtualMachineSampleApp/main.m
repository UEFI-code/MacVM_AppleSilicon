/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The entry for `macOSVirtualMachineSampleApp`.
*/

#import <Cocoa/Cocoa.h>
void init_vm_config(void);

int main(int argc, const char * argv[]) {
    init_vm_config();
    return NSApplicationMain(argc, argv);
}
