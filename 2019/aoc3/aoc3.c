#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include <stdint.h>

#define MAX 35000LL
#define CENTER 17500LL

typedef struct Directions {
  char where;
  uint16_t len;
} dir;

void map(dir route[], uint8_t** g, size_t len, int mask);
void get_route(dir buf[]);
size_t length(uint8_t **g, size_t coords[][2]);
long check(dir route[], size_t len, size_t x, size_t y);

void bound_check(size_t n){
  if(n >= MAX || n < 0){
    printf("grid isn't big enough ya dum dum");
  }
}


int main(){
  uint8_t** grid = calloc(MAX, sizeof(uint8_t*));
  for(size_t i = 0; i < MAX; i++){
    grid[i] = calloc(MAX, sizeof(uint8_t));
  }
  dir routeA[301] = {0};
  dir routeB[301] = {0};

  get_route(routeA);
  get_route(routeB);

  map(routeA, grid, sizeof(routeA)/sizeof(routeA[0]), 1);
  map(routeB, grid, sizeof(routeB)/sizeof(routeB[0]), 2);

  size_t coords[100][2] = {0};
  printf("Part 1: %ld\n", length(grid,coords));
  long min = MAX + MAX;
  for(int i = 0; coords[i][0] != 0 && coords[i][1] != 0; i++){
    long x = check(routeA, sizeof(routeA)/sizeof(routeA[0]), coords[i][0], coords[i][1]);
    long y = check(routeB, sizeof(routeB)/sizeof(routeB[0]), coords[i][0], coords[i][1]);
    if(x + y < min){
      min = x + y;
    }
  }
  printf("Part 2: %ld\n", min);


  free(grid);
}

long check(dir route[], size_t len, size_t x, size_t y){
  bool flag = false;
  int ver, hor;
  ver = hor = CENTER;
  for(int i = 0; i < len && flag == false; i++){
    switch(route[i].where){
      case 'U':
        for(size_t j = 1; j <= route[i].len; j++){
          if(ver-j == x && hor == y){
            long acc = 0;
            for(int k = 0; k < i; k++){
              acc += route[k].len;
            }
            acc += j;
            return acc;
          }
        }
        ver -= route[i].len;
        break;
      case 'D':
        for(size_t j = 1; j <= route[i].len; j++){
          if(ver+j == x && hor == y){
            long acc = 0;
            for(int k = 0; k < i; k++){
              acc += route[k].len;
            }
            acc += j;
            return acc;
          }
        }
        ver += route[i].len;
        break;
      case 'L':
        for(size_t j = 1; j <= route[i].len; j++){
          if(ver == x && hor-j == y){
            long acc = 0;
            for(int k = 0; k < i; k++){
              acc += route[k].len;
            }
            acc += j;
            return acc;
          }
        }
        hor -= route[i].len;
        break;
      case 'R':
        for(size_t j = 1; j <= route[i].len; j++){
          if(ver == x && hor+j == y){
            long acc = 0;
            for(int k = 0; k < i; k++){
              acc += route[k].len;
            }
            acc += j;
            return acc;
          }
        }
        hor += route[i].len;
        break;
      default:
        flag = true;
        break;
    }
  }
}

void map(dir route[], uint8_t** grid, size_t len, int mask){
  bool flag = false;
  int ver, hor;
  ver = hor = CENTER;
  for(int i = 0; i < len && flag == false; i++){
    switch(route[i].where){
      case 'U':
        bound_check(ver - route[i].len);
        for(size_t j = 1; j <= route[i].len; j++){
          grid[ver-j][hor] |= mask;
        }
        ver -= route[i].len;
        break;
      case 'D':
        bound_check(ver + route[i].len);
        for(size_t j = 1; j <= route[i].len; j++){
          grid[ver+j][hor] |= mask;
        }
        ver += route[i].len;
        break;
      case 'L':
        bound_check(hor - route[i].len);
        for(size_t j = 1; j <= route[i].len; j++){
          grid[ver][hor-j] |= mask;
        }
        hor -= route[i].len;
        break;
      case 'R':
        bound_check(hor + route[i].len);
        for(size_t j = 1; j <= route[i].len; j++){
          grid[ver][hor+j] |= mask;
        }
        hor += route[i].len;
        break;
      default:
        flag = true;
        break;
    }
  }
}

void get_route(dir buf[]){
  char buffer[2000];
  fgets(buffer, 2000, stdin);

  char* token = strtok(buffer, ","); 


  for (size_t i = 0; token != NULL; i++) { 
    buf[i].where = token[0];
    buf[i].len = atoi(token+1);

    token = strtok(NULL, ","); 
  }
}

size_t length(uint8_t** grid, size_t coords[][2]){
  size_t min = MAX;
  int count = 0;
  for(size_t i = 0; i < MAX; i++){
    for(size_t j = 0; j < MAX; j++){
      if(grid[i][j] == 3){
        size_t temp = abs(CENTER - i) + abs(CENTER - j);
        coords[count][0] = i;
        coords[count++][1] = j;
        if(temp < min){
          min = temp;
        }
      }
    }
  }
  return min;
}
