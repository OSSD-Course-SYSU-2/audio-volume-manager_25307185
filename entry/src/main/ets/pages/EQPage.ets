/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstants } from '../common/CommonConstants';
import { EQMode } from '../viewModel/PlayerViewModel';
import router from '@ohos.router';

@Builder
export function EQPageBuilder(name: string, param: Object) {
  EQPage()
}

@Entry
@Component
struct EQPage {
  @StorageLink('eqEnabled') eqEnabled: boolean = CommonConstants.DEFAULT_EQ_ENABLED;
  @StorageLink('eqMode') eqMode: number = CommonConstants.DEFAULT_EQ_MODE;
  @StorageLink('eqBands') eqBands: number[] = CommonConstants.DEFAULT_EQ_PRESET;
  
  @State presetOptions: string[] = [
    $r('app.string.eq_preset_flat'),
    $r('app.string.eq_preset_rock'),
    $r('app.string.eq_preset_pop'),
    $r('app.string.eq_preset_jazz'),
    $r('app.string.eq_preset_classical'),
    $r('app.string.eq_preset_custom')
  ];
  
  @State selectedPresetIndex: number = 0;

  aboutToAppear(): void {
    this.selectedPresetIndex = this.eqMode;
  }

  build() {
    Column() {
      // Header
      Row() {
        Image($r('app.media.chevron_left'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back();
          })
        
        Text($r('app.string.eq_settings'))
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#182431')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        
        // Placeholder for alignment
        Image($r('app.media.chevron_left'))
          .width(24)
          .height(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('#FFFFFF')
      .borderRadius({ topLeft: 12, topRight: 12 })

      Scroll() {
        Column() {
          // EQ Enable Switch
          Row() {
            Text($r('app.string.eq_enable'))
              .fontSize(16)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
            Toggle({ type: ToggleType.Switch, isOn: this.eqEnabled })
              .onChange((isOn: boolean) => {
                this.eqEnabled = isOn;
              })
          }
          .height(56)
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .padding({ left: 16, right: 16 })
          .margin({ top: 8 })

          Divider()
            .backgroundColor('#F1F3F5')
            .width('100%')

          // Preset Selector
          Column() {
            Text($r('app.string.eq_preset'))
              .fontSize(16)
              .fontColor('#182431')
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 8 })
              .width('100%')
              .padding({ left: 16, right: 16 })

            // Preset options
            Column() {
              ForEach(this.presetOptions, (item: string, index: number) => {
                Row() {
                  Text(item)
                    .fontSize(14)
                    .fontColor(this.selectedPresetIndex === index ? '#0A59F7' : '#182431')
                    .fontWeight(this.selectedPresetIndex === index ? FontWeight.Medium : FontWeight.Normal)
                  
                  if (this.selectedPresetIndex === index) {
                    Image($r('app.media.ic_check'))
                      .width(20)
                      .height(20)
                      .margin({ left: 8 })
                  }
                }
                .width('100%')
                .height(48)
                .justifyContent(FlexAlign.SpaceBetween)
                .padding({ left: 16, right: 16 })
                .backgroundColor(this.selectedPresetIndex === index ? '#F0F7FF' : '#FFFFFF')
                .onClick(() => {
                  this.selectedPresetIndex = index;
                  this.eqMode = index;
                  this.loadPreset(index);
                })
              })
            }
            .borderRadius(8)
            .backgroundColor('#FFFFFF')
            .margin({ left: 16, right: 16, bottom: 16 })
            .shadow({ radius: 4, color: '#1A000000', offsetX: 0, offsetY: 2 })
          }
          .margin({ top: 16 })

          Divider()
            .backgroundColor('#F1F3F5')
            .width('100%')

          // EQ Bands Sliders
          Column() {
            Text($r('app.string.eq_description'))
              .fontSize(14)
              .fontColor('#666666')
              .margin({ bottom: 16 })
              .width('100%')
              .padding({ left: 16, right: 16 })

            // EQ Band sliders
            ForEach(CommonConstants.EQ_BAND_FREQUENCIES, (frequency: number, index: number) => {
              Column() {
                Row() {
                  Text(CommonConstants.EQ_BAND_LABELS[index])
                    .fontSize(14)
                    .fontColor('#182431')
                    .fontWeight(FontWeight.Medium)
                  
                  Text(`${this.eqBands[index].toFixed(1)} ${$r('app.string.eq_db')}`)
                    .fontSize(14)
                    .fontColor('#0A59F7')
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .width('100%')
                .margin({ bottom: 8 })

                Slider({
                  value: this.eqBands[index],
                  min: CommonConstants.MIN_EQ_GAIN,
                  max: CommonConstants.MAX_EQ_GAIN,
                  step: CommonConstants.EQ_GAIN_STEP,
                  style: SliderStyle.InSet
                })
                .trackColor('#F1F3F5')
                .selectedColor('#0A59F7')
                .blockColor('#0A59F7')
                .showSteps(true)
                .showTips(true)
                .onChange((value: number) => {
                  this.eqBands[index] = value;
                  // Mark as custom preset if user manually adjusts
                  if (this.eqMode !== EQMode.CUSTOM) {
                    this.eqMode = EQMode.CUSTOM;
                    this.selectedPresetIndex = EQMode.CUSTOM;
                  }
                })
              }
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .backgroundColor('#FFFFFF')
              .borderRadius(8)
              .margin({ left: 16, right: 16, bottom: 8 })
              .shadow({ radius: 2, color: '#0A000000', offsetX: 0, offsetY: 1 })
            })
          }
          .margin({ top: 16 })

          // Reset Button
          Button($r('app.string.eq_reset'), { type: ButtonType.Normal })
            .width('90%')
            .height(48)
            .backgroundColor('#F0F7FF')
            .fontColor('#0A59F7')
            .margin({ top: 24, bottom: 32 })
            .onClick(() => {
              this.resetToFlat();
            })
        }
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .backgroundColor('#F8F9FA')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F9FA')
  }

  private loadPreset(presetIndex: number): void {
    switch (presetIndex) {
      case EQMode.FLAT:
        this.eqBands = [...CommonConstants.DEFAULT_EQ_PRESET];
        break;
      case EQMode.ROCK:
        this.eqBands = [...CommonConstants.ROCK_EQ_PRESET];
        break;
      case EQMode.POP:
        this.eqBands = [...CommonConstants.POP_EQ_PRESET];
        break;
      case EQMode.JAZZ:
        this.eqBands = [...CommonConstants.JAZZ_EQ_PRESET];
        break;
      case EQMode.CLASSICAL:
        this.eqBands = [...CommonConstants.CLASSICAL_EQ_PRESET];
        break;
      case EQMode.CUSTOM:
        // Keep current custom settings
        break;
    }
  }

  private resetToFlat(): void {
    this.eqBands = [...CommonConstants.DEFAULT_EQ_PRESET];
    this.eqMode = EQMode.FLAT;
    this.selectedPresetIndex = EQMode.FLAT;
  }
}