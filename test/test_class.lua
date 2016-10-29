test = require "test/test"
pp = require "diresys/pp"
f = require "diresys/func"
class = require "diresys/class"

local test_class = {}

test_class.test_inheritance_0 = function()
	Animal = class.create()

	function Animal:new(name)
		local obj = self:classInit()
		obj.name = name
		return obj
	end

	function Animal:say()
		return "ah!"
	end

	Goat = class.create(Animal)

	function Goat:new(name)
		local obj = Animal.new(self, name)
		obj.name = obj.name .. "!"
		return obj
	end

	Dog = class.create(Animal)

	function Dog:say()
		return "woof"
	end

	function Goat:eatsGrass()
		return true
	end

	function Goat:say()
		local v = Animal.say(self)
		return v .. "!"
	end

	local animal = Animal:new("Kevin")
	local dog = Dog:new("Bobo")
	local goat = Goat:new("Gary")

	test.assert(animal:say() == "ah!", "Animal inheritance 1")
	test.assert(dog:say() == "woof", "Dog Overloading Inheritance")
	test.assert(goat:say() == "ah!!", "Animal inheritance 2")
	test.assert(animal.name == "Kevin", "constructor")
	test.assert(dog.name == "Bobo", "constructor virtual")
	test.assert(goat.name == "Gary!", "constructor overloading")
	test.assert(goat:eatsGrass() == true, "new methods")
end

return test_class
