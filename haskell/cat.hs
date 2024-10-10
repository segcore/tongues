import System.IO
import qualified Data.ByteString as BS

main = do
    slice <- BS.hGetSome stdin 1024
    if BS.null slice
        then return ()
        else do
            BS.hPut stdout slice
            main
