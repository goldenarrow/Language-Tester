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
		self:fetchWords()
		self:testWord()
	elseif tostring(x) == "n" then
		self:newWord()
	elseif tostring(x) == "b" then
		printLangs()
	else
		self:selectOpt()
	end
end

function language:loadMenu()
	os.execute("cls")
	print("t) Test")
	print("n) New Word \n")
	print("b) Go Back \n")
	print("Type the value of the option you would like to select")
	self:selectOpt()
end

function language:newWord()
	os.execute("cls")
	print("What is the word?")
	word = io.read()
	file = io.open("Files/"..self.name.."/"..word..".txt", "w")
	os.execute("cls")
	print("What does the word mean?")
	x = io.read()
	file:write(x.."\n")
	os.execute("cls")
	print("Give a hint for yourself of what the word means")
	x = io.read()
	file:write(x)
	file:close()
	file = io.open("Files/"..self.name.."/wordcount.txt")
	num = tonumber(file:read())
	file:close()
	num = num + 1
	file = io.open("Files/"..self.name.."/wordcount.txt", "w")
	file:write(num)
	file:close()
	file = io.open("Files/"..self.name.."/words.txt", "a")
	file:write(word.."\n")
	file:close()
	self:loadMenu()
end

function language:fetchWords()
	ctrl = 0
	self.words = {}
	file = io.open("Files/"..self.name.."/words.txt")
	for line in file:lines() do
		self.words[ctrl] = {}
		self.words[ctrl]["name"] = line
		f = io.open("Files/"..self.name.."/"..self.words[ctrl]["name"]..".txt")
		self.words[ctrl].checked = 0
		ctrls = 0
		for iline in f:lines() do
			if ctrls == 0 then
				self.words[ctrl]["meaning"] = iline
			else
				self.words[ctrl]["hint"] = iline
			end
			ctrls = ctrls + 1
		end
		ctrl = ctrl + 1
	end
	self.words["amount"] = ctrl
	print(self.words["amount"])
end

function language:selectWord()
	math.randomseed(os.time())
	amount = self.words["amount"] -1
	rand = math.random(amount)
	print(rand)
	while self.words[rand]["checked"] > 0 do
		rand = math.random(0, self.words["amount"])
	end
	return self.words[rand]
end

function language:testWord()
	answer = ""
	testScore = 0
	amount2 = self.words["amount"] - 1
	for i = 0, amount2 do
		testWord = self:selectWord()
		hintUsed = 0
		while testWord.checked == 0 do
			os.execute("cls")
			print(testWord.name.."\n")
			if hintUsed == 0 then
				print("Type the meaning of this word.  If you get it wrong it will be given to you again at somepoint later.  Type 'help' for a hint. Type 'a' for the answer. Type 'e' to end the test.")
			else
				print("Type the meaning of this word.  If you get it wrong it will be given to you again at somepoint later.  You cannot use the hint anymore.  Type 'a' for the answer. Type 'e' to end the test.")
			end
			answer = io.read()
			if answer == "help" and hintUsed == 0 then
				hintUsed = 1
				os.execute("cls")
				print(testWord["hint"])
				wait = io.read()
				os.execute("cls")
				print(testWord.name.."\n")
				print("Type the meaning of this word.  If you get it wrong it will be given to you again at somepoint later.  You cannot use the hint anymore.  Type 'a' for the answer. Type 'e' to end the test.")
				answer = io.read()
				if answer == testWord.meaning then
					print("Well Done.  Moving on!")
					testScore = testScore + 1
					testWord.checked = 1
					wait = io.read()
				elseif answer == "a" then
					os.execute("cls")
					print(testWord.meaning)
					tesetWord.checked = 1
					wait  = io.read()
				elseif answer == "e" then
					self:loadMenu()
				else
					i = i - 1
					print("Sorry, try again later")
					wait = io.read()
				end
			elseif answer == "help" and hintUsed == 1 then
				print("You have already used your hint!")
				wait = io.read()
			elseif answer == testWord.meaning then
				print("Well Done.  Moving on!")
				testWord.checked = 1
				testScore = testScore + 1
				wait = io.read()
			elseif answer == "a" then
				os.execute("cls")
				print(testWord.meaning)
				testWord.checked = 1
				wait  = io.read()
			elseif answer == "e" then
				self:loadMenu()
			else
				i = i - 1
				print("Sorry, Try Again Later.")
				wait = io.read()
			end
		end
	end
	os.execute("cls")
	print("You Scored: "..testScore.."!")
	wait = io.read()
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
	printLangs()
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
	file = io.open("Files/"..name.."/wordcount.txt", "w")
	file:write(0)
	file:close()
	file = io.open("Files/"..name.."/words.txt", "w")
	file:close()
	getLangs()
	printLangs()
end




getLangs()
printLangs()
