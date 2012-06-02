note
	description: "A OBS_REPOSITORY implemented using file based storage"
	date: "$Date: $"
	revision: "$Revision: $"

class
	OBS_FILE_REPOSITORY

inherit
	OBS_REPOSITORY

create
	make

feature -- Access

	has (a_data_id: like new_data_id): BOOLEAN
			-- <Precursor>
		do
			
		end


end
