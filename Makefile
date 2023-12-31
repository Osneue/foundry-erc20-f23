-include .env

.PHONY: all test clean deploy help install snapshot format anvil 

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install foundry-rs/forge-std@v1.7.1 --no-commit && forge install OpenZeppelin/openzeppelin-contracts@v0.5.0 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast
TEST_ARGS := 

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)
	TEST_ARGS := --fork-url $(SEPOLIA_RPC_URL)
else ifeq ($(findstring --network ganache,$(ARGS)),--network ganache)
	NETWORK_ARGS := --rpc-url $(GANACHE_RPC_URL) --private-key $(GANACHE_PRIVATE_KEY) --broadcast
	TEST_ARGS := --fork-url $(GANACHE_RPC_URL)
endif
ifeq ($(findstring --verbose,$(ARGS)),--verbose)
	TEST_ARGS += -vvvv
	NETWORK_ARGS += -vvvv
endif

test :; forge test $(TEST_ARGS)

deploy:
	@forge script script/DeployLeoToken.s.sol:DeployLeoToken $(NETWORK_ARGS)