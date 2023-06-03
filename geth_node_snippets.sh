#!/bin/bash
# ethereum geth node bash commands & curl/json API commands

#pass json rpc method calls into geth node:
echo '{"jsonrpc":"2.0","method":"personal_unlockAccount","params": ["0xc966f7f5c60373ddaa49f27c205f7bb902472389" ,"passphrase",0],"id":1}' | nc -U "/storage/disk1/rinkeby/geth/geth.ipc"
echo '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0xc966f7f5c60373ddaa49f27c205f7bb902472389", "to": "0xdfe5443654725f409ecc47c2beeae1619ad50bf3", "value": "0x1", "data": "0x010203040506070809", "gas": "0x100000"}],"id":1}'  | nc -U "/storage/disk1/rinkeby/geth/geth.ipc"

#pass method calls into geth node via curl commands:
curl 127.0.0.1:8545  -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from": "0xb8ce9ab6943e0eced004cde8e3bbed6568b2fa01", "to": "0x79007f136220e48f6bbc2240e022702028b798cf", "value": "0x1", "data": "0x010203040506070809", "gas": "0x100000"}],"id":1}'

curl 127.0.0.1:8545  -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' curl localhost:8545 -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, /' -H 'Cache-Control: no-cache' -X POST --data '{"jsonrpc":"2.0","method":"personal_unlockAccount","params":["0xb8ce9ab6943e0eced004cde8e3bbed6568b2fa01", "password", 15],"id":1}'

#start geth node (w/ rinkeby network)
tmux new-session -d -s geth_node
tmux send-keys -t geth_node:0 'geth --rinkeby --datadir /storage/disk1/rinkeby --syncmode fast --http --ws --ws.addr "127.0.0.1" --ws.port 8546 --ws.api "eth,net,web3,rpc" --ws.origins="*"' ENTER
## combined tmux-new-session && initialization command 
#tmux new-session -d -s geth_node geth --rinkeby --datadir /storage/disk1/rinkeby --syncmode fast --http --ws --ws.addr "127.0.0.1" --ws.port 8546 --ws.api "eth,net,web3,rpc" --ws.origins="*"

### grep to find private keys in files
grep -r '\b[5KL][1-9A-HJ-NP-Za-km-z]\{50,51\}\b' *
