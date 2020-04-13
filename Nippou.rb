require 'date'
require 'pp'


require_relative './NippouOptions'

class Nippou
	OPTION_ADDRESSES             = "addresses"
	OPTION_FIRST_NAME            = "firstName"
	OPTION_LAST_NAME             = "lastName"
	OPTION_MIDDLE_NAME           = "middleName"
	OPTION_FULL_NAME_OVERRIDE    = "fullNameOverride"
	OPTION_SUBJECT_LINE_LABEL    = "subjectLineLabel"
	OPTION_PUT_DATE_IN_SUBJECT   = "putDateInSubject"
	OPTION_INTRODUCTION          = "introduction"
	OPTION_MAIN_SECTION          = "mainSection"
	OPTION_WORK_CODE_LINE        = "workCodeLine"

	OPTION_BODY_SUBSECTIONS             = "bodySubsections"
	OPTION_BODY_SUBSECTIONS_HEADER      = 'header'
	OPTION_BODY_SUBSECTIONS_SECOND_PART = 'headerSecondPart'
	OPTION_BODY_SUBSECTIONS_CONTENT     = 'content'

	OPTION_CONCLUSION            = "conclusion"
	OPTION_POST_MESSAGE          = "postMessage"

	INTRODUCTION_TEMPLATE = "template"
	INTRODUCTION_ARGUMENTS = "arguments"

	@addresses
	@firstName
	@lastName
	@middleName
	@fullNameOverride
	@subjectLineLabel
	@putDateInSubject
	@introduction
	@mainSection
	@bodySubsections
	@conclusion
	@postMessage
	@workCodeLine

	def initialize(nippouOptions)
		# pp(nippouOptions)
		@configFilePath = nippouOptions.getConfigFilePath()
		@contentsFilePath = nippouOptions.getContentsFilePath()
		@commandLineOverrides = nippouOptions
		parseConfigFile()
		if(!nippouOptions.getContentsFilePath().nil?)
			loadBodyContents(nippouOptions.getContentsFilePath())
		end
	end

	def loadBodyContents(filePath)
		# puts "loading main body from #{filePath}"

		@mainSection['content'] = IO.read(filePath, encoding: 'UTF-8')
		# puts @mainSection
	end

	def parseConfigFile()
		# puts "parsing the config file"
		if(!@configFilePath.nil?)
			# puts "parsing at path:#{@configFilePath}"
			parseAtPath(@configFilePath)
		elsif(!@configFileName.nil?)
			# puts "parsing file with name:#{@configFileName}"
			parseAtPath("./config/user_configs/#{@configFileName}")
		else
			puts 'No config file specified'
		end
	end

	def parseAtPath(completePath)
		parser = FileParser.new()
		data = parser.parse(File.path(completePath));
		data.each do |key, value|
			# puts "key:#{key} value:#{value}"
			filter(key, value)
		end
	end

	def filter(key, value)
		case(key)
		when OPTION_ADDRESSES
			@addresses = value
		when OPTION_FIRST_NAME
			@firstName = @commandLineOverrides.getFirstName() || value
		when OPTION_LAST_NAME
			@lastName = @commandLineOverrides.getLastName() || value
		when OPTION_MIDDLE_NAME
			@middleName = value
		when OPTION_FULL_NAME_OVERRIDE
			@fullNameOverride = value
		when OPTION_SUBJECT_LINE_LABEL
			@subjectLineLabel = value
		when OPTION_PUT_DATE_IN_SUBJECT
			@putDateInSubject = value
		when OPTION_INTRODUCTION
			@introduction = value
		when OPTION_MAIN_SECTION
			@mainSection = value
		when OPTION_BODY_SUBSECTIONS
			@bodySubsections = value
		when OPTION_CONCLUSION
			@conclusion = @commandLineOverrides.getLastMessageFormal() || value
		when OPTION_POST_MESSAGE
			@postMessage = @commandLineOverrides.getLastMessagePersonal() || value
		when OPTION_WORK_CODE_LINE
			@workCodeLine = value
		else
			puts "Key:#{key} didn't hit a case in the switch statement"
		end
	end

	def getFullName()
		nameParts = [@lastName]
		if(@middleName)
			nameParts.push(@middleName)
		end
		nameParts.push(@firstName)
		return nameParts.join(' ')
	end

	def setDate(newDate = nil)
		if(!newDate.nil?)
			@date = newDate
		end

		@date = DateTime.now
	end

	def getDateFormatted(formatterString = "%Y/%m/%d")
		if(@date.nil?)
			puts 'no date specified, using today'
			setDate()
		end
		return @date.strftime(formatterString);
	end

	def getSubjectLabel()
		return @subjectLabel
	end

	def getFirstName()
		return @firstName
	end

	ADDRESS_SEPARATOR = ', '
	NEWLINE = "\n"
	INDENTNEWLINE = "#{NEWLINE}\t"

	def prepare()
		@preparedNippou = [
			buildRecipients(),
			"",
			buildSubject(),
			"",
			buildIntroduction(),
			"",
			buildBody(),
			buildConclusion()
		].join(NEWLINE)
	end

	def buildIntroduction()
		if(!defined(@introduction))
			return
		end

		introductionTemplate = @introduction[INTRODUCTION_TEMPLATE]
		introductionTemplateArguments = @introduction[INTRODUCTION_ARGUMENTS]

		compiledIntroduction = introductionTemplate % introductionTemplateArguments
		return compiledIntroduction
	end

	def buildConclusion()
		if(@conclusion.nil?)
			return ''
		end

		return @conclusion + @postMessage
	end

	def buildRecipients()
		if(@addresses.nil?)
			return ''
		end

		return @addresses.join(ADDRESS_SEPARATOR)
	end

	def getPreparedNippou()
		return @preparedNippou
	end

	def buildSubject()
		subjectLineElements = [@subjectLineLabel]

		if(@putDateInSubject)
			subjectLineElements.push(getDateFormatted())
		end

		if(!@fullNameOverride.nil? && @fullNameOverride != '')
			subjectLineElements.push(@fullNameOverride)
		else
			subjectLineElements.push(getFullName())
		end

		return subjectLineElements.join(' ')
	end

	def makeHeader(firstPart, secondPart = "")
		if(definedNonEmpty(firstPart))
			return firstPart + secondPart
		end

		return ""
	end

	def setPostMessage(postMessage)
		@postMessage = postMessage
	end

	def setWorkCodeLine(workCodeLine)
		@workCodeLine = workCodeLine
	end

	def buildBody()
		bodyContents = []
		# namePart = ""
		if(definedNonEmpty(@workCodeLine))
			bodyContents.push(@workCodeLine)
		end

		if(!@mainSection.nil?)
			if(definedNonEmpty(@workCodeLine))
				bodyContents.push(@workCodeLine)
			else
				bodyContents.push(@mainSection['header'])
				puts "pushing: #{@mainSection['header']}"
			end
			bodyContents.push(@mainSection['content'])
		end

		if(defined(@bodySubsections))
			processSubheaders(bodyContents)
		end

		if(definedNonEmpty(@farewell))
			bodyContents.push(@farewell)
		end

		if(definedNonEmpty(@postMessage))
			bodyContents.push(@postMessage)
		end

		separator = "\n\n"
		# puts bodyContents.join(separator)
		return bodyContents.join(separator)
	end

	def processSubheaders(arrayToPushInto)
		@bodySubsections.each do |subsection|
			header     = subsection[OPTION_BODY_SUBSECTIONS_HEADER]
			secondPart = subsection[OPTION_BODY_SUBSECTIONS_SECOND_PART]
			content    = subsection[OPTION_BODY_SUBSECTIONS_CONTENT]
			arrayToPushInto.push(makeHeader(header, secondPart))
			if(definedNonEmpty(content))
				arrayToPushInto.push(content)
			end
		end
	end

	def defined(object)
		return !object.nil?
	end

	def definedNonEmpty(string)
		return defined(string) && string != ''
	end

	def getFooter()
		return ""
	end

	def output()
		preparedNippou = getPreparedNippou()
		if(preparedNippou.nil?)
			puts 'Need to call prepare nippo method first!'
			return
		end
		puts preparedNippou
	end
end
