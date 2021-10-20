#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

/*
 * 默认 -n 为 1，如果有 -n 参数
 * 统计一下 \n 的次数再fork exec即可
**/

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(2, "xargs error!\n");
        exit(1);
    }


    char *_argv[MAXARG];
    for (int i = 1; i < argc; i++)
        _argv[i - 1] = argv[i];

    char buf[1024];
    char c;
    int stat = 1;

    while (stat) {
        int buf_cnt = 0;
        int arg_begin = 0;
        int argv_cnt = argc - 1;
        while (1) {
            stat = read(0, &c, 1);
            if (stat == 0)
                exit(0);
            if (c == ' ' || c == '\n') {
                buf[buf_cnt++] = 0;
                _argv[argv_cnt++] = &buf[arg_begin];
                arg_begin = buf_cnt;
                if (c == '\n')
                    break;
            } else {
                buf[buf_cnt++] = c;
            }
        }
        _argv[argv_cnt] = 0;
        if (fork() == 0) {
            exec(_argv[0], _argv);
        } else {
            wait(0);
        }
    }

    exit(0);
}