#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "tree_t.h"

static void tree_clear(tree_node_t *root);
static void tree_traversal(tree_node_t *root, int *flag);
static void tree_travel_level(tree_node_t *root);

static int tree_depth(tree_node_t *root);


static tree_node_t *tree_node_make(item_t item);
static tree_node_t *tree_node_find(tree_node_t *cur_node, item_t item);

static void tree_node_insert(tree_node_t **cur_node, tree_node_t *new_node);
static void tree_node_delete(tree_node_t *del_node);




tree_t *tree_init()
{
    tree_t *tree = malloc(sizeof(tree_t));
    if(!tree) return NULL;

    tree->root = NULL;
    tree->node_num = 0;
    tree->flag = 1;

    return tree;
}

void tree_free(tree_t *tree)
{
    if(!tree) return;

    tree_clear(tree->root);
    tree->node_num = 0;
    free(tree);

    return;
}

void tree_travel(tree_t *tree)
{
    printf("node nums:%d\n", tree->node_num);
    return tree_traversal(tree->root, &tree->flag);
}

void tree_info(tree_t *tree)
{
    printf("node nums:%d\n", tree->node_num);
    return tree_travel_level(tree->root);
}

int tree_height(tree_t *tree)
{
    return tree_depth(tree->root);
}

void tree_insert(tree_t *tree, item_t item)
{
    tree_node_t *new_node = tree_node_make(item);
    if(!new_node) return;

    tree_node_insert(&tree->root, new_node);
    tree->node_num++;

    return;
}

void tree_delete(tree_t *tree, item_t item)
{
    tree_node_t *node = tree_node_find(tree->root, item);
    if(node == NULL) return;

    tree_node_delete(node);
    tree->node_num--;
}

static void tree_clear(tree_node_t *node)
{
    if(!node) return;

    tree_clear(node->l_child);
    tree_clear(node->r_child);
    free(node);
    node = NULL;

    return;
}

static void tree_traversal(tree_node_t *node, int *flag)
{
/*
    if(!node) return;

    tree_traversal(node->l_child);
    printf("%d ", node->data);
    tree_traversal(node->r_child);
*/
    if(node == NULL) return;

    if(*flag == 1)
    {
        while(node)
        {
            while(node->l_child && !node->l_child->visited) node = node->l_child;

            if(!node->visited)
            {
                printf("%d ", node->data);
                node->visited = 1;
            }

            if(node->r_child && !node->r_child->visited) node = node->r_child;

            else node = node->parent;
        }
        *flag = 0;
        return;
    }
    else if(*flag == 0)
    {
        while(node)
        {
            while(node->l_child && node->l_child->visited) node = node->l_child;

            if(node->visited)
            {
                printf("%d ", node->data);
                node->visited = 0;
            }

            if(node->r_child && node->r_child->visited) node = node->r_child;

            else node = node->parent;
        }
        *flag = 1;
        return;
    }
}

static void tree_travel_level(tree_node_t *root)
{
    if(!root) return;
    root->visited = 1;
    printf("%d ", root->data);
    tree_node_t *left = root->l_child;
    tree_node_t *right = root->r_child;

    while(left || right)
    {
        if(left)
        {
            printf("%d ", left->data);
            left->visited = 1;
            if(left->l_child && !left->visited) left = left->l_child;
            else left = left->r_child;
        }
        else left = left->parent;

        if(right)
        {
            printf("%d ", right->data);
            right->visited = 1;
            if(right->l_child && !right->visited) right = right->l_child;
            else right = right->r_child;
        }
        else right = right->parent;
    }



    while(left || right)
    {
        if(left->l_child && !left->visited)
        {
            printf("%d ", left->data);
            left->visited = 1;
            if(left->l_child && !left->visited) left = left->l_child;
            else left = left->r_child;
        }
        else if(left->r_child && !left->visited)
        left = left->parent;

        if(right)
        {
            printf("%d ", right->data);
            right->visited = 1;
            if(right->l_child && !right->visited) right = right->l_child;
            else right = right->r_child;
        }
        else right = right->parent;
    }

}

static tree_node_t *tree_node_make(item_t item)
{
    tree_node_t *node = malloc(sizeof(tree_node_t));
    if(!node) return NULL;

    memcpy(&node->data, &item, sizeof(item_t));
    node->parent = NULL;
    node->l_child = NULL;
    node->r_child = NULL;
    node->visited = 0;

    return node;
}

static void tree_node_insert(tree_node_t **cur_node, tree_node_t *new_node)
{
/*                //recursive
    if(*cur_node == NULL) *cur_node = new_node;

    else if(new_node->data < (*cur_node)->data)
            tree_node_insert(&(*cur_node)->l_child, new_node);

    else tree_node_insert(&(*cur_node)->r_child, new_node);
*/
    tree_node_t *cur = *cur_node;

    //为待插入的元素查找插入位置
    while(cur)
    {
        new_node->parent = cur;
        if(new_node->data < cur->data) cur = cur->l_child;

        else cur = cur->r_child;
    }

    //作为根结点插入,或者在删除节点时有效
    if(new_node->parent == NULL) *cur_node = new_node;

    else if(new_node->data < new_node->parent->data)
        new_node->parent->l_child = new_node;

    else new_node->parent->r_child = new_node;

    return;
}

static void tree_node_delete(tree_node_t *del_node)
{
/*
    删除策略；只要待删除的节点有子节点，就将该子节点变为右子节点，统一处理
              如下；
              如果左子节点存在，将其插入到右子节点中，
              变成该节点只有右子节点，然后将该节点的
              父节点与右子节点连起来，再删除该节点
*/
    if(del_node->l_child)
    {
        //左子节点的父节点需要重新定位，所以必须置为空
        del_node->l_child->parent = NULL;
        tree_node_insert(&del_node->r_child, del_node->l_child);
    }
    //判断该节点是父节点的左孩子，还是右孩子
    if(del_node->data < del_node->parent->data)
        del_node->parent->l_child = del_node->r_child;
    else
        del_node->parent->r_child = del_node->r_child;

    if(del_node->r_child)
        del_node->r_child->parent = del_node->parent;

    free(del_node);

    return;
}

static tree_node_t *tree_node_find(tree_node_t *node, item_t item)
{
/*      //recursive
    if(node == NULL) return NULL;
    if(node->data == item) return node;
    if(item < node->data) return tree_node_find(node->l_child, item);
    return tree_node_find(node->r_child, item);
*/
    while(node)
    {
        if(item == node->data) return node;

        if(item < node->data) node = node->l_child;

        else node = node->r_child;
    }

    return NULL;
}

static int tree_depth(tree_node_t *root)
{
    if(root == NULL) return 0;
    return 1;

}


