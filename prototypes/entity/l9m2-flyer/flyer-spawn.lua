
-- flyers in the spitter spawner. the chances were startup settings in the l9m2-flyer-enemy mod, fixed to its defaults.
-- (frontier td spawns its waves from script, the spawners on the map do not spawn anything)
local biterSpawner = data.raw["unit-spawner"]["spitter-spawner"]
if biterSpawner then
    local small_rate = 0.75
    local medium_rate = 0.75
    local big_rate = 0.75
    local behemoth_rate = 0.75
    --local leviathan_rate = setting_utils.getPositivePercentageOf("l9m2-flyer-leviathan-flyer-spawn-probability")
    local ultra_rate = 0.25
    local unitSet = biterSpawner["result_units"]
    unitSet[#unitSet + 1] = {
        "small-flyer",
		{
			{
			
			0.0, --Evolution Factor
			0.0 --Spawn chance
			},
            {
			
                0.02, --Evolution Factor
                0.0 --Spawn chance
                },
			{
				0.1,
				0.3 * small_rate
			},
			{
				0.4,
				0.0
			}
		}
	}
    unitSet[#unitSet + 1] = {
        "medium-flyer",
        {
            {
                0.2,
                0.0
            },
            {
                0.4,
                0.3 * medium_rate
            },
            {
                0.7,
                0.1 * medium_rate
            }
        }
    }
    unitSet[#unitSet + 1] = {
        "big-flyer",
        {
            {
                0.5,
                0.0
            },
            {
                1.0,
                0.4 * big_rate
            }
        }
    }
    unitSet[#unitSet + 1] = {
        "behemoth-flyer",
        {
            {
                0.9,
                0.0
            },
            {
                1.0,
                0.3 * behemoth_rate
            }
        }
    }
    unitSet[#unitSet + 1] = {
        "ultra-flyer",
        {
            {
                0.97,
                0.0
            },
            {
                1.0,
                0.01 * ultra_rate
            }
        }
    }
    end