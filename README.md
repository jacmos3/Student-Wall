# Student Wall

## Known issues

As per this open issue, https://github.com/MioQuispe/create-ic-app/issues/24, the lib connect2ic/svelte is causing the dapp not working on IC, so it is only possible to test it in local. But a fix is work in progress.
Meanwhile, follows the steps to run it in local while the fix is coming..

## Initial configuration

Node version : 16.20.0
Dfx version: 0.14.0
npm version: 8.19.4

## Local deploy:

```$ dfx start```

```$ dfx canister create wallcoin```

- copy the canister id and paste it into the WALLCOIN_DEV constant in: ./canisters/studentwall/studentwall.mo

```$ dfx canister create studentwall```

```$ dfx canister create assets```

```$ dfx deploy```

```$ npm run dev```

## Intention:
This dapp is meant to allow Motoko Bootcamp Students to write down their vents during the development of their final projects or day challenges. 
Every student needs to free his/her frustration when encountering an error. This is the right place to do so while developing, to let other students know you are venting much more than them!
Creative students could receive upvotes or tips, so they can gain WALL tokens (usage TBD)

## Features
StudentWall allows users to get access to a shared wall containing a list of users vents.
Users can connect as guest or using their preferred wallet.
Connecting as guest they have limited options; guests can only view all the messages already sent and post a new message as anonymous user.

Logged users (NOTE: please connect with plug wallet as per now), can write a message into the wall, but they can also upvote or downvote other users posts.
They cannot vote their own posts, but they can edit or delete them instead.
If the edit, an “**edit” message will appear near the post to let everybody knows that was not an original version.

Upvoting and Downvoting cost 2 WALL each coin.

There’s no way to buy WALL coin, but it is possible to claim for free. 
Logged users can set a profile handle. If they set it they receive 100 WALL tokens for free.
The balance of the WALL coins is shown on top of the wall.

Once users select their unique handle, it will be replaced to all their old posts replacing their principal: it will be come “@handle said:” instead of “principal-id said:”

Logged users will be able to send tips to other users if they liked their posts.

## WALL Tokenomics

WALL token has no max supply and there is no any sale.
100 WALL tokens will be claimable for free by everyone just being a new user with and handle.
WALL tokens can be used to upvote/downvote other users posts:
each UP vote costs 2 WALL: 1 WALL goes to the author of the post you are voting, 1 WALL goes to the DAO canister (DAO is TBD).
each DOWN vote costs 2 WALL which go directly to the DAO.

## TODO

A DAO,
Improve UI,
Add profile,
Allow pictures upload,
Allow nested posts,
Allow images in posts,
Improve tokenomics avoiding SPAM opportunities (by adding a WALL cost to post and removing write access to guests),
Adding administration section where admin of the Motoko Bootcamp could start a new sprint session with clean wall,
Add principals whitelist allowing login to only motoko students