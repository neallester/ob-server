note
	description: "A OBS_REPOSITORY implemented using file based storage"
	date: "$Date: $"
	revision: "$Revision: $"

class
	OBS_FILE_REPOSITORY

inherit
	OBS_REPOSITORY

create
	make_with_location

feature {NONE} -- Initialization

	make_with_location (a_directory: STRING)
			-- Create repository file files stored at `a_directory'
		require
			is_directory_writable: is_directory_writable (a_directory)
		local
			l_data_id_file_name: FILE_NAME
		do
			directory_name := a_directory
			create directory.make_open_read (a_directory)
			create l_data_id_file_name.make
			l_data_id_file_name.set_directory (a_directory)
			l_data_id_file_name.set_file_name ("last_assigned_data_id.txt")
			create data_id_file.make (l_data_id_file_name.string)
			if data_id_file.exists then
				data_id_file.open_read
				data_id_file.read_natural_64
				last_assigned_data_id := data_id_file.last_natural_64
				data_id_file.close
			end
			make

		end

feature -- Access

	has (a_data_id: like new_data_id): BOOLEAN
			-- <Precursor>
		do
			Result := directory.has_entry (file_name_for_id (a_data_id))
		end

	is_directory_writable (a_directory: STRING): BOOLEAN
			-- Does `a_directory' exist
		local
			l_directory: DIRECTORY
			l_exception_occurred: BOOLEAN
		do
			if not l_exception_occurred then
				create l_directory.make_open_read (a_directory)
				Result := l_directory.is_writable
			end
		rescue
			l_exception_occurred := True
			Retry
		end

	file_extension: STRING = "obj"

	file_name_for_id (a_data_id: like new_data_id): STRING
			-- File name of file containing serialization of object with `a_data_id'
		do
			Result := a_data_id.out + "." + "obj"
		end

feature {OBS_TEST_SET_HELPER} -- Implementation

	directory_name: STRING
			-- Name of directory in which current is stored

	directory: DIRECTORY
			-- Representation of file system directory containing Current

	data_id_file: PLAIN_TEXT_FILE
			-- File in which `last_assigned_data_id' is stored

	persist_data_id
			-- <Precursor>
		do
			data_id_file.open_write
			data_id_file.put_natural_64 (last_assigned_data_id)
			data_id_file.close
		end

	persist_repository
			-- <Precursor>
		do
		end

invariant

	name_consistent: directory.name.same_string (directory_name)

end
