#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

struct list {
  struct list* back;
  char elem[4];
};

struct list* find(const char planet[], struct list* data[]);
void input(struct list* data[]);
void part1(struct list* data[]);
void part2(struct list* data[]);
struct list* locate(const char* str, struct list* data[]);


int main(){
  struct list* data[5000] = {0};
  input(data);

  part1(data);
  part2(data);

  for(int i = 0; data[i]; i++){
    free(data[i]);
  }
  
}

void part2(struct list* data[]){
  struct list* you_start = locate("YOU", data)->back;
  struct list* santa = locate("SAN", data)->back;

  int ans = 0;
  struct list* you = you_start;
  while(1){
    int counter = 0;
    while(strcmp(you->elem, "COM")){
      if(!strcmp(you->elem, santa->elem)){
          printf("Part 2: %d\n", ans + counter);
          return;
      }
      counter++;
      you = you->back;
    }

    you = you_start;
    ans++;
    santa = santa->back;
  }

}

struct list* locate(const char* str, struct list* data[]){
  for(int i = 0; data[i] != NULL && *(data[i])->elem != 0; i++){
    if(!strcmp(data[i]->elem, str)){
      return data[i];
    }
  }
}

void part1(struct list* data[]){
  int ans = 0;
  for(int i = 0; data[i] != NULL && *(data[i])->elem != 0; i++){
    if(!strcmp(data[i]->elem, "COM")){
      continue;
    }

    struct list* heh = data[i]->back;
    while(heh != NULL){
      ans++;
      heh = heh->back;
    }
  }

  printf("Part 1: %d\n", ans);
}

void input(struct list* data[]){
  FILE* fp = fopen("file", "r");
  char buffer[100];
  while(fgets(buffer, 100, fp)){
    char *pos;
    if ((pos=strchr(buffer, '\n')) != NULL)
      *pos = '\0';
    char* token = strtok(buffer, ")"); 
    char* token2 = strtok(NULL, ")"); 
    struct list* current = find(token2, data);
    current->back = find(token, data);
  }
  fclose(fp);
}

struct list* find(const char planet[], struct list* data[]){
  int i;
  for(i = 0; data[i] != NULL && *(data[i])->elem != 0; i++){
    if(!strcmp(data[i]->elem, planet)){
      return data[i];
    }
  }

  data[i] = calloc(1, sizeof(struct list));
  strcpy(data[i]->elem, planet);
  return data[i];
}
