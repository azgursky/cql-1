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
module Api.App where

import           Api.Config.Config      (Config (Config))
import           Api.Config.Environment (Environment (Development))
import           Api.Lib                (startApp)

-- base
import           Data.Maybe             (fromMaybe)
import           System.Environment     (lookupEnv)
import           Text.Read              (readMaybe)

app :: IO ()
app = do
  environment <- lookupEnvVar "CQL_ENV" Development
  apiPort <- lookupEnvVar "PORT" 8080
  startApp $ Config environment apiPort

lookupEnvVar :: (Read a, Show a) => String -> a -> IO a
lookupEnvVar variable default' = do
    maybeValue <- lookupEnv variable
    return $ fromMaybe default' $ readMaybe =<< maybeValue
