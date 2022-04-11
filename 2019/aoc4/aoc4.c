#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdbool.h>

int check(const char* str);

int main(){
  int start, end;
  scanf("%d-%d", &start, &end);

  int part1, part2;
  part1 = part2 = 0;
  for(int i = start; i <= end; i++){
    size_t length = snprintf(NULL, 0, "%d", i);
    char* str = malloc(length + 1);
    snprintf(str, length + 1, "%d", i);

    int ans = check(str);
    part1 += ans & 1;
    part2 += (ans & 2) >> 1;
  }
  printf("Part 1: %d\nPart 2: %d\n", part1, part2);
}

int check(const char* str){
  int dup[10] = {0};

  int max = -1;
  for(int i = 0; i < strlen(str); i++){
    int num = str[i] - '0';
    dup[num] += 1;
    if(num >= max){
      max = num;
    } else {
      return 0;
    }
  }

  int ans = 0;
  for(int i = 0; i < 10; i++){
    if(dup[i] == 2){
      ans |= 2;
    }
    if(dup[i] > 1){
      ans |= 1;
    }
  }
  return ans;
}

