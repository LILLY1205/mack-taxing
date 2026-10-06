Config = {}
-- Set job account money will be sent to
Config.Job = "governor"

-- Set webhook to send logs total
Config.Logs = "taxes" -- If you use the default. Add "taxes" to you config.lua for qb-logs

-- Change how offten your taxed. Default is 60 Mins
Config.Time = 7200000 --Use google to translate the timing. Its in ms.

-- Change Percentages
Config.TaxBracket1 = 0 -- Set Tax Braket 1 (Flyin)

Config.TaxBracket2 = 1 -- Set Tax Braket 2 (Poor)

Config.TaxBracket3 = 2 -- Set Tax Braket 3 (Not Bad)

Config.TaxBracket4 = 4 -- Set Tax Braket 4 (Medium)

Config.TaxBracket5 = 6 -- Set Tax Braket 5 (Rich)

Config.TaxBracket6 = 8 -- Set Tax Braket 6 (Too Rich)


-- Set minimum bank value to be taxed in this bracket
Config.flyin = 0.5

Config.poor = 1

Config.notbad = 2

Config.medium = 3

Config.rich = 4

Config.toorich = 5