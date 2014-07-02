#! /usr/bin/env python
# -*- coding: utf-8 -*-

# romiq.kh@gmail.com, 2014

import os, sys
import subprocess
import tempfile


APPNAME = "Text user interface for gtk-builder-win"
VERSION = "v0.1 2014-06-29"
AUTHOR = "romiq.kh@gmail.com"

STDDLG = ["whiptail", "--title", "Gtk-builder TUI " + VERSION]
STDDLG2 = ["whiptail"]

PATTERN_IN = [
    ": Вход в каталог `",
    ": Entering directory `"
]

PATTERN_OUT = [
    ": Выход из каталога `",
    ": Leaving directory `"
]

PATTERN_ERR = [
    "configure: error: ***",
    "make: ***"
]

class LogReader:
    def __init__(self):
        self.reset()
                
    def reset(self):
        self.readbuf = b""
        self.readpos = 0
        self.readstr = ""
        self.status = ""
        self.build = []
        self.lineno = 0
        self.err = False
        
    def feed(self, fn, end = False):
        f = open(fn, "rb")
        try:
            f.seek(self.readpos)
            data = f.read()
        finally:
            f.close()
        oldpos = self.readpos
        self.readpos += len(data)
        self.readbuf += data
        # adjust inconsistent utf buffer
        parsebuf = self.readbuf
        bufsz = len(parsebuf)
        while True:
            try:
                buf = parsebuf.decode("utf-8")
                self.readbuf = self.readbuf[len(parsebuf):]
            except Exception as e:
                buf = ""
                # remove last byte
                parsebuf = parsebuf[:-1]
                if bufsz - len(parsebuf) > 6:
                    break
                if bufsz - len(parsebuf) > len(data):
                    continue
            break
        # parse readstr
        self.readstr += buf
        line = ""
        for ch in self.readstr:
            if ch == "\n":
                self.feed_line(line)
                line = ""
            else:
                line += ch
        self.readstr = line
    
        if end:
            self.feed_end()
    
    def feed_end(self):
        if self.readstr:
            self.feed_line(self.readstr)
            self.readstr = ""

    def feed_line(self, line):
        self.lineno += 1
        #print("+++", line)
        for pt in PATTERN_ERR:
            if line.startswith(pt):
                self.err = True
                break
                
        if line[:5] == "make[":
            # make line
            line = line[5:]
            spos = line.find("]")
            if spos > 0:
                num = line[:spos]
                line = line[spos + 1:]
                #print(num, line)
                if line[:5] == ": ***":
                    self.err = True

                for pt in PATTERN_IN:
                    if line.startswith(pt):
                        # in
                        line = line[len(pt):]
                        spos = line.find("'")
                        if spos > 0:
                            path = line[:spos]
                            #print("in", num, path)
                            self.build.append((num, path))
                            break
                        
                for pt in PATTERN_OUT:
                    if line.startswith(pt):
                        # out
                        line = line[len(pt):]
                        spos = line.find("'")
                        if spos > 0:
                            path = line[:spos]
                            #print("out", num, path)
                            self.build.remove((num, path))
                            #print(len(self.build))
                            break

        if self.err:
            self.status = "error"
            return
            
        if len(self.build) > 0:
            self.status = "build" 
        else:
            self.status = "done"

