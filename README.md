## parsePermission


There are two options: 
-p which indicates the permission to search for and is associated with a permission value, and 
-r which indicates that a directory is searched recursively.

If the -p option is not used the default set of permissions to search for is 644. If the -r option is not used a directory's contents are searched only at the top level as before.

The options can now be followed by a list of names, not just one. Each name is processed as a directory to search in. If no list is given, search the current directory.

The output of the program will be that each file's name is printed as the full absolute path name of it. This is followed on the line by the size in bytes of the file. keeping a running total of the number of bytes contained in all of the located files. This total will be printed at the end of the report.
