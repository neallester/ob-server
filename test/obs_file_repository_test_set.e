note
	description: "Tests of class OBS_FILE_RESPOSITORY"
	date: "$Date: $"
	revision: "$Revision: $"

class
	OBS_FILE_REPOSITORY_TEST_SET

inherit
	EQA_TEST_SET
	OBS_TEST_SET_HELPER
		undefine
			default_create
		end

feature -- Tests

	test_has
			-- Test OBS_FILE_REPOSITORY.has
		local
			l_repository: OBS_FILE_REPOSITORY
			l_data_id: NATURAL_64
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_current_directory_name: STRING
		do
			l_data_id := 100
			l_current_directory_name := execution_environment.current_working_directory
			create l_repository.make_with_location (l_current_directory_name)
			assert ("not has", not l_repository.has (l_data_id))
			create l_file_name.make
			l_file_name.set_directory (l_current_directory_name)
			l_file_name.set_file_name (l_repository.file_name_for_id (l_data_id))
			create l_file.make_open_write (l_file_name.string)
			l_file.put_new_line
			l_file.close
			assert ("has", l_repository.has (l_data_id))
			l_file.delete
			assert ("cleaned-up", not l_repository.has (l_data_id))
		end

	test_persist_data_id
			-- Test OBS_FILE_REPOSITORY.persist_data_id
		local
			l_repository: OBS_FILE_REPOSITORY
			l_data_id: NATURAL_64
		do
			create l_repository.make_with_location (execution_environment.current_working_directory)
			l_data_id := l_repository.new_data_id
			l_data_id := l_repository.new_data_id
			l_data_id := l_repository.new_data_id
			assert ("new_data_id_value", l_repository.last_assigned_data_id = 3)
			create l_repository.make_with_location (execution_environment.current_working_directory)
			assert ("new_data_id_value after retrieval", l_repository.last_assigned_data_id = 3)
			l_repository.data_id_file.delete
		end

feature {NONE} -- Test Support

	execution_environment: EXECUTION_ENVIRONMENT
			-- Environment in which test is executed
		once
			create Result
		end


end
