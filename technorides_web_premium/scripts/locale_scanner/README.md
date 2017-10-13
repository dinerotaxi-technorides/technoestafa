# REQUIREMENTS

The SilverSearcher `ag`, a much improved and faster `grep`:

    # apt-get install silversearcher-ag


# USAGE

Point the `scan` script at a directory:

    $ coffee scan.coffee <target directory>


That's it. The script will:

1. Find files named exactly 'locale.coffee'
2. Compare dictionaries found in each of those files, reporting missing keys
3. Find files named '*.jade'
4. Scan those files and report keys with no occurences anywhere


# EXAMPLE

    $ coffee scan.coffee ~/workspace/technorides_web_premium


# IMPROVEMENT

The script is not written to be fast, but runs in under 10 seconds in current
conditions. It can be improved if the project grows and runtime is no longer
reasonable.