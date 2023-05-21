import HashMap "mo:base/HashMap";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Order "mo:base/Order";
import Int "mo:base/Int";
import Text "mo:base/Text";
import Principal "mo:base/Principal";

import Account "../wallcoin/account";
import Types "Types";

actor StudentWall {
    
    let IS_DEV = true;
    
    let WALLCOIN_DEV = "bkyz2-fmaaa-aaaaa-qaaaq-cai";
    let WALLCOIN_IC = "ojsrx-iyaaa-aaaao-ajpaa-cai";

    let WALLCOIN_CANISTER_ID = if (IS_DEV) WALLCOIN_DEV else WALLCOIN_IC;
    let DAO_CANISTER = if (IS_DEV) WALLCOIN_DEV else WALLCOIN_IC; //TODO. DAO CANISTER NEEDS TO BE DEVELOPED YET
    
    func hashId(id : Nat) : Hash.Hash {
        Text.hash(Nat.toText(id));
    };

    var messageId : Nat = 0;    
    let wall = HashMap.HashMap<Nat,Types.Message>(0, Nat.equal, hashId);
    let handles = HashMap.HashMap<Principal, Text>(0,Principal.equal, Principal.hash);
    let principals = HashMap.HashMap<Text, Principal>(0,Text.equal, Text.hash);
    let daoPrincipal = Principal.fromText(DAO_CANISTER);

    let wallCoinCanister = actor (WALLCOIN_CANISTER_ID) : actor {
        claimAirdropFor : shared (principal: Principal) -> async Result.Result<(), Text>;
        balanceOf : shared (principal: Text) -> async (Nat);
        transfer(from: Account.Account, to : Account.Account, amount : Nat) : async Result.Result<(), Text>
    };

    public shared ({caller}) func writeTextMessage(t: Text) : async Nat{
        var c : Types.Content = #Text(t);
        return _writeMessage(c, caller, "writeTextMessage");
    };

    private func _writeMessage(c : Types.Content, caller: Principal, method: Text) : Nat{
        messageId += 1;
        var m : Types.Message = Types.createMessage(0, c, caller, messageId, false);
        wall.put(messageId, m);
        return messageId;
    };

    public shared ({caller}) func writeMessage(c : Types.Content) : async Nat{
        return _writeMessage(c, caller, "writeMessage");
    };

    private func _getHandle(caller: Principal): ?Text{
        return handles.get(caller);
    };

    public shared func getHandle(caller: Principal) : async ?Text{
        return _getHandle(caller);
    };

    public shared func getHandleT(caller: Text) : async ?Text{
        return _getHandle(Principal.fromText(caller));
    };

    public shared ({caller}) func getMyHandle() : async ?Text{
        return _getHandle(caller);
    };

    public shared func getPrincipal(handle: Text) : async ?Principal{
        return principals.get(handle);
    };

    public shared ({caller}) func setHandle(newHandle : Text) : async Result.Result<(), Text>{
        if (principals.get(newHandle) == null){
            let result = await wallCoinCanister.claimAirdropFor(caller);
            switch(result){
                case (#ok){
                    principals.put(newHandle, caller);
                    handles.put(caller, newHandle);
                    return #ok();
                };
                case (_){
                    return result;
                };
            };
        }
        else
            return #err("Handle already in use by someone else");
    };

    private func _getMessage (messageId : Nat) :  Result.Result<Types.Message, Text>{
        var m = wall.get(messageId);
        
        switch (m){
            case (null){
                return #err("messageId NOT valid");
            };
            case (? something){
                return #ok(something);
            };
        };
    };

    public shared query func getMessage (messageId : Nat) : async Result.Result<Types.Message, Text>{
        return _getMessage(messageId);
     };

    public shared ({caller}) func updateTextMessage(messageId : Nat, t: Text) : async Result.Result<(), Text> {
        return _updateMessage(messageId, #Text(t), caller);
    };

    private func _updateMessage(messageId : Nat, c : Types.Content, caller: Principal) : Result.Result<(), Text> {
        var result = _getMessage(messageId);
        if (Result.isOk(result)){
            var message = Result.toOption(result);
            switch (message){
                case (null) { return #err("message does not exist")};
                case (? something) {
                    if (caller != something.creator){
                        return #err("caller is not the creator of this message");
                    }
                    else{
                        var m : Types.Message = Types.createMessage(something.vote, c, caller, something.id, true);
                        var oldM = wall.replace(messageId,m);
                        if (oldM == null){
                            return #err("not possible to update");
                        }
                        else{
                            return #ok();
                        }
                    }
                };
            }
        };
        return #err("not valid");
     };

     public shared ({caller}) func updateMessage(messageId : Nat, c : Types.Content) : async Result.Result<(), Text> {
        return _updateMessage(messageId, c, caller);
     };

    public shared ({caller}) func deleteMessage (messageId : Nat) : async Result.Result<(), Text>{
        let result = _getMessage(messageId);

        if (Result.isOk(result)){
            var message = Result.toOption(result);
            switch (message){
                case (null) { 
                    return #err("message does not exist")
                };
                case (? m){

                    if (caller == m.creator){
                        var removed = wall.remove(messageId);
                        if (removed == null){
                            return #err("messageId not valid");
                        };
                        return #ok();
                    }
                    else{
                        return #err("Only the author can delete this message!");
                    };
                };
            };
        };
        
        return #err("not possible to delete");
    };

    
    private func _voting(messageId: Nat, voting: Int) : Result.Result<(), Text> {
        var result =  _getMessage(messageId);
        if (Result.isOk(result)){
            var message = Result.toOption(result);
            switch (message){
                case (null) { 
                    return #err("message does not exist")
                };
                case (? something) {
                    var m = Types.createMessage(something.vote + voting, something.content, something.creator, something.id, something.edited);
                    var oldM = wall.replace(messageId, m);
                    if (oldM == null){
                        return #err("Cannot update vote");
                    };
                    return #ok();
                };
            };
        };
        return #err("messageId not correct");
    };

     public shared ({caller}) func upVote (messageId  : Nat) : async Result.Result<(), Text>{
        var result =  _voting(messageId, 1);
        var rollback: Bool = false;
        if (Result.isOk(result)){
            let from = Account.createAccount(caller, null);
            let m = wall.get(messageId);
            switch (m){
                case(null){
                    rollback := true;
                };
                case(? something){
                    var to = Account.createAccount(Principal.fromText(DAO_CANISTER), null);
                    result := await wallCoinCanister.transfer(from, to, 1);
                    if (Result.isOk(result)){
                        //I return ok even if this breaks
                        to := Account.createAccount(something.creator, null);
                        ignore await wallCoinCanister.transfer(from, to, 1);
                        return #ok;
                    }
                    else{
                        rollback := true;
                    };
                }
            }
        };

        if (rollback){
            //rollback
            ignore _voting(messageId, -1);
            return result;
        };

        return #err("cannot upVote");
    };

    public shared ({caller}) func downVote (messageId  : Nat) : async Result.Result<(), Text>{
        let result =  _voting(messageId, -1);
        if (Result.isOk(result)){
            let from = Account.createAccount(caller, null);
            let to = Account.createAccount(daoPrincipal, null);
            var res = await wallCoinCanister.transfer(from, to, 1);
            if (Result.isOk(res)){
                return res;
            }
            else{
                //rollback
                ignore _voting(messageId, 1);
                return res;
            };
        };
        return #err("cannot downVote");
    };

    //Get all messages
    public shared query func getAllMessages () : async [Types.Message]{
        return Iter.toArray<(Types.Message)>(wall.vals());
    };

    private func isGreaterVote(x: Types.Message, y : Types.Message) : Order.Order {
        return Int.compare(y.vote, x.vote);
    };

    public shared query func getAllMessagesRanked() : async [Types.Message]{
        var posts : Iter.Iter<Types.Message> = wall.vals();
        var postArray = Iter.toArray(posts) ;
        var sorted = Array.sort(postArray, isGreaterVote);
        return sorted;
    };
};