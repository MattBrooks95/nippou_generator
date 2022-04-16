module Main where

import qualified MyLib (nippouGenerator)

main :: IO ()
main = do
	--putStrLn "Hello, Haskell!"
	MyLib.nippouGenerator
