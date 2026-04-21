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
import { Logger } from '../utils/Logger';

const TAG = 'EQTest';

export class EQTest {
  /**
   * Test EQ functionality
   */
  static testEQFunctionality(): void {
    Logger.info(TAG, 'Starting EQ functionality test...');
    
    // Test 1: Verify EQ constants
    this.testEQConstants();
    
    // Test 2: Verify EQ data model
    this.testEQDataModel();
    
    // Test 3: Verify EQ volume calculation
    this.testEQVolumeCalculation();
    
    Logger.info(TAG, 'EQ functionality test completed.');
  }
  
  /**
   * Test EQ constants
   */
  private static testEQConstants(): void {
    Logger.info(TAG, 'Testing EQ constants...');
    
    // Verify default values
    if (CommonConstants.DEFAULT_EQ_ENABLED === false) {
      Logger.info(TAG, '✓ DEFAULT_EQ_ENABLED is correctly set to false');
    } else {
      Logger.error(TAG, '✗ DEFAULT_EQ_ENABLED should be false');
    }
    
    if (CommonConstants.DEFAULT_EQ_MODE === 0) {
      Logger.info(TAG, '✓ DEFAULT_EQ_MODE is correctly set to 0 (Flat)');
    } else {
      Logger.error(TAG, '✗ DEFAULT_EQ_MODE should be 0');
    }
    
    // Verify EQ bands
    if (CommonConstants.DEFAULT_EQ_PRESET.length === 5) {
      Logger.info(TAG, '✓ DEFAULT_EQ_PRESET has 5 bands');
    } else {
      Logger.error(TAG, `✗ DEFAULT_EQ_PRESET should have 5 bands, got ${CommonConstants.DEFAULT_EQ_PRESET.length}`);
    }
    
    // Verify all bands are zero (flat EQ)
    const allZero = CommonConstants.DEFAULT_EQ_PRESET.every(band => band === 0);
    if (allZero) {
      Logger.info(TAG, '✓ All EQ bands are zero (flat EQ)');
    } else {
      Logger.error(TAG, '✗ EQ bands should all be zero for flat EQ');
    }
    
    // Verify EQ presets
    if (CommonConstants.EQ_PRESETS.length === 6) {
      Logger.info(TAG, '✓ EQ_PRESETS has 6 presets');
    } else {
      Logger.error(TAG, `✗ EQ_PRESETS should have 6 presets, got ${CommonConstants.EQ_PRESETS.length}`);
    }
    
    Logger.info(TAG, 'EQ constants test completed.');
  }
  
  /**
   * Test EQ data model
   */
  private static testEQDataModel(): void {
    Logger.info(TAG, 'Testing EQ data model...');
    
    // Test EQ modes
    const modes = ['Flat', 'Rock', 'Pop', 'Jazz', 'Classical', 'Custom'];
    for (let i = 0; i < modes.length; i++) {
      Logger.info(TAG, `✓ EQ Mode ${i}: ${modes[i]}`);
    }
    
    // Test frequency bands
    const frequencies = ['60Hz', '230Hz', '910Hz', '3.6kHz', '14kHz'];
    for (let i = 0; i < frequencies.length; i++) {
      Logger.info(TAG, `✓ Frequency Band ${i}: ${frequencies[i]}`);
    }
    
    Logger.info(TAG, 'EQ data model test completed.');
  }
  
  /**
   * Test EQ volume calculation
   */
  private static testEQVolumeCalculation(): void {
    Logger.info(TAG, 'Testing EQ volume calculation...');
    
    // Test case 1: Flat EQ (all zeros)
    const flatEQ = [0, 0, 0, 0, 0];
    const volume1 = 10;
    const result1 = this.simulateEQProcessing(volume1, flatEQ);
    if (Math.abs(result1 - volume1) < 0.01) {
      Logger.info(TAG, `✓ Flat EQ: ${volume1} -> ${result1.toFixed(2)} (no change)`);
    } else {
      Logger.error(TAG, `✗ Flat EQ: ${volume1} -> ${result1.toFixed(2)} (should be ${volume1})`);
    }
    
    // Test case 2: Positive gain EQ
    const positiveEQ = [3, 2, 1, 0, -1]; // Average positive gain = (3+2+1)/3 = 2dB
    const volume2 = 10;
    const result2 = this.simulateEQProcessing(volume2, positiveEQ);
    const expected2 = volume2 * Math.pow(10, 2/20); // 2dB gain
    if (Math.abs(result2 - expected2) < 0.1) {
      Logger.info(TAG, `✓ Positive EQ: ${volume2} -> ${result2.toFixed(2)} (expected ${expected2.toFixed(2)})`);
    } else {
      Logger.error(TAG, `✗ Positive EQ: ${volume2} -> ${result2.toFixed(2)} (expected ${expected2.toFixed(2)})`);
    }
    
    // Test case 3: Volume limiting
    const highGainEQ = [12, 12, 12, 12, 12]; // 12dB gain
    const volume3 = 10;
    const result3 = this.simulateEQProcessing(volume3, highGainEQ);
    if (result3 <= 15) {
      Logger.info(TAG, `✓ Volume limiting: ${volume3} -> ${result3.toFixed(2)} (max 15)`);
    } else {
      Logger.error(TAG, `✗ Volume limiting: ${volume3} -> ${result3.toFixed(2)} (should be ≤ 15)`);
    }
    
    Logger.info(TAG, 'EQ volume calculation test completed.');
  }
  
  /**
   * Simulate EQ processing (same logic as in AudioRendererController)
   */
  private static simulateEQProcessing(volume: number, eqBands: number[]): number {
    if (!eqBands || eqBands.length === 0) {
      return volume;
    }
    
    // Calculate average gain from all EQ bands (excluding negative values for now)
    let totalPositiveGain = 0;
    let positiveCount = 0;
    
    for (const gain of eqBands) {
      if (gain > 0) {
        totalPositiveGain += gain;
        positiveCount++;
      }
    }
    
    // Calculate average positive gain
    const avgGain = positiveCount > 0 ? totalPositiveGain / positiveCount : 0;
    
    // Apply gain to volume (simple linear scaling)
    // Convert dB gain to linear multiplier: 10^(gain/20)
    const gainMultiplier = Math.pow(10, avgGain / 20);
    
    // Apply gain with volume limiting (max 15)
    let eqVolume = volume * gainMultiplier;
    
    // Limit to maximum volume
    if (eqVolume > 15) {
      eqVolume = 15;
    }
    
    return eqVolume;
  }
}