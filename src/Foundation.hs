{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}

module Foundation where

import Yesod.Core

data App = App

mkYesodData "App" [parseRoutes|/ HomeR GET|]

getHomeR :: Handler TypedContent
getHomeR = selectRep $ provideJson $ object []

instance Yesod App
