import os, subprocess, fnmatch, shlex

dir = "."
files = os.listdir(dir)

for name in files:
    if fnmatch.fnmatch(name, '*mka'):
        new_name = name.replace(' ', '_')
        os.rename(name, new_name)
        print(name)

for name in files:
    if fnmatch.fnmatch(name, '*mkv'):
        new_name = name.replace(' ', '_')
        os.rename(name, new_name)
        cmd2 = 'C:/Users/heimc//Downloads/mkvtoolnix/mkvmerge.exe -o ' + new_name[:-4] + '_mux.mkv' + ' ' + new_name + ' ' + new_name[:-4] + ".mka"
        subprocess.run(shlex.split(cmd2))