# Audio Stream Volume Management

## Project Introduction

This project is developed based on Huawei's official demo code for [audio-volume-management](https://gitcode.com/HarmonyOS_Samples/audio-volume-management).

This case demonstrates how to get volume, set volume, use gestures to adjust volume, customize volume panels, disable volume keys, and implement automatic volume balancing.

## Preview
<img src="./screenshots/device/screenshot.png" width="320">

## Usage Instructions
1. Install and enter the application.
2. After entering the playback page, click the play button to play music. Click the icon in the upper right corner to enter volume settings:
   - Click the switch component for disabling volume keys to disable system volume keys
   - Slide the audio stream volume slider to increase or decrease music volume
   - Enable automatic volume balancing to smooth audio volume and avoid sudden changes
   - Adjust compression strength to control the intensity of the balancing effect

## Project Structure

```
├──entry/src/main/ets/
│  ├──common                           // Common modules
│  │  └──CommonConstants.ets           // Constants class
│  ├──components                       // Component modules
│  │  ├──AVVolumePanelView.ets         // System volume panel component
│  │  ├──ControlAreaComponent.ets      // Playback control area component
│  │  ├──SystemVolumePanelView.ets     // Custom system volume panel component
│  │  └──VolumePanelView.ets           // Custom volume panel component
│  ├──entryability
│  │  └──EntryAbility.ets              // Ability lifecycle callbacks
│  ├──entrybackupability
│  │  └──EntryBackupAbility.ets        // EntryBackupAbility lifecycle callbacks
│  ├──model                        
│  │  └──SongData.ets                  // Song entity
│  ├──pages
│  │  ├──Index.ets                     // Home page                             
│  │  └──Player.ets                    // Playback page
│  ├──player                             
│  │  ├──AudioRendererController.ets   // AudioRenderer playback control
│  │  └──AudioVolumeController.ets     // AudioVolumeManager volume management
│  ├──utils
│  │  ├──ColorTools.ets                // Background color tools
│  │  ├──Logger.ets                    // Logging tools
│  │  └──MediaTools.ets                // Media tools
│  └──viewModel
│     └──PlayerViewModel.ets           // Playback page data
└──entry/src/main/resources            // Application static resources directory
```

## Implementation Details
1. Manage system volume through audioVolumeManager, slide custom volume bars to adjust system volume size, and monitor system volume changes.
2. Manage audio stream volume through audioRenderer, slide audio stream volume bars to adjust audio stream volume size.
3. Intercept volume keys by registering inputConsumer.on('keyPressed').
4. Implement automatic volume balancing function to dynamically compress audio volume, avoid sudden volume changes, and provide a smoother listening experience.

## Related Permissions

Not applicable

## Dependencies

Not applicable

## Constraints and Limitations

1. This example only runs on standard systems, supported devices: Huawei phones.
2. HarmonyOS system: HarmonyOS 6.0.0 Release and above.
3. DevEco Studio version: DevEco Studio 6.0.0 Release and above.
4. HarmonyOS SDK version: HarmonyOS 6.0.0 Release SDK and above.