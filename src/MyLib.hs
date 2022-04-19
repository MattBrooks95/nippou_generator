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

data TestParser = TestParser {
	configFileName :: String
}

parser :: Parser TestParser
parser = TestParser
	<$> strOption
		(long "templateFileName"
		<> short 't'
		<> help "path to the template file")

nippouGenerator :: IO ()
nippouGenerator = greet =<< execParser opts
	where
		opts = info (parser <**> helper)
			(fullDesc
			<> progDesc "interpolate string values into an email template provided in a file"
			<> header "nippou generator - combines templates, data files and selected variables into an email body"
			)

greet :: TestParser -> IO ()
greet (TestParser h) = putStrLn $ "template file name: " ++ h 
greet _ = return ()
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
	

