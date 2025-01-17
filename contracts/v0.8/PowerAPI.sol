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

import "./types/CommonTypes.sol";
import "./types/PowerTypes.sol";
import "./cbor/PowerCbor.sol";
import "./cbor/BytesCbor.sol";
import "./cbor/IntCbor.sol";

import "./utils/Actor.sol";

/// @title This library is a proxy to a built-in Power actor. Calling one of its methods will result in a cross-actor call being performed.
/// @author Zondax AG
library PowerAPI {
    using Uint64CBOR for uint64;
    using BytesCBOR for bytes;
    using PowerCBOR for *;

    /// @notice create a new miner for the owner address and worker address.
    /// @param params data required to create the miner
    /// @param value the amount of token the new miner will receive
    /// @return exit code (!= 0) if an error occured, 0 otherwise
    /// @return newly created miner's information
    function createMiner(PowerTypes.CreateMinerParams memory params, uint256 value) internal returns (int256, PowerTypes.CreateMinerReturn memory) {
        bytes memory raw_request = params.serializeCreateMinerParams();

        (int256 exit_code, bytes memory result) = Actor.callByID(
            PowerTypes.ActorID,
            PowerTypes.CreateMinerMethodNum,
            Misc.CBOR_CODEC,
            raw_request,
            value,
            false
        );

        if (exit_code == 0) {
            return (0, result.deserializeCreateMinerReturn());
        }

        PowerTypes.CreateMinerReturn memory empty_res;
        return (exit_code, empty_res);
    }

    /// @notice get the total number of miners created, regardless of whether or not they have any pledged storage.
    /// @return exit code (!= 0) if an error occured, 0 otherwise
    /// @return total number of miners created
    function minerCount() internal view returns (int256, uint64) {
        bytes memory raw_request = new bytes(0);

        (int256 exit_code, bytes memory result) = Actor.callByIDReadOnly(PowerTypes.ActorID, PowerTypes.MinerCountMethodNum, Misc.NONE_CODEC, raw_request);

        if (exit_code == 0) {
            return (0, result.deserializeUint64());
        }

        uint64 empty_res;
        return (exit_code, empty_res);
    }

    /// @notice get the total number of miners that have more than the consensus minimum amount of storage active.
    /// @return exit code (!= 0) if an error occured, 0 otherwise
    /// @return total number of miners that have more than the consensus minimum amount of storage active
    function minerConsensusCount() internal view returns (int256, int64) {
        bytes memory raw_request = new bytes(0);

        (int256 exit_code, bytes memory result) = Actor.callByIDReadOnly(
            PowerTypes.ActorID,
            PowerTypes.MinerConsensusCountMethodNum,
            Misc.NONE_CODEC,
            raw_request
        );

        if (exit_code == 0) {
            return (0, result.deserializeInt64());
        }

        int64 empty_res;
        return (exit_code, empty_res);
    }

    /// @notice get the total raw power of the network.
    /// @return exit code (!= 0) if an error occured, 0 otherwise
    /// @return total raw power of the network
    function networkRawPower() internal view returns (int256, CommonTypes.BigInt memory) {
        bytes memory raw_request = new bytes(0);

        (int256 exit_code, bytes memory result) = Actor.callByIDReadOnly(PowerTypes.ActorID, PowerTypes.NetworkRawPowerMethodNum, Misc.NONE_CODEC, raw_request);

        if (exit_code == 0) {
            return (0, result.deserializeBytesBigInt());
        }

        CommonTypes.BigInt memory empty_res;
        return (exit_code, empty_res);
    }

    /// @notice get the raw power claimed by the specified miner, and whether the miner has more than the consensus minimum amount of storage active.
    /// @param minerID the miner id you want to get information from
    /// @return exit code (!= 0) if an error occured, 0 otherwise
    /// @return raw power claimed by the specified miner
    function minerRawPower(uint64 minerID) internal view returns (int256, PowerTypes.MinerRawPowerReturn memory) {
        bytes memory raw_request = minerID.serialize();

        (int256 exit_code, bytes memory result) = Actor.callByIDReadOnly(PowerTypes.ActorID, PowerTypes.MinerRawPowerMethodNum, Misc.CBOR_CODEC, raw_request);

        if (exit_code == 0) {
            return (0, result.deserializeMinerRawPowerReturn());
        }

        PowerTypes.MinerRawPowerReturn memory empty_res;
        return (exit_code, empty_res);
    }
}
