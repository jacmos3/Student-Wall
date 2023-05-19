export const idlFactory = ({ IDL }) => {
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const Subaccount = IDL.Vec(IDL.Nat8);
  const Account = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(Subaccount),
  });
  return IDL.Service({
    'balanceOf' : IDL.Func([IDL.Text], [IDL.Nat], ['query']),
    'claimAirdrop' : IDL.Func([], [Result], []),
    'claimAirdropFor' : IDL.Func([IDL.Principal], [Result], []),
    'myBalance' : IDL.Func([], [IDL.Nat], []),
    'name' : IDL.Func([], [IDL.Text], ['query']),
    'symbol' : IDL.Func([], [IDL.Text], ['query']),
    'totalSupply' : IDL.Func([], [IDL.Nat], ['query']),
    'transfer' : IDL.Func([Account, Account, IDL.Nat], [Result], []),
    'whoAmI' : IDL.Func([], [IDL.Text], []),
    'whoClaimed' : IDL.Func([], [IDL.Vec(IDL.Principal)], ['query']),
  });
};
export const init = ({ IDL }) => { return []; };
