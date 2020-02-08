-------------------------------- MODULE MCFPaxos -------------------------------
EXTENDS APAFPaxos, TLC
-----------------------------------------------------------------------------
CONSTANTS a1, a2, a3, a4, a5  \* acceptors
CONSTANTS v1, v2      \* Values

MCAcceptor == {a1, a2, a3, a4}
MCValue    == {v1, v2}
MCQuorum1 == {{a1, a2},{a3, a4}}
MCQuorum2 == {{a1, a3},{a2, a4}}
MCBallot == 0..2

MC5Acceptor == {a1, a2, a3, a4, a5}

MC5Quorum1 == {
{a1, a2, a5}, 
{a1, a3, a5}, 
{a2, a3, a5}, 
{a1, a4, a5}, 
{a2, a4, a5}, 
{a3, a4, a5}
}

MC5Quorum2 == {
{a1, a5}, 
{a2, a5}, 
{a3, a5}, 
{a4, a5}
}
=============================================================================
