#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

void int_code(int* data, size_t n);
void reset(int* init, int*data, size_t n);

int main(){
  char input[1000];
  fgets(input, 1000, stdin);

  int init[200];
  int i = 0;
  char* token = strtok(input, ",");
  while(token != NULL){
    init[i++] = atoi(token);
    token = strtok(NULL, ",");
  }

  int data[sizeof(init)/sizeof(int)];
  for(int x = 0; x < 100; x++){
    for(int y = 0; y < 100; y++){
      reset(init, data, sizeof(data)/sizeof(int));
      data[1] = x;
      data[2] = y;
      int_code(data, sizeof(data)/sizeof(int));
      if(data[0] == 19690720){
        printf("%d\n", 100 * x + y);
        exit(0);
      }
    }
  }
}

void int_code(int* data, size_t n){
  bool flag = false;
  for(int i = 0; i < n && flag == false; i += 4){
    switch(data[i]){
      case 1: data[data[i+3]] = data[data[i+1]] + data[data[i+2]]; break;
      case 2: data[data[i+3]] = data[data[i+1]] * data[data[i+2]]; break;
      case 99: flag = true; break;
    }
  }
}

void reset(int* init, int*data, size_t n){
  for(int i = 0; i < n; i++){
    data[i] = init[i];
  }
}

