import sys

root = { "__dir__": True }

def addChild(directory, child): 
    directory.update(child)

def parent(directory):
    return directory.get("__parent__")

def is_dir(directory):
    return directory.get("__dir__") is not False

def size(directory):
    return directory.get("__size__")

def is_root(directory):
    return is_dir(directory) and parent(directory) is None

def move(cwd, dir):
    if dir == "/":
        return root
    elif dir == "..":
        return parent(cwd)
    else:
        return cwd[dir]


def parse(cwd=root):
    for line in sys.stdin:
        line = line.strip()
        if line.startswith("$ cd "):
            cwd = move(cwd, line[5:])
        elif line.startswith("$ ls"):
            continue
        elif line.startswith("dir"):
            addChild(cwd, {line[4:] : {"__dir__": True, "__parent__": cwd}})
        else:
            size = int(line.split()[0])
            name = line.split()[1]
            addChild(cwd, {name : {"__dir__": False, "__parent__": cwd, "__size__": size}})

def totals():
    dirs = dict()
    def f(cwd, name):
        acc = 0
        for k, v in cwd.items():
            if k in ["__dir__", "__parent__", "__size__"]:
                continue
            elif (is_dir(v)):
                acc += f(v, k)
            else:
                acc += v["__size__"]
        dirs[name] = acc
        return acc
    f(root, "/")
    return dirs

                

def main():
    parse()
    print(totals())
    print(sum(filter(lambda x: x <= 100000, totals().values())))

if __name__ == "__main__":
    main()
