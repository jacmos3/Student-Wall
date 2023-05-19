import Account "account";

import TrieMap "mo:base/TrieMap";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";

actor WallCoin {
    let ledger = TrieMap.TrieMap<Account.Account, Nat>(Account.accountsEqual, Account.accountsHash);
    let tokenName = "WallCoin";
    let tokenSymbol = "WALL";
    let airdropAmount = 1000;
    var circulationTotalSupply = 0;

    let alreadyClaimed = HashMap.HashMap<Principal,Bool>(0, Principal.equal, Principal.hash);
    public shared query func whoClaimed() : async [Principal]{
        return Iter.toArray(alreadyClaimed.keys());
    };

    // Returns the name of the token 
    public shared query func name() : async Text{
        return tokenName;
    };
    
    // Returns the symbol of the token 
    public shared query func symbol() : async Text{
        return tokenSymbol;
    };

    // Returns the the total number of tokens on all accounts
    public shared query func totalSupply() : async Nat{
        return circulationTotalSupply;
    };

    // Returns the balance of the account
    public shared ({caller}) func myBalance() : async (Nat){
        let account : Account.Account = Account.createAccount(caller, null);
        return _balanceOf(account);
    };

    public shared query func balanceOf(principal: Text) : async (Nat){
        let account : Account.Account = Account.createAccount(Principal.fromText(principal), null);
        return _balanceOf(account);
    };

    public shared ({caller}) func whoAmI() : async Text{
        return Principal.toText(caller);
    };

    private func _balanceOf(account: Account.Account) :(Nat){
        let balance = ledger.get(account);
        switch (balance){
            case (null){0};
            case (? something){
                return something;
            };
        };
    };

    // Transfer tokens to another account
    public shared func transfer(from: Account.Account, to : Account.Account, amount : Nat) : async Result.Result<(), Text>{
        let senderBalance = _balanceOf(from);
        if (senderBalance < amount){
            return #err("not enough tokens");
        }
        else{
            let receiverBalance = _balanceOf(to);
            let oldSValue = ledger.replace(from, senderBalance - amount);
            if (oldSValue == null){
                return #err("error occurred");
            };

            let oldRValue = ledger.replace(to, receiverBalance + amount);
            if (oldRValue == null){
                ledger.put(to, receiverBalance + amount);
            };
        };

        return #ok();
    };

    public shared ({caller}) func claimAirdrop()  : async Result.Result<(),Text>{
        return _claimAirdrop(caller);
    };

    public shared func claimAirdropFor(principal :Principal) : async Result.Result<(), Text>{
        return _claimAirdrop(principal);
    };

    private func _claimAirdrop(caller : Principal)  : Result.Result<(),Text>{
        if (alreadyClaimed.get(caller) != null){
            return #err("Already claimed");
        }
        else{
            let account: Account.Account = {owner = caller; subaccount= null};
            ledger.put(account, airdropAmount);
            circulationTotalSupply += airdropAmount;
            alreadyClaimed.put(caller, true);
            return #ok;
        };
        
        return #err("unknown error");
    };
    
};