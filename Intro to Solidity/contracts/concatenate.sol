pragma solidity 0.4.19;


contract Concatenate {
    function concatWithoutImport(string _a, string _b) public returns (string) {
    	bytes memory _a1 = bytes(_a);
	    bytes memory _a2 = bytes(_b);
	    string memory a3 = new string(_a1.length + _a2.length);
	    bytes memory babcde = bytes(a3);
	    uint k = 0;
	    for (uint i = 0; i < _a1.length; i++) babcde[k++] = _a1[i];
	    for (i = 0; i < _a2.length; i++) babcde[k++] = _a2[i];
	    return string(babcde);
    }

    /* BONUS */
    function concatWithImport(string s, string t) public returns (string) {
    }
}
