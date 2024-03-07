#!cue

// Basic lookup of grains
"Testing": {
	"test.succeed_without_changes": [
		{name: "This is running on \(#grains.os)"},
	]
}

// Loop test
#deployregions: ["area1", "area2", "area3"]
for i, region in #deployregions {
	"\( region ) setup": {
		"test.succeed_without_changes": [
			{
				name: "Success #\( i )"
			},
		]
	}
}

// Conditional test
#SystemWithExa: {
	"exa": {
		"pkg.installed": [
		]
	}
}

#SystemWithoutExa: {
	"exa": {
		"test.succeed_without_changes": [
			{
				name: "This system opted not to install exa. (\(#grains.os))"
			},
		]
	}
}

if #grains.os == "Ubuntu" {
	#SystemWithExa
}

if #grains.os != "Ubuntu" {
	#SystemWithoutExa
}
