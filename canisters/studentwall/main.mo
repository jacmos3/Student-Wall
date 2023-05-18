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

import Types "Types";

actor StudentWall {
    func hashId(id : Nat) : Hash.Hash {
        Text.hash(Nat.toText(id));
    };
    var messageId : Nat = 0;    
    let wall = HashMap.HashMap<Nat,Types.Message>(0, Nat.equal, hashId);
    var logs : Text = "";
    private func log(log: Text){
        logs := logs # " - " # log;
    };

    public shared ({caller}) func writeTextMessage(t: Text) : async Nat{
        var c : Types.Content = #Text(t);
        return _writeMessage(c, caller, "writeTextMessage");
    };

    private func _writeMessage(c : Types.Content, caller: Principal, method: Text) : Nat{
        log("[begin "#method#"]");
        messageId += 1;
        var m : Types.Message = Types.createMessage(0, c, caller, messageId, false);
        wall.put(messageId, m);
        log("[end "#method#"]");
        return messageId;
    };

    public shared ({caller}) func writeMessage(c : Types.Content) : async Nat{
        return _writeMessage(c, caller, "writeMessage");
    };

    private func _getMessage (messageId : Nat) :  Result.Result<Types.Message, Text>{
        log("[begin _getMessage] - messageId: " # Nat.toText(messageId));
        var m = wall.get(messageId);
        
        switch (m){
            case (null){
                log("[end _getMessage] - error");
                return #err("messageId not valid");
            };
            case (? something){
                log("[end _getMessage] - ok");
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
        log("[begin updateMessage]");
        var result = _getMessage(messageId);
        if (Result.isOk(result)){
            var message = Result.toOption(result);
            switch (message){
                case (null) { return #err("message does not exist")};
                case (? something) {
                    if (caller != something.creator){
                        log("[end updateMessage] - caller not creator");
                        return #err("caller is not the creator of this message");
                    }
                    else{
                        var m : Types.Message = Types.createMessage(something.vote, c, caller, something.id, true);
                        var oldM = wall.replace(messageId,m);
                        if (oldM == null){
                            log("[end updateMessage] - err old Null");
                            return #err("not possible to update");
                        }
                        else{
                            log("[end updateMessage] - ok: " # Nat.toText(messageId) # " - " # Principal.toText(something.creator) # " - " # Principal.toText(caller));
                            return #ok();
                        }
                    }
                };
            }
        };
        log("[end updateMessage] - err final");
        return #err("not valid");
     };

     public shared ({caller}) func updateMessage(messageId : Nat, c : Types.Content) : async Result.Result<(), Text> {
        return _updateMessage(messageId, c, caller);
     };

    public shared ({caller}) func deleteMessage (messageId : Nat) : async Result.Result<(), Text>{
        log("[begin deleteMessage]");
        let result = _getMessage(messageId);

        if (Result.isOk(result)){
            var message = Result.toOption(result);
            switch (message){
                case (null) { 
                    log("[end voting] - final error: message null");
                    return #err("message does not exist")
                };
                case (? m){

                    if (caller == m.creator){
                        var removed = wall.remove(messageId);
                        if (removed == null){
                            log("[end deleteMessage] - err id not valid");
                            return #err("messageId not valid");
                        };
                        log("[end deleteMessage] - ok final");
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
        log("[begin voting]");
        var result =  _getMessage(messageId);
        if (Result.isOk(result)){
            var message = Result.toOption(result);
            switch (message){
                case (null) { 
                    log("[end voting] - final error: message null");
                    return #err("message does not exist")
                };
                case (? something) {
                    var m = Types.createMessage(something.vote + voting, something.content, something.creator, something.id, something.edited);
                    var oldM = wall.replace(messageId, m);
                    if (oldM == null){
                        log("[end voting] - error old null");
                        return #err("Cannot update vote");
                    };
                    log("[end voting] - final ok old not null");            
                    return #ok();
                };
            };
        };
        log("[end voting] - final error");
        return #err("messageId not correct");
    };

    public shared func upVote (messageId  : Nat) : async Result.Result<(), Text>{
        log("[begin upVote] - id: " # Nat.toText(messageId));
        let result =  _voting(messageId, 1);
        if (Result.isOk(result)){
            log("[end upVote] - ok");
            return #ok();
        };
        log("[end upVote] - err");
        return #err("cannot upVote");
    };

    public shared func downVote (messageId  : Nat) : async Result.Result<(), Text>{
        log("[begin downVote] - id: " # Nat.toText(messageId));
        let result = _voting(messageId, -1);
        if (Result.isOk(result)){
            log("[end downVote] - ok");
            return #ok();
        };
        log("[end downVote] - err");
        return #err("cannot downVote");
    };

    //Get all messages
    public shared query func getAllMessages () : async [Types.Message]{
        log("[getAllMessages called]");
        return Iter.toArray<(Types.Message)>(wall.vals());
    };

    private func isGreaterVote(x: Types.Message, y : Types.Message) : Order.Order {
        log("[isGreaterVote called]");
        return Int.compare(y.vote, x.vote);
    };

    public shared query func getAllMessagesRanked() : async [Types.Message]{
        log("[begin getAllMessagesRanked]");
        var posts : Iter.Iter<Types.Message> = wall.vals();
        var postArray = Iter.toArray(posts) ;
        var sorted = Array.sort(postArray, isGreaterVote);
        log("[end getAllMessagesRanked]");
        return sorted;
    };

    private func getLogs(): Text{
        return logs;
    }
};