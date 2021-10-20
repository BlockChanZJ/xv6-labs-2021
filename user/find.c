#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int strstr(char *s, char *t) {
    int slen = strlen(s), tlen = strlen(t);
    int i, j, ok = 1;
    if (slen < tlen) return 0;
    for (i = 0; i + tlen - 1 < slen; i++) {
        if (s[i] != t[0]) continue;
        ok = 1;
        for (j = 0; j < tlen; j++) {
            if (s[i + j] != t[j]) ok = 0;
        }
        if (ok) return 1;
    }
    return 0;
}

char *
fmtname(char *path) {
    static char buf[DIRSIZ + 1];
    char *p;

    // Find first character after last slash.
    for (p = path + strlen(path); p >= path && *p != '/'; p--);
    p++;

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
        return p;
    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), '\0', DIRSIZ - strlen(p));
    return buf;
}

int is_valid(char *path) {
    static char buf[DIRSIZ + 1];
    char *p;
    for (p = path + strlen(path); p >= path && *p != '/'; p--);
    p++;

    // Return blank-padded name.
    if (strlen(p) >= DIRSIZ)
        return 0;

    memmove(buf, p, strlen(p));
    memset(buf + strlen(p), 0, DIRSIZ - strlen(p));

    if (strcmp(buf, ".") == 0 || strcmp(buf, "..") == 0)
        return 0;
    return 1;
}

void find(char *dirname, char *filename) {
    printf("dirname: %s, filename: %s\n", dirname, filename);
    char buf[512], *p;
    int fd;
    struct dirent de;
    struct stat st;

    if ((fd = open(dirname, 0)) < 0) {
        fprintf(2, "find: cannot open %s\n", dirname);
        return;
    }

    if (fstat(fd, &st) < 0) {
        fprintf(2, "find: cannot stat %s\n", dirname);
        close(fd);
        return;
    }

    switch (st.type) {
        case T_FILE:
            if (strstr(dirname, filename) > 0)
                printf("%s\n", dirname);
            break;

        case T_DIR:
            if (strlen(dirname) + 1 + DIRSIZ + 1 > sizeof buf) {
                printf("find: path too long\n");
                break;
            }
            strcpy(buf, dirname);
            p = buf + strlen(buf);
            *p++ = '/';
            while (read(fd, &de, sizeof(de)) == sizeof(de)) {
                if (de.inum == 0)
                    continue;
                memmove(p, de.name, DIRSIZ);
                p[DIRSIZ] = 0;
                if (stat(buf, &st) < 0) {
                    printf("find: cannot stat %s\n", buf);
                    continue;
                }
                if (st.type == T_DIR) {
                    if (is_valid(buf))
                        find(buf, filename);
                } else {
                    if (strcmp(fmtname(buf), filename) == 0)
                        printf("%s\n", buf);
                }
            }
            break;
    }
    close(fd);
}

int main(int argc, char **argv) {
    if (argc != 3) {
        fprintf(2, "find error!");
        exit(0);
    }
    find(argv[1], argv[2]);
    exit(0);
}