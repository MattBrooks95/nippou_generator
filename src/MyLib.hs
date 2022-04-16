module MyLib (nippouGenerator) where
import Configuration (getConfiguration)

nippouGenerator :: IO ()
nippouGenerator = do
	config <- getConfiguration
	print config
