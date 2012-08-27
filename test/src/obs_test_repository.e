note
	description: "A repository for use in testing"
	author: "Neal Lester"
	date: "$Date: $"
	revision: "$Revision: $"

class
	OBS_TEST_REPOSITORY

inherit
	OBS_REPOSITORY

create
	make

feature -- Status Report

	has (a_data_id: like new_data_id): BOOLEAN
			-- <Precursor>
		do
			check not_implemented: False end
		end

feature -- Basic Operations

	persist_data_id
			-- <Precursor>
		do
		end

	persist_repository
			-- <Precursor>
		do
		end

end
