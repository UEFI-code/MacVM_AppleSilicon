/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The helper that creates various configuration objects exposed in the `VZVirtualMachineConfiguration`.
*/

#import "MacOSVirtualMachineConfigurationHelper.h"

#import "Error.h"
#import "Path.h"

#ifdef __arm64__

uint8_t vm_cpu_num = 2;
uint64_t vm_ram_size = 2ull * 1024ull * 1024ull * 1024ull;
char vm_bundle_path[128] = {0};

void init_vm_config(void)
{
    char *cpu_env = getenv("VM_CPU_NUM");
    if (cpu_env) vm_cpu_num = (uint8_t)atoi(cpu_env);
    char *mem_env = getenv("VM_MEM_SIZE");
    if (mem_env) vm_ram_size = (uint64_t)atoll(mem_env) * 1024ull * 1024ull * 1024ull;
    char *bundle_env = getenv("VM_BUNDLE_PATH");
    if (bundle_env) strncpy(vm_bundle_path, bundle_env, sizeof(vm_bundle_path) - 1);
    else sprintf(vm_bundle_path, "%s/VM.bundle", getenv("HOME"));
    printf("---init_vm_config----\nCPU: %d\nRAM: %llu\nBundle: %s\n", vm_cpu_num, vm_ram_size, vm_bundle_path);
    sleep(3);
}

@implementation MacOSVirtualMachineConfigurationHelper

+ (VZMacOSBootLoader *)createBootLoader
{
    return [[VZMacOSBootLoader alloc] init];
}

+ (VZVirtioBlockDeviceConfiguration *)createBlockDeviceConfiguration
{
    NSError *error;
    VZDiskImageStorageDeviceAttachment *diskAttachment = [[VZDiskImageStorageDeviceAttachment alloc] initWithURL:getDiskImageURL() readOnly:NO error:&error];
    if (!diskAttachment) {
        abortWithErrorMessage([NSString stringWithFormat:@"Failed to create VZDiskImageStorageDeviceAttachment. %@", error.localizedDescription]);
    }
    VZVirtioBlockDeviceConfiguration *disk = [[VZVirtioBlockDeviceConfiguration alloc] initWithAttachment:diskAttachment];

    return disk;
}

+ (VZMacGraphicsDeviceConfiguration *)createGraphicsDeviceConfiguration
{
    VZMacGraphicsDeviceConfiguration *graphicsConfiguration = [[VZMacGraphicsDeviceConfiguration alloc] init];
    graphicsConfiguration.displays = @[
        // The system arbitrarily chooses the resolution of the display to be 1920 x 1200.
        [[VZMacGraphicsDisplayConfiguration alloc] initWithWidthInPixels:1920 heightInPixels:1200 pixelsPerInch:80],
    ];

    return graphicsConfiguration;
}

+ (VZVirtioNetworkDeviceConfiguration *)createNetworkDeviceConfiguration
{
    VZVirtioNetworkDeviceConfiguration *networkConfiguration = [[VZVirtioNetworkDeviceConfiguration alloc] init];
    networkConfiguration.MACAddress = [[VZMACAddress alloc] initWithString:@"d6:a7:58:8e:78:d5"];

    VZNATNetworkDeviceAttachment *natAttachment = [[VZNATNetworkDeviceAttachment alloc] init];
    networkConfiguration.attachment = natAttachment;

    return networkConfiguration;
}

+ (VZVirtioSoundDeviceConfiguration *)createSoundDeviceConfiguration
{
    VZVirtioSoundDeviceConfiguration *audioDeviceConfiguration = [[VZVirtioSoundDeviceConfiguration alloc] init];

    VZVirtioSoundDeviceInputStreamConfiguration *inputStream = [[VZVirtioSoundDeviceInputStreamConfiguration alloc] init];
    inputStream.source = [[VZHostAudioInputStreamSource alloc] init];

    VZVirtioSoundDeviceOutputStreamConfiguration *outputStream = [[VZVirtioSoundDeviceOutputStreamConfiguration alloc] init];
    outputStream.sink = [[VZHostAudioOutputStreamSink alloc] init];

    audioDeviceConfiguration.streams = @[ inputStream, outputStream ];

    return audioDeviceConfiguration;
}

+ (VZPointingDeviceConfiguration *)createPointingDeviceConfiguration
{
    return [[VZMacTrackpadConfiguration alloc] init];
}

+ (VZKeyboardConfiguration *)createKeyboardConfiguration
{
    if (@available(macOS 14.0, *)) {
        return [[VZMacKeyboardConfiguration alloc] init];
    } else {
        return [[VZUSBKeyboardConfiguration alloc] init];
    }
}

@end

#endif
