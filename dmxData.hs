-- DMX represented in Haskell's type system instead of messing around with C
-- The parts of this that will need to use C will be rewritten in Rust

import           Data.Foldable      (foldMap)
import           Data.List.NonEmpty (NonEmpty)
import           Data.Monoid        (Monoid, mappend)
import           Data.Semigroup     (Semigroup, sconcat)

infixr 5 +#+

(+#+) :: Monoid m => m -> m -> m
(+#+) = mappend


genAppend :: (Monoid m) =>
   (m -> a) -> (a -> m) -> a -> a -> a
genAppend cons decons x y =
   cons $ mappend (decons x) (decons y)

genConcat :: (Monoid m) =>
   (m -> a) -> (a -> m) -> [a] -> a
genConcat cons decons =
   cons . foldMap decons

nonEmptyConcat :: (Semigroup m) =>
   (m -> a) -> (a -> m) -> NonEmpty a -> a
nonEmptyConcat cons decons =
   cons . sconcat . fmap decons
