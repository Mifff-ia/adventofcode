#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include <float.h>

typedef struct point {
  int x;
  int y;
} point;

int gcd(int a, int b);
int part1(bool** arr, point dimensions, point* ans);
point part2(bool** grid, point dimensions, point x);
int check1(bool** arr, point dimensions, point loc);
#define MAX_BUF 1024
bool** input_grid(const char* file, point* dimensions);
point vector(point start, point end);
point translate(point p, point vector, point dimensions);
point circumnavigate(point prev, point dimensions);

int main(){
  point d;
  bool** grid = input_grid("file", &d);

  point x;
  printf("Part 1: %d\n", part1(grid, d, &x));
  //printf("Coords: %d, %d\n", x.x, x.y);
  point ans = part2(grid, d, x);
  printf("Part 2: %d\n", ans.x*100+ans.y);

  //point p = {.x = 0, .y = 0};
  //for(int i = 0; i < 16; i++){
  //  p = circumnavigate(p, d);
  //  printf("%d, %d\n", p.x, p.y);
  //}

  for(int i = 0; i < d.y; i++){
    //for(int j = 0; j < d.x; j++){
    //  printf("%c", grid[i][j] ? '#': '.');
    //}

    free(grid[i]);
    //printf("\n");
  }
  free(grid);
}

point part2(bool** grid, point d, point loc){
  // Copy array to be safe
  bool temp[d.y][d.x];
  for(int i = 0; i < d.y; i++){
    for(int j = 0; j < d.x; j++){
      temp[i][j] = grid[i][j];
    }
  }
  temp[loc.y][loc.x] = false;

  // compute angles of every location
  // with 2pi for locations with no asteroid
  double angles[d.y][d.x];
  for(int i = 0; i < d.y; i++){
    for(int j = 0; j < d.y; j++){
      if(temp[i][j]){
        point p = {.x = j, .y = i};
        point v = vector(loc, p);
        angles[i][j] = atan2(v.x,-v.y);
        if(angles[i][j] < 0){
          angles[i][j] += M_PI * 2;
        }
      } else {
        angles[i][j] = 2 * M_PI;
      }
    }
  }

  double a = 0;
  point p;
  for(int count = 0; count < 200; count++){
    // find the closest asteroid and destroy it
    double min = DBL_MAX;
    for(int i = 0; i < d.y; i++){
      for(int j = 0; j < d.x; j++){
        if(angles[i][j] == a){
          p.x = j;
          p.y = i;
          point v = vector(loc, p);
          p = translate(loc, v, d);
          while(!temp[p.y][p.x]){
            p = translate(p, v, d);
          }
          i++;
          temp[p.y][p.x] = false;
        }
      }
    }

    // find next smallest angle
    for(int i = 0; i < d.y; i++){
      for(int j = 0; j < d.x; j++){
        if(angles[i][j] > a && angles[i][j] < min){
          min = angles[i][j];
        }
      }
    }

    if(min < 2 * M_PI){
      a = min;
    } else {
      a = 0;
    }
  }

  return p;
}

int part1(bool** grid, point d, point* ans){
  ans->x = 0;
  ans->y = 0;
  int max = 0;
  for(int i = 0; i < d.y; i++){
    for(int j = 0; j < d.x; j++){
      if(grid[i][j]){
        point loc = {.x = j, .y = i};
        int result = check1(grid, d, loc);
        if(result > max){
          max = result;
          *ans = loc;
        }
      }
    }
  }

  return max;
}

int gcd(int a, int b) { 
    if (b == 0) 
        return a; 
    return gcd(b, a % b);  
}

point circumnavigate(point prev, point d){
  if(prev.x == 0 && prev.y != 0){
    prev.y--;
  } else if(prev.x == d.x - 1 && prev.y != d.y-1){
    prev.y++;
  } else if(prev.y == 0 && prev.x != d.x - 1){
    prev.x++;
  } else if(prev.y == d.y-1 && prev.x != 0){
    prev.x--;
  }

  return prev;
}

int check1(bool** arr, point d, point loc){
  bool temp[d.y][d.x];
  for(int i = 0; i < d.y; i++){
    for(int j = 0; j < d.x; j++){
      temp[i][j] = arr[i][j];
    }
  }

  temp[loc.y][loc.x] = false;
  for(int i = 0; i < d.y; i++){
    for(int j = 0; j < d.x; j++){
      if(temp[i][j]){
        point p = {.x = j, .y = i};
        point v = vector(loc, p);
        point k = translate(p, v, d);
        while(k.x != -1 && k.y != -1){
          temp[k.y][k.x] = false;
          k = translate(k, v, d);
        }
      }
    }
  }

  //printf("%d, %d\n", loc.x, loc.y);
  //for(int i = 0; i < d.y; i++){
    //for(int j = 0; j < d.x; j++){
      //printf("%d", temp[i][j]);
    //}
    //printf("\n");
  //}


  int acc = 0;
  for(int i = 0; i < d.y; i++){
    for(int j = 0; j < d.x; j++){
      acc += temp[i][j];
    }
  }
  //printf("%d\n\n", acc);
  return acc;
}

point vector(point start, point end){
  point x = {.x = end.x - start.x, .y = end.y - start.y};
  int g = gcd(abs(x.x), abs(x.y));
  x.x = x.x/g;
  x.y = x.y/g;
  return x;
}

point translate(point p, point vector, point d){
  point x = {.x = p.x + vector.x, .y = p.y + vector.y};
  if(!(x.x >= 0 && x.x < d.x)){
    x.x = -1;
  }
  if(!(x.y >= 0 && x.y < d.y)){
    x.y = -1;
  }
  return x;
}

bool** input_grid(const char* file, point* d){
  FILE* fp = fopen(file, "r");
  if(fp == NULL){
    fprintf(stderr, "Unable to open file: %s\n", file);
    exit(0);
  }
  
  fseek(fp, 0L, SEEK_END);
  int size = ftell(fp);
  fseek(fp, 0L, SEEK_SET);

  char buffer[MAX_BUF];
  fgets(buffer, MAX_BUF, fp);
  d->x = strlen(buffer) - 1;
  d->y = size/(d->x + 1);
  //printf("%d, %d\n", width, height);

  bool** arr = malloc(d->y * sizeof(bool*));
  for(int i = 0; i < d->y; i++){
    arr[i] = malloc(d->x * sizeof(bool));
  }

  for(int i = 0; i < d->y; i++){
    for(int j = 0; j < d->x; j++){
      arr[i][j] = buffer[j] == '#';
    }
    fgets(buffer, MAX_BUF, fp);
  }

  return arr;
}
