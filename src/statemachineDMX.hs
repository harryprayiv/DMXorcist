-- DMX Finite State Machine
-- repurposing a tutorial I found for FSM's
-- https://wickstrom.tech/finite-state-machines/2017/11/10/finite-state-machines-part-1-modeling-with-haskell.html

{-# LANGUAGE OverloadedStrings #-}
module StateMachinesWithAdts where

import           Control.Monad      (foldM)
import           Data.List.NonEmpty
import           Data.Text          (Text)
import           Text.Printf        (printf)

import           Checkout           (Card (..), CartItem (..), calculatePrice)
import qualified PaymentProvider

-- a data type to store current DMX state
data DMXstate
  = NoItems
  | HasItems (NonEmpty CartItem)
  | NoCard (NonEmpty CartItem)
  | CardSelected (NonEmpty CartItem)
                 Card
  | CardConfirmed (NonEmpty CartItem)
                  Card
  | OrderPlaced
  deriving (Show, Eq)

-- will become a send DMX event
data SendDMXevent
  = Select CartItem
  | Checkout
  | SelectCard Card
  | Confirm
  | PlaceOrder
  | Cancel
  deriving (Show, Eq)

  checkout
  :: DMXstate
  -> SendDMXevent
  -> IO DMXState
