/*******************************************************************************
 *   (c) 2022 Zondax AG
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ********************************************************************************/
//
// THIS CODE WAS SECURITY REVIEWED BY KUDELSKI SECURITY, BUT NOT FORMALLY AUDITED

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.17;


/// @title Filecoin actors' common types for Solidity.
/// @author Zondax AG
library CommonTypes {
    uint constant UniversalReceiverHookMethodNum = 3726118371;
    uint constant MAX_DEAL_LABEL_LENGTH = 256;
    
    /// @param idx index for the failure in batch
    /// @param code failure code
    struct FailCode {
        uint32 idx;
        uint32 code;
    }

    /// @param success_count total successes in batch
    /// @param fail_codes list of failures code and index for each failure in batch
    struct BatchReturn {
        uint32 success_count;
        FailCode[] fail_codes;
    }

    /// @param type_ asset type
    /// @param payload payload corresponding to asset type
    struct UniversalReceiverParams {
        uint32 type_;
        bytes payload;
    }

    /// @param val contains the actual arbitrary number written as binary
    /// @param neg indicates if val is negative or not
    struct BigInt {
        bytes val;
        bool neg;
    }

    /// @param data filecoin address in bytes format
    struct FilAddress {
        bytes data;
    }

    /// @param data cid in bytes format
    struct Cid {
        bytes data;
    }

    /// @param data deal proposal label in bytes format (it can be utf8 string or arbitrary bytes string).
    /// @param isString indicates if the data is string or raw bytes
    struct DealLabel {
        bytes data;
        bool isString;
    }

    type FilActorId is uint64;

    type ChainEpoch is int64;
}
