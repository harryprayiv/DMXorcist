import           Data.HashSet       (HashSet)
import qualified Data.HashSet       as Set
import           FiniteStateMachine as FSM
import           PushdownAutomata   as PDA
import           TuringMachine      as TM

assert p = if p then return () else error "Assertion failure."


--FSMs

myAlphabet = Set.fromList [0,1] :: HashSet Int
myStates = Set.fromList [1..3] :: HashSet Int
delta (1, 0) = 2
delta (1, 1) = 1
delta (2, 0) = 3
delta (2, 1) = 1
delta (3, 0) = 3
delta (3, 1) = 3
myFSM = FSM (myStates, myAlphabet, curry delta, 1, Set.singleton 1)

myStates2 = Set.fromList [1..2] :: HashSet Int
delta2 (1, 0) = 1
delta2 (2, 0) = 2
delta2 (1, 1) = 2
delta2 (2, 1) = 1
myFSM2 = FSM (myStates2, myAlphabet, curry delta2, 1, Set.singleton 2)

myFSM3 = union myFSM myFSM2

myNDAlphabet = Set.fromList [0,1] :: HashSet Int
myNDStates = Set.fromList [1..5] :: HashSet Int

nddelta :: Int -> Maybe Int -> HashSet Int
nddelta 1 (Just 0)  = Set.singleton 5
nddelta 1 (Nothing) = Set.singleton 2
nddelta 5 (Just 1)  = Set.singleton 1
nddelta 2 (Just 0)  = Set.singleton 3
nddelta 3 (Just 0)  = Set.singleton 2
nddelta 2 (Just 1)  = Set.singleton 4
nddelta 4 (Just 0)  = Set.singleton 2
nddelta _ _         = Set.empty

myNDFSM = NDFSM (myNDStates, myNDAlphabet, nddelta, 1, Set.fromList [1, 2]) --(01)*(10 U 00)*


myNDStates2 = Set.fromList [1..7] :: HashSet Int
nddelta2 7 (Just 0) = Set.fromList [2,6]
nddelta2 1 Nothing  = Set.fromList [4,7]
nddelta2 4 (Just 0) = Set.singleton 5
nddelta2 5 (Just 0) = Set.singleton 4
nddelta2 6 (Just 1) = Set.singleton 7
nddelta2 2 (Just 0) = Set.singleton 3
nddelta2 3 (Just 0) = Set.singleton 7
nddelta2 _ _        = Set.empty

myNDFSM2 = NDFSM (myNDStates2, myNDAlphabet, nddelta2, 1, Set.fromList [7, 4]) -- (00)* U (000 U 01)*

myFSM4 = ndfsmToFSM myNDFSM2



main = do
    assert $ applyFSM myFSM [0,1,0,1]
    putStrLn "Passed test 1 (fsm true)."
    assert . not $ applyFSM myFSM [0,1,0,0,1]
    putStrLn "Passed test 2 (fsm false)."
    assert $ applyNDFSM myNDFSM [0,1,0,1,1,0,0,0]
    putStrLn "Passed test 3 (ndfsm true)."
    assert . not $ applyNDFSM myNDFSM [0,0,0]
    putStrLn "Passed test 4 (ndfsm false)."
    assert $ applyFSM myFSM4 [0,0,0,0]
    putStrLn "Passed test 5 (ndfsm to fsm true)."
    assert . not $ applyFSM myFSM4 [0,0,0,1]
    putStrLn "Passed test 6 (ndfsm to fsm false)."
    assert $ myPDAAccepts "" --Takes a long time
    putStrLn "Passed test 7 (pda true 1)."
    assert $ myPDAAccepts "ab" --Take a slightly less long time (don't have to regenerate CNFCFG)
    putStrLn "Passed test 8 (pda true 2)."
    assert . not $ myPDAAccepts "b"
    putStrLn "Passed test 9 (pda false)."
    let isPowerOfTwo x = if x == 0 then False else if x == 1 then True else (rem x 2 == 0) && isPowerOfTwo (div x 2)
        a = map (flip replicate '0') [0..100]
        tmRes = map (tmAccepts myTM) a
        haskRes = map (isPowerOfTwo . length) a
    assert $ tmRes == haskRes
    putStrLn "Passed test 10 (myTM holds for 0 to 100)."


{- Output:

*Main> :l Examples.hs
[1 of 5] Compiling TuringMachine    ( TuringMachine.hs, interpreted )
[2 of 5] Compiling SetTools         ( SetTools.hs, interpreted )
[3 of 5] Compiling PushdownAutomata ( PushdownAutomata.hs, interpreted )
[4 of 5] Compiling FiniteStateMachine ( FiniteStateMachine.hs, interpreted )
[5 of 5] Compiling Main             ( Examples.hs, interpreted )
Ok, modules loaded: FiniteStateMachine, PushdownAutomata, Main, SetTools, TuringMachine.
*Main> main
Passed test 1 (fsm true).
Passed test 2 (fsm false).
Passed test 3 (ndfsm true).
Passed test 4 (ndfsm false).
Passed test 5 (ndfsm to fsm true).
Passed test 6 (ndfsm to fsm false).
Passed test 7 (pda true 1).
Passed test 8 (pda true 2).
Passed test 9 (pda false).
Passed test 10 (myTM holds for 0 to 100).

-}
