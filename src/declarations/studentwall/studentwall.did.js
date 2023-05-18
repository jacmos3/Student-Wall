export const idlFactory = ({ IDL }) => {
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const Content = IDL.Variant({
    'Text' : IDL.Text,
    'Image' : IDL.Vec(IDL.Nat8),
    'Video' : IDL.Vec(IDL.Nat8),
  });
  const Message = IDL.Record({
    'id' : IDL.Nat,
    'creator' : IDL.Principal,
    'content' : Content,
    'edited' : IDL.Bool,
    'vote' : IDL.Int,
  });
  const Result_1 = IDL.Variant({ 'ok' : Message, 'err' : IDL.Text });
  return IDL.Service({
    'deleteMessage' : IDL.Func([IDL.Nat], [Result], []),
    'downVote' : IDL.Func([IDL.Nat], [Result], []),
    'getAllMessages' : IDL.Func([], [IDL.Vec(Message)], ['query']),
    'getAllMessagesRanked' : IDL.Func([], [IDL.Vec(Message)], ['query']),
    'getHandle' : IDL.Func([IDL.Text], [IDL.Opt(IDL.Text)], []),
    'getMessage' : IDL.Func([IDL.Nat], [Result_1], ['query']),
    'getMyHandle' : IDL.Func([], [IDL.Opt(IDL.Text)], []),
    'getPrincipal' : IDL.Func([IDL.Text], [IDL.Opt(IDL.Principal)], []),
    'setHandle' : IDL.Func([IDL.Text], [Result], []),
    'upVote' : IDL.Func([IDL.Nat], [Result], []),
    'updateMessage' : IDL.Func([IDL.Nat, Content], [Result], []),
    'updateTextMessage' : IDL.Func([IDL.Nat, IDL.Text], [Result], []),
    'writeMessage' : IDL.Func([Content], [IDL.Nat], []),
    'writeTextMessage' : IDL.Func([IDL.Text], [IDL.Nat], []),
  });
};
export const init = ({ IDL }) => { return []; };
