{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_DMXorcist (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/plutus/harryprayiv/DMXorcist/.cabal-sandbox/bin"
libdir     = "/home/plutus/harryprayiv/DMXorcist/.cabal-sandbox/lib/x86_64-linux-ghc-8.0.2/DMXorcist-0.1.0.0-LMWZhUknmqpKTgckV5BF3J"
dynlibdir  = "/home/plutus/harryprayiv/DMXorcist/.cabal-sandbox/lib/x86_64-linux-ghc-8.0.2"
datadir    = "/home/plutus/harryprayiv/DMXorcist/.cabal-sandbox/share/x86_64-linux-ghc-8.0.2/DMXorcist-0.1.0.0"
libexecdir = "/home/plutus/harryprayiv/DMXorcist/.cabal-sandbox/libexec"
sysconfdir = "/home/plutus/harryprayiv/DMXorcist/.cabal-sandbox/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "DMXorcist_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "DMXorcist_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "DMXorcist_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "DMXorcist_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "DMXorcist_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "DMXorcist_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
