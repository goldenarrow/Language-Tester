--Language Tester
require 'lfs'

language = {}
language.__index = language

--language class functions

function language.create(name)
	l = {}
	l.name = name
	setmetatable(l, language)
	return l
end

function language:selectOpt()
	x = io.read()
	if tostring(x) == "t" then
		self:testMenu()
	elseif tostring(x) == "n" then
		self:newWord()
	elseif tostring(x) == "d" then
		self:delWord()
	elseif tostring(x) == "b" then
		printLangs()
	end
end

function language:loadMenu()
	os.execute("cls")
	print("t) Test")
	print("n) New Word")
	print("d) Delete Word \n")
	print("b) Go Back \n")
	print("Type the value of the option you would like to select")
	self:selectOpt()
end

function language:newWord()
	os.execute("cls")
	print("What is the word?")
	word = io.read()
	file = io.open("Files/"..self.name.."/"..word..".txt", "w")
	file:write(word.."\n")
	os.execute("cls")
	print("What does the word mean?")
	x = io.read()
	file:write(x.."\n")
	os.execute("cls")
	print("Give a hint for yourself of what the word means")
	x = io.read()
	file:write(x)
	file:close()
	file = io.open("Files/"..self.name.."/wordcount.txt", "w")
	file:write(word.."\n")
	file:close()
	self:loadMenu()
end

--Main Menu Functions

function getLangs()
	langs = {}
	file = io.open("files/languages.txt")
	ctrl = 0
	for line in file:lines() do
		langs[ctrl] = language.create(line)
		langs[ctrl]["number"] = ctrl + 1
		print(langs[ctrl]["number"])
		ctrl = ctrl + 1
	end
end

function saveLangs()
	file = io.open("files/languages.txt", "w")
	for k, v in pairs(langs) do
		file:write(v.name.."\n")
	end
	file:close()
end

function selectLang()
	print("Type the value of the option you would like to select")
	x = io.read()
	if x == "n" then
		newLang()
	elseif x == "e" then
		os.exit()
	elseif x == "d" then
		delLang()
	else
		ctrl = 0
		for k, v in pairs(langs) do
			if tonumber(x) == langs[ctrl]["number"] then
				v:loadMenu()
			end
			ctrl = ctrl + 1
		end
	end
end


function printLangs()
	os.execute("cls")
	ctrl = 1
	for k, v in pairs(langs) do
		print(ctrl..") "..v.name)
		ctrl = ctrl + 1
	end
	print("")
	print("n) New Language")
	print("d) Delete Language")
	print("e) Exit ")
	selectLang()
end


function delLang()
	os.execute("cls")
	print("Which language would you like to be deleted?  Please be exact with spelling and capitalisation.")
	x = io.read()
	ctrl = 0
	for k, v in pairs (langs) do
		if v == x then
			langs[ctrl] = nil
		end
	end
	saveLangs()
	getLangs()
	print("Press any button to return to select screen...")
	x = io.read()
	printLangs()
end



function newLang()
	os.execute("cls")
	ctrl = 0
	for k, v in pairs(langs) do
		ctrl = ctrl + 1
	end
	print("Type the name of the language")
	name = io.read()
	langs[(ctrl + 1)] = language.create(name)
	lfs.mkdir("Files/"..name)
	saveLangs()
	print("Press any button to return to select screen...")
	x = io.read()
	printLangs()
end




getLangs()
printLangs()
