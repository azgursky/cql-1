{-
SPDX-License-Identifier: AGPL-3.0-only

This file is part of `statebox/cql`, the categorical query language.

Copyright (C) 2019 Stichting Statebox <https://statebox.nl>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
-}
{-# LANGUAGE OverloadedStrings #-}

module CQLSpec where

import           Language.CQL
import           Language.CQL.Schema
import           Language.CQL.Term
import           Language.CQL.Typeside

-- base
import           Data.Either            (isRight)
import           Data.Map.Strict        as Map
import           Data.Set               as Set
import           Prelude                hiding (EQ)

-- hspec
import           Test.Hspec

-- transformers
import           Control.Monad.IO.Class (liftIO)


spec :: Spec
spec = do
  it "processes correctly the example file Mapping.cql" $ do
    fileContent <- liftIO $ readFile ("examples/Mapping.cql" :: String)
    parsed <- pure $ runProg fileContent
    isRight parsed `shouldBe` True
  it "processes correctly the example file Employee.cql" $ do
    fileContent <- liftIO $ readFile ("examples/Employee.cql" :: String)
    parsed <- pure $ runProg fileContent
    isRight parsed `shouldBe` True
  it "processes correctly the example file Sigma.cql" $ do
    fileContent <- liftIO $ readFile ("examples/Sigma.cql" :: String)
    parsed <- pure $ runProg fileContent
    isRight parsed `shouldBe` True
  it "processes correctly the example file Delta.cql" $ do
    fileContent <- liftIO $ readFile ("examples/Delta.cql" :: String)
    parsed <- pure $ runProg fileContent
    isRight parsed `shouldBe` True
  it "processes correctly the example file Import.cql" $ do
    fileContent <- liftIO $ readFile ("examples/Import.cql" :: String)
    parsed <- pure $ runProg fileContent
    isRight parsed `shouldBe` True
  it "processes correctly the example file Congruence.cql" $ do
    fileContent <- liftIO $ readFile ("examples/Congruence.cql" :: String)
    parsed <- pure $ runProg fileContent
    isRight parsed `shouldBe` True
  it "processes correctly the example file KB.cql" $ do
    fileContent <- liftIO $ readFile ("examples/KB.cql" :: String)
    parsed <- pure $ runProg fileContent
    isRight parsed `shouldBe` True
  -- it "processes correctly the example file Petri.cql" $ do
  --   fileContent <- liftIO $ readFile ("examples/Petri.cql" :: String)
  --   parsed <- pure $ runProg fileContent
  --   isRight parsed `shouldBe` True
  -- print typesideDom
  -- print schemaOne
  -- print schemaTwo
  -- print mappingTwoToOne
  -- print instanceOne

--------------------------------------------------------------------------------

schemaOne :: (Eq var, Eq fk) => Schema var String String String fk String
schemaOne =
  Schema typesideDom (Set.singleton "A") Map.empty atts' Set.empty Set.empty (\_ (EQ (lhs, rhs)) -> lhs == rhs)
  where
    atts' = Map.fromList [ ("A_att", ("A", "Dom")) ]

schemaTwo :: Eq var => Schema var String String String String String
schemaTwo =
  Schema typesideDom (Set.fromList ["A", "B"]) atts' atts'' Set.empty Set.empty (\_ (EQ (lhs, rhs)) -> lhs == rhs)
  where
    atts'  = Map.fromList [ ("f"    , ("A", "B"  )) ]
    atts'' = Map.fromList [ ("A_att", ("A", "Dom"))
                         , ("B_att", ("B", "Dom"))
                         ]

--example typeside one sort Dom { c0 ,..., c100 }
typesideDom :: Eq var => Typeside var String String
typesideDom = Typeside (Set.singleton "Dom") sym Set.empty (\_ (EQ (lhs,rhs)) -> lhs == rhs)
  where sym = sym' 100

        sym' :: Integer -> Map String ([String], String)
        sym' 0 = Map.empty
        sym' n = Map.insert ("c" ++ show n) ([], "Dom") $ sym' (n-1)

--------------------------------------------------------------------------------

-- instanceOne = Instance schemaOne
--   (Map.insert "g1" "A" Map.empty) Map.empty Set.empty (\(EQ (lhs,rhs)) -> lhs == rhs)
--   $ Algebra schemaOne (Map.fromList [("A", Set.singleton "x")])
--     (Map.empty) (Map.fromList [("A_att", Map.fromList [("x",Sym "c42" [])])])
--     (\t -> "x") (\t -> Gen "g1") (\t -> Sym "c42" []) (\t -> Sym "c42" [])

--------------------------------------------------------------------------------

-- mappingTwoToOne = Mapping schemaTwo schemaOne
--   (Map.fromList [("B", "A"), ("A","A")])
--   (Map.fromList [("f", Var ())])
--   (Map.fromList [("A_att", Att "att" (Var ())), ("B_att", Att "att" (Var ()))])
