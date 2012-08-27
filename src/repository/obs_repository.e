note
	description: "Storage for persistent objects"
	date: "$Date: $"
	revision: "$Revision: $"

deferred class
	OBS_REPOSITORY

feature {NONE} -- Creation

	make
			-- Creation with defaults
		do
			create dynamic_type_by_persistent_type.make (projected_class_count)
			create persistent_type_by_dynamic_type.make (projected_class_count)
			create persistent_type_by_name.make (projected_class_count)
		end

feature -- Access

	new_data_id: NATURAL_64
			-- A new (previously unassigned) value for use as a data_id in an OBS_STORABLE
			--| Violates CQS to simplify atomic assignment in a multi-threaded environment
		do
			Result := last_assigned_data_id + 1
			last_assigned_data_id := Result
			persist_data_id
		ensure
			result_incremented: Result > old last_assigned_data_id
		end

	has (a_data_id: like new_data_id): BOOLEAN
			-- Is an object with `a_data_id' persisted within Current?
		deferred
		end

feature -- Basic Operations

	persistent_type_code (a_object: ANY): INTEGER
			-- Persistent type code for `a_object'
		local
			l_dynamic_type: INTEGER
			l_internal: INTERNAL
		do
			l_internal := internal
			l_dynamic_type := l_internal.dynamic_type (a_object)
			Result := persistent_type_by_dynamic_type.item (l_dynamic_type)
			if Result = 0 then
				last_persistent_type_code_assigned := last_persistent_type_code_assigned + 1
				Result := last_persistent_type_code_assigned
				persistent_type_by_name.put (Result, internal.type_name_of_type (l_dynamic_type))
				dynamic_type_by_persistent_type.put (l_dynamic_type, Result)
				persistent_type_by_dynamic_type.put (Result, l_dynamic_type)
				persist_repository
			end
		ensure
			valid_result: Result > 0
			persistent_type_by_name_has: Result = persistent_type_by_name.item (internal.type_name_of_type (internal.dynamic_type (a_object)))
			persistent_type_by_dynamic_type_has: Result = persistent_type_by_dynamic_type.item (internal.dynamic_type (a_object))
			dynamic_type_by_persistent_type_has: dynamic_type_by_persistent_type.item (Result) = internal.dynamic_type (a_object)
		end

feature {OBS_TEST_SET_HELPER} -- Implementation

	persist_data_id
			-- Persist `last_assigned_data_id' to storage medium
		deferred
		end

	persist_repository
			-- Persist Current to storage medium
		deferred
		end

	last_assigned_data_id: NATURAL_64
			-- The previously assigned `data_id'

	last_persistent_type_code_assigned: INTEGER
			-- The previously assigned persistent type code

	projected_class_count: INTEGER
			-- Expected number of classes in the system
		attribute
			Result := 500
		end

	dynamic_type_by_persistent_type: HASH_TABLE [INTEGER, INTEGER]
			-- Dynamic type codes in current system, indexed by their code in the repository

	persistent_type_by_dynamic_type: HASH_TABLE [INTEGER, INTEGER]
			-- Persistent type codes in the repository, indexed by their dynamic type in the current system

	persistent_type_by_name: HASH_TABLE [INTEGER, STRING]
			-- Persistent type codes in the repository, indexed by their class name

	type_cross_reference: STRING
			-- A cross reference of the contents of class name, persistent type code, and dynamic type code
			-- in comma separated format: class_name,persistent_type_code,dynamic_type_code
		local
			l_persistent_type_code: INTEGER
		do
			Result := ""
			from
				persistent_type_by_name.start
			until
				persistent_type_by_name.after
			loop
				Result.append (persistent_type_by_name.key_for_iteration + ",")
				l_persistent_type_code := persistent_type_by_name.item_for_iteration
				Result.append (l_persistent_type_code.out + ",")
				if l_persistent_type_code > last_persistent_type_code_assigned then
					last_persistent_type_code_assigned := l_persistent_type_code
				end
				Result.append (dynamic_type_by_persistent_type.item (l_persistent_type_code).out + "%N")
				persistent_type_by_name.forth
			end
		end

	internal: INTERNAL
			-- Access to class INTERNAL
		once
			create Result
		end

invariant
	last_persistent_type_code_assigned_non_negative: last_persistent_type_code_assigned >= 0

end
