const address = '0x9DABf796de88D43Dd84F6F2741acA3C946Bc0A10'
const ABI = [
	{
		"constant": false,
		"inputs": [
			{
				"name": "_toAirline",
				"type": "address"
			}
		],
		"name": "settlePayment",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_userAddress",
				"type": "address"
			}
		],
		"name": "unregisterUser",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_toAirline",
				"type": "address"
			},
			{
				"name": "_response",
				"type": "uint256"
			}
		],
		"name": "response",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_date",
				"type": "string"
			},
			{
				"name": "_toCity",
				"type": "string"
			},
			{
				"name": "_fromCity",
				"type": "string"
			},
			{
				"name": "_response",
				"type": "uint256"
			},
			{
				"name": "_noSeats",
				"type": "uint256"
			}
		],
		"name": "request",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "registerMember",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"name": "_addr",
				"type": "address"
			}
		],
		"name": "getBalance",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "constructor"
	}
]
export {address, ABI}
