module MyLib (nippouGenerator) where
import System.Directory
import Control.Exception (
		try,
		SomeException,
		catch
	)
--import Configuration (getConfiguration)

import Options.Applicative
import Data.Semigroup ((<>))
import Data.List (intercalate)
import System.Directory.Internal.Prelude (exitFailure)
import System.FilePath (combine)

data TestParser = TestParser {
	configFileName :: String
}

parser :: Parser TestParser
parser = TestParser
	<$> strOption
		(long "templateFileName"
		<> short 't'
		<> metavar "TEMPLATE"
		<> help "path to the template file")

nippouGenerator :: IO ()
nippouGenerator = do
	greet <- execParser opts
	print (configFileName greet)
	appXdgDir <- getXdgDirectory XdgConfig "nippou_generator"
	print appXdgDir
	files <- try (listDirectory appXdgDir):: IO (Either SomeException [FilePath])
	case files of
		Left error ->  do
			putStrLn (appXdgDir ++ " configuration directory didn't exist, it will be created")
			catch (createDirectory appXdgDir) handler
			where
				handler :: SomeException -> IO()
				handler exception = do
					putStrLn " configuration directory creation failed"
					exitFailure
		Right files -> do
			putStr "files:"
			print files -- TODO I should probably make this a catch as well
	let templateFileName = configFileName greet
	--note that this will not work, because it does not input the slash
	--to separate the directories. you need to use combine as below
	let targetFile = appXdgDir ++ configFileName greet
	--I guess this is the same thing as usin let
	--targetFile <- return appXdgDir ++ configFileName greet
	print ("targetFile:" ++ targetFile)
	--there is a "<\>" operator that I should be able to use, but I can't figure out
	--how to import it
	let targetFilePath = appXdgDir `combine` templateFileName
	print ("target path:" ++ targetFilePath)
	--print ("target path:" ++ (appXdgDir `combine` templateFileName))
	fileContents <- readFile targetFilePath
	print fileContents
	--putStrLn "target file:" ++ targetFile
	where
		opts = info (parser <**> helper)
			(fullDesc
			<> progDesc "interpolate string values into an email TEMPLATE provided in a file"
			<> header "nippou generator - combines templates, data files and selected variables into an email body"
			)

--greet :: TestParser -> IO ()
--greet (TestParser h) = putStrLn $ "template file name: " ++ h 
--greet _ = return ()
--nippouGenerator = do
	--config <- getConfiguration
	--print config
	--appXdgDir <- getXdgDirectory XdgConfig "nippou_generator"
	--print appXdgDir
	--files <- try (listDirectory appXdgDir):: IO (Either SomeException [FilePath])
	--case files of
	--	Left error ->  do
	--		putStrLn (appXdgDir ++ " configuration directory didn't exist, it will be created")
	--		catch (createDirectory appXdgDir) handler
	--		where
	--			handler :: SomeException -> IO()
	--			handler exception = putStrLn " configuration directory creation failed"
	--	Right files -> print files -- TODO I should probably make this a catch as well
	

