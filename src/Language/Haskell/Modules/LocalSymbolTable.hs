-- | This module is designed to be imported qualified.
module Language.Haskell.Modules.LocalSymbolTable
  ( Table
  , empty
  , lookupValue
  , addValue
  ) where

import qualified Data.Map as Map
import Language.Haskell.Exts.Annotated
import Language.Haskell.Modules.SyntaxUtils
import Language.Haskell.Modules.Types

-- | Local symbol table — contains locally bound names
newtype Table = Table (Map.Map NameS SrcLoc)

addValue :: SrcInfo l => Name l -> Table -> Table
addValue n (Table vs) =
  Table (Map.insert (nameToString n) (getPointLoc $ ann n) vs)

lookupValue :: QName l -> Table -> Either (Error l) SrcLoc
lookupValue qn@(UnQual _ n) (Table vs) =
  maybe (Left $ ENotInScope qn) Right $
    Map.lookup (nameToString n) vs
lookupValue qn _ = Left $ ENotInScope qn

empty :: Table
empty = Table Map.empty
