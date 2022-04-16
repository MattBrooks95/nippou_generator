module Configuration where
import OperatingSystem (
		getEnvironmentVariable,
	)

newtype SearchPaths = SearchPaths [Path]

type Path = String

type ScriptRootDir = Path

data NippouGeneratorConfig = NippouGeneratorConfig {} deriving Show

getConfiguration :: IO NippouGeneratorConfig
getConfiguration = do
	homeDirectory <- getEnvironmentVariable "HOME"
	case homeDirectory of
		Just homeDir -> print ("home dir:" ++ homeDir)
		Nothing -> print "home dir was not found"
	xdgConfigDir <- getEnvironmentVariable "XDG_CONFIG_HOME"
	case xdgConfigDir of
		Just configDir -> print $ "config dir:" ++ configDir
		Nothing -> print "config dir was not found"
	return NippouGeneratorConfig {}

