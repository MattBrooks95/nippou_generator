class NippouOptions
	def NippouOptions()
		puts "constructed nippou options"
	end

	# gotta be a better way to do this
	def setFromOther(otherOptions)
		if(!otherOptions.is_a?(NippouOptions))
			puts "#{__METHOD__} given incompatible object!"
		end

		@configFilePath      = otherOptions.getConfigFilePath()
		@firstName           = otherOptions.getFirstName()
		@lastName            = otherOptions.getLastName()
		@contentsFilePath    = otherOptions.getContentsFilePath()
		@postMessage         = otherOptions.getPostMessage()
		@lastMessageFormal   = otherOptions.getLastMessageFormal()
		@lastMessagePersonal = otherOptions.getLastMessagePersonal()
		@contentSubSections  = otherOptions.getContentSubSections()
	end

	def getInspectString()
		return self.inspect;
	end

	def printInspect()
		puts(getInspectString())
	end

	def fillFromJson(jsonFilePath)

	end

	def setConfigFilePath(configFilePath)
		@configFilePath = configFilePath
	end

	def getConfigFilePath()
		return @configFilePath
	end

	def setFirstName(firstName)
		@firstName = firstName
	end

	def getFirstName()
		return @firstName
	end

	def setLastName(lastName)
		@lastName = lastName
	end

	def getLastName()
		return @lastName
	end

	def setContentsFilePath(contentsFilePath)
		@contentsFilePath = contentsFilePath
	end

	def getContentsFilePath()
		return @contentsFilePath
	end

	def setPostMessage(postMessage)
		@postMessage = postMessage
	end

	def getPostMessage()
		return @postMessage
	end

	def setLastMessageFormal(lastMessageFormal)
		@lastMessageFormal = lastMessageFormal
	end

	def getLastMessageFormal()
		return @lastMessageFormal
	end

	def setLastMessagePersonal(lastMessagePersonal)
		@lastMessagePersonal = lastMessagePersonal
	end

	def getLastMessagePersonal()
		return @lastMessagePersonal
	end

	def setContentSubsections(contentSubsections)
		@contentSubSections = contentSubSections
	end

	def getContentSubSections()
		return @getContentSubSections
	end
end
