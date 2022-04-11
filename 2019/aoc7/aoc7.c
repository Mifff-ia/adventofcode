//{{{ header
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

void reset(int data[], const int init[], size_t n);
int int_code(int* i, int arr[], size_t n, const int input[]);
int mode(int mod, int loc, int data[]);
int instruction(int* i, int data[], int first, int second, int input[]);
int check(int data[],const int init[], size_t n);
int check2(const int init[], size_t n);
void permute(int *array,int i,int length);

int perm[120][5];
int perm_count = 0;
//}}}

//{{{ main
int main(){
  char input[5000];
  fgets(input, 5000, stdin);

  int init[2000] = {0};
  int i = 0;
  char* token = strtok(input, ",");
  while(token != NULL){
    init[i++] = atoi(token);
    token = strtok(NULL, ",");
  }

  int data[2000];
  /*
  for(int i = 0; i < 120; i++){
    printf("%d: ", i);
    for(int j = 0; j < 5; j++){
      printf("%d", perm[i][j]);
    }
    printf("\n");
  }
  */

  //printf("Part 1: %d\n", check(data, init, sizeof(data)/sizeof(int)));
  printf("Part 2: %d\n", check2(init, sizeof(data)/sizeof(int)));
}
//}}}


//{{{ check
int check(int data[],const int init[], size_t n){
  perm_count = 0;
  int y[] = {0, 1, 2, 3, 4};
  permute(y, 0, 5);
  int max;
  for(int i = 0; i < 120; i++){
    int input[2] = {0};
    for(int j = 0; j < 5; j++){
      reset(data, init, n);
      input[0] = perm[i][j];
      int i = 0;
      int x = int_code(&i, data, n, input);
      input[1] = x;
    }
    if(input[1] > max){
      max = input[1];
    }
  }
  return max;
}
//}}}

//{{{ check2
int check2(const int init[], size_t n){
  perm_count = 0;
  int y[] = {5, 6, 7, 8, 9};
  permute(y, 0, 5);

  int data[5][n];
  for(int i = 0; i < 5; i++){
    reset(data[i], init, n);
  }

  int max = 0;
  for(int i = 0; i < 120; i++){
    int input[2] = {0};
    int ans;
    int count[5] = {0};

    for(int j = 0; j < 5; j++){
      input[0] = perm[i][j];
      input[1] = int_code(&count[j], data[j], n, input);
    }

    input[0] = input[1];
    input[1] = INT_MIN;
    for(int j = 0; data[j][count[j]] != 99; j = (j + 1) % 5){
      ans = input[0];
      input[0] = int_code(&count[j], data[j], n, input);
    }

    if(ans > max){
      max = ans;
    }
    printf("%d\n", max);
  }
  return max;
}
//}}}


//{{{ permute
void swap(int* i, int* j){
  int temp = *i;
  *i = *j;
  *j = temp;
}

void permute(int *array,int i,int length) { 
  if (length == i){
    for(int i = 0; i < 5; i++){
      perm[perm_count][i] = array[i];
    }
    perm_count++;
    return;
  }

  for (int j = i; j < length; j++) { 
    swap(array+i,array+j);
    permute(array,i+1,length);
    swap(array+i,array+j);
  }
  return;
}
//}}}

//{{{ int_code
int int_code(int* i, int data[], size_t n, const int input[]){
  /*
  int* output = malloc(100*sizeof(int));
  for(int i = 0; i < 100; i++){
    output[i] = INT_MIN;
  }
  */
  int j = 0;
  while(*i < n){
    int first, second;
    int x = data[*i] % 100;
    if(x == 99){
      return INT_MIN;
    }

    if(*i + 1 < n && data[*i+1] < n)
        first = mode(data[*i]/100, data[*i+1], data);
    if(*i + 2 < n && data[*i+2] < n)
        second = mode(data[*i]/1000, data[*i+2], data);
    int ans = instruction(i, data, first, second, input);
    if(x == 4){
      return ans;
    }
  }

  return INT_MAX;
}
//}}}

//{{{ instruction
int instruction(int* i, int data[], int first, int second, int input[]){
  int ans = INT_MIN;
  int j;
  switch(data[*i] % 100){
    case 1:
      data[data[*i+3]] = first + second;
      *i+=4; break;
    case 2:
      data[data[*i+3]] = first * second;
      *i+=4; break;
    case 3:
      for(j = 0; input[j] == INT_MIN; j++)
        ;
      data[data[*i+1]] = input[j];
      input[j] = INT_MIN;
      *i+=2; break;
    case 4: 
      ans = first;
      *i+=2; break;
    case 5:
      if(first)
        *i = second;
      else
        *i += 3;
      break;
    case 6:
      if(!first)
        *i = second;
      else
        *i += 3;
      break;
    case 7:
      data[data[*i+3]] = first < second;
      *i += 4; break;
    case 8:
      data[data[*i+3]] = first == second;
      *i += 4; break;
  }
  return ans;
}
//}}}

//{{{ mode
int mode(int mod, int loc, int data[]){
  if(mod % 2 == 0)
    return data[loc];
  else
    return loc;
}
//}}}

//{{{ reset
void reset(int data[], const int init[], size_t n){
  for(int i = 0; i < n; i++){
    data[i] = init[i];
  }
}
//}}}
