# tfsbuild.py
import json
import os
import shutil


# check working directory, update as needed
def checkWorkingDirectory():
    filepath = os.path.dirname(os.path.realpath(__file__))
    # no sense in checking, just change it for this execution.
    # cwd = os.getcwd()
    os.chdir(filepath)


# private method to help find the nth character in a string
# pretty genius - refer to here http://stackoverflow.com/a/1884151/918237
def findnth(haystack, needle, n):
    parts = haystack.split(needle, n + 1)
    if len(parts) <= n + 1:
        return -1
    return len(haystack) - len(parts[-1]) - len(needle)


# update the release version
def updateReleaseVersion(type=None):
    try:
        # perform backup
        shutil.copyfile('../vss-extension.json', '../vss-extension.json.bak')
        # if no type is specified, do nothing
        if type is None:
            return
        # test path
        # since we changed the working directory before, this should work no sweat.
        with open('../vss-extension.json') as json_data:
            vssext = json.load(json_data)
        version = vssext.get('version')
        periodidx = findnth(version, '.', 1)
        major = version[0:version.find('.')]
        minor = version[version.find('.')+1:periodidx]
        build = version[periodidx+1:]
        print("Old version is {0}".format(version))
        print("Major version is {0}".format(version[0:version.find('.')]))
        print("Minor Version is {0}".format(version[version.find('.')+1:periodidx]))
        print("Build Version is {0}".format(version[periodidx+1:]))
        # if type is 'major':
        if type is 'major':
            newversion = "{0}.{1}.{2}".format(major+1, 0, 0)
        if type is 'minor':
            newversion = "{0}.{1}.{2}".format(major, minor+1, 0)
        if type is 'build':
            newversion = "{0}.{1}.{2}".format(major, minor, build+1)
        if type is 'test':
            print('New version will be {0}'.format(newversion))
            return

    except:
        raise


checkWorkingDirectory()
updateReleaseVersion("test")
