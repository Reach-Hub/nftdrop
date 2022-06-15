"reach 0.1";
"use strict";
// -----------------------------------------------
// Name: Interface Template
// Description: NP Rapp simple
// Author: Nicholas Shellabarger
// Version: 0.0.2 - initial
// Requires Reach v0.1.7 (stable)
// ----------------------------------------------
export const Event = () => [];
export const Participants = () => [
  Participant("Alice", {
    getParams: Fun(
      [],
      Object({
        recvAddr: Address,
      })
    ),
  }),
  Participant("Relay", {}),
];
export const Views = () => [
  View({
    manager: Address,
    receiver: Address,
    token: Token
  })
];
export const Api = () => [];
export const App = (map) => {
  const [{ amt, ttl, tok0: token }, [addr, _], [Alice, Relay], [v], _, _] = map;
  Alice.only(() => {
    const { recvAddr } = declassify(interact.getParams());
  });
  Alice.publish(recvAddr).pay(amt)
  .timeout(relativeTime(ttl), () => {
    Anybody.publish()
    transfer(balance()).to(addr)
    commit();
    exit();
  })
  transfer(amt).to(addr);
  v.manager.set(Alice);
  v.receiver.set(recvAddr);
  v.token.set(token);
  commit();
  Relay.publish();
  transfer(balance(token), token).to(recvAddr);
  transfer(balance()).to(addr)
  commit();
  exit();
};
// ----------------------------------------------
