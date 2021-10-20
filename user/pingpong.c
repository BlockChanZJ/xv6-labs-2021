#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[]) {
    int p[2];
    pipe(p);
    char buf[128];

    if (fork() == 0) {
        read(p[0], buf, sizeof(buf));
        printf("%d: received %s\n", getpid(), buf);
        write(p[1], "pong", 4);
    } else {
        write(p[1], "ping", 4);
        read(p[0], buf, sizeof(buf));
        printf("%d: received %s\n", getpid(), buf);
    }
    exit(0);
}
