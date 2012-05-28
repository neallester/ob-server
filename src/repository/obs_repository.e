note
	description: "Storage for persistent objects"
	date: "$Date$"
	revision: "$Revision$"

class
	OBS_REPOSITORY

create
	make

feature {NONE} -- Creation

	make
			-- Creation with defaults
		do
			create dynamic_type_by_persistent_type.make (projected_class_count)
			create persistent_type_by_dynamic_type.make (projected_class_count)
			create persistent_type_by_name.make (projected_class_count)
		end

feature -- Access

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
			end
		ensure
			valid_result: Result > 0
			persistent_type_by_name_has: Result = persistent_type_by_name.item (internal.type_name_of_type (internal.dynamic_type (a_object)))
			persistent_type_by_dynamic_type_has: Result = persistent_type_by_dynamic_type.item (internal.dynamic_type (a_object))
			dynamic_type_by_persistent_type_has: dynamic_type_by_persistent_type.item (Result) = internal.dynamic_type (a_object)
		end

feature {NONE} -- Implementation

	is_metadata_dirty: BOOLEAN
			-- Has metadata about Current changed since the last save?

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

	internal: INTERNAL
			-- Access to class INTERNAL
		once
			create Result
		end

invariant
	last_persistent_type_code_assigned_non_negative: last_persistent_type_code_assigned >= 0

end
