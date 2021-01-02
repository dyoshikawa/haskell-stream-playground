module Lib
    ( streamCopy
    ) where

import           Conduit
import           Network.AWS.S3.StreamingUpload

streamCopy :: IO ()
streamCopy = do
    writeFile "input.txt" "This is a test." -- create the source file
    runConduitRes $ sourceFileBS "input.txt" .| sinkFile "output.txt" -- actual copying


