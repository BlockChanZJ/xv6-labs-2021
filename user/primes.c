#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define R 0
#define W 1

/*
 * 祖宗线程发2-35，
 * 孩子线程接受到的第一个数字必定为素数，然后继续创建子线程来发送由父线程收到的其他数字
 * redirect是为了使程序更简化，不用传描述符的参数了
 */

void redirect(int k, int p[]) {
    close(k);
    dup(p[k]);
    close(p[R]);
    close(p[W]);
}

void filter(int d) {
    int p;
    while (read(R, &p, sizeof(p))) {
        if (d % p != 0)
            write(W, &p, sizeof(p));
    }
    close(W);
    wait(0);
    exit(0);
}

void waitForNumber() {
    int fd[2];
    int p;

    if (read(R, &p, sizeof(p))) {
        printf("prime %d\n", p);
        pipe(fd);
        if (fork() == 0) {
            redirect(R, fd);
            waitForNumber();
        } else {
            redirect(W, fd);
            filter(p);
        }
    }
    exit(0);
}

int main() {

    int fd[2];
    pipe(fd);

    if (fork() == 0) {
        redirect(R, fd);
        waitForNumber();
    } else {
        redirect(W, fd);
        for (int i = 2; i <= 35; i++)
            write(W, &i, sizeof(i));
        close(W);
        wait(0);
    }
    exit(0);
}