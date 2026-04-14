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

export class CommonConstants {
  /**
   * Initial volume.
   */
  static readonly INITIAL_VOLUME: number = 5;

  /**
   * Mix volume.
   */
  static readonly MIX_VOLUME: number = 1;

  /**
   * Max volume.
   */
  static readonly MAX_VOLUME: number = 15;

  /**
   * Auto balance default compression ratio.
   */
  static readonly DEFAULT_COMPRESSION_RATIO: number = 0.5;

  /**
   * Auto balance default enabled state.
   */
  static readonly DEFAULT_AUTO_BALANCE_ENABLED: boolean = false;

  /**
   * Minimum compression ratio.
   */
  static readonly MIN_COMPRESSION_RATIO: number = 0.1;

  /**
   * Maximum compression ratio.
   */
  static readonly MAX_COMPRESSION_RATIO: number = 1.0;

  /**
   * Compression step.
   */
  static readonly COMPRESSION_STEP: number = 0.1;
}