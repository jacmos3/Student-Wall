import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Account {
  'owner' : Principal,
  'subaccount' : [] | [Subaccount],
}
export type Result = { 'ok' : null } |
  { 'err' : string };
export type Subaccount = Uint8Array | number[];
export interface _SERVICE {
  'balanceOf' : ActorMethod<[string], bigint>,
  'claimAirdrop' : ActorMethod<[], Result>,
  'claimAirdropFor' : ActorMethod<[Principal], Result>,
  'myBalance' : ActorMethod<[], bigint>,
  'name' : ActorMethod<[], string>,
  'symbol' : ActorMethod<[], string>,
  'totalSupply' : ActorMethod<[], bigint>,
  'transfer' : ActorMethod<[Account, Account, bigint], Result>,
  'whoAmI' : ActorMethod<[], string>,
  'whoClaimed' : ActorMethod<[], Array<Principal>>,
}
