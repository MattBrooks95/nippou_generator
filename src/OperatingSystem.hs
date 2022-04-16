module OperatingSystem (
	getEnvironmentVariable,
) where
import System.Environment (lookupEnv)

getEnvironmentVariable :: String -> IO (Maybe String)
getEnvironmentVariable targetVariable = do 
	environmentVariable <- lookupEnv targetVariable
	case environmentVariable of
		(Just _) -> return environmentVariable
		Nothing -> return Nothing
