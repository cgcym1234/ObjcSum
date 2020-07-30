//
//  yyclib.c
//  ObjcSum
//
//  Created by yuany on 2020/2/25.
//  Copyright © 2020 sihuan. All rights reserved.
//

#include "yyclib.h"

int        daemon_proc;        /* set nonzero by daemon_init() */

static void    err_doit(int, int, const char *, va_list);

void err_msg(const char *fmt, ...) {
    va_list ap;
    
    va_start(ap, fmt);
    err_doit(0, LOG_INFO, fmt, ap);
    va_end(ap);
    return;
}

void err_ret(const char *fmt, ...) {
    va_list ap;
    
    va_start(ap, fmt);
    err_doit(1, LOG_INFO, fmt, ap);
    va_end(ap);
    return;
}

void err_sys(const char *fmt, ...) {
    va_list ap;
    
    va_start(ap, fmt);
    err_doit(1, LOG_ERR, fmt, ap);
    va_end(ap);
    exit(1);
}

void err_quit(const char *fmt, ...) {
    va_list        ap;

    va_start(ap, fmt);
    err_doit(0, LOG_ERR, fmt, ap);
    va_end(ap);
    exit(1);
}

/// Print message, dump core, and terminate
void err_dump(const char *fmt, ...) {
    va_list ap;
    
    va_start(ap, fmt);
    err_doit(1, LOG_ERR, fmt, ap);
    va_end(ap);
    abort();
}

static void err_doit(int err, int level, const char *fmt, va_list ap) {
    int err_save, n;
    char buf[MAXLINE + 1];
    
    err_save = errno;
#ifdef HAVE_VSNPRINTF
    vsnprintf(buf, MAXLINE, fmt, ap); /* safe */
#else
    vsprintf(buf, fmt, ap); /* not safe */
#endif
    n = (int)strlen(buf);
    if (err) {
        snprintf(buf + n, MAXLINE - n, ": %s", strerror(err_save));
    }
    strcat(buf, "\n");
    
    if (daemon_proc) {
        syslog(level, "%s", buf);
    } else {
        /* in case stdout and stderr are the same */
        fflush(stdout);
        fputs(buf, stdout);
        fflush(stderr);
    }
}
