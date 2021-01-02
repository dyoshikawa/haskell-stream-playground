{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( streamCopy,
      s3Upload
    ) where

import           Conduit
import           Control.Lens
import           Control.Monad
import           Control.Monad.IO.Class
import           Control.Monad.Trans.AWS
import           Data.Text                            (Text)
import qualified Data.Text.IO                         as Text
import           Network.AWS.S3
import           Network.AWS.S3.CreateMultipartUpload
import           System.IO

createSourceFile :: IO ()
createSourceFile = do
    writeFile "input.txt" "This is a test."

streamCopy :: IO ()
streamCopy = do
    writeFile "input.txt" "This is a test." -- create the source file
    runConduitRes $ sourceFileBS "input.txt" .| sinkFile "output.txt" -- actual copying

s3Upload :: IO ()
s3Upload = do
    createSourceFile
    logger <- newLogger Debug stdout
    env <- newEnv Discover <&> set envLogger logger . set envRegion Tokyo
    runResourceT . runAWST env $ do
        body <- chunkedFile defaultChunkSize "./input.txt"
        void . send $ putObject (BucketName "dyoshikawa-test") (ObjectKey "output.txt") body
        -- say $ "Successfully Uploaded: "
        --     <> toText f <> " to " <> toText b <> " - " <> toText k

-- streamS3Upload :: IO ()
-- streamS3Upload = do
--     runRWSC $ streamUpload 1 (createMultipartUpload (BucketName "test") (ObjectKey "test"))
