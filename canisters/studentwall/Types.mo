module Types{
    
    public type Message = {
        vote: Int;
        content: Content;
        creator: Principal;
        id: Nat;
        edited: Bool;
    };

    public func createMessage(_vote : Int, _content : Content, _creator: Principal, _id : Nat, _edited : Bool) : Message {
        return {
            vote = _vote;
            content = _content;
            creator = _creator;
            id = _id;
            edited = _edited;
        };
    };

    public type Content = {
        #Text: Text;
        #Image: Blob;
        #Video: Blob;
    };    
}