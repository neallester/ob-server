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
		local
			l_repository: OBS_REPOSITORY
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
			create l_repository.make
		end

end
