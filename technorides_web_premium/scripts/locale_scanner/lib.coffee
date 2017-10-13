fs = require 'fs'
cs = require 'coffee-script'
cp = require 'child_process'


@flatten = flatten = (arrays) ->
  return [].concat.apply([], arrays)


@unique = unique = (array_of_keys) ->
  set = {}
  set[key] = 1 for key in array_of_keys
  return Object.keys(set)


@uniqueKeys = uniqueKeys = (objects) ->
  return unique flatten(Object.keys(object) for object in objects)


spawn = (command, $done) ->
  # Run an external command, buffering stdout
  cp.exec command, (err, stdout, stderr) ->
    if err?
      console.error("Command #{command} exited with status #{err.code}. Stderr:")
      console.error(stderr)
      throw err

    $done(stdout)


@findName = findName = (directory, glob, $done) ->
  spawn "find '#{directory}' -name '#{glob}'", (output) ->
    $done(output.trim().split('\n'))


grepCount = (pattern, files, $done) ->
  file_args = ("'#{file}'" for file in files).join(" ")

  spawn "ag '#{pattern}' -l #{file_args}", (output) ->
    output = output.trim()
    $done(pattern, if output then output.split('\n').length else 0)


@grepCountAll = grepCountAll = (patterns, files, $each, i = 0) ->
  if i == patterns.length then return

  grepCount patterns[i], files, (pattern, count) ->
    $each(pattern, count)
    grepCountAll(patterns, files, $each, i + 1)


class MockTranslator
  # An instance of this class replaces `technoridesApp` while executing locale
  # scripts, mocking the interface to gather data.
  constructor: ->
    @keys      = {}
    @languages = {}

  config: ([ ..., callback ]) ->
    # Called with an injection array, Angular-style. We only want the callback.
    # The `translations` method will be invoked in the object passed:
    callback(@)

  translations: (language, dictionary) ->
    @languages[language] = dictionary
    @keys[key] = 1 for key of dictionary

  preferredLanguage: ->


compare = (languages) ->
  # Find missing keys in translation maps
  keys  = uniqueKeys(dictionary for language, dictionary of languages)
  stats = {}

  for language, dictionary of languages
    stats[language] = { count: Object.keys(dictionary).length, missing: [] }

    for key in keys when key not of dictionary
      stats[language].missing.push(key)

  return stats


scan = (filename) ->
  try
    code   = cs.compile(fs.readFileSync(filename, 'utf-8'))
    mtrans = new MockTranslator()

    # Code is evaluated in this scope. This is not ideal, but not really
    # dangerous in this case. We declare these variables for eval() to see:
    $              = { inArray: -> true }
    navigator      = { language: '' }
    technoridesApp = mtrans

    eval(code)
    
    return {
      keys      : Object.keys(mtrans.keys),
      comparison: compare(mtrans.languages)
    }

  catch e
    console.error("Error scanning #{filename}: #{e.stack}")


scanAll = (filenames) ->
  results = {}

  for filename in filenames 
    results[filename] = scan(filename)

  return results


@scanDir = (directory, $done) ->
  findName directory, 'locale.coffee', (files) ->
    $done scanAll(files)
