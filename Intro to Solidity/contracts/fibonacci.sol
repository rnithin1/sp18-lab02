pragma solidity 0.4.19;


contract Fibonacci {
    /* Carry out calculations to find the nth Fibonacci number */
    function fibRecur(uint n) public pure returns (uint) {
    	return n
    }

    /* Carry out calculations to find the nth Fibonacci number */
    function fibIter(uint n) public returns (uint) {
    	uint[] memory myArray = new uint[](n);
	    myArray[0] = 1;
	    myArray[1] = 1;
	    for(uint i = 2;i <= m; i++) {
            	myArray[i] = myArray[i - 1] + myArray[i - 2];
	    }
	    return myArray[m];
    }
}
