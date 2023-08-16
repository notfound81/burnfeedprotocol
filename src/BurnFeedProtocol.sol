// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

/**
 * @title BurnFeedProtocol
 * Inspired by: https://github.com/simpubprotocol/simpubprotocol.
 */
contract BurnFeedProtocol {
    address public immutable token;
    address public immutable vault;

    mapping(address user => bytes[] pubkeys) public userPubkeys;

    /**
     * @dev Emitted when a user publishes action files.
     * @param user The address of the user who published the action file.
     * @param uri The URI of the action file.
     * @param burn The number of tokens to be burned to increase visibility.
     */
    event Actions(address indexed user, string indexed uri, uint256 burn);

    /**
     * @dev Emitted when a user registers a new public key.
     * @param user The address of the user.
     * @param pubkey The public key that the user registered.
     */
    event PubKey(address indexed user, bytes pubkey);

    /**
     * @notice Sets up the contract with the specified ERC20 token and vault.
     * @param _token The address of the ERC20 token.
     * @param _vault The address of the vault where burned tokens will be sent.
     */
    constructor(address _token, address _vault) {
        token = _token;
        vault = _vault;
    }

    /**
     * @notice Publishes an action file, with an option to burn tokens to
     * amplify visibility. Users can optionally burn tokens to increase the
     * attention to their published actions.
     * @param uri The URI of the action file.
     * @param burn The number of tokens to be burned to increase visibility.
     */
    function publishActions(string calldata uri, uint256 burn) external {
        if (burn > 0) {
            ERC20(token).transferFrom(msg.sender, vault, burn);
        }
        emit Actions(msg.sender, uri, burn);
    }

    /**
     * @notice Registers a new public key for encrypted communication.
     * @dev Users can register public keys that others can use for encrypted
     * communication.
     * @param pubkey The public key to be registered.
     */
    function registerPubKey(bytes calldata pubkey) external {
        require(pubkey.length > 0, "Public key cannot be null");
        userPubkeys[msg.sender].push(pubkey);
        emit PubKey(msg.sender, pubkey);
    }
}
