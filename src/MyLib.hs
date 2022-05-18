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
import System.FilePath (combine, isRelative)
import Text.Show.Unicode (ushow)

data TestParser = TestParser {
	templateFileName :: String,
	contentFilePath :: String
}

parser :: Parser TestParser
parser = TestParser
	<$> strOption
		(long "templateFileName"
		<> short 't'
		<> metavar "TEMPLATE"
		<> help "name of the template file in the config directory to use")
	<*> strOption
		(long "contentFilePath"
		<> short 'c'
		<> metavar "CONTENT"
		<> help "path to content that needs to be placed into the template")

nippouGenerator :: IO ()
nippouGenerator = do
	greet <- execParser opts
	print (templateFileName greet)
	print (contentFilePath greet)
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
	--let templateFileName = templateFileName greet
	----let contentFileName = contentFileName greet
	----note that this will not work, because it does not input the slash
	----to separate the directories. you need to use combine as below
	let templateFilePath = appXdgDir `combine` templateFileName greet
	--I guess this is the same thing as usin let
	--targetFile <- return appXdgDir ++ configFileName greet
	print ("template file path:" ++ templateFilePath)
	-- contentFilePath = (contentFilePath greet) will not work, because the let binding's
	-- name clashes with the accessor function for the TestParser record type,
	-- and to disambiguate it requires turning on language extensions
	-- we can use pattern matching in an assignment, though, which I did not know
	let TestParser { contentFilePath = c } = greet
	print ("content file path:" ++ c)
	print ("is relative?"  ++ show (isRelative c))
	contentFileContents <- readFile c
	--this prints out Japanese text as the utf-8 escape code and not the character itself
	--for example, it could print:
	--"content file contentsThis is the email body contents file.\n\12371\12428\12399\12513\12540\12523\12398\26412\25991\12501\12449\12452\12523\12391\12377\12290\n"
	-- (-_-)
	print ("content file contents" ++ contentFileContents)
	putStrLn (ushow ("content file contents" ++ contentFileContents))
	--there is a "<\>" operator that I should be able to use, but I can't figure out
	--how to import it
	--let targetFilePath = appXdgDir `combine` templateFileName
	--print ("target path:" ++ targetFilePath)
	----print ("target path:" ++ (appXdgDir `combine` templateFileName))
	--fileContents <- readFile targetFilePath
	--print fileContents
	----putStrLn "target file:" ++ targetFile
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
	

