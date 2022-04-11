#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

char*** input(int width, int height, char* file);
int part1(char*** input, int width, int height);
void part2(char*** input, int width, int height);
int count(const char* string, char ch);

int main(int argc, char** argv){
  if(argc != 3){
    printf("Error\n");
    exit(1);
  }
  int width = atoi(argv[1]), height = atoi(argv[2]);
  char*** x = input(width, height, "file");
  for(int i = 0; x[i] != NULL; i++){
    for(int j = 0; j < height; j++){
      printf("%s ", x[i][j]);
    }
    printf("\n");
  }
  printf("Part 1: %d\n", part1(x, width, height));
  part2(x, width, height);
  free(x);
}

void part2(char*** input, int width, int height){
  for(int j = 0; j < height; j++){
    for(int k = 0; k < width; k++){
      int ans = 0;
      for(int i = 0; input[i] != NULL; i++){
        int num = input[i][j][k] - '0';
        if(num != 2){
          ans = num;
          break;
        }
      }
      printf("%d", ans);
    }
    printf("\n");
  }
}

int part1(char*** input, int width, int height){
  int min = INT_MAX, x = 0;
  for(int i = 0; input[i] != NULL; i++){
    int acc = 0;
    for(int j = 0; j < height; j++){
      acc += count(input[i][j], '0');
    }

    if(acc < min){
      min = acc;
      x = i;
    }
  }

  int count1 = 0, count2 = 0;
  for(int i = 0; i < height; i++){
    count1 += count(input[x][i], '1');
    count2 += count(input[x][i], '2');
  }

  return count1 * count2;
}

int count(const char* string, char ch){
    int count = 0;
    for(; *string; count += (*string++ == ch)) ;
    return count;
}

char*** input(int width, int height, char* file){
  FILE* fp = fopen(file, "r");
  fseek(fp, 0L, SEEK_END);
  size_t size = ftell(fp);
  rewind(fp);

  int layers = size/height/width;
  char*** arr = calloc(layers + 1, sizeof(char**));
  for(int i = 0; i < layers; i++){
    arr[i] = malloc(height*sizeof(char*));
    for(int j = 0; j < width; j++){
      arr[i][j] = malloc(width*sizeof(char*) + 1);
    }
  }

  for(int i = 0; i < layers; i++){
    for(int j = 0; j < height; j++){
      fgets(arr[i][j], width + 1, stdin);
    }
  }
  fclose(fp);

  return arr;
}
