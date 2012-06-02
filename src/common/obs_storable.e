note
	description: "Objects persisted via an OBS_REPOSITORY"
	date: "$Date: $"
	revision: "$Revision: $"

deferred class
	OBS_STORABLE

feature {NONE} -- Creation

	make_storable (a_repository: OBS_REPOSITORY; a_segment: OBS_SEGMENT)
			-- Create Current with `a_repository' and `a_segment'
		do
			repository := a_repository
			segment := a_segment
		end

feature

	data_id: NATURAL_64
			-- ID of Current within `repository'

	is_persistent: BOOLEAN
			-- Has Current been persisted to `repository'

	is_dirty: BOOLEAN
			-- Does Current include non-persistent changes?

	is_read_only: BOOLEAN
			-- Is Current in read only mode?
		do
			Result := not attached segment
		ensure
			not_read_only_implies_attached_segment: not Result implies attached segment
		end

feature {OBS_REPOSITORY} -- Persistence Management

	set_persisted
			-- Indicate that Current has been persisted to `repository'
		do
			is_persistent := True
			is_dirty := False
		end

feature {OBS_TEST_SET_HELPER} -- Implementation

	segment: detachable OBS_SEGMENT
			-- The current containing Current, if `is_dirty'

	repository: OBS_REPOSITORY
			-- The repository which contains or will contain Current

invariant
	not_persistent_implies_is_dirty: not is_persistent implies is_dirty
	is_persistent_implies_repository_has_current: is_persistent implies repository.has (data_id)

end
