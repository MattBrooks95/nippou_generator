module Configuration where
import Data.Map (
		Map,
		elems,
		mapWithKey,
		toList
	)
import qualified Data.Map as Map
import Data.Maybe (fromMaybe)
import Data.List (
		concat,
		intercalate
	)
import OperatingSystem (
		getEnvironmentVariable,
	)

newtype SearchPaths = SearchPaths [Path]

type Path = String

type ScriptRootDir = Path

data WorkCode = WorkCode {
		code::String,
		display::String,
		description::Maybe String
	} deriving Show

type WorkCodes = [WorkCode]

appConfigDir = "nippou_generator"

data NippouGeneratorConfig = NippouGeneratorConfig {
		workCodes:: WorkCodes,
		environmentVariables:: Map.Map String (IO (Maybe String))
	}

instance Show NippouGeneratorConfig where
	show nippouGeneratorConfig = intercalate "\n" [shownWorkCodes, shownEnvironmentVariableMap]
		where
			shownWorkCodes = show (workCodes nippouGeneratorConfig)
			--shownEnvironmentVariableMap = intercalate " " (map (\x -> (fst x) ++ ":" ++ (fromMaybe "env variable not found" (snd x))) (toList (environmentVariables nippouGeneratorConfig)))
			shownEnvironmentVariableMap = show "TODO print IO values in the environment variable map"
			--shownEnvironmentVariableMap = show (map fromMaybe (environmentVariables nippouGeneratorConfig))
			--shownEnvironmentVariableMap = show (environmentVariables nippouGeneratorConfig)

defaultMaybe :: Maybe String -> String -> String
defaultMaybe realString defaultString = fromMaybe defaultString realString

getEnvironmentVariablesMap :: (String -> IO (Maybe String)) -> [String] -> Map.Map String (IO (Maybe String))
getEnvironmentVariablesMap getVariable variableNames =
	let variables = [ (x, getVariable x) | x <- variableNames ] in
	Map.fromList variables

getConfiguration:: IO NippouGeneratorConfig
getConfiguration = do
	homeDirectory <- getEnvironmentVariable "HOME"
	case homeDirectory of
		Just homeDir -> print ("home dir:" ++ homeDir)
		Nothing -> print "home dir was not found"
	xdgConfigDir <- getEnvironmentVariable "XDG_CONFIG_HOME"
	case xdgConfigDir of
		Just configDir -> print $ "config dir:" ++ configDir
		Nothing -> print "config dir was not found"
	return NippouGeneratorConfig {
			workCodes=[],
			environmentVariables=environmentVariablesMap
		}
	where environmentVariablesMap = getEnvironmentVariablesMap getEnvironmentVariable [
			"XDG_CONFIG_HOME",
			"HOME",
			"APPDATA"
		]
		

