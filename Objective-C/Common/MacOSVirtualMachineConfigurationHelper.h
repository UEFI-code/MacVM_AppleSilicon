/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The helper that creates various configuration objects exposed in the `VZVirtualMachineConfiguration`.
*/

#ifndef MacOSVirtualMachineConfigurationHelper_h
#define MacOSVirtualMachineConfigurationHelper_h

#import <Virtualization/Virtualization.h>

#ifdef __arm64__

extern uint8_t vm_cpu_num;
extern uint64_t vm_ram_size;

@interface MacOSVirtualMachineConfigurationHelper : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (VZMacOSBootLoader *)createBootLoader;

+ (VZVirtioBlockDeviceConfiguration *)createBlockDeviceConfiguration;
+ (VZMacGraphicsDeviceConfiguration *)createGraphicsDeviceConfiguration;
+ (VZVirtioNetworkDeviceConfiguration *)createNetworkDeviceConfiguration;
+ (VZVirtioSoundDeviceConfiguration *)createSoundDeviceConfiguration;

+ (VZPointingDeviceConfiguration *)createPointingDeviceConfiguration;
+ (VZKeyboardConfiguration *)createKeyboardConfiguration;

@end

#endif /* __arm64__ */
#endif /* MacOSVirtualMachineConfigurationHelper_h */
