"reach 0.1";
"use strict";
// -----------------------------------------------
// Name: NFT Drop
// Description: Drop NFT to any address
// Author: Nicholas Shellabarger
// Version: 1.0.0 - initial
// Requires Reach v0.1.10
// ----------------------------------------------
const SERIAL_VER = 2;
export const Event = () => [];
export const Participants = () => [
  Participant("Alice", {
    getParams: Fun(
      [],
      Object({
        recvAddr: Address,
        ttl2: UInt,
        tokenAmt: UInt,
        rewardAmt: UInt
      })
    ),
    signal: Fun([], Null)
  }),
  ParticipantClass("Relay", {}),
];
export const Views = () => [
  View({
    manager: Address,
    receiver: Address,
    token: Token,
  }),
];
export const Api = () => [];
export const App = (map) => {
  const [{ amt, ttl, tok0: token }, [addr, _], [Alice, Relay], [v], _, _] = map;
  Alice.only(() => {
    const { recvAddr, ttl2, tokenAmt, rewardAmt } = declassify(interact.getParams());
  });
  Alice.publish(recvAddr, ttl2, tokenAmt, rewardAmt)
    .pay([amt+rewardAmt+SERIAL_VER, [tokenAmt, token]])
    .timeout(relativeTime(ttl), () => {
      Anybody.publish();
      transfer(balance()).to(addr);
      commit();
      exit();
    });
  transfer(amt).to(addr);
  v.manager.set(Alice);
  v.receiver.set(recvAddr);
  v.token.set(token);
  Alice.interact.signal();
  commit();
  Relay.publish().timeout(relativeTime(ttl2), () => {
    Relay.publish().timeout(relativeTime(ttl2), () => {
      Relay.only(() => {
        const rAddr = this;
      });
      Relay.publish(rAddr);
      transfer(balance(token), token).to(rAddr);
      transfer(balance()).to(rAddr);
      commit();
      exit();
    });
    transfer(balance(token), token).to(Alice);
    transfer(balance()).to(Alice);
    commit();
    exit();
  });
  transfer(balance(token), token).to(recvAddr);
  transfer(balance()).to(recvAddr);
  commit();
  exit();
};
// ----------------------------------------------
