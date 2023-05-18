import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type Content = { 'Text' : string } |
  { 'Image' : Uint8Array | number[] } |
  { 'Video' : Uint8Array | number[] };
export interface Message {
  'id' : bigint,
  'creator' : Principal,
  'content' : Content,
  'edited' : boolean,
  'vote' : bigint,
}
export type Result = { 'ok' : null } |
  { 'err' : string };
export type Result_1 = { 'ok' : Message } |
  { 'err' : string };
export interface _SERVICE {
  'deleteMessage' : ActorMethod<[bigint], Result>,
  'downVote' : ActorMethod<[bigint], Result>,
  'getAllMessages' : ActorMethod<[], Array<Message>>,
  'getAllMessagesRanked' : ActorMethod<[], Array<Message>>,
  'getHandle' : ActorMethod<[Principal], [] | [string]>,
  'getHandleT' : ActorMethod<[string], [] | [string]>,
  'getMessage' : ActorMethod<[bigint], Result_1>,
  'getMyHandle' : ActorMethod<[], [] | [string]>,
  'getPrincipal' : ActorMethod<[string], [] | [Principal]>,
  'setHandle' : ActorMethod<[string], Result>,
  'upVote' : ActorMethod<[bigint], Result>,
  'updateMessage' : ActorMethod<[bigint, Content], Result>,
  'updateTextMessage' : ActorMethod<[bigint, string], Result>,
  'writeMessage' : ActorMethod<[Content], bigint>,
  'writeTextMessage' : ActorMethod<[string], bigint>,
}
