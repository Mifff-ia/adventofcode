#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

void int_code(int* data, size_t n);
int mode(int mod, int loc, int data[]);

int main(){
  char input[5000];
  fgets(input, 5000, stdin);

  int data[1000];
  int i = 0;
  char* token = strtok(input, ",");
  while(token != NULL){
    data[i++] = atoi(token);
    token = strtok(NULL, ",");
  }

  int_code(data, sizeof(data)/sizeof(int));
}

void int_code(int* data, size_t n){
  int i = 0;
  while(i < n){
    int first, second;
    int x = data[i] % 100;
    if(x == 99)
      break;

    if(i + 1 < n)
        first = mode(data[i]/100, data[i+1], data);
    if(i + 2 < n)
        second = mode(data[i]/1000, data[i+2], data);

    switch(x){
      case 1:
        data[data[i+3]] = first + second;
        i+=4; break;
      case 2:
        data[data[i+3]] = first * second;
        i+=4; break;
      case 3:
        scanf("%d", &data[data[i+1]]);
        i+=2; break;
      case 4: 
        printf("%d\n", first);
        i+=2; break;
      case 5:
        if(first)
          i = second;
        else
          i += 3;
        break;
      case 6:
        if(!first)
          i = second;
        else
          i += 3;
        break;
      case 7:
        data[data[i+3]] = first < second;
        i += 4; break;
      case 8:
        data[data[i+3]] = first == second;
        i += 4; break;
    }
  }
}

int mode(int mod, int loc, int data[]){
  if(mod % 2 == 0)
    return data[loc];
  else
    return loc;
}
