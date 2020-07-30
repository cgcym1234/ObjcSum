//
//  yyclib.h
//  ObjcSum
//
//  Created by yuany on 2020/2/25.
//  Copyright © 2020 sihuan. All rights reserved.
//

#ifndef yyclib_h
#define yyclib_h

#include    <sys/types.h>    /* basic system data types */
#include    <sys/socket.h>    /* basic socket definitions */
#include    <sys/time.h>    /* timeval{} for select() */
#include    <sys/stat.h>    /* for S_xxx file mode constants */
#include    <sys/uio.h>        /* for iovec{} and readv/writev */
#include    <sys/un.h>        /* for Unix domain sockets */
#include    <sys/wait.h>
#include    <netinet/in.h>    /* sockaddr_in{} and other Internet defns */
#include    <arpa/inet.h>    /* inet(3) functions */
#include    <time.h>        /* timespec{} for pselect() */
#include    <fcntl.h>        /* for nonblocking */
#include    <netdb.h>
#include    <signal.h>
#include    <stdio.h>
#include    <stdlib.h>
#include    <stdarg.h>        /* ANSI C header file */
#include    <syslog.h>        /* for syslog() */
#include    <string.h>
#include    <unistd.h>
#include    <errno.h>
#include    <ctype.h>

/* Miscellaneous constants */
#define    MAXLINE        4096    /* max text line length */
#define    MAXSOCKADDR  128    /* max socket address structure size */
#define    BUFFSIZE    8192    /* buffer size for reads and writes */

/* Define some port number that can be used for client-servers */
#define    SERV_PORT         9877            /* TCP and UDP client-servers */
#define    SERV_PORT_STR    "9877"            /* TCP and UDP client-servers */
#define    UNIXSTR_PATH    "/tmp/unix.str"    /* Unix domain stream cli-serv */
#define    UNIXDG_PATH        "/tmp/unix.dg"    /* Unix domain datagram cli-serv */

//#ifndef    HAVE_BZERO
//#define    bzero(ptr,n)        memset(ptr, 0, n)
//#endif
//
//#ifndef    HAVE_GETHOSTBYNAME2
//#define    gethostbyname2(host,family)        gethostbyname((host))
//#endif


#define    SA    struct sockaddr

#define    FILE_MODE    (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)
                    /* default file access permissions for new files */
#define    DIR_MODE    (FILE_MODE | S_IXUSR | S_IXGRP | S_IXOTH)
                    /* default permissions for new directories */

typedef    void    Sigfunc(int);    /* for signal handlers */

#define    min(a,b)    ((a) < (b) ? (a) : (b))
#define    max(a,b)    ((a) > (b) ? (a) : (b))


int         connect_nonb(int, const SA *, socklen_t, int);
int         connect_timeo(int, const SA *, socklen_t, int);
void     daemon_init(const char *, int);
void     daemon_inetd(const char *, int);
void     dg_cli(FILE *, int, const SA *, socklen_t);
void     dg_echo(int, SA *, socklen_t);
int         family_to_level(int);
char    *gf_time(void);
void     heartbeat_cli(int, int, int);
void     heartbeat_serv(int, int, int);
struct addrinfo *host_serv(const char *, const char *, int, int);
int         inet_srcrt_add(char *, int);
u_char  *inet_srcrt_init(void);
void     inet_srcrt_print(u_char *, int);
char   **my_addrs(int *);
int         readable_timeo(int, int);
ssize_t     readline(int, void *, size_t);
ssize_t     readn(int, void *, size_t);
ssize_t     read_fd(int, void *, size_t, int *);
ssize_t     recvfrom_flags(int, void *, size_t, int *, SA *, socklen_t *,
         struct in_pktinfo *);
Sigfunc *signal_intr(int, Sigfunc *);
int         sock_bind_wild(int, int);
int         sock_cmp_addr(const SA *, const SA *, socklen_t);
int         sock_cmp_port(const SA *, const SA *, socklen_t);
int         sock_get_port(const SA *, socklen_t);
void     sock_set_addr(SA *, socklen_t, const void *);
void     sock_set_port(SA *, socklen_t, int);
void     sock_set_wild(SA *, socklen_t);
char    *sock_ntop(const SA *, socklen_t);
char    *sock_ntop_host(const SA *, socklen_t);
int         sockfd_to_family(int);
void     str_echo(int);
void     str_cli(FILE *, int);
int         tcp_connect(const char *, const char *);
int         tcp_listen(const char *, const char *, socklen_t *);
void     tv_sub(struct timeval *, struct timeval *);
int         udp_client(const char *, const char *, void **, socklen_t *);
int         udp_connect(const char *, const char *);
int         udp_server(const char *, const char *, socklen_t *);
int         writable_timeo(int, int);
ssize_t     writen(int, const void *, size_t);
ssize_t     write_fd(int, void *, size_t, int);


void     err_dump(const char *, ...);
void     err_msg(const char *, ...);
void     err_quit(const char *, ...);
void     err_ret(const char *, ...);
void     err_sys(const char *, ...);

#endif /* yyclib_h */
