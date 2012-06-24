note
	description: "Tests for OBS_REPOSITORY"
	author: "Neal L Lester"
	date: "$Date: $"
	revision: "$Revision: $"

class
	OBS_REPOSITORY_TEST_SET

inherit
	EQA_TEST_SET
	OBS_TEST_SET_HELPER
		undefine
			default_create
		end

feature -- Tests

	test_persistent_type_code
			-- Test feature `persistent_type_code'
		local
			l_repository: OBS_FILE_REPOSITORY
			l_existing_codes: ARRAYED_LIST [INTEGER]
			l_string_32: READABLE_STRING_32
			l_immutable_string: IMMUTABLE_STRING_32
			l_boolean: BOOLEAN
			l_tupple_1: TUPLE [STRING]
			l_tupple_2: TUPLE [string_1: STRING; integer_1: INTEGER]
			l_integer_list: ARRAYED_LIST [INTEGER]
			l_string_list: ARRAYED_LIST [STRING]
			l_string_code, l_immutable_string_code, l_boolean_code, l_tuple_1_code, l_tuple_2_code, l_string_list_code, l_integer_list_code: INTEGER
		do
			create l_repository.make_with_location (execution_environment.current_working_directory)
			create l_existing_codes.make (10)
			l_string_32 := ("String1").as_string_32
			l_string_code := l_repository.persistent_type_code (l_string_32)
			l_existing_codes.extend (l_string_code)
			assert ("string code same", l_string_code = l_repository.persistent_type_code (("String2").as_string_32))
			l_boolean_code := l_repository.persistent_type_code (False)
			assert ("existing codes not has l_boolean_code", not l_existing_codes.has (l_boolean_code))
			l_existing_codes.extend (l_boolean_code)
			assert ("boolean code same", l_boolean_code = l_repository.persistent_type_code (True))
			l_tuple_1_code := l_repository.persistent_type_code (["STRING"])
			assert ("existing codes not has l_tuple_1_code", not l_existing_codes.has (l_tuple_1_code))
			l_existing_codes.extend (l_tuple_1_code)
			assert ("tuple_1 code same", l_tuple_1_code = l_repository.persistent_type_code (["STRING5"]))
			l_tuple_2_code := l_repository.persistent_type_code (["STRING3", 1])
			assert ("existing codes not has l_tuple_2_code", not l_existing_codes.has (l_tuple_2_code))
			l_existing_codes.extend (l_tuple_2_code)
			assert ("tuple_2 code same", l_tuple_2_code = l_repository.persistent_type_code (["STRING4", 2]))
			l_string_list_code := l_repository.persistent_type_code (create {ARRAYED_LIST [INTEGER]}.make_from_array (<<1, 2>>))
			assert ("existing codes not has l_string_list_code", not l_existing_codes.has (l_string_list_code))
			l_existing_codes.extend (l_string_list_code)
			assert ("string_list code same", l_string_list_code = l_repository.persistent_type_code (create {ARRAYED_LIST [INTEGER]}.make_from_array (<<3, 4>>)))
			l_integer_list_code := l_repository.persistent_type_code (create {ARRAYED_LIST [STRING]}.make_from_array (<<"1", "2">>))
			assert ("existing codes not has l_integer_list_list_code", not l_existing_codes.has (l_integer_list_code))
			l_existing_codes.extend (l_integer_list_code)
			assert ("integer_list_list code same", l_integer_list_code = l_repository.persistent_type_code (create {ARRAYED_LIST [STRING]}.make_from_array (<<"1", "2">>)))
			l_immutable_string := "My Immutable_string"
			l_immutable_string_code := l_repository.persistent_type_code (l_immutable_string)
			assert ("existing codes not has l_immutable_string_code", not l_existing_codes.has (l_immutable_string_code))
			l_immutable_string := "My Immutable_string 2"
			l_string_32 := l_immutable_string
			l_existing_codes.extend (l_immutable_string_code)
			assert ("immutable_string code same", l_immutable_string_code = l_repository.persistent_type_code (l_string_32))
			l_string_32 := ("String10").as_string_32
			assert ("string code same", l_string_code = l_repository.persistent_type_code (("String2").as_string_32))
		end

feature {NONE} -- Test Support

	execution_environment: EXECUTION_ENVIRONMENT
			-- Environment in which test is executed
		once
			create Result
		end

end
