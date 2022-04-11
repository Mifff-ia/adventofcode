#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

void int_code(long long* data, size_t n);
long long* mode(long long mod, const long long* loc, long long rel, const long long data[]);

int main(){
  char input[5000];
  fgets(input, 5000, stdin);

  long long data[2000] = {0};
  int i = 0;
  char* token = strtok(input, ",");
  while(token != NULL){
    data[i++] = atoll(token);
    token = strtok(NULL, ",");
  }

  int_code(data, sizeof(data)/sizeof(data[0]));
}

void int_code(long long* data, size_t n){
  int i = 0;
  long long rel = 0;
  while(i < n){
    long long* first,* second,* third;
    long long x = data[i] % 100;
    if(x == 99)
      break;

    if(i + 1 < n)
      first = mode(data[i]/100, &data[i+1], rel, data);
    if(i + 2 < n)
      second = mode(data[i]/1000, &data[i+2], rel, data);
    if(i + 3 < n)
      third = mode(data[i]/10000, &data[i+3], rel, data);

    switch(x){
      case 1:
        *third = *first + *second;
        i+=4; break;
      case 2:
        *third = *first * *second;
        i+=4; break;
      case 3:
        scanf("%lld", first);
        i+=2; break;
      case 4: 
        printf("%lld\n", *first);
        i+=2; break;
      case 5:
        if(*first)
          i=*second;
        else
          i+=3;
        break;
      case 6:
        if(!*first)
          i=*second;
        else
          i+=3;
        break;
      case 7:
        *third = *first < *second;
        i+=4; break;
      case 8:
        *third = *first == *second;
        i+=4; break;
      case 9:
        rel += *first;
        i+=2; break;
    }
  }
}

long long* mode(long long mod, const long long* loc, long long rel, const long long data[]){
  if(mod % 10 == 0)
    return &data[*loc];
  else if(mod % 10 == 1)
    return loc;
  else
    return &data[*loc + rel];
}