class App:
    def __init__(self):
        # read config
        self.root = os.path.join(os.path.dirname(os.path.abspath(".")), "libs")
        self.base = os.path.abspath(".")
        self.buildparts = ["BUILD_ALL_NATIVE", "BUILD_ALL_WIN32"]
        self.load_config()
        
        
    def load_config(self):
        # vars
        f = tempfile.NamedTemporaryFile(delete = False, suffix = ".sh")
        scriptname = f.name
        f.close()
        f = open(scriptname, "w")
        try:
            f.write("#!/bin/sh\n")
            f.write("source {}\n\n".format(os.path.join(
                self.base, "vars.sh")))
            f.write("echo $NATIVEPREFIX\n")
            f.write("echo $WIN32PREFIX\n")
        finally:
            f.close()
        # exec
        proc = subprocess.Popen(["bash", scriptname], stdout = subprocess.PIPE)
        std, err = proc.communicate()
        try:
            os.unlink(scriptname)
        except OSError: pass        
        self.buildpath = std.decode("UTF-8").split("\n")
        # read target
        self.targets = {}
        with open(os.path.join(self.root, "target"), "r") as f:
            csect = None
            sect = []
            for line in f.readlines():
                line = line.strip()
                if not line: continue
                if line[:1] == "[" and line[-1:] == "]":
                    if csect:
                        self.targets[csect] = sect
                    csect = line[1:-1]
                    sect = []       
                else:
                    sect.append(line)
            if csect:
                self.targets[csect] = sect
                            
            self.targetname = self.targets["VERSION"][0]
        # scan submodules
        self.submodules = []
        for item in os.listdir(self.root):
            if not item[-3:] == ".sh":
                continue
            if item[:6] == "BUILD_":
                continue
            self.submodules.append(item[:-3])
        self.submodules.sort()
        # scan 4_Build.sh
        mode = 0
        self.nativepost = []
        self.nativepre = []
        self.winpre = []
        with open(os.path.join(self.base, "4_Build.sh"), "r") as f:
            for line in f.readlines():
                line = line.strip()
                if mode == 0:
                    if line == "export BUILD_MODE=native":
                        mode = 1
                elif mode == 1:
                    if line == "export BUILD_MODE=win32":
                        mode = 2
                    elif line == "# PRENATIVE":
                        mode = 11
                    elif line == "# POSTNATIVE":
                        mode = 21
                elif mode == 11:
                    if line == "# PRENATIVEEND":
                        mode = 1
                    else:
                        self.nativepre.append(line)
                elif mode == 21:
                    if line == "# POSTNATIVEEND":
                        mode = 1
                    else:
                        self.nativepost.append(line)
                elif mode == 2:
                    if line == "# PREWIN32":
                        mode = 12
                elif mode == 12:
                    if line == "# PREWIN32END":
                        mode = 2
                    else:
                        self.winpre.append(line)
            # scan enabled submodules
            self.subdefault = []
            for pid, part in enumerate(self.buildparts):
                self.subdefault.append({})
                with open(os.path.join(self.root, part + ".sh"), "r") as f:
                    for line in f.readlines():
                        line = line.strip()
                        if line[-3:] != ".sh":
                            continue
                        if line[:2] == "./":
                            sub = (line[2:-3], True)
                        elif line[:3] == "#./":
                            sub = (line[3:-3], False)
                        else:
                            continue
                        if sub[0] not in self.submodules:
                            continue
                        self.subdefault[pid][sub[0]] = sub[1]
                
                

    def error(self, title, text):
        cmd = STDDLG2 + ["--title", title, 
            "--msgbox", text, "0", "0", "0"]
        proc = subprocess.Popen(cmd)
        proc.communicate()

    def info(self, title, text):
        cmd = STDDLG2 + ["--title", title, 
            "--msgbox", text, "0", "0", "0"]
        proc = subprocess.Popen(cmd)
        proc.communicate()
    
    def menu_part(self, pid):
        cmd = STDDLG + [
            "--checklist", "Select components to build " + 
            self.buildparts[pid], "0", "0", "0", "A", "All", ""]
        # parse
        with open(os.path.join(self.root, 
                self.buildparts[pid] + ".sh"), "r") as f:
            psub = []
            psubn = list(self.subdefault[pid].keys())
            psubn.sort()
            for subn in psubn:
                build = self.subdefault[pid][subn] 
                if build:
                    sect = self.buildparts[pid] + "." + subn
                    items = self.targets.get(sect, [])
                    ok = len(items) > 0
                    for item in items:
                        ok = ok and os.path.exists(self.buildpath[pid] + 
                            "/" + item)
                    build = not ok
                psub.append(subn)
                cmd += [str(len(psub)), subn, "1" if build else ""]

        proc = subprocess.Popen(cmd, stderr = subprocess.PIPE)
        std, err = proc.communicate()
        if proc.returncode != 0:
            # esc or cancel
            return
        sids = []
        if len(err) == 0:
            return
        if err[:3] == b"\"A\"":
            # all
            for sub in psub:
                # convert to all list   
                sids.append(self.submodules.index(sub))   
        else:
            items = err.decode("UTF-8").split(" ")
            for item in items:
                pn = int(item[1:-1], 10) - 1
                sids.append(self.submodules.index(psub[pn]))   
        self.build_parts(pid, sids)            

    def menu_buildone(self, pid):
        cmd = STDDLG + [
            "--menu", "Select component to build " + 
            self.buildparts[pid], "0", "0", "0"]

        for sid, sub in enumerate(self.submodules):
            if sub in self.subdefault[pid]:
                cmd += [str(sid + 1), sub]

        proc = subprocess.Popen(cmd, stderr = subprocess.PIPE)
        std, err = proc.communicate()
        if proc.returncode != 0:
            # esc or cancel
            return
        sid = int(err, 10) - 1
        
        # options
        cmd = STDDLG + [
            "--menu", "Select options " + 
            self.buildparts[pid] + " - " + self.submodules[sid], "0", "0", "0"]

        cmd += ["NO", "Default build"]
        cmd += ["BC", "Shell before configure"]
        cmd += ["BM", "Shell before make"]
        cmd += ["BI", "Shell before install"]
        cmd += ["AI", "Shell after install"]
        cmd += ["UN", "Shell in unpacked tree"]
        
        proc = subprocess.Popen(cmd, stderr = subprocess.PIPE)
        std, err = proc.communicate()
        if proc.returncode != 0:
            # esc or cancel
            return

        self.build_parts(pid, [sid], err.decode("UTF-8"))  
        
    def menu_compversion(self):
        # scan submodules
        lst = []
        for sid, sub in enumerate(self.submodules):
            version = ""
            with open(os.path.join(self.root, sub + ".sh"), "r") as f:
                for line in f.readlines():
                    line = line.strip()
                    if line[:1] == "#":
                        continue
                    if not line: continue
                    if line[:7] == "MODVER=":
                        version = line[7:]
                        break
                    elif line[:10] == "MAJOR_VER=":
                        version = line[10:]
                    elif line[:10] == "MINOR_VER=":
                        version += "." + line[10:]
                    elif line[:10] == "PATCH_VER=":
                        version += "." + line[10:]
                        break
            # detect patches
            patch = False
            arch = ""
            other = False
            ppath = os.path.join(self.root, sub)
            if os.path.exists(ppath):
                for item in os.listdir(ppath):
                    if item[-6:] == ".patch":
                        patch = True
                    elif item[-4:] == ".zip" or item[-3:] == ".gz" or\
                        item[-4:] == ".bz2" or item[-3:] == ".xz":
                            arch = str(os.path.getsize(os.path.join(ppath, 
                                item)) // 1024) + "kb"
                    else:
                        other = True
            cmt = version
            if patch:
                cmt += " + patch"
            if other:
                cmt += " + fix"
            if arch:
                cmt += ", " + arch
            lst.append("{}) {} - {}".format(sid + 1, sub, cmt))

        cmd = STDDLG + ["--title", "Component version", 
            "--msgbox", "\n".join(lst), "0", "0"]
        proc = subprocess.Popen(cmd, stderr = subprocess.PIPE)
        std, err = proc.communicate()
            
            
    def select_part(self, hint):
        cmd = STDDLG + [
            "--menu", hint, "0", "0", "0"]

        for pid, part in enumerate(self.buildparts):
            cmd += [str(pid + 1), part]

        proc = subprocess.Popen(cmd, stderr = subprocess.PIPE)
        std, err = proc.communicate()
        if proc.returncode != 0:
            # esc or cancel
            return -1
        return int(err, 10) - 1
        
        
    def menu_main(self):
        while True:
            cmd = STDDLG + [
                "--cancel-button", "Exit", "--menu", 
                "Build " + self.targetname, "0", "0", "0"]
            cmd += ["A", "Build all"]
            cmd += ["B", "Build one component"]
            cmd += ["V", "Component versions"]
            cmd += ["P", "Prepare environment"]
            cmd += ["C", "Check environment"]
            cmd += ["L", "View make logs"]
            proc = subprocess.Popen(cmd, stderr = subprocess.PIPE)
            std, err = proc.communicate()
            if proc.returncode != 0:
                # esc or cancel
                return
            if err == b"A":
                pid = self.select_part("Select part to consequence build")
                if pid >= 0:
                    self.menu_part(pid)
                continue
            elif err == b"B":
                pid = self.select_part("Select part to build")
                if pid >= 0:
                    self.menu_buildone(pid)
                continue
            elif err == b"V":
                self.menu_compversion()
                continue
            elif err == b"P":
                proc = subprocess.Popen(["bash", os.path.join(self.base, 
                    "3_PrepBuild.sh")], stderr = subprocess.PIPE)
                std, err = proc.communicate()
                if err:
                    self.error("Error prepare environment", err.decode("UTF-8"))
                continue
            elif err == b"C":
                proc = subprocess.Popen(["bash", os.path.join(self.base, 
                    "2a_Check.sh")], stdout = subprocess.PIPE, 
                    stderr = subprocess.PIPE)
                std, err = proc.communicate()
                if std:
                    self.info("Check environment", std.decode("UTF-8"))
                continue
            elif err == b"L":
                self.menu_logs()
                continue


    def menu_logs(self):
        while True:
            cmd = STDDLG + ["--menu", 
                "Select log to view", "0", "0", "0"]
            logs = []
            logpath = os.path.join(self.root, "logs")
            for item in os.listdir(logpath):
                if item[-4:] != ".log": continue
                logs.append(item)
            logs.sort()
            for lid, item in enumerate(logs):
                ml = LogReader()
                ml.feed(os.path.join(logpath, item), True)
                cmd += [str(lid + 1), ml.status + " - " + item[:-4]]
            proc = subprocess.Popen(cmd, stderr = subprocess.PIPE)
            std, err = proc.communicate()
            if proc.returncode != 0:
                # esc or cancel
                return


    def build_parts(self, pid, sids, mode = "NO"):
        # build one by one
        try:
            os.mkdir(os.path.join(self.root, "logs"))
        except OSError: pass
        logpath = os.path.join(self.root, "logs", 
            ("n_" if pid == 0 else "w_"))
        while True:
            if len(sids) == 0:
                break
            sid = sids[0]
            sids = sids[1:]
            sub = self.submodules[sid]
            desc = "{} - {}".format(self.buildparts[pid], sub)
            logm = logpath + sub + "-make.log"
            logi = logpath + sub + "-makeinstall.log"
            # cleanup logs
            try:    
                os.unlink(logm)
            except OSError: pass
            try:    
                os.unlink(logi)
            except OSError: pass
            # build scrit
            if mode != "NO":
                f = tempfile.NamedTemporaryFile(delete = False, suffix = ".sh")
                buildname = f.name
                f.close()
                f = open(buildname, "w")
                try:
                    with open(os.path.join(self.root, sub + ".sh"), "r") as s:
                        for lid, line in enumerate(s.readlines()):
                            if lid == 1:
                                if mode == "UN":
                                    # integrate ONCESHELL
                                    f.write("ONCESHELLUSED=\n")
                                    f.write("  function ONCESHELL {\n")
                                    f.write("  if [ \"$ONCESHELLUSED\" "\
                                        "== \"\" ]; then\n")
                                    f.write("    ONCESHELLUSED=y\n")
                                    f.write("    bash\n")
                                    f.write("  fi\n")
                                    f.write("\n")
                                    f.write("\n")
                                    f.write("\n")
                                    f.write("}\n\n")
                            sline = line.strip()
                            if sline[:11] == "./configure":
                                if mode == "BC":
                                    f.write("echo Entering shell before "\
                                        "configure\n")
                                    f.write("echo Building {}\n".format(sub))
                                    f.write("bash\n")
                                    f.write(line + "\n")
                                elif mode == "UN":
                                    f.write("ONCESHELL\n")
                                else:
                                    f.write(line + "\n")
                            elif sline[:15] == "make 2>&1 | tee":
                                if mode == "BM":
                                    f.write("echo Entering shell before "\
                                        "make\n")
                                    f.write("echo Building {}\n".format(sub))
                                    f.write("bash\n")
                                    f.write(line + "\n")
                                elif mode == "UN":
                                    f.write("ONCESHELL\n")
                                else:
                                    f.write(line + "\n")
                            elif sline[:23] == "make install 2>&1 | tee":
                                if mode == "BI":
                                    f.write("echo Entering shell before "\
                                        "install\n")
                                    f.write("echo Building {}\n".format(sub))
                                    f.write("bash\n")
                                    f.write(line + "\n")
                                elif mode == "AI":
                                    f.write(line + "\n")
                                    f.write("echo Entering shell after "\
                                        "install\n")
                                    f.write("echo Building {}\n".format(sub))
                                    f.write("bash\n")
                                elif mode == "UN":
                                    f.write("ONCESHELL\n")
                                else:
                                    f.write(line + "\n")
                            else:                                            
                                f.write(line + "\n")

                finally:
                    f.close()   
            else:                         
                buildname = os.path.join(self.root, sub + ".sh")
                
            # script
            f = tempfile.NamedTemporaryFile(delete = False, suffix = ".sh")
            scriptname = f.name
            f.close()
            f = open(scriptname, "w")
            try:
                f.write("#!/bin/sh\n")
                f.write("echo Compile {}\n".format(desc))
                if pid == 0:
                    f.write("export BUILD_MODE=native\n\n")
                else:                
                    f.write("export BUILD_MODE=win32\n\n")
                f.write("source {}\n\n".format(os.path.join(
                    self.base, "vars.sh")))
                if pid == 0:
                    for exp in self.nativepre:
                        f.write(exp + "\n")
                else:                
                    f.write("export PATH=$PATH:$NATIVEPREFIX/bin\n\n")
                    for exp in self.winpre:
                        f.write(exp + "\n")
                f.write("\ncd {}\n".format(self.root))
                f.write("bash {}\n".format(buildname))
                f.write("cd {}\n\n".format(self.base))
                if pid == 0:
                    for exp in self.nativepost:
                        f.write(exp + "\n")
                
            finally:
                f.close()
            # exec
            proc = subprocess.call(["bash", scriptname])
            # cleanu
            try:    
                os.unlink(scriptname)
            except OSError: pass
            if mode != "NO":
                try:    
                    os.unlink(buildname)
                except OSError: pass
            # check logs
            resm = ""
            if os.path.exists(logm):                
                ml = LogReader()
                ml.feed(logm, True)
                resm = ml.status
            resi = ""
            if os.path.exists(logi):                
                ml = LogReader()
                ml.feed(logi, True)
                resi = ml.status
            #self.info("", resm + " " + logm + "\n" + resi + " " + logi)
            if not resm and not resi:
                # ERROR - no logs at all
                self.error(desc, "No make or install log")
                return False
            elif resm != "done":
                self.error(desc, "Make error\n" + logm)
                return False
            elif resm == "done" and resi != "done" and os.path.exists(logi):
                self.error(desc, "Install error\n" + logi)
                return False
            # check files
            sect = self.buildparts[pid] + "." + sub
            items = self.targets.get(sect, [])
            for item in items:
                if not os.path.exists(self.buildpath[pid] + "/" + item):
                    self.error(desc, "File not found:\n" + item)
                    return False
        return True  
        

def main():
    app = App()
    app.menu_main()

if __name__ == "__main__":
    main()
