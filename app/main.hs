import Application ()
import Foundation
import Yesod.Core

main :: IO ()
main = warp 3000 App
