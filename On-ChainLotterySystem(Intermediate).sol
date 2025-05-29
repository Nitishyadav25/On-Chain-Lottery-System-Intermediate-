// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DecentralizedVoting {
    address public admin;
    bool public votingStarted;
    bool public votingEnded;

    string[] public proposals;
    mapping(address => bool) public hasVoted;
    mapping(address => bool) public isRegistered;
    mapping(uint => uint) public voteCount;

    constructor(string[] memory _proposals) {
        admin = msg.sender;
        proposals = _proposals;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can do this");
        _;
    }

    modifier onlyDuringVoting() {
        require(votingStarted && !votingEnded, "Voting not active");
        _;
    }

    function registerVoter(address _voter) external onlyAdmin {
        require(!isRegistered[_voter], "Already registered");
        isRegistered[_voter] = true;
    }

    function startVoting() external onlyAdmin {
        votingStarted = true;
    }

    function endVoting() external onlyAdmin {
        votingEnded = true;
    }

    function vote(uint proposalIndex) external onlyDuringVoting {
        require(isRegistered[msg.sender], "Not registered to vote");
        require(!hasVoted[msg.sender], "Already voted");
        require(proposalIndex < proposals.length, "Invalid proposal");

        hasVoted[msg.sender] = true;
        voteCount[proposalIndex]++;
    }

    function getWinningProposal() external view returns (string memory winner) {
        require(votingEnded, "Voting not yet ended");
        uint winningVoteCount = 0;
        uint winningProposalIndex = 0;

        for (uint i = 0; i < proposals.length; i++) {
            if (voteCount[i] > winningVoteCount) {
                winningVoteCount = voteCount[i];
                winningProposalIndex = i;
            }
        }

        winner = proposals[winningProposalIndex];
    }

    function getProposals() external view returns (string[] memory) {
        return proposals;
    }
}

