note
	description : "ob-server application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	OBJECT_SERVER_POC

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end
