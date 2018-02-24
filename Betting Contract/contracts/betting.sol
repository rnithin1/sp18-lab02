pragma solidity 0.4.20;


contract Betting {
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public {
        owner = msg.sender;
        for (uint i = 0; i < _outcomes.length; i++) {
            outcomes[i] = _outcomes[i];
        }
    }

    /* Fallback function */
    function() public payable {
        revert();
    }

    /* Standard state variables */
    address public owner;
    address public gamblerA;
    address public gamblerB;
    address public oracle;

    /* Structs are custom data structures with self-defined parameters */
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    /* Keep track of every gambler's bet */
    mapping (address => Bet) bets;
    /* Keep track of every player's winnings (if any) */
    mapping (address => uint) winnings;
    /* Keep track of all outcomes (maps index to numerical outcome) */
    mapping (uint => uint) public outcomes;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();

    /* Uh Oh, what are these? */
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
    modifier oracleOnly() {
        require(msg.sender == oracle);
        _;
    }
    modifier outcomeExists(uint outcome) {
        require(outcomes[outcome] == uint(0x0));
        _;
    }

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
    	oracle = _oracle;
        return oracle;
    }

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
        require(msg.sender != owner &&
                (gamblerA == address(0) || gamblerB == address(0)));
        bets[msg.sender] = Bet({
            outcome : _outcome,
            amount : msg.value,
            initialized : true
        });
        if (gamblerA == address(0) && gamblerB == address(0)) {
            BetMade(msg.sender);
            gamblerA = msg.sender;
            BetClosed();
        } else {
            BetMade(msg.sender);
            gamblerB = msg.sender;
            BetClosed();
        }
    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        if (bets[gamblerA].outcome == _outcome &&
            bets[gamblerB].outcome == _outcome) {
            winnings[gamblerA] += bets[gamblerA].amount;
            winnings[gamblerB] += bets[gamblerB].amount;
        } else if (bets[gamblerA].outcome == _outcome &&
                   bets[gamblerB].outcome != _outcome) {
            winnings[gamblerA] += (bets[gamblerA].amount +
                                   bets[gamblerB].amount);
        } else if (bets[gamblerB].outcome == _outcome &&
                   bets[gamblerA].outcome != _outcome) {
            winnings[gamblerB] += (bets[gamblerA].amount +
                                   bets[gamblerB].amount);
        } else {
            msg.sender.transfer(bets[gamblerA].amount +
                            bets[gamblerB].amount);
        }
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        if (withdrawAmount <= winnings[msg.sender]) {
            msg.sender.transfer(withdrawAmount);
            winnings[msg.sender] -= withdrawAmount;
        }
        return checkWinnings();
    }

    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint outcome) public view returns (uint) {
        return outcomes[outcome];
    }

    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
        return winnings[msg.sender];
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {
        delete owner;
        delete gamblerA;
        delete gamblerB;
        delete oracle;
    }
}
