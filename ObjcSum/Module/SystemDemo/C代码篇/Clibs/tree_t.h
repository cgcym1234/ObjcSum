#ifndef _TREE_T_H_
#define _TREE_T_H_

typedef int item_t;
typedef struct tree_node_s
{
    struct tree_node_s *parent;
    struct tree_node_s *r_child;
    struct tree_node_s *l_child;
    int visited;
    item_t data;
}tree_node_t;

typedef struct
{
    struct tree_node_s *root;
    int node_num;
    int flag;//改变遍历时的visited状态
}tree_t;


tree_t *tree_init();
void tree_free(tree_t *);

void tree_insert(tree_t *, item_t);
void tree_delete(tree_t *, item_t);

void tree_travel(tree_t *);
void tree_info(tree_t *);
int tree_height(tree_t *);



#endif

