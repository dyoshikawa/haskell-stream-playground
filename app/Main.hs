{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Lib

main :: IO ()
main = do
    streamCopy
    s3Upload
