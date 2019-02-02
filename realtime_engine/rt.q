tradeWatch:([]s:`$();price:`float$();size:`int$();stop:`boolean$();cond:`char$();ex:`char$();bid:`float$();ask:`float$();bsize:`long$();asksize:`long$();mode:`char$())

rf:([t:`$()];wc:();f:())
/ `rtfunc upsert (`quote;((in;`sym;enlist `GOOG);(=;`mode;"Y"));{show x;if[count x;`quote1 insert last x]})
`rf upsert (`trade;((in;`sym;enlist `AMD);(=;`cond;"E"));{if[count x;`tradeWatch insert aj[`sym`time;x;quote]]})
upd:{if[x in key rf;rf[x;`f] ?[y;rf[x;`wc];0b;()]];x insert y}
/ upd:insert

\c 50 150
\t 1000
.z.ts:{show -10#tradeWatch}