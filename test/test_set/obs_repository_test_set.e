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
			l_repository: OBS_TEST_REPOSITORY
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
			create l_repository.make
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

	test_type_cross_reference
			-- Test feature `type_cross_reference'
		local
			l_repository: OBS_TEST_REPOSITORY
			l_known_list: ARRAYED_LIST [TUPLE [class_name: STRING; persistent_type: INTEGER; dynamic_type: INTEGER]]
			l_known_item: TUPLE [class_name: STRING; persistent_type: INTEGER; dynamic_type: INTEGER]
			l_internal: INTERNAL
			l_type_cross_reference, l_string: STRING
			l_integer: INTEGER
			l_lines, l_entries: LIST [STRING]
		do
			create l_internal
			create l_known_list.make (3)
			create l_repository.make
			l_string := ""
			l_known_list.extend ([l_string.generating_type.name.as_string_8, l_repository.persistent_type_code (l_string), l_internal.type_of (l_string).type_id])
			l_known_list.extend ([l_integer.generating_type.name.as_string_8, l_repository.persistent_type_code (l_integer), l_internal.type_of (l_integer).type_id])
			l_known_list.extend ([l_internal.generating_type.name.as_string_8, l_repository.persistent_type_code (l_internal), l_internal.type_of (l_internal).type_id])
			l_type_cross_reference := l_repository.type_cross_reference
			l_lines := l_type_cross_reference.split ('%N')
			across l_lines as ic_lines loop
				if not ic_lines.item.is_empty	 then
					l_known_item := l_known_list.i_th (ic_lines.cursor_index)
					l_entries := ic_lines.item.split (',')
					assert ("class_same_string" + ic_lines.cursor_index.out, l_entries.i_th (1).same_string (l_known_item.class_name))
					assert ("persistent_type" + ic_lines.cursor_index.out, l_entries.i_th (2).to_integer = l_known_item.persistent_type)
					assert ("dynamic_type" + ic_lines.cursor_index.out, l_entries.i_th (3).to_integer = l_known_item.dynamic_type)
				end
			end
			l_repository.load_type_cross_reference (l_type_cross_reference)
			assert ("type_cross_reference loaded correctly", l_type_cross_reference.same_string (l_repository.type_cross_reference))
		end

feature {NONE} -- Test Support

	execution_environment: EXECUTION_ENVIRONMENT
			-- Environment in which test is executed
		once
			create Result
		end

end
