{ scanDir, grepCountAll, findName, unique, flatten } = require './lib.coffee'


if process.argv.length < 3
  console.error("Usage: coffee scan.coffee <directory>")
  process.exit(1)

directory = process.argv[2]


console.log("Scanning 'locale.coffee' files in #{directory}...")

scanDir directory, (results) ->
  for file, { keys, comparison } of results
    console.log("File #{file}: #{keys.length} keys total")

    for language, info of comparison when info.missing.length > 0
      console.log("    #{language} missing #{info.missing.length} keys")
      console.log("        #{key}") for key in info.missing


  console.log("\nSearching for keys without mentions in Jade views...")
  keys = unique flatten(stats.keys for file, stats of results)

  findName directory, '*.jade', (files) ->
    grepCountAll keys, files, (key, count) ->
      if count is 0
        console.log("Not found: #{key}")