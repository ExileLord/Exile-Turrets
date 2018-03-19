# This script generates the default_name_list.lua file from the text files in the list subdirectory

import os

# Makes a "[[string]]""[=[string]=]"/ style quote where the amount of equal signs is equal to the depth given
def makequotedepth(c, depth):
    s = c
    for x in range(0, depth):
        s += "="
    s += c
    return s

# Finds out the needed quote depth in order to encapsulate the given string s without escaping anything inside
def getquotedepth(s):
    depth = 0
    while True:
        opener = makequotedepth("[", depth)
        closer = makequotedepth("]", depth)
        if opener in s or closer in s:
            depth += 1
            continue
        else:
            break
    return depth

# Joins all text files in the list subdirectory
directory = "lists"
joinedText = ""
for filename in os.listdir(directory):
    if filename.endswith(".txt"):
        fullname = os.path.join(directory, filename)
        print(filename)
        f = open(fullname, "r")
        joinedText += (f.read() + "\n")
        continue
    else:
        continue

# Generate the .lua file
quoteDepth = getquotedepth(joinedText)
opener = makequotedepth("[", quoteDepth) + "\n"
closer = "\n" + makequotedepth("]", quoteDepth)
joinedText = ("return --[[This list is autogenerated by build_default_list.py. If you wish to edit it, please make changes to the files in the list subdirectory.]] " + opener + joinedText + closer)
f = open("default_name_list.lua","w+")
f.write(joinedText)
f.close()